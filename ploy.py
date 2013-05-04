#!/usr/bin/env python3

'''
Interpreter for a Scheme-like language.
Derived from: http://thinkpython.blogspot.com/2005/02/simple-scheme-interpreter.html
'''

import re
import functools
import operator
import sys

from pprint import pprint


rep_prompt = white_right_pointing_triangle = '▷ '
rep_continue_prompt = ellipsis = '… '
trace_sym = white_bullet = '◦'
cont_sym = white_down_pointing_small_triangle = '▿'
rep_val_sym = white_circle = '○'

options = { '-trace' }

trace_enabled = False


def error(*items):
  print(*items, file=sys.stderr)
  sys.exit(1)


class PloyError(Exception):

  def __init__(self, *items):
    self.message = ' '.join(str(i) for i in items)
    super().__init__(self, self.message)


class TokenError(PloyError):
  pass


class ParseError(PloyError):
  pass


class EnvError(PloyError):
  pass


class Symbol:

  def __init__(self, name):
    self.name = name

  def __str__(self):
    return self.name

  def __repr__(self):
    return '<Symbol: {}>'.format(repr(self.name))

  def __eq__(self, other):
    return self.name == other.name if isinstance(other, Symbol) else False


class Env:
  
  def setVars(self, names, values):
    if names == None:
      return
    elif isinstance(names, Symbol):
      self.vars[str(names)] = values
    else:   
      name, restNames = names
      value, restValues = values
      self.vars[str(name)]=value
      self.setVars(restNames, restValues)

  def __init__(self, parent, var_names = None, values = None):
    self.parent = parent
    self.vars = {}
    self.setVars(var_names, values)

  def get(self, var_name):
    if var_name in self.vars:
      return self.vars[var_name]
    elif self.parent != None:
      return self.parent.get(var_name)
    else:
      raise EnvError('get unknown variable:', var_name)

  def set(self, var_name, value):
    if var_name in self.vars:
      self.vars[var_name] = value
    elif self.parent != None:
      return self.parent.set(var_name, value)
    else:
      raise EnvError('set unknown variable:', var_name)

  def define(self, var_name, value):
    self.vars[var_name] = value
    


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
| [\w+\-*/<>=!?]+ # sym
)''', flags=re.VERBOSE)


def gen_tokens(source_text):  
  parts = tokens_re.split(source_text)
  #pprint(parts, indent=2)
  for i, part in enumerate(parts):
    if i % 2 == 0:
      if part and not part.isspace():
        raise TokenError('Invalid token separator:', repr(part))
      continue
    if part.startswith(';'): # comment
      continue
    if part == '(':
      yield (T_op, part)
    elif part == ')':
      yield (T_cp, part)
    elif part == '.':
      yield (T_dot, part)
    elif part == "'":
      yield (T_sq, part)
    elif part.isdigit():
      yield (T_atom, int(part))
    elif part[0] == '"':
      yield (T_atom, part[1:-1].replace(r'\\', '\\').replace(r'\"', r'"'))
    elif part[0] == '#':
      if part[1] == '\\':
        char = part[2:]
        if char == 'space':
          char = ' '
        if char == 'newline':
          char = '\n'
        yield (T_atom, char)
      elif part[1] == 't':
        yield (T_atom, True)
      elif part[1] == 'f':
        yield (T_atom, False)
      else:
        raise TokenError('Invalid token:', repr(part))
    else:
      yield (T_sym, Symbol(part))


def tokenize(source_text):
  'we want to do all tokenizing in a single step so that we detect any syntax errors first.'
  return list(gen_tokens(source_text))


# s-expressions

# predefined symbols
S_lambda, S_if, S_begin, S_set, S_define, S_load, S_quote \
= (Symbol(s) for s in ('lambda', 'if', 'begin', 'set!', 'define', 'load', 'quote'))


def sexpr(token_stream):
  'parse an s-expression from a token stream.'
  token_type, value = next(token_stream)
  if token_type == T_sq:
    return [S_quote, [sexpr(token_stream), None]]
  elif token_type == T_op:
    cons = [None, None]
    lst = cons
    sub_value = None
    while True:
      sub_value = sexpr(token_stream)
      if sub_value not in [')', '.']:
        cons[1] = [sub_value, None]
        cons = cons[1]
      else:
        break
    if sub_value == '.':
      cons[1] = sexpr(token_stream)
      token_type, sub_value = next(token_stream)
    if sub_value == ')':
      return lst[1]
    else:
      raise ParseError('Expected closing parenthesis for expression:', lst, sub_value)
  else:
    return value


def sexprs(token_stream):
  'parse a sequence of s-expressions from a token stream.'
  lst = [None, None]
  cur = lst
  try:
    while True:
      cur[1] = [sexpr(token_stream), None]
      cur = cur[1]
  except StopIteration:
    pass
  return lst[1]
    
    
def native_fn(py_fn):
  '''
  wrap a python function in a CPS interpreter function.
  used to create various builtin functions.
  '''
  def f(cont, args):
    argList = []
    while args != None:
      arg, args = args
      argList.append(arg)
    return cont, py_fn(*argList)
  return f


def create_eval_fn(env):
  '''
  create a scheme eval function using the given environment.
  used to create the 'eval' scheme builtin.
  '''
  def eval_func(cont, arg):
    expr, nil = arg
    return (Cont_eval(cont, env, expr), None)
  return eval_func


def py_exec(cont, arg):
  'py-exec builtin implementation.'
  code, nil = arg
  exec(code, py_env)
  return (cont, None)


def py_eval(cont, arg):
  'py-eval builtin implementation.'
  code, nil = arg
  return (cont, eval(code, py_env))


def call_cc(cont, args):
  'call/cc builtin implementation.'
  func, nil = args
  def cont_func(cont_ignored, arg_nil):
    'note that the argument continuation is ignored and replaced by the captured continuation.'
    arg, nil = arg_nil
    return (cont, arg)
  return func(cont, (cont_func, None))


# environment for py-exec and py-eval
py_env = {}

global_env = Env(None)

global_env.vars = {
  'eval'    : create_eval_fn(global_env), # note the reference cycle
  'py-exec' : py_exec,
  'py-eval' : py_eval,
  'call/cc' : call_cc,
  'call-with-current-continuation' : call_cc,
}


def add_native_fn(name, py_fn):
  'wrapper used to give builtin functions names for error clarity.'
  f = native_fn(py_fn)
  f.__qualname__ = 'native:' + name
  global_env.vars[name] = f


add_native_fn('+', lambda *args: sum(args))
add_native_fn('*', lambda *args: functools.reduce(operator.mul, args))
add_native_fn('-', lambda a, b: a - b)
add_native_fn('<', lambda a, b: a < b)
add_native_fn('>', lambda a, b: a > b)
add_native_fn('<=', lambda a, b: a <= b)
add_native_fn('>=', lambda a, b: a >= b)
add_native_fn('eq?', lambda a, b: a == b)
add_native_fn('cons', lambda a, b: [a, b])
add_native_fn('car', lambda a_b: a_b[0])
add_native_fn('cdr', lambda a_b: a_b[1])
add_native_fn('display', print)

# for now define test as a  builtin function; should be a macro
def test(a, b):
  if a == b:
    print(a)
  else:
    print('test failed:')
    print(' ', a)
    print(' ', b)
    sys.exit(1)
  
add_native_fn('test', test)


# continuations


class Cont_eval:
  'continuation for the evaluation of an expression.'
  def __init__(self, cont, env, expr):
    self.cont = cont
    self.env = env
    self.expr = expr
  def run(self, val_ignored):
    return eval_(self.cont, self.env, self.expr)


class Cont_expr_list:
  def __init__(self, cont, env, exprs):
    expr, rest = exprs
    self.cont = Cont_expr_list(cont, env, rest) if rest else cont
    self.env = env
    self.expr = expr
  def run(self, val_ignored):
    return eval_(self.cont, self.env, self.expr)


class Cont_define:
  def __init__(self, cont, env, var_name):
    self.cont = cont
    self.env = env
    self.var_name = var_name
  def run(self, value):
    self.env.define(self.var_name, value)
    return self.cont, None


class Cont_set:
  def __init__(self, cont, env, var_name):
    self.cont = cont
    self.env = env
    self.var_name = var_name
  def run(self, value):
    self.env.set(self.var_name, value)
    return self.cont, None


class Cont_if:
  def __init__(self, cont, env, then_code, else_code):
    self.cont = cont
    self.env = env
    self.then_code = then_code
    self.else_code = else_code
  def run(self, value):
    if value:
      return eval_(self.cont, self.env, self.then_code)
    else:
      return eval_(self.cont, self.env, self.else_code)


class Cont_apply:
  def __init__(self, cont):
    self.cont = cont
  def run(self, value_fn):
    return value_fn(self.cont, self.params)


class Cont_param:
  def __init__(self, cont, prev):
    self.cont = cont
    self.prev = prev
    self.params = None
  def run(self, value):
    self.prev.params = (value, self.params)
    return (self.cont, None)


class Cont_list_param:
  def __init__(self, cont, prev):
    self.cont = cont
    self.prev = prev
  def run(self, value):
    self.prev.params = value
    return (self.cont, None)



# evaluation helpers


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


# evaluation methods


def eval_set(cont, env, code):
  set_sym, (var_name, (expr, nil)) = code
  cont = Cont_set(cont, env, str(var_name))
  return eval_(cont, env, expr)


def eval_quote(cont, env, code):
  quote_sym, (item, nil) = code
  return (cont, item)


def eval_begin(cont, env, code):
  begin_sym, exprs = code
  return sub_eval_expr_list(cont, env, exprs)


def eval_lambda(cont, parent_env, code):
  lambda_sym, (params, exprs) = code
  def func(cont, args):
    new_env = Env(parent_env, params, args)
    return sub_eval_expr_list(cont, new_env, exprs)
  return (cont, func)


def eval_if(cont, env, code):
  if_sym, (predicate, (then_code, rest)) = code
  else_code = rest[0] if rest else None
  return eval_(Cont_if(cont, env, then_code, else_code), env, predicate)


def eval_define(cont, env, code):
  define_sym, (var_name, (expr, nil)) = code
  cont = Cont_define(cont, env, str(var_name))
  return eval_(cont, env, expr)
  

def eval_load(cont, env, code):
  load_sym, (path, nil) = code
  return sub_eval_load_from_path(cont, env, path)
  

def make_param_conts(cont, prev, env, code):
  assert isinstance(code, list)
  expr, rest = code
  cont_param = Cont_param(cont, prev)
  cont = Cont_eval(cont_param, env, expr)
  if rest == None:
    return cont
  else:
    return make_param_conts(cont, cont_param, env, rest)
    
  
def eval_apply(cont, env, code):
  operator, exprs = code
  apply_cont = Cont_apply(cont)
  eval_cont = Cont_eval(apply_cont, env, operator)
  cont = make_param_conts(eval_cont, apply_cont, env, exprs)
  return (cont, None)



def eval_(cont, env,  code):
  if isinstance(code, list):
    if code[0] == S_lambda:
      return eval_lambda(cont, env,  code)
    elif code[0] == S_if:
      return eval_if(cont, env, code)
    elif code[0]== S_begin:
      return eval_begin(cont, env, code)
    elif code[0] == S_define:
      return eval_define(cont, env, code)
    elif code[0] == S_set:
      return eval_set(cont, env, code)
    elif code[0] == S_quote:
      return eval_quote(cont, env, code)
    elif code[0] == S_load:
      return eval_load(cont, env, code)
    else:
      return eval_apply(cont, env, code)
  elif isinstance(code, Symbol):
    return (cont, env.get(str(code)))
  else: # atom evaluates to self
    return (cont, code)



# continuation eval loop


def eval_loop(cont):
  'trampoline loop over the current continuation; each iteration runs a step of the computation.'
  value = None
  while cont:
    if trace_enabled:
      print(cont_sym, cont)
    cont, value = cont.run(value)
    if trace_enabled and value:
      print(trace_sym, value, file=sys.stderr)
  return value


# read eval loop


def token_level(t):
  if t == T_op:
    return 1
  if t == T_cp:
    return -1
  return 0


def read_input():
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
    raise ParseError('unexpected tokens:', *culprits)
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
    # other errors return to top level of REPL
    except KeyboardInterrupt:
      print(' Interrupt')
      continue
    except PloyError as e:
      print()
      print(e.message)
      continue


if __name__ == '__main__':
  args = sys.argv[1:]
  trace_enabled = ('-trace' in args)
  paths = [a for a in args if a not in options]

  for path in paths:
    cont, value = sub_eval_load_from_path(None, global_env, path)
    eval_loop(cont)

  if not args:
    rep_loop()
