(test (inexact? -1) #f)
(test (inexact? -1.797693134862315699999999999999999999998E308) #t)
(test (inexact? -2.225073858507201399999999999999999999996E-308) #t)
(test (inexact? -9223372036854775808) #f)
(test (inexact? 1.0) #t)
(test (inexact? 1.110223024625156799999999999999999999997E-16) #t)
(test (inexact? 1.5+0.123i) #t)
(test (inexact? 1/2) #f)
(test (inexact? 3) #f)
(test (inexact? 3.123) #t)
(test (inexact? 9223372036854775807) #f)
(test (inexact? +inf.0) #t)
(test (inexact? -inf.0) #t)
(test (inexact? nan.0) #t)

(if with-bignums
    (begin
      (test (inexact? 12345678901234567890) #f)
      (test (inexact? 9223372036854775808.1) #t)
      (test (inexact? 9223372036854775808) #f)
      (test (inexact? 9223372036854775808/3) #f)
      (test (inexact? 9223372036854775808.1+1.0i) #t)
      ))

(test (inexact? "hi") 'error)
(test (inexact? 1.0+23.0i 1.0+23.0i) 'error)
(test (inexact?) 'error)

(for-each
 (lambda (arg)
   (test (inexact? arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))
