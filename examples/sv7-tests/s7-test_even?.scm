(test (even? 3) #f )
(test (even? 2) #t )
(test (even? -4) #t )
(test (even? -1) #f )
(test (even? -0) #t)
(test (even? -9223372036854775808) #t)
(test (even? 9223372036854775807) #f)
(test (even? most-positive-fixnum) #f)
(test (even? most-negative-fixnum) #t)
(test (even? -2147483647) #f)
(test (even? -2147483648) #t)
(test (even? -2147483649) #f)
(test (even? 2147483647) #f)
(test (even? 2147483648) #t)
(test (even? 2147483649) #f)

(for-each
 (lambda (n)
   (if (not (even? n))
       (format #t ";(even? ~A) -> #f?~%" n)))
 (list 0 2 1234 -4 -10000002 1000000006))

(for-each
 (lambda (n)
   (if (even? n)
       (format #t ";(even? ~A) -> #t?~%" n)))
 (list 1 -1 31 50001 543321))

(let ((top-exp 60))
  (let ((happy #t))
    (do ((i 2 (+ i 1)))
	((or (not happy) (> i top-exp)))
      (let* ((val1 (+ 2 (inexact->exact (expt 2 i))))
	     (val2 (- val1 1))
	     (ev1 (even? val1))
	     (ov1 (odd? val1))
	     (ev2 (even? val2))
	     (ov2 (odd? val2)))
	(if (not ev1)
	    (begin (set! happy #f) (display "not (even? ") (display val1) (display ")?") (newline)))
	(if ev2
	    (begin (set! happy #f) (display "(even? ") (display val2) (display ")?") (newline)))
	(if ov1
	    (begin (set! happy #f) (display "(odd? ") (display val1) (display ")?") (newline)))
	(if (not ov2)
	    (begin (set! happy #f) (display "not (odd? ") (display val2) (display ")?") (newline)))))))

(if with-bignums
    (begin
      (test (even? 12345678901234567890) #t)
      (test (even? 12345678901234567891) #f)
      (test (even? -1231234567891234567891) #f)
      (test (even? -1234567891234567891) #f)
      (test (even? -1239223372036854775808) #t)
      (test (even? -9223372036854775808) #t)
      (test (even? 1231234567891234567891) #f)
      (test (even? 1234567891234567891) #f)
      (test (even? 1239223372036854775808) #t)
      (test (even? 9223372036854775808) #t)
      (test (even? 9223372036854775808/9223372036854775807) 'error)
      (test (even? 0+92233720368547758081.0i) 'error)
      ))

(test (even?) 'error)
(test (even? 1.23) 'error)
(test (even? 1.0) 'error)
(test (even? 123 123) 'error)
(test (even? 1+i) 'error)
(test (even? 1+0i) 'error)
(test (even? inf.0) 'error)
(test (even? nan.0) 'error)
(test (even? 1/2) 'error)

(for-each
 (lambda (arg)
   (test (even? arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))