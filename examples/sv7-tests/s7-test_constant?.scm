(test (constant? '__c1__) #t)
(test (constant? pi) #t)
(test (constant? 'pi) #t) ; take that, Clisp!
(test (constant? 12345) #t)
(test (constant? 3.14) #t)
(test (constant? :asdf) #t) 
(test (constant? 'asdf) #f)
(test (constant? "hi") #t) 
(test (constant? #\a) #t) 
(test (constant? #f) #t) 
(test (constant? #t) #t) 
(test (constant? '()) #t) 
(test (constant? ()) #t) 
(test (constant? '(a)) #t) 
(test (constant? '*features*) #f)
(test (let ((a 3)) (constant? 'a)) #f)
(test (constant? 'abs) #f)
(test (constant? abs) #t)
(test (constant? most-positive-fixnum) #t)
(test (constant? (/ (log 0))) #t)       ; nan.0 is a constant as a number I guess
(test (constant? 1/0) #t)
(test (constant? (log 0)) #t)
(test (constant?) 'error)
(test (constant? 1 2) 'error)
(test (constant? #<eof>) #t) ; ?
(test (constant? '-) #f)
(test (constant? ''-) #t)
(test (constant? '''-) #t)
(test (constant? '1) #t)
(test (constant? 1/2) #t)
(test (constant? 'with-environment) #t)
(test (constant? with-environment) #t)

;; and some I wonder about -- in CL's terms, these always evaluate to the same thing, so they're constantp
;;   but Clisp:
;;     (constantp (cons 1 2)) ->NIL
;;     (constantp #(1 2)) -> T
;;     (constantp '(1 . 2)) -> NIL
;; etc -- what a mess!

(test (constant? (cons 1 2)) #t)
(test (constant? #(1 2)) #t)
(test (constant? (list 1 2)) #t)
(test (constant? (vector 1 2)) #t)
(test (let ((v (vector 1 2))) (constant? v)) #t) ;!!
;; it's returning #t unless the arg is a symbol that is not a keyword or a defined constant
;; (it's seeing the value of v, not v):
(test (let ((v (vector 1 2))) (constant? 'v)) #f)
;; that is something that can be set! is not a constant?

(if with-bignums
    (begin
      (test (constant? 1624540914719833702142058941) #t)
      (test (constant? 1624540914719833702142058941.4) #t)
      (test (constant? 7151305879464824441563197685/828567267217721441067369971) #t)))

(test (constant? lambda) #t)   ; like abs?
(test (constant? (lambda () 1)) #t)
(test (constant? ''3) #t)
(test (constant? (if #f #f)) #t)
(test (constant? 'x) #f)
(test (let ((x 'x)) (and (not (constant? x)) (equal? x (eval x)))) #t)
(test (and (constant? (list + 1)) (not (equal? (list + 1) (eval (list + 1))))) #t)

;; not sure this is the right thing...
;; but CL makes no sense: 
;; [3]> (constantp (vector 1))
;; T
;; [4]> (constantp (cons 1 2))
;; NIL
;; [5]> (constantp (list 1))
;; NIL
;; [7]> (constantp "hi")
;; T
;; (setf (elt "hi" 1) #\a)
;; #\a
;; at least they finally agree that pi is a constant!

(let ()
  (define-constant __hi__ (vector 3 0))
  (set! (__hi__ 1) 231)
  (test __hi__ #(3 231)))
;; that is, hi is the constant as a vector, not the vector elements
