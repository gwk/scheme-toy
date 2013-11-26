#!/usr/bin/env python3
# Copyright 2013 George King.
# Permission to use this file is granted in ploy/license.txt.

'''
Interpreter for a Scheme-like language.
Derived from: http://thinkpython.blogspot.com/2005/02/simple-scheme-interpreter.html.
Note that as of 2013-05-07 there is no copyright or license specification in that source.

Another source of inspiration: http://norvig.com/lispy.html 
Further improvements could be made by following: http://norvig.com/lispy2.html

This implementation is mostly interesting because it uses continuations explicitly.
Every step of the computation is performed by a continuation (a Python closure),
which takes a single value argument (the result of the previous step),
and returns a (continuation, value) pair.
The interpreter runs in a loop, repeatedly passing the value of the previous step to the current continuation.
This allows us to implement call-with-current-continuation easily,
and also to trace the progress of evaluation by printing out the intermediate value returned by each continuation step.

This implementation is experimental, containing bugs and design flaws.
'''

import re
import sys

from pprint import pprint

# various unicode symbols indicating interactive interpreter status.
rep_prompt = white_right_pointing_triangle = '▷ '
rep_continue_prompt = ellipsis = '… '
trace_sym = white_bullet = '◦'
cont_sym = white_down_pointing_small_triangle = '▿'
rep_val_sym = white_circle = '○'

# flags recognized by this program.
known_flags = { '-trace' }

trace_enabled = False


def error(*items):
  'print an error and exit.'
  print(*items, file=sys.stderr)
  sys.exit(1)


class PloyError(Exception):
  'python exception class for signaling an error in the scheme interpreter.'
  def __init__(self, *items):
    self.message = ' '.join(str(i) for i in items)
    super().__init__(self, self.message)


class PloyTokenError(PloyError):
  pass

class PloyParseError(PloyError):
  pass

class PloyEnvError(PloyError):
  pass

class PloyCallError(PloyError):
  pass

class PloyTypeError(PloyError):
  pass


class Symbol:
  'ploy symbol.'

  __slots__ = ['name'] # slots speed things up a tad and save memory.

  def __init__(self, name):
    self.name = name

  def __str__(self):
    return self.name

  def __repr__(self):
    return '<Symbol: {}>'.format(repr(self.name))

  def __eq__(self, other):
    return self.name == other.name if isinstance(other, Symbol) else False


# predefined symbols.
# S_dot is a hack for the Link chain iterator.
S_dot, S_quote, S_begin, S_lambda, S_let, S_if, S_define, S_set, S_load, \
= (Symbol(s) for s in \
('.', 'quote', 'begin', 'lambda', 'let', 'if', 'define', 'set!', 'load'))


class Link:
  '''
  ploy cons cell.
  note that we use attributes named hd and tl instead of traditional lisp car and cdr.
  '''

  __slots__ = ('hd', 'tl') # slots speed things up a tad and save memory
  
  def __init__(self, hd, tl=None):
    self.hd = hd
    self.tl = tl

  def __iter__(self):
    c = self
    while isinstance(c, Link):
      yield c.hd
      c = c.tl
    if c is not None:
      yield S_dot
      yield c

  def __eq__(self, other):
    if not isinstance(other, Link):
      return False
    for a, b in zip(self, other):
      if a != b:
        return False
    return True

  def __str__(self):
    return '({})'.format(' '.join(str(i) for i in self))


def chain_from_iterable(iterable):
  'create a chain (scheme list) from an iterable.'
  anchor = Link(None) # chain to be returned is the tail of anchor
  current = anchor
  for i in iterable:
    c = Link(i)
    current.tl = c
    current = c
  return anchor.tl


class Env:
  '''
  environment frame.
  each frame contains a set of symbolic bindings, plus a reference to its parent frame.
  '''

  __slots__ = ['parent', 'bindings']

  def __init__(self, parent, bindings):
    self.parent = parent
    self.bindings = bindings

  def dump(self):
    if not trace_enabled:
      return
    print('\nEnvironment Dump:')
    pprint(self.bindings)
    if self.parent:
      self.parent.dump()
    else:
      print()

  def get(self, name):
    e = self
    while e:
      try:
        return e.bindings[name]
      except KeyError:
        e = e.parent
        continue
    self.dump()
    raise PloyEnvError('cannot get unbound variable:', name)

  def set(self, name, value):
    e = self
    while e:
      if name in e:
        e.bindings[name] = value
        return
      else:
        e = e.parent
    self.dump()
    raise PloyEnvError('cannot set unbound variable:', name)

  def define(self, name, value):
    if name in self.bindings:
      raise PloyEnvError('variable already bound:', name)
    self.bindings[name] = value
    

# tokenizer

# token enum
T_comment, T_dot, T_sq, T_op, T_cp, T_atom, T_sym = range(7)

tokens_re = re.compile(r'''(
  ;[^\n]*  # comment
| \.          # dot
| '           # sq: single quote
| \(          # op: open parenthesis
| \)          # cp: close parenthesis
| "(?:[^"]|\\")+" # atom: string literal
| \#(?:[tf]|\\(?:.|newline|space)) # atom: true, false, char
| [\w+\-*/<>=!?]+ # sym or number
)''', flags=re.VERBOSE)


def gen_tokens(source_text):  
  parts = tokens_re.split(source_text)
  #pprint(parts, indent=2)
  for i, part in enumerate(parts):
    if i % 2 == 0:
      if part and not part.isspace():
        raise PloyTokenError('Invalid token separator:', repr(part))
      continue
    if part.startswith(';'): # comment
      continue
    if part == '(':
      yield (T_op, part); continue
    if part == ')':
      yield (T_cp, part); continue
    if part == '.':
      yield (T_dot, part); continue
    if part == "'":
      yield (T_sq, part); continue
    try:
      i = int(part)
      yield (T_atom, i); continue
    except ValueError:
      pass
    if part[0] == '"':
      yield (T_atom, part[1:-1].replace(r'\\', '\\').replace(r'\"', r'"')); continue
    if part[0] == '#':
      if part[1] == '\\':
        char = part[2:]
        if char == 'space':
          char = ' '
        if char == 'newline':
          char = '\n'
        yield (T_atom, char); continue
      if part[1] == 't':
        yield (T_atom, True); continue
      if part[1] == 'f':
        yield (T_atom, False); continue
      raise PloyTokenError('Invalid token:', repr(part))
    # else symbol
    yield (T_sym, Symbol(part))


def tokenize(source_text):
  'do all tokenizing in a single step in order to detect any syntax errors first.'
  return list(gen_tokens(source_text))


# s-expressions


def sexpr(token_stream):
  'parse an s-expression from a token stream.'
  token_type, value = next(token_stream)
  if token_type == T_sq:
    next_val = sexpr(token_stream)
    if next_val == ')':
      raise PloyParseError('cannot quote closing parenthesis')
    return Link(S_quote, Link(next_val))
  elif token_type == T_op:
    anchor = Link(None)
    current = anchor
    sub_value = None
    while True:
      sub_value = sexpr(token_stream)
      if sub_value in (')', '.'):
        break
      c = Link(sub_value)
      current.tl = c
      current = c
    # process closing token value
    if sub_value == '.':
      current.tl = sexpr(token_stream)
      sub_token_type, sub_value = next(token_stream)
    if sub_value == ')':
      return anchor.tl
    else:
      raise PloyParseError('Expected closing parenthesis for expression:', anchor.tl, sub_value)
  else:
    return value


def sexprs(token_stream):
  'parse a sequence of s-expressions from a token stream.'
  anchor = Link(None)
  current = anchor
  try:
    while True:
      c = Link(sexpr(token_stream))
      current.tl = c
      current = c
  except StopIteration:
    pass
  return anchor.tl
    
    
def native_fn(py_fn):
  '''
  wrap a python function in a CPS interpreter function.
  used to create various builtin functions.
  '''
  def f(cont, args):
    arg_iter = args if args else ()
    return cont, py_fn(*arg_iter)
  return f


def create_eval_fn(env):
  '''
  create a ploy eval function using the given environment.
  used to create the 'eval' scheme builtin.
  '''
  def eval_func(cont, args):
    expr = args.hd
    assert args.tl is None
    return (Cont_eval(cont, env, expr), None)
  return eval_func


def py_exec(cont, args):
  'py-exec builtin implementation.'
  source_text = arg.hd
  assert arg.tl is None
  exec(source_text, py_env)
  return (cont, None)


def py_eval(cont, arg):
  'py-eval builtin implementation.'
  source_text = arg.hd
  assert arg.tl is None
  return (cont, eval(source_text, py_env))


def call_cc(cont, args):
  'call/cc builtin implementation.'
  func = args.hd
  assert args.tl is None
  def cont_func(cont_ignored, args):
    'note that the argument continuation is ignored and replaced by the captured continuation.'
    arg = args.hd
    assert args.tl is None
    return (cont, arg)
  return func(cont, Link(cont_func))


# environment for py-exec and py-eval
py_env = {}

global_env = Env(None, {
  'py-exec' : py_exec,
  'py-eval' : py_eval,
  'call/cc' : call_cc,
})

global_env.define('eval', create_eval_fn(global_env.bindings)) # note the reference cycle


def add_native_fn(name, py_fn):
  'wrapper used to give builtin functions names for error and trace clarity.'
  f = native_fn(py_fn)
  f.__qualname__ = 'native:' + name # qualname is used by function repr implementation.
  global_env.define(name, f)


def add_native_fns():
  import functools as ft
  import operator as op
  add_native_fn('+',  lambda *args: sum(args))
  add_native_fn('*',  lambda *args: ft.reduce(op.mul, args, 1))
  add_native_fn('-',  op.sub)
  add_native_fn('/',  op.truediv)
  add_native_fn('//', op.floordiv)
  add_native_fn('<',  op.lt)
  add_native_fn('>',  op.gt)
  add_native_fn('<=', op.le)
  add_native_fn('>=', op.ge)
  add_native_fn('not', op.not_)
  add_native_fn('eq?', op.eq)
  #add_native_fn('equal?' or 'eqv?', is_)
  add_native_fn('cons', lambda a, b: Link(a, b))
  add_native_fn('car', lambda c: c.hd)
  add_native_fn('cdr', lambda c: c.tl)
  add_native_fn('symbol?', lambda x: isinstance(s, Symbol))
  add_native_fn('list?', lambda x: x is None or isinstance(x, Link))
  add_native_fn('cons?', lambda x: isinstance(x, Link))
  add_native_fn('display', print)

add_native_fns()


# for now define test as a builtin function; should be a macro.
def test(a, b):
  if a == b:
    print(a)
  else:
    print('test failed:')
    print(' ', a)
    print(' ', b)
    sys.exit(1)
  
add_native_fn('test', test)


## evaluation

# expression lists; used by load, apply, and interactive loop.

def Cont_expr_list(cont, env, exprs):
  'continuation for the evaluation of an expression list (function bodies, begin).'
  expr = exprs.hd
  rest = exprs.tl
  # recursively create continuations for the remainder of the expr list evaluation.
  next_cont = Cont_expr_list(cont, env, rest) if rest else cont
  def cont_expr_list(value_ignored):
    '''
    value is ignored because each expr in the list does not receive the value of the previous expr.
    the final value will be passed out of the expression list to cont.
    '''
    return eval_(next_cont, env, expr)
  return cont_expr_list


def sub_eval_expr_list(cont, env, exprs):
  return (Cont_expr_list(cont, env, exprs), None)
  

def sub_eval_tokens(cont, env, tokens):
  stream = iter(tokens)
  exprs = sexprs(stream)
  return sub_eval_expr_list(cont, env, exprs)


def sub_eval_load_from_path(cont, env, path):
  with open(path) as f:
    source_text = f.read()
  tokens = tokenize(source_text)
  return sub_eval_tokens(cont, env, tokens)


# quote

def eval_quote(cont, env_unused, code):
  '''
  quote simply returns the quoted code as the value.
  env argument is unused; we prefer to have all the eval_x signatures the same,
  in case we want to alter dispatch in eval_ implementation in the future.
  '''
  assert code.hd == S_quote
  rest = code.tl
  expr = rest.hd
  assert rest.tl is None
  return (cont, expr)


# begin

def eval_begin(cont, env, code):
  'begin evaluates each argument expression and returns the value of the last.'
  assert code.hd == S_begin
  exprs = code.tl
  return sub_eval_expr_list(cont, env, exprs)


# lambda

def eval_lambda(cont, env, code):
  '''
  lambda creates a new environment frame by binding the argument names in the first expression (a list),
  then evaluates the remaining expressions in that environment, returning the value of the last.
  note that environments are lexically scoped:
  the immediate environment (argument bindings) of a function call is created at call-time,
  but the parent environment is determined when the call to lambda (not the call to the resulting function) is made.
  '''
  assert code.hd == S_lambda
  rest = code.tl
  arg_names = rest.hd
  exprs = rest.tl
  names = [p.name for p in arg_names] # arg names are Symbol objects
  def func(cont, args):
    vals = list(args)
    if not len(names) == len(vals):
      raise PloyCallError('expected {} arguments; received {}; names: {}'.format(len(names), len(vals), ', '.join(names)))
    bindings = dict(zip(names, args))
    call_env = Env(env, bindings)
    return sub_eval_expr_list(cont, call_env, exprs)
  return (cont, func)


# let

def Cont_let_pairs(cont, env, exprs, pair_list):
  '''
  recursive continuation for the evaluation of a (name, expr) let pairs.
  pair_exprs is a ((name expr) ...) scheme list.
  pair_list is a python list that accumulates the (name, val) pairs.
  '''
  pair = exprs.hd
  rest = exprs.tl
  sym, val_expr = pair
  if not isinstance(sym, Symbol):
    raise PloyTypeError('let binding requires Symbol for name; received {}; {}'.format(type(name), name))
  name = sym.name
  cont_next = Cont_let_pairs(cont, env, rest, pair_list) if rest else cont
  def cont_let_pairs(value):
    'save the value resulting from evaluating val_expr into the pair list.'
    pair_list.append((name, value))
    return cont_next, None
  return Cont_eval(cont_let_pairs, env, val_expr)


def Cont_let(cont, env, exprs, pair_list):
  def cont_let(value):
    bindings = dict(pair_list)
    let_env = Env(env, bindings)
    return sub_eval_expr_list(cont, let_env, exprs)
  return cont_let


def eval_let(cont, env, code):
  assert code.hd == S_let
  rest = code.tl
  pair_exprs = rest.hd
  exprs = rest.tl
  pair_list = []
  cont_let = Cont_let(cont, env, exprs, pair_list)
  cont_let_pairs = Cont_let_pairs(cont_let, env, pair_exprs, pair_list)
  return (cont_let_pairs, None)


# if

def Cont_if(cont, env, then_code, else_code):
  def cont_if(value):
    return eval_(cont, env, then_code if value else else_code)
  return cont_if


def eval_if(cont, env, code):
  assert code.hd == S_if
  rest = code.tl
  predicate = rest.hd
  rest = rest.tl
  then_code = rest.hd
  rest = rest.tl
  if rest is not None:
    else_code = rest.hd
    assert rest.tl is None
  else:
    else_code = None
  cont_if = Cont_if(cont, env, then_code, else_code)
  return eval_(cont_if, env, predicate)


# define

def Cont_define(cont, env, var_name):
  def cont_define(value):
    env.define(var_name, value)
    return cont, None
  return cont_define


def eval_define(cont, env, code):
  assert code.hd == S_define
  rest = code.tl
  var_name = rest.hd
  rest = rest.tl
  expr = rest.hd
  assert rest.tl is None
  define_cont = Cont_define(cont, env, str(var_name))
  return eval_(define_cont, env, expr)
  

# set

def Cont_set(cont, env, var_name):
  def cont_set(value):
    env.set(var_name, value)
    return cont, None
  return cont_set


def eval_set(cont, env, code):
  assert code.hd == S_set
  rest = code.tl
  expr = rest.hd
  assert rest.tl is None
  cont = Cont_set(cont, env, str(var_name))
  return eval_(cont, env, expr)


# load

def eval_load(cont, env, code):
  assert code.hd == S_load
  rest = code.tl
  path = rest.hd
  assert rest.tl is None
  return sub_eval_load_from_path(cont, env, path)


# apply

def Cont_args(cont_arg_list, env, exprs, val_list):
  '''
  recursive continuation for the evaluation of function arguments.
  exprs is the chain of expressions.
  val_list is a python list that accumulates the argument values.
  '''
  expr = exprs.hd
  rest = exprs.tl
  # recursively create continuations for the remainder of the arg list evaluation.
  cont_next = Cont_args(cont_arg_list, env, rest, val_list) if rest else cont_arg_list
  def cont_arg(value):
    'value is the result of evaluating expr; append it to the val_list.'
    val_list.append(value)
    return cont_next, None
  return Cont_eval(cont_arg, env, expr)


def Cont_arg_list(cont_apply, env, exprs):
  'continuation for the evaluation of function arguments.'
  val_list = [] # argument values accumulate here
  def cont_arg_list(value):
    'return the val list as a chain.'
    chain = chain_from_iterable(val_list)
    return cont_apply, chain
  # recursively create continuations to eval each arg
  return Cont_args(cont_arg_list, env, exprs, val_list)


def Cont_apply(cont):
  def cont_apply(value):
    '''
    value is the evaluated operator and args list.
    '''
    operator = value.hd
    args = value.tl
    return operator(cont, args)
  return cont_apply


def eval_apply(cont, env, code):
  cont_apply = Cont_apply(cont)
  cont_args = Cont_arg_list(cont_apply, env, code)
  return (cont_args, None)


# eval

def Cont_eval(cont, env, expr):
  'continuation for the evaluation of an expression.'
  def cont_eval(value_ignored):
    'value is ignored because result of eval call depends only on the environment passed in.'
    return eval_(cont, env, expr)
  return cont_eval


def eval_(cont, env, code):
  'evaluate code in the context of env, with cont as the following computational step.'
  if isinstance(code, Link):
    if code.hd == S_quote:
      return eval_quote(cont, env, code)
    if code.hd == S_begin:
      return eval_begin(cont, env, code)
    if code.hd == S_lambda:
      return eval_lambda(cont, env, code)
    if code.hd == S_let:
      return eval_let(cont, env, code)
    if code.hd == S_if:
      return eval_if(cont, env, code)
    if code.hd == S_define:
      return eval_define(cont, env, code)
    if code.hd == S_set:
      return eval_set(cont, env, code)
    if code.hd == S_load:
      return eval_load(cont, env, code)
    return eval_apply(cont, env, code)
  elif isinstance(code, Symbol):
    return (cont, env.get(code.name))
  else: # atoms evaluates to themselves
    return (cont, code)


# continuation eval loop


def eval_loop(cont):
  '''
  the core of the interpreter.
  trampoline loop over the current continuation; each iteration runs a step of the computation.
  '''
  try:
    value = None
    while cont:
      if trace_enabled:
        print(cont_sym, cont)
      cont, value = cont(value)
      if trace_enabled and value:
        print(trace_sym, value, file=sys.stderr)
    return value
  except KeyboardInterrupt:
    print(' Interrupt')
  except PloyError as e:
    print()
    print('error:', e.message)
  return None


# read eval loop


def token_level(t):
  if t == T_op:
    return 1
  if t == T_cp:
    return -1
  return 0


def read_input():
  'prompt and read input from stdin.'
  tokens = []
  level = 0
  while not tokens or level > 0:
    prompt = rep_continue_prompt if tokens else rep_prompt
    line = input(prompt)
    line_tokens = tokenize(line)
    for t, v in line_tokens: # unpack tokens into type and value
      level += token_level(t)
    tokens.extend(line_tokens)
  # check for excessive tokens
  if level < 0:
    l = 0
    culprits = []
    for i, (t, v) in enumerate(tokens):
      l += token_level(t)
      if l < 0:
        culprits = [v for t, v in tokens[i:i + 16]]
        break
    raise PloyParseError('unexpected tokens:', *culprits)
  return tokens


def rep_loop():
  '''
  read-eval-print loop for interactive session.
  '''
  while True:
    try:
      tokens = read_input()
      cont, value_ignored = sub_eval_tokens(None, global_env, tokens)
      value = eval_loop(cont)
      if value is not None:
        print(rep_val_sym, value)
    except EOFError: # exit the REPL
      print()
      break
    # error handling in eval_loop is duplicated here to catch errors in sub_eval_tokens
    except KeyboardInterrupt:
      print(' Interrupt')
    except PloyError as e:
      print()
      print('error:', e.message)


if __name__ == '__main__':
  args = sys.argv[1:]
  flags = [a for a in args if a.startswith('-')]
  paths = [a for a in args if not a.startswith('-')]

  for f in flags:
    if f not in known_flags:
      error('unknown flag:', f)

  trace_enabled = ('-trace' in flags)

  for path in paths:
    cont, value = sub_eval_load_from_path(None, global_env, path)
    eval_loop(cont)

  if not paths:
    rep_loop()
