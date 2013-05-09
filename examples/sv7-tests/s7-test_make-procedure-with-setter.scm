(test (let ((local 123))
	(define pws-test (make-procedure-with-setter
			  (lambda () local)
			  (lambda (val) (set! local val))))
	(pws-test))
      123)

(test (let ((local 123))
	(define pws-test (make-procedure-with-setter
			  (lambda () local)
			  (lambda (val) (set! local val))))
	(pws-test 32))
      'error)

(test (let ((local 123))
	(define pws-test (make-procedure-with-setter
			  (lambda () local)
			  (lambda (val) (set! local val))))
	(set! (pws-test 32) 123))
      'error)

(test (call-with-exit 
       (lambda (return) 
	 (let ((local 123))
	   (define pws-test (make-procedure-with-setter
			     (lambda () (return "oops"))
			     (lambda (val) (set! local val))))
	   (pws-test))))
      "oops")
(test (call-with-exit 
       (lambda (return)
	 (let ((local 123))
	   (define pws-test (make-procedure-with-setter
			     (lambda () 123)
			     (lambda (val) (return "oops"))))
	   (set! (pws-test) 1))))
      "oops")

(test (let ((local 123))
	(define pws-test (make-procedure-with-setter
			  (lambda () local)
			  (lambda (val) (set! local val))))
	(set! (pws-test) 321)
	(pws-test))
      321)

(test (let ((v (vector 1 2 3)))
	(define vset (make-procedure-with-setter
		      (lambda (loc)
			(vector-ref v loc))
		      (lambda (loc val)
			(vector-set! v loc val))))
	(let ((lst (list vset)))
	  (let ((val (vset 1)))
	    (set! (vset 1) 32)
	    (let ((val1 (vset 1)))
	      (set! ((car lst) 1) 3)
	      (list val val1 (vset 1))))))
      (list 2 32 3))

(let ((local 123))
  (define pws-test (make-procedure-with-setter
		    (lambda () local)
		    (lambda (val) (set! local val))))
  (test (procedure-with-setter? pws-test) #t)
  (test (pws-test) 123)
  (set! (pws-test) 32)
  (test (pws-test) 32)
  (set! (pws-test) 0)
  (test (pws-test) 0))

(let ((local 123))
  (define pws-test (make-procedure-with-setter
		    (lambda (val) (+ local val))
		    (lambda (val new-val) (set! local new-val) (+ local val))))
  (test (pws-test 1) 124)
  (set! (pws-test 1) 32)
  (test (pws-test 2) 34)
  (set! (pws-test 3) 0)
  (test (pws-test 3) 3))


(test (make-procedure-with-setter) 'error)
(test (make-procedure-with-setter abs) 'error)
(test (make-procedure-with-setter 1 2) 'error)
(test (make-procedure-with-setter (lambda () 1) (lambda (a) a) (lambda () 2)) 'error)
(test (make-procedure-with-setter (lambda () 1) 2) 'error)

(for-each
 (lambda (arg)
   (test (make-procedure-with-setter arg (lambda () #f)) 'error)
   (test (make-procedure-with-setter (lambda () #f) arg) 'error))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (procedure-with-setter? arg) #f))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi "hi" '#(()) abs (lambda () #f) (list (lambda () #f) (lambda (val) val)) (list 1 2 3) '(1 . 2) #<eof> #<unspecified> #<undefined>))

(let ((pws (make-procedure-with-setter vector-ref vector-set!)))
  (let ((v (vector 1 2 3)))
    (test (procedure-with-setter? pws) #t)
    (test (procedure-with-setter? pws pws) 'error)
    (test (pws v 1) 2)
    (set! (pws v 1) 32)
    (test (pws v 1) 32)
    (test (procedure-arity pws) '(2 0 #t))
    (test (procedure-arity (procedure-setter pws)) '(3 0 #t))))

(test (procedure-with-setter?) 'error)


#|
(let ()
  (define pws-args (make-procedure-with-setter
		    (lambda args args)
		    (lambda args (set-car! args 0) args)))
  (let ((lst (list 1 2 3)))
    (let ((l1 (apply pws-args lst)))
      (test l1 '(1 2 3))
      (set-car! l1 32)
      (test lst '(1 2 3))
      (set! (pws-args l1) 3)
      (test l1 '(32 2 3))
      (test lst '(1 2 3))
      (let ()
	(define (pws1)
	  (pws-args lst))
	(let ((l2 (pws1)))
	  (set! l2 (pws1))
	  (test lst '(1 2 3)))))))
|#

(test (call-with-exit (lambda (return) (procedure-with-setter? return))) #f)
(test (procedure-with-setter? quasiquote) #f)
(test (procedure-with-setter? -s7-symbol-table-locked?) #t)
(test (procedure-arity -s7-symbol-table-locked?) '(0 0 #f))
(test (procedure-arity (procedure-setter -s7-symbol-table-locked?)) '(1 0 #f))

;; (test (procedure-with-setter? '-s7-symbol-table-locked?) #f) ; this parallels (procedure? 'abs) -> #f but seems inconsistent with other *? funcs

(define (procedure-setter-arity proc) (procedure-arity (procedure-setter proc)))
(test (let ((pws (make-procedure-with-setter (lambda () 1) (lambda (a) a)))) (procedure-setter-arity pws)) '(1 0 #f))
(test (let ((pws (make-procedure-with-setter (lambda () 1) (lambda (a b c) a)))) (procedure-setter-arity pws)) '(3 0 #f))
(test (let ((pws (make-procedure-with-setter (lambda () 1) (lambda (a . b) a)))) (procedure-setter-arity pws)) '(1 0 #t))
(test (let ((pws (make-procedure-with-setter (lambda () 1) (lambda* (a (b 1)) a)))) (procedure-setter-arity pws)) '(0 2 #f))
(test (let ((pws (make-procedure-with-setter (lambda () 1) (lambda* (a :rest b) a)))) (procedure-setter-arity pws)) '(0 1 #t))
;; (test (procedure-setter-arity symbol-access) '(2 0 #f))
(test (let ((pws (make-procedure-with-setter (lambda args (apply + args)) (lambda args (apply * args))))) (pws 2 3 4)) 9)
(test (let ((pws (make-procedure-with-setter (lambda args (apply + args)) (lambda args (apply * args))))) (set! (pws 2 3 4) 5)) 120)
(let ((x 0)) 
  (let ((pws (make-procedure-with-setter
	      (let ((y 1)) ((lambda () (set! x (+ x y)) (lambda () x))))
	      (let ((y 2)) ((lambda () (set! x (* x y)) (lambda (z) (set! x (+ x z)))))))))
    (test x 2)
    (set! (pws) 3)
    (test x 5)))

(let ((p1 (make-procedure-with-setter (lambda () 1) (lambda (a) a))))
  (let ((p2 (make-procedure-with-setter p1 p1)))
    (test (p2) 1)))
(let () (define-macro (hi a) `(+ ,a 1)) (test (make-procedure-with-setter hi hi) 'error))
(test (make-procedure-with-setter quasiquote call/cc) 'error)
(test ((make-procedure-with-setter call-with-exit call/cc) (lambda (a) (a 1))) 1)
(test (length (make-procedure-with-setter < >)) 'error)

(let ((p1 (make-procedure-with-setter (lambda (a) (+ a 1)) (lambda (a b) (+ a b)))))
  (let ((p2 (make-procedure-with-setter p1 p1)))
    (test (p2 1) 2)))
