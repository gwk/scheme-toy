(define (catch-test sym)
  (let ((errs '()))
    (catch 'a1
	 (lambda ()
	   (catch 'a2
		  (lambda ()
		    (catch 'a3
			   (lambda ()
			     (catch 'a4
				    (lambda ()
				      (error sym "hit error!"))
				    (lambda args
				      (set! errs (cons 'a4 errs))
				      'a4)))
			   (lambda args
			     (set! errs (cons 'a3 errs))
			     'a3)))
		  (lambda args
		    (set! errs (cons 'a2 errs))
		    'a2)))
	 (lambda args
	   (set! errs (cons 'a1 errs))
	   'a1))
    errs))

(test (catch-test 'a1) '(a1))
(test (catch-test 'a2) '(a2))
(test (catch-test 'a3) '(a3))
(test (catch-test 'a4) '(a4))

(define (catch-test-1 sym)
  (let ((errs '()))
    (catch 'a1
	 (lambda ()
	   (catch 'a2
		  (lambda ()
		    (catch 'a3
			   (lambda ()
			     (catch 'a4
				    (lambda ()
				      (error sym "hit error!"))
				    (lambda args
				      (set! errs (cons 'a4 errs))
				      (error 'a3)
				      'a4)))
			   (lambda args
			     (set! errs (cons 'a3 errs))
			     (error 'a2)
			     'a3)))
		  (lambda args
		    (set! errs (cons 'a2 errs))
		    (error 'a1)
		    'a2)))
	 (lambda args
	   (set! errs (cons 'a1 errs))
	   'a1))
    errs))

(test (catch-test-1 'a1) '(a1))
(test (catch-test-1 'a2) '(a1 a2))
(test (catch-test-1 'a3) '(a1 a2 a3))
(test (catch-test-1 'a4) '(a1 a2 a3 a4))

(test (catch #t (catch #t (lambda () (lambda () 1)) (lambda args 'oops)) (lambda args 'error)) 1)
(test (catch #t (catch #t (lambda () (error 'oops)) (lambda args (lambda () 1))) (lambda args 'error)) 1)
(test ((catch #t (lambda () (error 'oops)) (lambda args (lambda () 1)))) 1)
(test ((catch #t (lambda () (error 'oops)) (catch #t (lambda () (lambda args (lambda () 1))) (lambda args 'error)))) 1)
(test (catch #t (dynamic-wind (lambda () #f) (lambda () (lambda () 1)) (lambda () #f)) (lambda args 'error)) 1)
(test (dynamic-wind (catch #t (lambda () (lambda () #f)) (lambda args 'error)) (lambda () 1) (lambda () #f)) 1)
(test (dynamic-wind ((lambda () (lambda () #f))) (lambda () 1) (((lambda () (lambda () (lambda () #t)))))) 1)
(test (catch #t ((lambda () (lambda () 1))) (lambda b a)) 1)
(test (map (catch #t (lambda () abs) abs) '(-1 -2 -3)) '(1 2 3))
(test (catch + (((lambda () lambda)) () 1) +) 1)
(test (catch #t + +) 'error)
(test (string? (catch + s7-version +)) #t)
(test (string? (apply catch + s7-version (list +))) #t)
(test (catch #t (lambda () (catch '#t (lambda () (error '#t)) (lambda args 1))) (lambda args 2)) 1)
(test (catch #t (lambda () (catch "hi" (lambda () (error "hi")) (lambda args 1))) (lambda args 2)) 2) ; guile agrees with this
(test (let ((str (list 1 2))) (catch #t (lambda () (catch str (lambda () (error str)) (lambda args 1))) (lambda args 2))) 1)
(test (let () (abs (catch #t (lambda () -1) (lambda args 0)))) 1)
(test (let ((e #f)) (catch #t (lambda () (+ 1 "asdf")) (lambda args (set! e (error-environment)))) (eq? e (error-environment))) #t)

(let ()
  (define-macro (catch-all . body) 
    `(catch #t (lambda () ,@body) (lambda args args)))
  (let ((val (catch-all (+ 1 asdf))))
    (test (car val) 'syntax-error)))

;;; since catch is a function, everything is evaluated:
(test
 (catch (#(0 #t 1) 1)
   ((lambda (a) 
      (lambda () 
	(+ a "asdf")))
    1)
   ((lambda (b) 
      (lambda args 
	(format #f "got: ~A" b)))
    2))
 "got: 2")

(let ()
  (define (hi c)
    (catch c
      ((lambda (a) 
	 (lambda () 
	   (+ a "asdf")))
       1)
      ((lambda (b) 
	 (lambda args 
	   (format #f "got: ~A" b)))
       2)))
  (test (hi #t) "got: 2"))

(test
 (catch (#(0 #t 1) 1)
   (values ((lambda (a) 
	      (lambda () 
		(+ a "asdf")))
	    1)
	   ((lambda (b) 
	      (lambda args 
		(format #f "got: ~A" b)))
	    2)))
 "got: 2")

(let ((x 0))
  (catch #t
	 (lambda ()
	   (catch #t
		  (lambda ()
		    (+ 1 __asdf__))
		  (lambda args
		    (set! x (+ x 1))
		    (+ 1 __asdf__))))
	 (lambda args
	   (set! x (+ x 1))))
  (test x 2))

(test (let ((x 0))
	(catch 'a
	     (lambda ()
	       (catch 'b
		      (lambda ()
			(catch 'a
			       (lambda ()
				 (error 'a))
			       (lambda args
				 (set! x 1))))
		      (lambda args
			(set! x 2))))
	     (lambda args
	       (set! x 3)))
	x)
      1)

(test (catch) 'error)
(test (catch s7-version) 'error)
(test (catch #t s7-version) 'error)
(test (catch #t s7-version + +) 'error)

;;; throw
(define (catch-test sym)
  (let ((errs '()))
    (catch 'a1
	 (lambda ()
	   (catch 'a2
		  (lambda ()
		    (catch 'a3
			   (lambda ()
			     (catch 'a4
				    (lambda ()
				      (throw sym "hit error!"))
				    (lambda args
				      (set! errs (cons 'a4 errs))
				      'a4)))
			   (lambda args
			     (set! errs (cons 'a3 errs))
			     'a3)))
		  (lambda args
		    (set! errs (cons 'a2 errs))
		    'a2)))
	 (lambda args
	   (set! errs (cons 'a1 errs))
	   'a1))
    errs))

(test (catch-test 'a1) '(a1))
(test (catch-test 'a2) '(a2))
(test (catch-test 'a3) '(a3))
(test (catch-test 'a4) '(a4))

(define (catch-test-1 sym)
  (let ((errs '()))
    (catch 'a1
	 (lambda ()
	   (catch 'a2
		  (lambda ()
		    (catch 'a3
			   (lambda ()
			     (catch 'a4
				    (lambda ()
				      (throw sym "hit error!"))
				    (lambda args
				      (set! errs (cons 'a4 errs))
				      (throw 'a3)
				      'a4)))
			   (lambda args
			     (set! errs (cons 'a3 errs))
			     (throw 'a2)
			     'a3)))
		  (lambda args
		    (set! errs (cons 'a2 errs))
		    (throw 'a1)
		    'a2)))
	 (lambda args
	   (set! errs (cons 'a1 errs))
	   'a1))
    errs))

(test (catch-test-1 'a1) '(a1))
(test (catch-test-1 'a2) '(a1 a2))
(test (catch-test-1 'a3) '(a1 a2 a3))
(test (catch-test-1 'a4) '(a1 a2 a3 a4))

(test (catch #t (catch #t (lambda () (throw 'oops)) (lambda args (lambda () 1))) (lambda args 'error)) 1)
(test ((catch #t (lambda () (throw 'oops)) (lambda args (lambda () 1)))) 1)
(test ((catch #t (lambda () (throw 'oops)) (catch #t (lambda () (lambda args (lambda () 1))) (lambda args 'error)))) 1)
(test (catch #t (lambda () (catch '#t (lambda () (throw '#t)) (lambda args 1))) (lambda args 2)) 1)
(test (catch #t (lambda () (catch "hi" (lambda () (throw "hi")) (lambda args 1))) (lambda args 2)) 2) ; guile agrees with this
(test (let ((str (list 1 2))) (catch #t (lambda () (catch str (lambda () (throw str)) (lambda args 1))) (lambda args 2))) 1)

(test (throw) 'error)
(test (catch #f (lambda () (throw #f 1 2 3)) (lambda args (cadr args))) '(1 2 3))

(for-each
 (lambda (arg) 
   (catch #t 
     (lambda ()
       (test (catch arg
	       (lambda () 
		 (throw arg 1 2 3)) 
	       (lambda args (cadr args)))
	     '(1 2 3)))
     (lambda args 
       (format #t "~A not caught~%" (car args)))))
 (list #\a 'a-symbol #f #t abs #<unspecified>))

(test (let ((e #f)) 
	(catch #t 
	  (lambda () 
	    (catch #t 
	      (lambda () (+ 1 "asdf")) 
	      (lambda args (set! e (environment->list (error-environment))))))
	  (lambda args #f)) (equal? e (environment->list (error-environment)))) #t)

(let ((e 1))
  (catch #t 
    (lambda ()
      (catch #t
	(lambda ()
	  (error 'an-error "an-error"))
	(lambda args
	  (set! e (environment->list (error-environment)))))
      (throw #t "not an error"))
    (lambda args
      #f))
  (test (equal? e (environment->list (error-environment))) #t))
