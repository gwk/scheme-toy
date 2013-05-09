(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (dynamic-wind
			(lambda () (set! ctr1 (+ ctr1 1)))
			(lambda () (set! ctr2 (+ ctr2 1)) (+ 1 ctr2))
			(lambda () (set! ctr3 (+ ctr3 1))))))
	  (= ctr1 ctr2 ctr3 (- ctr4 1) 1)))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (catch 'dw
			   (lambda ()
			     (dynamic-wind
				 (lambda () (set! ctr1 (+ ctr1 1)))
				 (lambda () (set! ctr2 (+ ctr2 1)) (error 'dw "dw-error") ctr2)
				 (lambda () (set! ctr3 (+ ctr3 1)))))
			   (lambda args (car args)))))
	  (and (eq? ctr4 'dw)
	       (= ctr1 1) (= ctr2 1) (= ctr3 1))))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (catch 'dw
			   (lambda ()
			     (dynamic-wind
				 (lambda () (set! ctr1 (+ ctr1 1)))
				 (lambda () (error 'dw "dw-error") (set! ctr2 (+ ctr2 1)) ctr2)
				 (lambda () (set! ctr3 (+ ctr3 1)))))
			   (lambda args (car args)))))
	  (and (eq? ctr4 'dw)
	       (= ctr1 1) (= ctr2 0) (= ctr3 1))))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (catch #t
			   (lambda ()
			     (dynamic-wind
				 (lambda () (set! ctr1 (+ ctr1 1)) (error 'dw-init "dw-error"))
				 (lambda () (set! ctr2 (+ ctr2 1)) (error 'dw "dw-error") ctr2)
				 (lambda () (set! ctr3 (+ ctr3 1)))))
			   (lambda args (car args)))))
	  (and (eq? ctr4 'dw-init)
	       (= ctr1 1) (= ctr2 0) (= ctr3 0))))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (catch #t
			   (lambda ()
			     (dynamic-wind
				 (lambda () (set! ctr1 (+ ctr1 1)))
				 (lambda () (set! ctr2 (+ ctr2 1)) ctr2)
				 (lambda () (set! ctr3 (+ ctr3 1)) (error 'dw-final "dw-error"))))
			   (lambda args (car args)))))
	  (and (eq? ctr4 'dw-final)
	       (= ctr1 1) (= ctr2 1) (= ctr3 1))))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (catch #t
			   (lambda ()
			     (dynamic-wind
				 (lambda () (set! ctr1 (+ ctr1 1)))
				 (lambda () (set! ctr2 (+ ctr2 1)) ctr2)
				 (lambda () (error 'dw-final "dw-error") (set! ctr3 (+ ctr3 1)))))
			   (lambda args (car args)))))
	  (and (eq? ctr4 'dw-final)
	       (= ctr1 1) (= ctr2 1) (= ctr3 0))))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (call/cc (lambda (exit)
			       (dynamic-wind
				   (lambda () (set! ctr1 (+ ctr1 1)))
				   (lambda () (exit ctr2) (set! ctr2 (+ ctr2 1)) ctr2)
				   (lambda () (set! ctr3 (+ ctr3 1)) 123))))))
	  (and (= ctr1 ctr3 1)
	       (= ctr2 ctr4 0))))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (call/cc (lambda (exit)
			       (dynamic-wind
				   (lambda () (exit ctr1) (set! ctr1 (+ ctr1 1)))
				   (lambda () (set! ctr2 (+ ctr2 1)) ctr2)
				   (lambda () (set! ctr3 (+ ctr3 1))))))))
	  (= ctr1 ctr2 ctr3 ctr4 0)))
      #t)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((ctr4 (call/cc (lambda (exit)
			       (dynamic-wind
				   (lambda () (set! ctr1 (+ ctr1 1)))
				   (lambda () (set! ctr2 (+ ctr2 1)) ctr2)
				   (lambda () (exit ctr3) (set! ctr3 (+ ctr3 1))))))))
	  (and (= ctr1 ctr2 1)
	       (= ctr3 ctr4 0))))
      #t)

(test (let ((path '())  
	    (c #f)) 
	(let ((add (lambda (s)  
		     (set! path (cons s path))))) 
	  (dynamic-wind  
	      (lambda () (add 'connect))  
	      (lambda () (add (call-with-current-continuation  
			       (lambda (c0) (set! c c0) 'talk1))))  
	      (lambda () (add 'disconnect))) 
	  (if (< (length path) 4) 
	      (c 'talk2) 
	      (reverse path)))) 
      '(connect talk1 disconnect  connect talk2 disconnect))


(for-each
 (lambda (arg)
   (test (dynamic-wind (lambda () #f) (lambda () arg) (lambda () #f)) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (dynamic-wind (lambda () #f) (lambda () #f) (lambda () #f)) #f)
(test (+ 1 (dynamic-wind (lambda () #f) (lambda () (values 2 3 4)) (lambda () #f)) 5) 15)

(test (let ((identity (lambda (a) a)))
        (let ((x '())
              (c #f))
          (dynamic-wind
	      (lambda () (set! x (cons 'a x)))
	      (lambda ()
		(dynamic-wind
		    (lambda () (set! x (cons 'b x)))
		    (lambda ()
		      (dynamic-wind
			  (lambda () (set! x (cons 'c x)))
			  (lambda () (set! c (call/cc identity)))
			  (lambda () (set! x (cons 'd x)))))
		    (lambda () (set! x (cons 'e x))))
		(dynamic-wind
		    (lambda () (set! x (cons 'f x)))
		    (lambda () (if c (c #f)))
		    (lambda () (set! x (cons 'g x)))))
	      (lambda () (set! x (cons 'h x))))
          (reverse x)))
      '(a b c d e f g b c d e f g h))


(test (list (dynamic-wind 
		(lambda () #f)
		(lambda () (values 'a 'b 'c))
		(lambda () #f)))
      (list 'a 'b 'c))

(test (let ((dynamic-wind 1)) (+ dynamic-wind 2)) 3)

(test (let ((ctr1 0)
	    (ctr2 0)
	    (ctr3 0))
	(let ((val (dynamic-wind
		       (lambda () #f)
		       (lambda ()
			 (set! ctr1 1)
			 (call/cc
			  (lambda (exit)
			    (exit 123)
			    (set! ctr2 2)
			    321)))
		       (lambda ()
			 (set! ctr3 3)))))
	  (and (= ctr1 1) (= ctr2 0) (= ctr3 3) (= val 123))))
      #t)

(test (let ((ctr1 0))
	(let ((val (dynamic-wind
		       (let ((a 1))
			 (lambda ()
			   (set! ctr1 a)))
		       (let ((a 10))
			 (lambda ()
			   (set! ctr1 (+ ctr1 a))
			   ctr1))
		       (let ((a 100))
			 (lambda ()
			   (set! ctr1 (+ ctr1 a)))))))
	  (and (= ctr1 111) (= val 11))))
      #t)

(test (let ((ctr1 0))
	(let ((val (+ 3 (dynamic-wind
			    (let ((a 1))
			      (lambda ()
				(set! ctr1 a)))
			    (let ((a 10))
			      (lambda ()
				(set! ctr1 (+ ctr1 a))
				ctr1))
			    (let ((a 100))
			      (lambda ()
				(set! ctr1 (+ ctr1 a)))))
		      1000)))
	  (and (= ctr1 111) (= val 1014))))
      #t)

(test (let ((n 0))
	(call-with-current-continuation
	 (lambda (k)
	   (dynamic-wind
	       (lambda ()
		 (set! n (+ n 1))
		 (k))
	       (lambda ()
		 (set! n (+ n 2)))
	       (lambda ()
		 (set! n (+ n 4))))))
	n)
      1)

(test (let ((n 0))
	(call-with-current-continuation
	 (lambda (k)
	   (dynamic-wind
	       (lambda () #f)
	       (lambda ()
		 (dynamic-wind
		     (lambda () #f)
		     (lambda ()
		       (set! n (+ n 1))
		       (k))
		     (lambda ()
		       (set! n (+ n 2))
					;(k)
		       )))
	       (lambda ()
		 (set! n (+ n 4))))))
	n)
      7)

(test (let ((n 0))
	(call-with-current-continuation
	 (lambda (k)
	   (dynamic-wind
	       (lambda () #f)
	       (lambda ()
		 (dynamic-wind
		     (lambda () #f)
		     (lambda ()
		       (dynamic-wind
			   (lambda () #f)
			   (lambda ()
			     (set! n (+ n 1))
			     (k))
			   (lambda ()
			     (if (= n 1)
				 (set! n (+ n 2))))))
		     (lambda ()
		       (if (= n 3)
			   (set! n (+ n 4))))))
	       (lambda ()
		 (if (= n 7)
		     (set! n (+ n 8)))))))
	n)
      15)

(test (dynamic-wind) 'error)
(test (dynamic-wind (lambda () #f)) 'error)
(test (dynamic-wind (lambda () #f) (lambda () #f)) 'error)
(test (dynamic-wind (lambda (a) #f) (lambda () #f) (lambda () #f)) 'error)
(test (dynamic-wind (lambda () #f) (lambda (a b) #f) (lambda () #f)) 'error)
(test (dynamic-wind (lambda () #f) (lambda () #f) (lambda (a) #f)) 'error)
(test (dynamic-wind (lambda () 1) #f (lambda () 2)) 'error)
(test (dynamic-wind . 1) 'error)
(test (dynamic-wind () () ()) 'error)
(test (dynamic-wind () _ht_ ()) 'error)

(for-each
 (lambda (arg)
   (test (dynamic-wind arg (lambda () #f) (lambda () #f)) 'error)
   (test (dynamic-wind (lambda () #f) arg (lambda () #f)) 'error)
   (test (dynamic-wind (lambda () #f) (lambda () #f) arg) 'error))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (dynamic-wind (let ((x 1)) (lambda () x)) ((lambda () (lambda () 2))) s7-version) 2)
(test (let ((x 0)) (dynamic-wind (lambda () (set! x 1)) ((lambda () (set! x 32) (lambda () x))) (let () (set! x 44) (lambda () x)))) 1)
(test (let ((x 0)) (dynamic-wind (lambda () (set! x (+ x 1))) ((lambda () (set! x 32) (lambda () x))) (let () (set! x 44) (lambda () x)))) 45)
(test (let ((x 0)) (dynamic-wind (lambda () (set! x (+ x 1))) ((lambda () (set! x 32) (lambda () x))) (let () (lambda () x)))) 33)
(test (let ((x 0)) (dynamic-wind (lambda () (set! x (+ x 1))) ((lambda () (set! x (+ x 32)) (lambda () x))) (let () (lambda () (set! x (+ x 100)) x)))) 33)

(let ()
  (define-macro (make-thunk val) `(lambda () ,val))
  (test (dynamic-wind (make-thunk 0) (make-thunk 1) (make-thunk 2)) 1))

;;; from scheme wiki
;;; http://community.schemewiki.org/?hose-the-repl
;;; jorgen-schafer

(test (let loop ()  
	(call-with-exit
	 (lambda (k)  
	   (dynamic-wind  
	       (lambda () #t)  
	       (lambda () (let loop () (loop)))  
	       k))) 
	(loop))
      'error)
;; that example calls to mind a bunch like it:
(test (call-with-exit (lambda (k) (dynamic-wind (lambda () #t) (lambda () (let loop () (loop))) k))) 'error)
(test (call-with-exit (lambda (k) (dynamic-wind (lambda () #t) k (lambda () #t)))) 'error)
(test (call-with-exit (lambda (k) (dynamic-wind k (lambda () #f) (lambda () #t)))) 'error)

(test (call-with-exit (lambda (k) (procedure-documentation k))) "")
(test (call-with-exit (lambda (k) (procedure-arity k))) '(0 0 #t))
(test (call-with-exit (lambda (k) (procedure-source k))) '())

(test (procedure-arity (make-procedure-with-setter vector-ref vector-set!)) '(2 0 #t))
(test (let ((pws (make-procedure-with-setter vector-ref vector-set!))) 
	(let ((pws1 (make-procedure-with-setter pws vector-set!))) 
	  (let ((v (vector 1 2))) 
	    (set! (pws1 v 1) 32) 
	    (pws1 v 1))))
      32)
(test (call-with-exit (lambda (k) (map k '(1 2 3)))) 1)
(test (call-with-exit (lambda (k) (for-each k '(1 2 3)))) 1)
(test (call-with-exit (lambda (k) (catch #t k k))) 'error)
(test (call-with-exit (lambda (k) (catch #t (lambda () #f) k))) #f)
;(test (call-with-exit (lambda (k) (catch #t (lambda () (error 'an-error)) k))) 'error) ; this seems like it could be either
(test (procedure? (call-with-exit (lambda (return) (call-with-exit return)))) #t)
;(test (call-with-exit (lambda (k) (sort! '(1 2 3) k))) 'error) -- currently returns (values 2 3) which is plausible
(test (sort! '(1 2 3) (lambda () #f)) 'error)
(test (sort! '(1 2 3) (lambda (a) #f)) 'error)
(test (sort! '(1 2 3) (lambda (a b c) #f)) 'error)
(test (let () (define-macro (asdf a b) `(< ,a ,b)) (sort! '(1 2 3) asdf)) 'error)
(test (let () (let asdf () (sort! '(1 2 3) asdf))) 'error)
(test (let () (let asdf () (map asdf '(1 2 3)))) 'error)
(test (let () (let asdf () (for-each asdf '(1 2 3)))) 'error)
(test (dynamic-wind quasiquote s7-version s7-version) 'error)

(test (let ((ctr 0))
	(call-with-exit
	 (lambda (exit)
	   (let asdf
	       ()
	     (set! ctr (+ ctr 1))
	     (if (> ctr 2)
		 (exit ctr))
	     (dynamic-wind
		 (lambda () #f)
		 (lambda () #f)
		 asdf)))))
      3)

(test (let ((ctr 0))
	(dynamic-wind
	    (lambda () #f)
	    (lambda ()
	      (call-with-exit
	       (lambda (exit)
		 (catch #t
			(lambda ()
			  (error 'error))
			(lambda args
			  (exit 'error)))
		 (set! ctr 1))))
	    (lambda ()
	      (set! ctr (+ ctr 2))))
	ctr)
      2)
(test (call-with-exit (lambda (r1) (call-with-exit (lambda (r2) (call-with-exit (lambda (r3) (r1 12) (r2 1))) (r1 2))) 3)) 12)
(test (call-with-exit (lambda (r1) (call-with-exit (lambda (r2) (call-with-exit (lambda (r3) (r2 12) (r2 1))) (r1 2))) 3)) 3)
(test (call-with-exit (lambda (r1) (call-with-exit (lambda (r2) (call-with-exit (lambda (r3) (r3 12) (r2 1))) (r1 2))) 3)) 2)

;; make sure call-with-exit closes ports
(test (let ((p (call-with-exit (lambda (return) 
				 (call-with-input-file "tmp1.r5rs" 
				   (lambda (port) 
				     (return port))))))) 
	(port-closed? p)) 
      #t)
(test (let ((p (call-with-exit (lambda (return) 
				 (call-with-input-file "tmp1.r5rs" 
				   (lambda (port) 
				     (if (not (port-closed? port)) (return port))))))))
	(port-closed? p)) 
      #t)
(test (let ((p (call-with-exit (lambda (return) 
				 (with-input-from-file "tmp1.r5rs" 
				   (lambda () 
				     (return (current-input-port)))))))) 
	(port-closed? p)) 
      #t)
(test (let ((p (call-with-exit (lambda (return) 
				 (with-output-to-file "empty-file" 
				   (lambda () 
				     (return (current-output-port)))))))) 
	(port-closed? p)) 
      #t)
(test (let ((p (call-with-exit (lambda (return) 
				 (call-with-output-file "empty-file" 
				   (lambda (port) 
				     (return port)))))))
	(port-closed? p)) 
      #t)
(test (let ((p (call-with-exit (lambda (return) 
				 (call-with-input-string "this is a test" 
				   (lambda (port) 
				     (return port)))))))
	(port-closed? p)) 
      #t)
(test (let ((p (call-with-exit (lambda (return) 
				 (call-with-output-string
				   (lambda (port) 
				     (return port)))))))
	(port-closed? p)) 
      #t)

(let ((pws (make-procedure-with-setter < >))) (test (sort! '(2 3 1 4) pws) '(1 2 3 4)))
(test (call-with-exit (lambda (k) (call-with-input-string "123" k))) 'error)
(test (call-with-exit (lambda (k) (call-with-input-file "tmp1.r5rs" k))) 'error)
(test (call-with-exit (lambda (k) (call-with-output-file "tmp1.r5rs" k))) 'error)
(test (call-with-exit (lambda (k) (call-with-output-string k))) 'error)
(let ((pws (make-procedure-with-setter (lambda (a) (+ a 1)) (lambda (a b) b))))
  (test (procedure? pws) #t)
  (test (map pws '(1 2 3)) '(2 3 4))
  (test (apply pws '(1)) 2))
(test (let ((ctr 0)) (call-with-exit (lambda (top-exit) (set! ctr (+ ctr 1)) (call-with-exit top-exit) (set! ctr (+ ctr 16)))) ctr) 1)

(test (let () (+ 5 (call-with-exit (lambda (return) (return 1 2 3) 4)))) 11)
(test (+ 5 (call-with-exit (lambda (return) (return 1)))) 6)
(test (+ 5 (call-with-exit (lambda (return) (return)))) 'error)

(test (let ((cur '()))
	(define (step pos)
	  (dynamic-wind
	      (lambda ()
		(set! cur (cons pos cur)))
	      (lambda ()
		(set! cur (cons (+ pos 1) cur))
		(if (< pos 40)
		    (step (+ pos 10)))
		(set! cur (cons (+ pos 2) cur))
		cur)
	      (lambda ()
		(set! cur (cons (+ pos 3) cur)))))
	(reverse (step 0)))
      '(0 1 10 11 20 21 30 31 40 41 42 43 32 33 22 23 12 13 2))


(test (let ((cur '()))
	(define (step pos)
	  (dynamic-wind
	      (lambda ()
		(set! cur (cons pos cur)))
	      (lambda ()
		(set! cur (cons (+ pos 1) cur))
		(if (< pos 40)
		    (step (+ pos 10))
		    (error 'all-done))
		(set! cur (cons (+ pos 2) cur))
		cur)
	      (lambda ()
		(set! cur (cons (+ pos 3) cur)))))
	(catch 'all-done
	       (lambda ()
		 (reverse (step 0)))
	       (lambda args (reverse cur))))
      '(0 1 10 11 20 21 30 31 40 41 43 33 23 13 3))

(test (let ((cur '()))
	(define (step pos ret)
	  (dynamic-wind
	      (lambda ()
		(set! cur (cons pos cur)))
	      (lambda ()
		(set! cur (cons (+ pos 1) cur))
		(if (< pos 40)
		    (step (+ pos 10) ret)
		    (ret (reverse cur)))
		(set! cur (cons (+ pos 2) cur))
		cur)
	      (lambda ()
		(set! cur (cons (+ pos 3) cur)))))
	(list (call-with-exit
	       (lambda (ret)
		 (step 0 ret)))
	      (reverse cur)))
      '((0 1 10 11 20 21 30 31 40 41) (0 1 10 11 20 21 30 31 40 41 43 33 23 13 3)))

(test (let ()
	(catch #t
	       (lambda ()
		 (eval-string "(error 'hi \"hi\")"))
	       (lambda args
		 'error)))
      'error)
(test (let ()
	(catch #t
	       (lambda ()
		 (eval-string "(+ 1 #\\a)"))
	       (lambda args
		 'oops)))
      'oops)

(test (let ()
	(call-with-exit
	 (lambda (return)
	   (eval-string "(return 3)"))))
      3)
(test (let ()
	(call-with-exit
	 (lambda (return)
	   (eval-string "(abs (+ 1 (if #t (return 3))))"))))
      3)

(test (let ((val (catch #t
			(lambda ()
			  (eval-string "(catch 'a (lambda () (+ 1 __asdf__)) (lambda args 'oops))"))
			(lambda args 'error))))
	val)
      'error)

(test (let ((val (catch #t
			(lambda ()
			  (eval `(catch 'a (lambda () (+ 1 __asdf__)) (lambda args 'oops))))
			(lambda args 'error))))
	val)
      'error)


#|
;; this exits the s7test load
(test (let ()
	(call/cc
	 (lambda (return)
	   (eval-string "(return 3)"))))
      3)
|#

(let ((x 0)
      (y 0)
      (z 0))
  (define (dw1 a c) 
    (dynamic-wind
	(lambda ()
	  (set! x (+ x 1)))
	(lambda ()
	  (set! y (+ y 1))
	  (or (and (>= a c) a)
	      (dw1 (+ a 1) c)))
	(lambda ()
	  (set! z (+ z 1))
	  (set! y (- y 1)))))
  (let ((val (dw1 0 8)))
    (test (list val x y z) (list 8 9 0 9))))

(let ((x 0)
      (y 0)
      (z 0))
  (define (dw1 a c) 
    (catch #t
	   (lambda ()
	     (dynamic-wind
		 (lambda ()
		   (set! x (+ x 1)))
		 (lambda ()
		   (set! y (+ y 1))
		   (or (and (>= a c) a)
		       (dw1 (+ a 1) c)))
		 (lambda ()
		   (set! z (+ z 1))
		   (set! y (= y 1))))) ; an error after the 1st call because we have (= #f 1)
	   (lambda args 'error)))
  (let ((val (dw1 0 4)))
    (test val 'error)))

(let ((x 0)
      (y 0)
      (z 0))
  (define (dw1 a c) 
    (catch #t
	   (lambda ()
	     (dynamic-wind
		 (lambda ()
		   (set! x (+ x 1)))
		 (lambda ()
		   (set! y (= y 1)) ; an error after the 1st call because we have (= #f 1)
		   (or (and (>= a c) a)
		       (dw1 (+ a 1) c)))
		 (lambda ()
		   (set! z (+ z 1))
		   (set! y (= y 1)))))
	   (lambda args 'error)))
  (let ((val (dw1 0 4)))
    (test val 'error)))

(let ((x 0)
      (y 0)
      (z 0))
  (define (dw1 a c) 
    (catch #t
	   (lambda ()
	     (dynamic-wind
		 (lambda ()
		   (set! x (= x 1))) ; an error after the 1st call because we have (= #f 1)
		 (lambda ()
		   (set! y (= y 1)) 
		   (or (and (>= a c) a)
		       (dw1 (+ a 1) c)))
		 (lambda ()
		   (set! z (+ z 1))
		   (set! y (= y 1)))))
	   (lambda args 'error)))
  (let ((val (dw1 0 4)))
    (test val 'error)))

(let ((x 0)
      (y 0)
      (z 0))
  (let ((val (call-with-exit
	      (lambda (r)
		(catch #t
		       (lambda ()
			 (dynamic-wind
			     (lambda ()
			       (set! x (+ x 1)))
			     (lambda ()
			       (set! y (+ y 1))
			       (r y))
			     (lambda ()
			       (set! z (+ z 1)))))
		       (lambda args 'error))))))
    (test (list val z) '(1 1))))

(let ((x 0)
      (y 0)
      (z 0))
  (let ((val (catch #t
		    (lambda ()
		      (dynamic-wind
			  (lambda ()
			    (set! x (+ x 1)))
			  (lambda ()
			    (call-with-exit
			     (lambda (r)
			       (set! y r)
			       x)))
			  (lambda ()
			    (set! z (+ z 1))
			    (y z))))
		    (lambda args 'error))))
    (test val 'error)))

(test (dynamic-wind 
	  (lambda () (eq? (let ((lst (cons 1 2))) (set-cdr! lst lst) lst) (call/cc (lambda (k) k))))
	  (lambda () #f)
	  (lambda () #f))
      #f)
