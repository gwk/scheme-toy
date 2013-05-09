(test (let () (length (current-environment))) 0)
(test (let ((a 1) (b 2) (c 3)) (length (current-environment))) 3)

(for-each
 (lambda (arg)
   (test (environment? arg) #f))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))
(let () (test (environment? (initial-environment)) #t))
(test (environment? (current-environment)) #t)
(test (environment? (global-environment)) #t)
(test (environment? (augment-environment '())) #t)
(test (environment? (augment-environment! '())) #t)
(test (environment? (augment-environment (augment-environment '()) '(a . 1))) #t)
(test (environment? (augment-environment '() '(a . 1))) #t)
(test (eq? abs ((global-environment) 'abs)) #t)
(test ((augment-environment () '(asdf . 32)) 'asdf) 32)
(test ((augment-environment () '(asdf . 32)) 'asd) #<undefined>)
(test (environment? (augment-environment (current-environment))) #t) ; no bindings is like (let () ...)
(test (augment-environment! (global-environment) '(quote . 1)) 'error)

#|
if t423.scm is
(define (t423-1 a b) (+ a b))
(define t423-2 423)
t423-2

then (let* ((a (load "t423.scm")) (b (t423-1 a 1))) b) -> t424 ; but t423-* are globals now

:(let((a (load "t423.scm")) (b (t423-1 a 1))) b)
;a: unbound variable
;    (t423-1 a 1)

:(letrec ((a (load "t423.scm")) (b (t423-1 a 1))) b)
;+ argument 1, #<undefined>, is an untyped but should be a number
;    (+ a b)
;    ["t423.scm", line 1]

:(letrec* ((a (load "t423.scm")) (b (t423-1 a 1))) b)
424

:(letrec ((a (load "t423.scm"))) (t423-1 a 1))
424

:(letrec ((a (load "t423.scm") (current-environment))) (t423-1 a 1))
;letrec variable declaration has more than one value?: (a (load "t423.scm") (current-environment))
;    (letrec ((a (load "t423.scm") (current-environment)) (b 1)) (t423-1 a 1))

; and let/let*/letrec* also

:(let () (let () (let* ((a (load "t423.scm" (outer-environment (current-environment))))) a) (t423-1 2 1)))
3
:(let () (let () (let* ((a (load "t423.scm" (outer-environment (current-environment))))) a) 1) (t423-1 2 1))
3
:(let () (let () (let* ((a (load "t423.scm" (current-environment)))) a) 1) (t423-1 2 1))
;t423-1: unbound variable
;    (t423-1 2 1)
:(let () (let () (let* ((a (load "t423.scm" (current-environment)))) a) (t423-1 2 1)))
3
:(let () (let ((t423-1 #t)) (let* ((a (load "t423.scm" (current-environment)))) a) (t423-1 2 1)))
3
|#

(test (let ((#_+ 3)) #_+) 'error)
(test (define #_+ 3) 'error)
(test (set! #_+ 3) 'error)

(test (let ()
	(with-environment (current-environment) (define hiho 43))
	hiho)
      43)
(let ()
  (define-macro (define! env . args) 
    `(with-environment ,env (define ,@args)))
  (test (let ()
	  (define! (current-environment) (hiho x) (+ x 1))
	  (hiho 2))
	3))


(let ()
  (with-environment (global-environment)
    (define (this-is-global a) (+ a 1))))

(test (this-is-global 2) 3)

(let ()
  (with-environment (environment)
    (define (this-is-not-global a) (+ a 1))))

(test (this-is-not-global 2) 'error)


(let ()
  (apply augment-environment! (current-environment)
	 (with-environment (initial-environment)
	   (let ()
	     (define (lognor n1 n2) (lognot (logior n1 n2)))
	     (define (logit n1) n1)

	     (map (lambda (binding)
		    (cons (string->symbol 
			   (string-append "library:" (symbol->string (car binding))))
			  (cdr binding)))
		  (environment->list (current-environment))))))
  (test (library:lognor 1 2) -4))


(test (null? (environment->list (global-environment))) #f)

(test (environment? (environment)) #t)
(test (length (environment)) 0)
(test (length (environment '(a . 2))) 1)
(test (with-environment (environment '(a . 2)) a) 2)
(test (with-environment (environment '(a . 2) '(b . 3)) (+ a b)) 5)
(test (eq? (environment) (global-environment)) #f)

(for-each
 (lambda (arg)
   (test (environment arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i pi abs macroexpand '() #<eof> #<unspecified> #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))

(test (let ((e (environment '(a . 1)))) ((lambda (x) (x *)) e)) 'error)
(test (let ((e (environment '(a . 1)))) ((lambda (x) (x pi)) e)) 'error)
(test (let () (environment (cons pi 1))) 'error)
(test (let () (environment (cons "hi" 1))) 'error)

(for-each
 (lambda (arg)
   (test (environment->list arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i pi '() #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))

(for-each
 (lambda (arg)
   (test (open-environment arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i pi abs macroexpand '() #<eof> #<unspecified> #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))

(let ()
  (let ((_xxx_ 0))
    (let ((e (current-environment)))
      (for-each
       (lambda (arg)
	 (environment-set! e '_xxx_ arg)
	 (test (environment-ref e '_xxx_) arg))
       (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i pi abs macroexpand '() #<eof> #<unspecified> #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1)))))))

(test (environment-ref) 'error)
(test (environment-ref a b c) 'error)
(test (environment-ref (augment-environment ()) '_asdf_) #<undefined>)
(test (environment-ref (augment-environment () '(a . 3)) 'a) 3)
(test (environment-ref (augment-environment () '(a . 3)) 'A) #<undefined>)
(test (environment-ref (global-environment) '+) +)
(test (environment-ref (global-environment) +) 'error)
(test (environment-ref () '+) 'error)
(test (environment-ref (procedure-environment (let ((a 2)) (lambda (b) (+ a b)))) 'a) 2)
(let ((etest (let ((a 2)) (lambda (b) (+ a b))))) 
  (environment-set! (procedure-environment etest) 'a 32)
  (test (etest 1) 33))
(test (environment-set!) 'error)
(test (environment-set! a b) 'error)
(for-each
 (lambda (arg)
   (test (environment-ref arg 'a) 'error)
   (test (environment-set! arg 'a 1) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i pi abs macroexpand '() #<eof> #<unspecified> #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))

(for-each
 (lambda (arg)
   (test (open-environment? arg) #f))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() abs macroexpand #<eof> #<unspecified> #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))

(test (open-environment) 'error)
(test (open-environment 1 2) 'error)
(test (open-environment?) 'error)
(test (open-environment? 1 2) 'error)
(test (open-environment (global-environment)) 'error)

(let ((f (lambda (x) (+ x 1))))
  (test (open-environment? f) #f)
  (open-environment f)
  (test (open-environment? f) #t))

(let ((f (lambda* (x) (+ x 1))))
  (test (open-environment? f) #f)
  (open-environment f)
  (test (open-environment? f) #t))

(let ((f (augment-environment ())))
  (test (open-environment? f) #f)
  (open-environment f)
  (test (open-environment? f) #t))

(let ()
  (define-macro (f x) `(+ ,x 1))
  (test (open-environment? f) #f)
  (test (open-environment f) 'error)
  (test (open-environment? f) #f))

(let ()
  (define-bacro* (f x) `(+ ,x 1))
  (test (open-environment? f) #f)
  (test (open-environment f) 'error)
  (test (open-environment? f) #f))

(test (current-environment 1) 'error)
(test (global-environment 1) 'error)
(test (initial-environment 1) 'error)
(test (set! (current-environment) 1) 'error)
(test (set! (global-environment) 1) 'error)
(test (set! (initial-environment) 1) 'error)
(test (let () (set! initial-environment 2)) 'error)
(test (let ((initial-environment 2)) initial-environment) 'error)

(test (let ((e (augment-environment () '(a . 1)))) ((lambda (x) (x *)) e)) 'error)
(test (let ((e (augment-environment () '(a . 1)))) ((lambda (x) (x pi)) e)) 'error)
(test (let () (augment-environment () (cons pi 1))) 'error)
(test (let () (augment-environment () (cons "hi" 1))) 'error)
(test (let () (augment-environment! () (cons pi 1))) 'error)
(test (let () (augment-environment! () (cons "hi" 1))) 'error)

(test (eq? (global-environment) '()) #f)
(test (eq? (global-environment) (global-environment)) #t)
(test (eq? (global-environment) (initial-environment)) #f)
(test (eqv? (global-environment) (global-environment)) #t)
(test (eqv? (global-environment) (initial-environment)) #f)
(test (equal? (global-environment) (global-environment)) #t)
(test (equal? (global-environment) (initial-environment)) #f)
;(test (equal? (current-environment) (initial-environment)) #f)
(let ((e #f) (g #f))
  (set! e (current-environment))
  (set! g (global-environment))
  (if (not (equal? e (current-environment))) ; test here introduces a new environment
      (format #t ";(equal? e (current-environment)) -> #f?~%"))
  (test g (global-environment))
  (test (equal? e g) #f)
  (let ()
    (if (equal? e (current-environment))
	(format #t ";2nd case (equal? e (current-environment)) -> #t?~%"))))

(let ()
  (define global-env (global-environment)) 
  (test (equal? global-env (global-environment)) #t)
  (test (equal? (list global-env) (list (global-environment))) #t)
  (test (morally-equal? global-env (global-environment)) #t)
  (test (morally-equal? (list global-env) (list (global-environment))) #t))

(test (let ((a 1) (b 2)) (map cdr (current-environment))) '(1 2))
(test (let () (map cdr (current-environment))) '())
(test (let ((vals ())) (let ((a 1) (b 2)) (for-each (lambda (slot) (set! vals (cons (cdr slot) vals))) (current-environment))) vals) '(2 1))
(test (let ((a '(1 2 3)) (b '(3 4 5)) (c '(6 7 8))) (map + a b c (apply values (map cdr (current-environment))))) '(20 26 32))
(test (let ((a 1) (b 2) (c 3)) (map (lambda (a b) (+ a (cdr b))) (list 1 2 3) (current-environment))) '(2 4 6))

(test (let () (format #f "~A" (current-environment))) "#<environment>") 
;(test (let ((a 32) (b '(1 2 3))) (format #f "~A" (current-environment))) "#<environment>")
;(test (let ((a 1)) (object->string (current-environment))) "#<environment>")
(test (let ((a 1)) (object->string (global-environment))) "#<global-environment>")
(test (format #f "~A" (global-environment)) "#<global-environment>")
(test (let ((a 32) (b #(1 2 3))) (format #f "~{~A~^ ~}" (current-environment))) "(a . 32) (b . #(1 2 3))")

(test (object->string (global-environment)) "#<global-environment>")
(test (let () (object->string (current-environment))) "#<environment>")
(test (let ((a 3)) (object->string (current-environment))) "#<environment
  #<slot: a 3>>")
(test (let ((a 3) (b "hi")) (object->string (current-environment))) "#<environment
  #<slot: b \"hi\">
  #<slot: a 3>>")
(test (let ()
	(define (hi a b) (current-environment))
	(object->string (hi 3 4))) "#<environment
  #<slot: b 4>
  #<slot: a 3>>")


(test (let () (augment-environment! (initial-environment) (cons 'a 32)) (symbol->value 'a (initial-environment))) #<undefined>)
(test (let ((caar 123)) (+ caar (with-environment (initial-environment) (caar '((2) 3))))) 125)
(test (let ()
	(+ (let ((caar 123)) 
	     (+ caar (with-environment (initial-environment) 
                       (let ((val (caar '((2) 3)))) 
			 (set! caar -1) 
			 (+ val caar))))) ; 124
	   (let ((caar -123)) 
	     (+ caar (with-environment (initial-environment) 
                       (let ((val (caar '((20) 3)))) 
			 (set! caar -2) 
			 (+ val caar))))) ; -105
	   (caar '((30) 3)))) ; 30 + 19
      49)

(test (let ((a 1)) (eval '(+ a b) (augment-environment (current-environment) (cons 'b 32)))) 33)
(test (let ((a 1)) (+ (eval '(+ a b) (augment-environment (current-environment) (cons 'b 32))) a)) 34)
(test (let ((a 1)) (+ (eval '(+ a b) (augment-environment (current-environment) (cons 'b 32) (cons 'a 12))) a)) 45)
(test (let ((a 2)) (eval '(+ a 1) (augment-environment (current-environment)))) 3)
(test (let ((a 1)) (+ (eval '(+ a b) (augment-environment (augment-environment (current-environment) (cons 'b 32)) (cons 'a 12))) a)) 45)
(test (eval (list + 'a (eval (list - 'b) (augment-environment (initial-environment) (cons 'b 1)))) 
	    (augment-environment (initial-environment) (cons 'a 2))) 
      1)

(let ()
  (define (environment . args) 
    (apply augment-environment () args))
  (let ((e (environment '(a . 1) '(b . 2))))
    (test (eval '(+ a b 3) e) 6)))

;(test (eval 'a (augment-environment () '(a . 1) '(a . 2))) 'error) ; no longer an error, mainly for repl's convenience
;(test (eval 'a (augment-environment! () '(a . 1) '(a . 2))) 'error)
(test (eval 'pi (augment-environment () '(pi . 1) '(a . 2))) 'error)
(test (eval 'pi (augment-environment! () '(pi . 1) '(a . 2))) 'error)
(test (eval 'pi (augment-environment () (cons 'pi pi))) pi)
(test (eval 'pi (augment-environment! () (cons 'pi pi))) pi)
(test (map (augment-environment () '(asdf . 32) '(bsdf . 3)) '(bsdf asdf)) '(3 32))
(test (equal? (map (global-environment) '(abs cons car)) (list abs cons car)) #t)

(test (with-environment (augment-environment (environment) '(a . 1)) a) 1)
(test (with-environment (augment-environment (environment '(b . 2)) '(a . 1)) (+ a b)) 3)
(test (with-environment (augment-environment () (environment) '(a . 1)) a) 1)
(test (with-environment (augment-environment () (environment '(b . 2)) '(a . 1)) (+ a b)) 3)
(test (with-environment (augment-environment (environment '(b . 2) '(c . 3)) '(a . 1)) (+ a b c)) 6)

(let ()
  (define (e1) (let ((e (current-environment))) (with-environment e 0)))
  (define (e2 a) (let ((e (current-environment))) (with-environment e a)))
  (define (e3) (let ((e (current-environment))) (with-environment e 1 . 2)))
  (define (e4) (let ((e (current-environment))) (with-environment e 0 1)))
  (define (e5) (let ((e (current-environment))) (with-environment e (+ 1 2) (+ 2 3))))
  (test (e2 10) 10) (e1)
  (test (e1) (e2 0))
  (test (e3) 'error) (e4)
  (test (e4) 1) (e5)
  (test (e5) 5))

(let ()
  (define-constant _a_constant_ 32)
  (test (eval '_a_constant_ (augment-environment () (cons '_a_constant_ 1))) 'error)
  (test (eval '_a_constant_ (augment-environment () (cons '_a_constant_ 32))) 32))

(let ()
  (define-bacro (value->symbol val)
    `(call-with-exit
      (lambda (return)
	(do ((e (current-environment) (outer-environment e))) ()
	  (for-each 
	   (lambda (slot)
	     (if (equal? ,val (cdr slot))
		 (return (car slot))))
	   e)
	  (if (eq? e (global-environment))
	      (return #f))))))
  (test (let ((a 1) (b "hi")) (value->symbol "hi")) 'b))

(test (let ((a 1)) (eval-string "(+ a b)" (augment-environment (current-environment) (cons 'b 32)))) 33)
(test (let ((a 1)) (+ (eval-string "(+ a b)" (augment-environment (current-environment) (cons 'b 32))) a)) 34)
(test (let ((a 1)) (+ (eval-string "(+ a b)" (augment-environment (current-environment) (cons 'b 32) (cons 'a 12))) a)) 45)
(test (let ((a 2)) (eval-string "(+ a 1)" (augment-environment (current-environment)))) 3)
(test (let ((a 1)) (+ (eval-string "(+ a b)" (augment-environment (augment-environment (current-environment) (cons 'b 32)) (cons 'a 12))) a)) 45)
(test (eval-string (string-append "(+ a " (number->string (eval (list - 'b) (augment-environment (initial-environment) (cons 'b 1)))) ")")
		   (augment-environment (initial-environment) (cons 'a 2)))
      1)

(test (augment-environment) 'error)
(for-each
 (lambda (arg)
   (test (augment-environment arg '(a . 32)) 'error)
   (test (augment-environment! arg '(a . 32)) 'error))
 (list -1 #\a 1 3.14 3/4 1.0+1.0i "hi" 'hi #() #f _ht_))

(let ((e (augment-environment (current-environment)
			      (cons 'a 32)
			      (cons 'b 12))))
  (test (eval '(+ a b) e) 44)
  (test (eval '(+ a b c) (augment-environment e (cons 'c 3))) 47)
  (test (eval '(+ a b) (augment-environment e (cons 'b 3))) 35)
  (test (eval-string "(+ a b)" e) 44)
  (test (eval-string "(+ a b c)" (augment-environment e (cons 'c 3))) 47)
  (test (eval-string "(+ a b)" (augment-environment e (cons 'b 3))) 35)
  )

(test (with-environment (augment-environment '() '(a . 1)) (defined? 'a)) #t)
(test (defined? 'a (augment-environment '() '(a . 1))) #t)
(test (defined? 'b (augment-environment '() '(a . 1))) #f)
(test (defined? 'a '((a . 1))) 'error)
(test (defined? 'a '((a . 1) 2)) 'error)
(test (defined? 'a (augment-environment '())) #f)

(test (symbol->value 'a (augment-environment '() '(a . 1))) 1)
(test (symbol->value 'b (augment-environment '() '(a . 1))) #<undefined>)
(test (symbol->value 'a '((a . 1))) 'error)
(test (symbol->value 'a '((a . 1) 2)) 'error)

(test (eval 'a (augment-environment '() '(a . 1))) 1)
(test (eval 'a (augment-environment '() '(b . 1))) 'error)
(test (eval 'a '((a . 1))) 'error)
(test (eval 'a '((a . 1) 2)) 'error)

(test (eval-string "a" (augment-environment '() '(a . 1))) 1)
(test (eval-string "a" (augment-environment '() '(b . 1))) 'error)
(test (eval-string "a" '((a . 1))) 'error)
(test (eval-string "a" '((a . 1) 2)) 'error)

(test (with-environment (augment-environment '() '(a . 1)) a) 1)
(test (with-environment (augment-environment '()) 1) 1)
(test (with-environment (augment-environment '() '(b . 1)) a) 'error)
(test (with-environment '((a . 1)) a) 'error)
(test (with-environment '((a . 1) 2) a) 'error)
(test (let ((a 1)) (set! ((current-environment) 'a) 32) a) 32)

(for-each
 (lambda (arg)
   (test (augment-environment (current-environment) arg) 'error)
   (test (augment-environment! (current-environment) arg) 'error))
 (list -1 #\a #(1 2 3) 3.14 3/4 1.0+1.0i 'hi "hi" abs '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))

(test (with-environment (current-environment) (let ((x 1)) x)) 1)

(let ((old-safety *safety*))
  (set! *safety* 1)
  (define (hi)
    (let ((e (augment-environment (current-environment)
	       (cons 'abs (lambda (a) (- a 1))))))
      (with-environment e
	(abs -1))))
  (test (hi) -2)
  (test (hi) -2)
  (test (let ((e (augment-environment (current-environment)
		   (cons 'abs (lambda (a) (- a 1))))))
	  (with-environment e
	    (abs -1)))
	-2)
  (set! *safety* old-safety))

(test (let ((x 12))
	(let ((e (current-environment)))
	  (let ((x 32))
	    (with-environment e (* x 2)))))
      24)

(test (let ((e #f)) (let ((x 2) (y 3)) (set! e (current-environment))) (let ((x 0) (y 0)) (with-environment e (+ x y)))) 5)
(test (let ((e #f)) (let () (define (func a b) (set! e (current-environment)) (+ a b)) (func 1 2)) (with-environment e (+ a b))) 3)
(test (let ((e #f)
	    (f #f))
	(let ()
	  (define (func a b) 
	    (set! e (current-environment)) 
	    (+ a b))
	  (set! f func)
	  (func 1 2))
	(let ((val (with-environment e (+ a b))))
	  (f 3 4)
	  (list val (with-environment e (+ a b)))))
      '(3 7))

(test (with-environment) 'error)
(test (with-environment 1) 'error)
(test (with-environment () 1) 'error)
(test (with-environment (current-environment)) 'error) ; ?? perhaps this should be #<unspecified> 
(test (outer-environment) 'error)
(test (outer-environment (current-environment) #f) 'error)
(test (eq? (outer-environment (global-environment)) (global-environment)) #t)
(test (set! (outer-environment (current-environment)) #f) 'error)

(for-each
 (lambda (arg)
   (test (with-environment arg #f) 'error)
   (test (outer-environment arg) 'error))
 (list -1 #\a #(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi "hi" abs '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))

(test (with-environment (augment-environment (augment-environment '()) '(a . 1)) 1) 1)
(test (with-environment (augment-environment (augment-environment '()) '(a . 1)) a) 1)
(test (with-environment (current-environment) 1) 1)
(test (let ((a 1))
	(+ (with-environment
	    (augment-environment (current-environment) (cons 'a 10))
	    a)
	   a))
      11)
(test (let ((a 1))
	(+ (with-environment
	    (augment-environment (current-environment) (cons 'a 10))
	    (+ a
	       (with-environment
		(augment-environment (current-environment) (cons 'a 100))
		a)))
	   a))
      111)
(test (let ((a 1))
	(+ (with-environment
	    (augment-environment (current-environment) (cons 'a 10))
	    (+ a
	       (with-environment
		(augment-environment (current-environment) (cons 'b 100))
		a)))
	   a))
      21)
(test (let ((a 1))
	(let ((e (current-environment)))
	  (+ (with-environment
	      (augment-environment (current-environment) (cons 'a 10))
	      (+ a
		 (with-environment e a)))
	   a)))
      12)
(test (let ((a 1))
	(let ((e (current-environment)))
	  (+ (with-environment
	      (augment-environment! (augment-environment (current-environment) (cons 'a 10)) (cons 'a 20))
	      (+ a
		 (with-environment e a)))
	   a)))
      22)
(test (let ((a 1))
	(+ (with-environment
	    (augment-environment (current-environment) (cons 'a 10))
	    (+ (let ((b a))
		 (augment-environment! (current-environment) (cons 'a 20))
		 (+ a b))
	       a))
	   a))
      41)

(test (let ((a 1)) (+ (let ((a 2)) (+ (let ((a 3)) a) a)) a)) 6)
(test (let ((a 1)) (+ (let () (+ (let ((a 3)) (augment-environment! (outer-environment (current-environment)) '(a . 2)) a) a)) a)) 6)
(test (let () (let ((a 1)) (augment-environment! (outer-environment (current-environment)) '(a . 2))) a) 2)

(test (let ((a 1))
	(let ((e (current-environment)))
	  (+ (with-environment
	      (augment-environment e (cons 'a 10))
	      (+ a
		 (with-environment e a)))
	   a)))
      'error) ; "e" is not in the current-environment at the top, so it's not in the nested env

(test (let ((x 3))
	(augment-environment! (current-environment)
          (cons 'y 123))
	(+ x y))
      126)
#|
(test (let ()
	(define (hiho a) (+ a b))
	(augment-environment! (procedure-environment hiho) (cons 'b 21)) ; hmmm...
	(hiho 1))
      22)
|#
(test (let ()
	(define hiho (let ((x 32)) (lambda (a) (+ a x b))))
	(augment-environment! (procedure-environment hiho) (cons 'b 10) (cons 'x 100))
	(hiho 1))
      111)

(test (let ()
	(define hiho (let () 
		       (define (hi b) 
			 (+ b 1)) 
		       (lambda (a) 
			 (hi a))))
	(augment-environment! (procedure-environment hiho) (cons 'hi (lambda (b) (+ b 123))))
	(hiho 2))
      125)

(test (let () ; here's one way for multiple functions to share a normal scheme closure
	(define f1 (let ((x 23))
		     (lambda (a)
		       (+ x a))))
	(define f2
	  (with-environment (procedure-environment f1)
            (lambda (b)
	      (+ b (* 2 x)))))
	(+ (f1 1) (f2 1)))
      71)

(test (augment-environment!) 'error)
(test (augment-environment 3) 'error)
(test (augment-environment! 3) 'error)

(test (let ((e (current-environment))) (environment? e)) #t)
(test (let ((f (lambda (x) (environment? x)))) (f (current-environment))) #t)
(test (let ((e (augment-environment! '() '(a . 1)))) (environment? e)) #t)
(test (let ((e (augment-environment! '() '(a . 1)))) ((lambda (x) (environment? x)) e)) #t)
(test (environment? ((lambda () (current-environment)))) #t)
(test (environment? ((lambda (x) x) (current-environment))) #t)
(test (let ((e (let ((x 32)) (lambda (y) (let ((z 123)) (current-environment))))))
	(eval `(+ x y z) (e 1)))
      156)
(test (let ((e #f)) (set! e (let ((x 32)) (lambda (y) (let ((z 123)) (procedure-environment e)))))
	   (eval `(+ x 1) (e 1)))
      33)

(test (let () ((current-environment) 'abs)) #<undefined>)
(test ((global-environment) 'abs) abs)

(test (catch #t
	     (lambda ()
	       (with-environment (current-environment)
		 (error 'testing "a test")
		 32))
	     (lambda args (car args)))
      'testing)
(test (call-with-exit
       (lambda (go)
	 (with-environment (current-environment)
	   (go 1)
	   32)))
      1)

(test (let ((x 0))
	(call-with-exit
	 (lambda (go)
	   (with-environment (augment-environment! (current-environment) (cons 'x 123))
            (go 1))))
	x)
      0)
(test (let ((x 1))
	(+ x (call-with-exit
	      (lambda (go)
		(with-environment (augment-environment! (current-environment) (cons 'x 123))
                  (go x))))
	   x))
      125)

(test (let ((x 0))
	(catch #t
          (lambda ()
	    (with-environment (augment-environment! (current-environment) (cons 'x 123))
              (error 'oops) x)) 
	  (lambda args x)))
      0)

(let ((a 1)) 
  (test ((current-environment) 'a) 1)
  (set! ((current-environment) 'a) 32)
  (test ((current-environment) 'a) 32))

(let () (test (equal? (current-environment) (global-environment)) #f))
(test (let ((a 1)) (let ((e (current-environment))) (set! (e 'a) 2)) a) 2)
(let () (define (hi e) (set! (e 'a) 2)) (test (let ((a 1)) (hi (current-environment)) a) 2))
(let () (define (hi) (let ((a 1)) (let ((e (current-environment)) (i 'a)) (set! (e i) #\a)) a)) (hi) (hi) (test (hi) #\a))

(test (let ((a 1)) (let ((e (current-environment))) (e :hi))) #<undefined>) ; global env is not searched in this case

(let ((e1 #f) (e2 #f))
  (let ((a 1)) (set! e1 (current-environment)))
  (let ((a 1)) (set! e2 (current-environment))) 
  (test (equal? e1 e2) #t)
  (test (eqv? e1 e2) #f))

(let ((e1 #f) (e2 #f))
  (let ((a 1)) (set! e1 (current-environment)))
  (let ((a 2)) (set! e2 (current-environment))) 
  (test (equal? e1 e2) #f))

(let ((e1 #f) (e2 #f))
  (let ((a 1)) (set! e1 (current-environment)))
  (let ((a 1) (b 2)) (set! e2 (current-environment))) 
  (test (equal? e1 e2) #f))

(let ((e1 #f) (e2 #f))
  (let ((a 1) (b 2)) (set! e1 (current-environment)))
  (let ((a 1) (b 2)) (set! e2 (current-environment))) 
  (test (equal? e1 e2) #t))

(let ((e1 #f) (e2 #f))
  (let () (set! e1 (current-environment)))
  (let ((a 1)) (set! e2 (current-environment))) 
  (test (equal? e1 e2) #f))

(test (let ((a #(1 2 3))) ((current-environment) 'a 1)) 2)
(test (let ((a #(1 2 3))) (let ((e (current-environment))) ((current-environment) 'e 'a 1))) 2)


;;; make-type
(let ()
  (define (make-type . args)
    (let* ((type (gensym "make-type type"))   ; built-in type and value slots have gensym'd names
	   (value (gensym "make-type value"))
	   (obj (open-environment 
		 (augment-environment ()
		   (cons type type)
		   (cons value #<unspecified>)))))
      
      ;; load up any methods/slots
      (do ((arg args (cddr arg)))
	  ((null? arg))
	(augment-environment! obj
			      (cons (keyword->symbol (car arg)) (cadr arg))))
      
      ;; return a list of '(? make ref) funcs
      (list (lambda (x)
	      (and (environment? x)
		   (eq? (x type) type)))
	    (lambda* (new-value)
		     (let ((new-obj (copy obj)))
		       (set! (new-obj value) new-value)
		       new-obj))
	    (lambda (x)
	      (x value)))))
  
  (define special-value
    (let ((type (make-type)))
      ((cadr type) 'special)))
  
  (test (eq? special-value special-value) #t)
  (test (eqv? special-value special-value) #t)
  (test (equal? special-value special-value) #t)
  (test (procedure? special-value) #f)
  (for-each
   (lambda (arg)
     (test (or (eq? arg special-value)
	       (eqv? arg special-value)
	       (equal? arg special-value))
	   #f))
   (list "hi" -1 #\a 1 'special 3.14 3/4 1.0+1.0i #f #t '(1 . 2) #<unspecified> #<undefined>))
  
  (test (let ((obj ((cadr (make-type :type "hi" :value 123)) 0))) (list (obj 'type) (obj 'value))) '("hi" 123))
  (test (let ((obj ((cadr (make-type :type "hi" :value 123))))) (list (obj 'type) (obj 'value))) '("hi" 123))

  (test (let* ((rec-type (make-type))
	       (? (car rec-type))
	       (make (cadr rec-type))
	       (ref (caddr rec-type)))
	  (let ((val-1 (make "hi")))
	    (let ((val-2 (make val-1)))
	      (let ((val-3 (make val-2)))
		(ref (ref (ref val-3)))))))
	"hi")

  (test (let* ((rec1-type (make-type))
	       (?1 (car rec1-type))
	       (make1 (cadr rec1-type))
	       (ref1 (caddr rec1-type)))
	  (let* ((rec2-type (make-type))
		 (?2 (car rec2-type))
		 (make2 (cadr rec2-type))
		 (ref2 (caddr rec2-type)))
	    (let ((val-1 (make1 "hi")))
	      (let ((val-2 (make2 "hi")))
		(let ((val-3 (make1 val-2)))
		  (and (string=? (ref2 (ref1 val-3)) "hi")
		       (not (equal? val-1 val-2))
		       (?1 val-1)
		       (?2 val-2)
		       (not (?2 val-3))))))))
	#t)

  (test (let* ((rec1-type (make-type))
	       (make1 (cadr rec1-type))
	       (ref1 (caddr rec1-type)))
	  (let* ((rec2-type (make-type))
		 (make2 (cadr rec2-type)))
	    (let ((val-1 (make1 "hi")))
	      (let ((val-2 (make2 val-1)))
		(ref1 val-2)))))
	#<undefined>)

  (test (make-type (make-type)) 'error)
  (let ((t (make-type)))
    (let ((t? (car t))
	  (make-t (cadr t))
	  (t-ref (caddr t)))
      (test (make-t 1 2) 'error)
      (test (t? (make-t)) #t)
      (test (t-ref (make-t)) #f)
      (test (t? 1 2) 'error)
      (test (t?) 'error)
      (test (t-ref) 'error)
      (test (t-ref 1 2) 'error)
      (for-each
       (lambda (arg)
	 (test (t-ref arg) 'error))
       (list #\a 'a-symbol 1.0+1.0i #t #(1 2) '() 3/4 3.14 #() "hi" :hi 1 #f #t '(1 . 2)))))
  
  (begin
    (define rec? #f)
    (define make-rec #f)
    (define rec-a #f)
    (define rec-b #f)
    
    (let* ((rec-type (make-type))
	   (? (car rec-type))
	   (make (cadr rec-type))
	   (ref (caddr rec-type)))
      
      (set! make-rec (lambda* ((a 1) (b 2))
			      (make (vector a b))))
      
      (set! rec? (lambda (obj)
		   (? obj)))
      
      (set! rec-a (make-procedure-with-setter
		   (lambda (obj)
		     (and (rec? obj)
			  (vector-ref (ref obj) 0)))
		   (lambda (obj val)
		     (if (rec? obj)
			 (vector-set! (ref obj) 0 val)))))
      
      (set! rec-b (make-procedure-with-setter
		   (lambda (obj)
		     (and (rec? obj)
			  (vector-ref (ref obj) 1)))
		   (lambda (obj val)
		     (if (rec? obj)
			 (vector-set! (ref obj) 1 val)))))))
  
  (let ((hi (make-rec 32 '(1 2))))
    (test (rec? hi) #t)
    (test (equal? hi hi) #t)
    (test (rec? 32) #f)
    (test (rec-a hi) 32)
    (test (rec-b hi) '(1 2))
    (set! (rec-b hi) 123)
    (test (rec-b hi) 123)
    (let ((ho (make-rec 32 '(1 2))))
      (test (eq? hi ho) #f)
      (test (eqv? hi ho) #f)
      (test (equal? hi ho) #f)
      (set! (rec-b ho) 123)
      (test (equal? hi ho) #t))
    (let ((ho (make-rec 123 '())))
      (test (eq? hi ho) #f)
      (test (eqv? hi ho) #f)
      (test (equal? hi ho) #f))
    (test (equal? (copy hi) hi) #t)
    (test (fill! hi 1) 'error)
    ;(test (object->string hi) "#<environment>")
    (test (length hi) 2)
    (test (reverse hi) 'error)
    (test (for-each abs hi) 'error)
    (test (map abs hi) 'error)
    (test (hi 1) 'error)
    (test (set! (hi 1) 2) 'error)
    )

  (let ((rec3? (car (make-type)))
	(rec4? (car (make-type :value 21))))
    (for-each
     (lambda (arg)
       (test (rec3? arg) #f)
       (test (rec4? arg) #f))
     (list "hi" -1 #\a 1 'a-symbol 3.14 3/4 1.0+1.0i #f #t '(1 . 2))))

    )


;;; float-vector
(let ()
  (begin
    (define float-vector? #f)
    (define make-float-vector #f)
    
    (let ((type (gensym))
	  (->float (lambda (x)
		     (if (real? x)
			 (* x 1.0)
			 (error 'wrong-type-arg "float-vector new value is not a real: ~A" x)))))
      
      (augment-environment! (current-environment)
	(cons 'length (lambda (p) ((procedure-environment p) 'len)))
	(cons 'object->string (lambda* (p (use-write #t)) "#<float-vector>"))
	(cons 'vector? (lambda (p) #t))
	(cons 'vector-length (lambda (p) ((procedure-environment p) 'len)))
	(cons 'vector-dimensions (lambda (p) (list ((procedure-environment p) 'len))))
	(cons 'vector-ref (lambda (p ind) (#_vector-ref ((procedure-environment p) 'obj) ind)))
	(cons 'vector-set! (lambda (p ind val) (#_vector-set! ((procedure-environment p) 'obj) ind (->float val))))
	(cons 'vector-fill! (lambda (p val) (#_vector-fill! ((procedure-environment p) 'obj) (->float val))))
	(cons 'fill! (lambda (p val) (#_vector-fill! ((procedure-environment p) 'obj) (->float val))))
	(cons 'vector->list (lambda (p) (#_vector->list ((procedure-environment p) 'obj))))
	(cons 'equal? (lambda (x y) (#_equal? ((procedure-environment x) 'obj) ((procedure-environment y) 'obj))))
	(cons 'morally-equal? (lambda (x y) (#_morally-equal? ((procedure-environment x) 'obj) ((procedure-environment y) 'obj))))
	(cons 'reverse (lambda (p) (vector->float-vector (#_reverse ((procedure-environment p) 'obj)))))
	(cons 'copy (lambda (p) (vector->float-vector ((procedure-environment p) 'obj))))
	(cons 'sort! (lambda (p f) (vector->float-vector (#_sort! ((procedure-environment p) 'obj) f))))
	)
      
      (set! make-float-vector
	    (lambda* (len (init 0.0)) 
	      (let ((obj (make-vector len (->float init))))
		(open-environment
		 (make-procedure-with-setter
		  (lambda (i) (#_vector-ref obj i))
		  (lambda (i val) (#_vector-set! obj i (->float val))))))))
      
      (set! float-vector?
	    (lambda (obj)
	      (and (procedure? obj)
		   (eq? ((procedure-environment obj) 'type) type))))))
  
  (define (float-vector . args)
    (let* ((len (length args))
	   (v (make-float-vector len)))
      (do ((i 0 (+ i 1))
	   (arg args (cdr arg)))
	  ((= i len) v)
	(set! (v i) (car arg)))))
  
  (define (vector->float-vector v)
    (let* ((len (length v))
	   (fv (make-float-vector len)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(set! (fv i) (v i)))
      fv))
  
  (let ((v (make-float-vector 3 0.0)))
    (test (length v) 3)
    (set! (v 1) 32.0)
    (test (v 0) 0.0)
    (test (v 1) 32.0)
    (test (eq? v v) #t)
    (test (eq? v (float-vector 0.0 32.0 0.0)) #f)
    (test (equal? v (float-vector 0.0 32.0 0.0)) #t)
    (test (morally-equal? v (float-vector 0.0 32.0 0.0)) #t)
    (test (map + (list 1 2 3) (float-vector 1 2 3)) '(2.0 4.0 6.0))
    (test (reverse (float-vector 1.0 2.0 3.0)) (float-vector 3.0 2.0 1.0))
    (test (copy (float-vector 1.0 2.0 3.0)) (float-vector 1.0 2.0 3.0))
    (test (let () (fill! v 1.0) v) (float-vector 1.0 1.0 1.0))
    (test (object->string v) "#<float-vector>")
    (test (let ((v (float-vector 1.0 2.0 3.0))) (map v (list 2 1 0))) '(3.0 2.0 1.0))
    (test (v -1) 'error)
    (test (v 32) 'error)
    (for-each
     (lambda (arg)
       (test (v arg) 'error))
     (list #\a 'a-symbol 1.0+1.0i #f #t abs #(1 2) '() 3/4 3.14 '(1 . 2)))
    
    (test (map (lambda (a b)
		 (floor (apply + (map + (list a b) (float-vector a b)))))
	       (float-vector 1 2 3) (float-vector 4 5 6))
	  '(10 14 18))
    
    (test (set! (v 0) "hi") 'error)
    (test (set! (v -1) "hi") 'error)
    (test (set! (v 32) "hi") 'error)
    (for-each
     (lambda (arg)
       (test (set! (v 0) arg) 'error))
     (list #\a 'a-symbol 1.0+1.0i #f #t abs #(1 2) '() '(1 . 2)))
    (test (let ((sum 0.0))
	    (for-each
	     (lambda (x)
	       (set! sum (+ sum x)))
	     (float-vector 1.0 2.0 3.0))
	    sum)
	  6.0)
    (test (length v) 3)
    )
  
  (let ((v1 (float-vector 3 1 4 8 2)))
    (let ((v2 (sort! v1 <)))
      (test (equal? v2 (float-vector 1 2 3 4 8)) #t)
      (test (vector? v1) #t)
      (test (float-vector? v1) #t)
      (test (vector-length v1) 5)
      (test (vector->list v1) '(1.0 2.0 3.0 4.0 8.0))
      (test (vector-ref v1 1) 2.0)
      (test (vector-set! v1 1 3/2) 1.5)
      (test (vector-ref v1 1) 1.5)
      (test (vector-dimensions v1) '(5))
      (fill! v1 32)
      (test v1 (float-vector 32.0 32.0 32.0 32.0 32.0))
      (test (float-vector? #(1 2 3)) #f)

      (for-each
       (lambda (arg)
	 (test (float-vector? arg) #f))
       (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))
      
      (for-each
       (lambda (arg)
	 (test (make-float-vector arg) 'error))
       (list -1 #\a '#(1 2 3) 3.14 3/4 1.0+1.0i '() #f '#(()) '(1 . 2) "hi" '((a . 1))))
      
      (for-each
       (lambda (arg)
	 (test (make-float-vector 3 arg) 'error))
       (list #\a '#(1 2 3) 1.0+1.0i '() #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))
      
      (for-each
       (lambda (arg)
	 (test (float-vector (list arg)) 'error))
       (list #\a '#(1 2 3) 1.0+1.0i '() #f '#(()) (list 1 2 3) '(1 . 2) "hi" '((a . 1))))

      )))


;;; environments as objects

(define-bacro* (define-class class-name inherited-classes (slots ()) (methods ()))

  ;; a bacro is needed so that the calling environment is accessible via outer-environment
  ;;   we could also use the begin/let shuffle, but it's too embarrassing

  `(let ((outer-env (outer-environment (current-environment)))
	 (new-methods ())
	 (new-slots ())
	 (new-type (gensym "define-class")))

    (for-each
     (lambda (class)
       ;; each class is a set of nested environments, the innermost (first in the list)
       ;;   holds the local slots which are copied each time an instance is created,
       ;;   the next holds the class slots (global to all instances, not copied);
       ;;   these hold the class name and other such info.  The remaining environments
       ;;   hold the methods, with the localmost method first.  So in this loop, we
       ;;   are gathering the local slots and all the methods of the inherited
       ;;   classes, and will splice them together below as a new class.

       (set! new-slots (append (environment->list class) new-slots))
       (do ((e (outer-environment (outer-environment class)) (outer-environment e)))
	   ((or (not (environment? e))
		(eq? e (global-environment))))
	 (set! new-methods (append (environment->list e) new-methods))))
     ,inherited-classes)

     (let ((remove-duplicates 
	    (lambda (lst)         ; if multiple local slots with same name, take the localmost
	      (letrec ((rem-dup
			(lambda (lst nlst)
			  (cond ((null? lst) nlst)
				((assq (caar lst) nlst) (rem-dup (cdr lst) nlst))
				(else (rem-dup (cdr lst) (cons (car lst) nlst)))))))
		(reverse (rem-dup lst ()))))))
       (set! new-slots 
	     (remove-duplicates
	      (append (map (lambda (slot)
			     (if (pair? slot)
				 (cons (car slot) (cadr slot))
				 (cons slot #f)))
			   ,slots)                    ; the incoming new slots, #f is the default value
		      new-slots))))                   ; the inherited slots

    (set! new-methods 
	  (append (map (lambda (method)
			 (if (pair? method)
			     (cons (car method) (cadr method))
			     (cons method #f)))
		       ,methods)                     ; the incoming new methods

		  ;; add an object->string method for this class. 
		  (list (cons 'object->string
                              (lambda* (obj (port #f))
				(format port "#<~A: ~{~A~^ ~}>" 
					',class-name
					(map (lambda (slot)
					       (list (car slot) (cdr slot)))
					     (environment->list obj))))))
		  (reverse! new-methods)))           ; the inherited methods, shadowed automatically

    (let ((new-class (open-environment
                       (apply augment-environment           ; the local slots
		         (augment-environment               ; the global slots
		           (apply augment-environment ()    ; the methods
			     (reverse new-methods))
		           (cons 'class-name ',class-name)  ; class-name slot
			   (cons 'class-type new-type)      ; save a unique type identifier (unneeded if class-names are unique)
			   (cons 'inherited ,inherited-classes)
			   (cons 'inheritors ()))           ; classes that inherit from this class
		         new-slots))))

      (augment-environment! outer-env                  
        (cons ',class-name new-class)                       ; define the class as class-name in the calling environment

	;; define class-name? type check
	(cons (string->symbol (string-append (symbol->string ',class-name) "?"))
	      (lambda (obj)
		(and (environment? obj)
		     (eq? (obj 'class-type) new-type)))))

      (augment-environment! outer-env
        ;; define the make-instance function for this class.  
        ;;   Each slot is a keyword argument to the make function.
        (cons (string->symbol (string-append "make-" (symbol->string ',class-name)))
	      (apply lambda* (map (lambda (slot)
				    (if (pair? slot)
					(list (car slot) (cdr slot))
					(list slot #f)))
				  new-slots)
		     `((let ((new-obj (copy ,,class-name)))
			 ,@(map (lambda (slot)
				  `(set! (new-obj ',(car slot)) ,(car slot)))
				new-slots)
			 new-obj)))))

      ;; save inheritance info for this class for subsequent define-method
      (letrec ((add-inheritor (lambda (class)
				(for-each add-inheritor (class 'inherited))
				(if (not (memq new-class (class 'inheritors)))
				    (set! (class 'inheritors) (cons new-class (class 'inheritors)))))))
	(for-each add-inheritor ,inherited-classes))
    
      ',class-name)))


(define-macro (define-generic name)
  `(define ,name (lambda args (apply ((car args) ',name) args))))


(define-macro (define-slot-accessor name slot)
  `(define ,name (make-procedure-with-setter 
                   (lambda (obj) (obj ',slot)) 
		   (lambda (obj val) (set! (obj ',slot) val)))))


(define-bacro (define-method name-and-args . body)
  `(let* ((outer-env (outer-environment (current-environment)))
	  (method-name (car ',name-and-args))
	  (method-args (cdr ',name-and-args))
	  (object (caar method-args))
	  (class (symbol->value (cadar method-args)))
	  (old-method (class method-name))
	  (method (apply lambda* method-args ',body)))

     ;; define the method as a normal-looking function
     ;;   s7test.scm has define-method-with-next-method that implements call-next-method here
     ;;   it also has make-instance 
     (augment-environment! outer-env
       (cons method-name 
	     (apply lambda* method-args 
		    `(((,object ',method-name)
		       ,@(map (lambda (arg)
				(if (pair? arg) (car arg) arg))
			      method-args))))))
     
     ;; add the method to the class
     (augment-environment! (outer-environment (outer-environment class))
       (cons method-name method))

     ;; if there are inheritors, add it to them as well, but not if they have a shadowing version
     (for-each
      (lambda (inheritor) 
	(if (not (eq? (inheritor method-name) #<undefined>)) ; defined? goes to the global env
	    (if (eq? (inheritor method-name) old-method)
		(set! (inheritor method-name) method))
	    (augment-environment! (outer-environment (outer-environment inheritor))
   	      (cons method-name method))))
      (class 'inheritors))

     method-name))


(define (all-methods obj method)
  ;; for arbitrary method combinations: this returns a list of all the methods of a given name
  ;;   in obj's class and the classes it inherits from (see example below)
  (let* ((base-method (obj method))
	 (methods (if (procedure? base-method) (list base-method) ())))
    (for-each 
     (lambda (ancestor)
       (let ((next-method (ancestor method)))
	 (if (and (procedure? next-method)
		  (not (memq next-method methods)))
	     (set! methods (cons next-method methods)))))
     (obj 'inherited))
    (reverse methods)))

(define (make-instance class . args)
  (let* ((cls (if (symbol? class) (symbol->value class) class))
	 (make (symbol->value (string->symbol (string-append "make-" (symbol->string (cls 'class-name)))))))
    (apply make args)))

(define-bacro (define-method-with-next-method name-and-args . body)
  `(let* ((outer-env (outer-environment (current-environment)))
	  (method-name (car ',name-and-args))
	  (method-args (cdr ',name-and-args))
	  (object (caar method-args))
	  (class (symbol->value (cadar method-args)))
	  (old-method (class method-name))
	  (arg-names (map (lambda (arg)
			    (if (pair? arg) (car arg) arg))
			  method-args))
	  (next-class (and (pair? (class 'inherited))
			   (car (class 'inherited)))) ; or perhaps the last member of this list?
	  (nwrap-body (if next-class
			  `((let ((call-next-method 
				   (lambda new-args 
				     (apply (,next-class ',method-name)
					    (or new-args ,arg-names)))))
			      ,@',body))
			  ',body))
	  (method (apply lambda* method-args nwrap-body)))

     ;; define the method as a normal-looking function
     (augment-environment! outer-env
       (cons method-name 
	     (apply lambda* method-args 
		    `(((,object ',method-name) ,@arg-names)))))
     
     ;; add the method to the class
     (augment-environment! (outer-environment (outer-environment class))
       (cons method-name method))

     ;; if there are inheritors, add it to them as well, but not if they have a shadowing version
     (for-each
      (lambda (inheritor) 
	(if (not (eq? (inheritor method-name) #<undefined>)) ; defined? goes to the global env
	    (if (eq? (inheritor method-name) old-method)
		(set! (inheritor method-name) method))
	    (augment-environment! (outer-environment (outer-environment inheritor))
   	      (cons method-name method))))
      (class 'inheritors))

     method-name))

(let ()

  (define-class class-1 () 
    '((a 1) (b 2)) 
    (list (list 'add (lambda (obj) 
		       (with-environment obj
			 (+ a b))))))

  (define-slot-accessor slot-a a)

  (let ()
    (test (environment? (outer-environment (current-environment))) #t)
    (test (class-1? class-1) #t)
    (test (class-1 'a) 1)
    (test (class-1 'b) 2)
    (test (class-1 'class-name) 'class-1)
    (test (class-1 'divide) #<undefined>)
    (test (class-1 'inheritors) ())
    (test ((class-1 'add) class-1) 3)
    (test (object->string class-1) "#<class-1: (a 1) (b 2)>")
    (test (format #f "~{~A~^ ~}" class-1) "(a . 1) (b . 2)"))

  (let ((v (make-class-1)))
    (test (class-1? v) #t)
    (test (v 'a) 1)
    (test (v 'b) 2)
    (test (v 'class-name) 'class-1)
    (test (v 'inheritors) ())
    (test ((v 'add) v) 3)
    (test (object->string v) "#<class-1: (a 1) (b 2)>")
    (test (format #f "~{~A~^ ~}" v) "(a . 1) (b . 2)")
    (set! (v 'a) 32)
    (test ((v 'add) v) 34)
    (test (equal? v v) #t)
    (test (equal? v (make-class-1 :a 32)) #t)
    (test (slot-a v) 32)
    (set! (slot-a v) 1)
    (test (slot-a v) 1)
    (test (map cdr v) '(1 2)))

  (let ((v (make-class-1 :a 32)))
    (test (class-1? v) #t)
    (test (v 'a) 32)
    (test (v 'b) 2)
    (test (v 'class-name) 'class-1)
    (test (v 'inheritors) ())
    (test ((v 'add) v) 34)
    (test (object->string v) "#<class-1: (a 32) (b 2)>"))

  (let ((v (make-class-1 32 3)))
    (test (class-1? v) #t)
    (test (v 'a) 32)
    (test (v 'b) 3)
    (test (v 'class-name) 'class-1)
    (test (v 'inheritors) ())
    (test ((v 'add) v) 35)
    (test (object->string v) "#<class-1: (a 32) (b 3)>"))

  (define-generic add)

  (let ()
    (test (add class-1) 3)
    (test (add (make-class-1 :b 0)) 1)
    (test (add 2) 'error))

  (define-class class-2 (list class-1)
    '((c 3)) 
    (list (list 'multiply (lambda (obj) 
			    (with-environment obj 
                              (* a b c))))))

  (let ((v (make-class-2 :a 32)))
    (test (class-1? v) #f)
    (test (class-2? v) #t)
    (test (equal? v (make-class-1 :a 32)) #f)
    (test (equal? v (make-class-2 :a 32)) #t)
    (test (v 'a) 32)
    (test (v 'b) 2)
    (test (v 'c) 3)
    (test (v 'class-name) 'class-2)
    (test (v 'inheritors) ())
    (test (class-1 'inheritors) (list class-2))
    (test ((v 'add) v) 34)
    (test (object->string v) "#<class-2: (c 3) (a 32) (b 2)>")
    (test ((v 'multiply) v) 192)
    (test (add v) 34))

  (let ((v1 (make-class-1))
	(v2 (make-class-1)))
    (test (add v1) 3)
    (test (add v2) 3)
    (augment-environment! v2 (cons 'add (lambda (obj) (with-environment obj (+ 1 a (* 2 b))))))
    (test (add v1) 3)
    (test (add v2) 6))

  (define-class class-3 (list class-2) 
    () 
    (list (list 'multiply (lambda (obj num) 
			    (* num 
			       ((class-2 'multiply) obj) 
			       (add obj))))))

  (let ((v (make-class-3)))
    (test (class-1? v) #f)
    (test (class-2? v) #f)
    (test (class-3? v) #t)
    (test (v 'a) 1)
    (test (v 'b) 2)
    (test (v 'c) 3)
    (test (v 'class-name) 'class-3)
    (test (v 'inheritors) ())
    (test (class-1 'inheritors) (list class-3 class-2))
    (test (class-2 'inheritors) (list class-3))
    (test ((v 'add) v) 3)
    (test (object->string v) "#<class-3: (c 3) (a 1) (b 2)>")
    (test ((v 'multiply) v) 'error)
    (test ((v 'multiply) v 4) (* 4 6 3))
    (test (add v) 3))

  (define-method (subtract (obj class-1)) 
    (with-environment obj 
      (- a b)))

  (let ((v1 (make-class-1))
	(v2 (make-class-2))
	(v3 (make-class-3)))
    (test (subtract v1) -1)
    (test (subtract v2) -1)
    (test (subtract v3) -1))

  ;; class-2|3 have their own multiply so...
  (define-method (multiply (obj class-1)) (with-environment obj (* a b 100)))

  (let ((v1 (make-class-1))
	(v2 (make-class-2))
	(v3 (make-class-3)))
    (test (multiply v1) 200)
    (test (multiply v2) 6)
    (test (multiply v3) 'error))

  (define-method-with-next-method (add-1 (obj class-1)) (+ (obj 'a) 1))
  (define-method-with-next-method (add-1 (obj class-2)) (+ 1 (call-next-method)))
  (define-method-with-next-method (add-1 (obj class-3)) (+ 1 (call-next-method obj)))
  
  (test (add-1 (make-class-1)) 2)
  (test (add-1 (make-class-2)) 3)
  (test (add-1 (make-class-3)) 4)

  (test ((make-instance class-1) 'class-name) 'class-1)
  (test ((make-instance 'class-1) 'class-name) 'class-1)
  (test ((make-instance class-2) 'class-name) 'class-2)
  (test ((make-instance class-1 :a 123) 'class-name) 'class-1)

  (test ((make-instance class-1) 'b) 2)
  (test ((make-instance 'class-1) 'b) 2)
  (test ((make-instance class-1 :b 12 :a 123) 'b) 12)

  (test ((make-instance 'class-3 :a "hi" :c 21) 'c) 21)

  )



;;; --------------------------------------------------------------------------------
;;; error-environment
(test (vector? (error-environment)) #f)
(test (environment? (error-environment)) #t)
(test (let () (set! (error-environment) 2)) 'error)
(test (error-environment 123) 'error)

(let ((val (catch #t (lambda () (/ 1 0.0)) (lambda args args))))
  (with-environment (error-environment)
    (test error-type 'division-by-zero)
    (test (equal? error-code '(/ 1 0.0)) #t)
    (test (list? error-data) #t)
    (test (string? error-file) #t)
    (test (integer? error-line) #t)
    (test ((error-environment) 'error-file) error-file)
    ))


;;; stacktrace

(test (string? (stacktrace)) #t)
(test (stacktrace 123) 'error)
