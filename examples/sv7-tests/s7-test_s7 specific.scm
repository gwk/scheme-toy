;;; keyword?
;;; make-keyword
;;; keyword->symbol
;;; symbol->keyword

(for-each
 (lambda (arg)
   (test (keyword? arg) #f))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(test (cond ((cond (())) ':)) ':)
(test (keyword? :#t) #t)
(test (eq? #t :#t) #f)
;(test (keyword? '#:t) #f)  ; these 2 are fooled by the Guile-related #: business (which is still supported)
;(test (keyword? '#:#t) #f)
;#:1.0e8 is also a keyword(!) 
;#:# is also, so #:#() is interpreted as #:# '()

(test (keyword? :-1) #t)
(test (keyword? :0/0) #t)
(test (keyword? :1+i) #t)
(test (keyword? :1) #t)
(test (keyword? 0/0:) #t)
(test (keyword? 1+i:) #t)
(test (keyword? 1:) #t)
;;; bizarre...

(test (keyword? (symbol ":#(1 #\\a (3))")) #t)
(test (keyword? (make-keyword (object->string #(1 #\a (3)) #f))) #t)
(test (keyword? begin) #f)
(test (keyword? if) #f)

(let ((kw (make-keyword "hiho")))
  (test (keyword? kw) #t)
  (test (keyword->symbol kw) 'hiho)
  (test (symbol->keyword 'hiho) kw)
  (test (keyword->symbol (symbol->keyword 'key)) 'key)
  (test (symbol->keyword (keyword->symbol (make-keyword "hi"))) :hi)
  (test (keyword? :a-key) #t)
  (test (keyword? ':a-key) #t)
  (test (keyword? ':a-key:) #t)
  (test (keyword? 'a-key:) #t)
  (test (symbol? (keyword->symbol :hi)) #t)
  (test (keyword? (keyword->symbol :hi)) #f)
  (test (symbol? (symbol->keyword 'hi)) #t)
  (test (equal? kw :hiho) #t)
  (test ((lambda (arg) (keyword? arg)) :hiho) #t)
  (test ((lambda (arg) (keyword? arg)) 'hiho) #f)
  (test ((lambda (arg) (keyword? arg)) kw) #t)
  (test ((lambda (arg) (keyword? arg)) (symbol->keyword 'hiho)) #t)
  (test (make-keyword "3") :3)
  (test (keyword? :3) #t)
  (test (keyword? ':3) #t)
  (test (eq? (keyword->symbol :hi) (keyword->symbol hi:)) #t)
  (test (equal? :3 3) #f)
  (test (equal? (keyword->symbol :3) 3) #f)
  (test (equal? (symbol->value (keyword->symbol :3)) 3) #f) ; 3 as a symbol has value #<undefined>

#|
  (let ()
    (apply define (symbol "3") '(32))
    (test (symbol->value (symbol "3")) 32) ; hmmm
    (apply define (list (symbol "3") (lambda () 32)))
    (test (symbol->value (symbol "3")) 32)
    (apply define (symbol ".") '(123))
    (test (+ (symbol->value (symbol ".")) 321) 444))
|#

  (test (keyword? '3) #f)
  (test (keyword? ':) #f)
  (test (keyword? '::) #t)
  (test (keyword? ::) #t)
  (test (keyword? ::a) #t)
  (test (eq? ::a ::a) #t)
  (test (eq? (keyword->symbol ::a) :a) #t)
  (test (eq? (symbol->keyword :a) ::a) #t)
  (test (symbol->string ::a) "::a")
  (test ((lambda* (:a 32) ::a) 0) 'error) ; :a is a constant
  (test (eq? :::a::: :::a:::) #t)
  (test (keyword? a::) #t)
  (test (keyword->symbol ::) ':)
  (test (keyword? :optional) #t)
  (test (symbol->string (keyword->symbol hi:)) "hi")
  (test (symbol->string (keyword->symbol :hi)) "hi")
  (test (keyword? (make-keyword (string #\x (integer->char 128) #\x))) #t)
  (test (keyword? (make-keyword (string #\x (integer->char 200) #\x))) #t)
  (test (keyword? (make-keyword (string #\x (integer->char 255) #\x))) #t)
  (test (make-keyword ":") ::)
  (test (make-keyword (string #\")) (symbol ":\""))
  (test (keyword? (make-keyword (string #\"))) #t)
  (test (keyword->symbol (make-keyword (string #\"))) (symbol "\""))
  )

(test (symbol->keyword 'begin) :begin)
(test (symbol->keyword 'quote) :quote)
(test (symbol->keyword if) 'error)
(test (symbol->keyword quote) 'error)

(test (let ((:hi 3)) :hi) 'error)
(test (set! :hi 2) 'error)
(test (define :hi 3) 'error)

(let ((strlen 8))
  (let ((str (make-string strlen)))
    (do ((i 0 (+ i 1)))
	((= i 10))
      (do ((k 0 (+ k 1)))
	  ((= k strlen))
	(set! (str k) (integer->char (+ 1 (random 255)))))
      (let ((key (make-keyword str)))
	(let ((newstr (symbol->string (keyword->symbol key))))
	  (if (not (string=? newstr str))
	      (format #t ";make-keyword -> string: ~S -> ~A -> ~S~%" str key newstr)))))))

(let ()
  (define* (hi a b) (+ a b))
  (test (hi 1 2) 3)
  (test (hi :b 3 :a 1) 4)
  (test (hi b: 3 a: 1) 4))

(for-each
 (lambda (arg)
   (test (make-keyword arg) 'error))
 (list -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (keyword->symbol arg) 'error))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (symbol->keyword arg) 'error))
 (list "hi" -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(test (keyword?) 'error)
(test (keyword? 1 2) 'error)
(test (make-keyword) 'error)
(test (make-keyword 'hi 'ho) 'error)
(test (keyword->symbol) 'error)
(test (keyword->symbol :hi :ho) 'error)
(test (symbol->keyword) 'error)
(test (symbol->keyword 'hi 'ho) 'error)



;;; --------------------------------------------------------------------------------
;;; gensym
(for-each
 (lambda (arg)
   (test (gensym arg) 'error))
 (list -1 #\a 1 'hi _ht_ '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(test (gensym "hi" "ho") 'error)

(test (symbol? (gensym)) #t)
(test (symbol? (gensym "temp")) #t)
(test (eq? (gensym) (gensym)) #f)
(test (eqv? (gensym) (gensym)) #f)
(test (equal? (gensym) (gensym)) #f)
(test (keyword? (gensym)) #f)
(test (let* ((a (gensym)) (b a)) (eq? a b)) #t)
(test (let* ((a (gensym)) (b a)) (eqv? a b)) #t)
(test (keyword? (symbol->keyword (gensym))) #t)
(test (let ((g (gensym))) (set! g 12) g) 12)

(let ((sym (gensym)))
  (test (eval `(let ((,sym 32)) (+ ,sym 1))) 33))

(let ((sym1 (gensym))
      (sym2 (gensym)))
  (test (eval `(let ((,sym1 32) (,sym2 1)) (+ ,sym1 ,sym2))) 33))
(test (eval (let ((var (gensym "a b c"))) `(let ((,var 2)) (+ ,var 1)))) 3)
(test (eval (let ((var (gensym ""))) `(let ((,var 2)) (+ ,var 1)))) 3)
(test (eval (let ((var (gensym "."))) `(let ((,var 2)) (+ ,var 1)))) 3)
(test (eval (let ((var (gensym "{"))) `(let ((,var 2)) (+ ,var 1)))) 3)
(test (eval (let ((var (gensym "}"))) `(let ((,var 2)) (+ ,var 1)))) 3)
(test (eval (let ((var (gensym (string #\newline)))) `(let ((,var 2)) (+ ,var 1)))) 3)

(test (let ((hi (gensym))) (eq? hi (string->symbol (symbol->string hi)))) #t)
(test (let () (define-macro (hi a) (let ((var (gensym ";"))) `(let ((,var ,a)) (+ 1 ,var)))) (hi 1)) 2)
(test (let () (define-macro (hi a) (let ((funny-name (string->symbol (string #\;)))) `(let ((,funny-name ,a)) (+ 1 ,funny-name)))) (hi 1)) 2)
(test (let () (define-macro (hi a) (let ((funny-name (string->symbol "| e t c |"))) `(let ((,funny-name ,a)) (+ 1 ,funny-name)))) (hi 2)) 3)

(let ((funny-name (string->symbol "| e t c |")))
  (define-macro (hi a) 
    `(define* (,a (,funny-name 32)) (+ ,funny-name 1)))
  (hi func)
  (test (func) 33)
  (test (func 1) 2)
  ;(procedure-source func) '(lambda* ((| e t c | 32)) (+ | e t c | 1))
  (test (apply func (list (symbol->keyword funny-name) 2)) 3)
  )

(let ((funny-name (string->symbol "| e t c |")))
  (apply define* `((func (,funny-name 32)) (+ ,funny-name 1)))
  (test (apply func (list (symbol->keyword funny-name) 2)) 3))
