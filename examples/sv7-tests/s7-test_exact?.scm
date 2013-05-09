(test (exact? 1/0) #f)
(test (exact? '0/1) #t)
(test (exact? (/ 1 2)) #t)
(test (exact? -0) #t)
(test (exact? -1.797693134862315699999999999999999999998E308) #f)
(test (exact? -2.225073858507201399999999999999999999996E-308) #f)
(test (exact? -9223372036854775808) #t)
(test (exact? 0/0) #f)
(test (exact? 0/1) #t)
(test (exact? 1.0) #f)
(test (exact? 1.110223024625156799999999999999999999997E-16) #f)
(test (exact? 1.5+0.123i) #f)
(test (exact? 1/2) #t)
(test (exact? 3) #t )
(test (exact? 3.123) #f)
(test (exact? 9223372036854775807) #t)
(test (exact? most-positive-fixnum) #t)
(test (exact? pi) #f)
(test (exact? +inf.0) #f)
(test (exact? -inf.0) #f)
(test (exact? nan.0) #f)
(test (exact? (imag-part 1+0i)) #f)
(test (exact? (imag-part 1+0.0i)) #f)
(test (exact? (imag-part 1+1i)) #f)

(if with-bignums
    (begin
      (test (exact? 12345678901234567890) #t)
      (test (exact? 9223372036854775808.1) #f)
      (test (exact? 9223372036854775808) #t)
      (test (exact? 9223372036854775808/3) #t)
      (test (exact? 9223372036854775808.1+1.0i) #f)
      ))

(test (exact?) 'error)
(test (exact? "hi") 'error)
(test (exact? 1.0+23.0i 1.0+23.0i) 'error)

(for-each
 (lambda (arg)
   (test (exact? arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))