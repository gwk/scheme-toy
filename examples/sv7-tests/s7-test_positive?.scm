(test (positive? 4/3) #t )
(test (positive? 4) #t )
(test (positive? -4) #f )
(test (positive? -4/3) #f )
(test (positive? 0) #f )
(test (positive? 0.0) #f )
(test (positive? -0) #f )
(test (positive? 1-0.0i) #t)
(test (positive? 1.0) #t)
(test (positive? -1.797693134862315699999999999999999999998E308) #f)
(test (positive? -2.225073858507201399999999999999999999996E-308) #f)
(test (positive? -9223372036854775808) #f)
(test (positive? 1.110223024625156799999999999999999999997E-16) #t)
(test (positive? 9223372036854775807) #t)
(test (positive? most-negative-fixnum) #f)
(test (positive? most-positive-fixnum) #t)
(test (positive? +inf.0) #t)
(test (positive? -inf.0) #f)
(test (positive? nan.0) #f)
(test (positive? 1000000000000000000000000000000000) #t)
(test (positive? -1000000000000000000000000000000000) #f)

(for-each
 (lambda (n)
   (if (not (positive? n))
       (format #t ";(positive? ~A) -> #f?~%") n))
 (list 1 123 123456123 1.4 0.001 1/2 124124124.2))

(for-each
 (lambda (n)
   (if (positive? n)
       (format #t ";(positive? ~A) -> #t?~%" n)))
 (list -1 -123 -123456123 -3/2 -0.00001 -1.4 -123124124.1))

(if with-bignums
    (begin
      (test (positive? 9.92209574402351949043519108941671096176E-1726) #t)
      (test (positive? 12345678901234567890) #t)
      (test (positive? -12345678901234567890) #f)
      (test (positive? 9223372036854775808) #t)
      (test (positive? 9223372036854775808.1) #t)
      (test (positive? 9223372036854775808/3) #t)
      (test (positive? (/ most-positive-fixnum most-negative-fixnum)) #f)
      (test (positive? 0+92233720368547758081.0i) 'error)
      ))

(test (positive? 1.23+1.0i) 'error)
(test (positive? 1.23 1.23) 'error)
(test (positive?) 'error)
(test (positive? 1 2) 'error)

(for-each
 (lambda (arg)
   (test (positive? arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))
