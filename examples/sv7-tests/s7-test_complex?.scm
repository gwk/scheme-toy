(test (complex? 1/2) #t)
(test (complex? 2) #t)
(test (complex? (sqrt 2)) #t)
(test (complex? 1.0) #t)
(test (complex? 1+i) #t)
(test (complex? most-negative-fixnum) #t)
(test (complex? 1/0) #t) ; nan is complex?? I guess so -- it's a "real"...
(test (complex? (log 0.0)) #t)
(test (complex? 0/0) #t)
(test (complex? 1+0/0i) #t)
(test (complex? -1.797693134862315699999999999999999999998E308) #t)
(test (complex? -2.225073858507201399999999999999999999996E-308) #t)
(test (complex? -9223372036854775808) #t)
(test (complex? 1.110223024625156799999999999999999999997E-16) #t)
(test (complex? 9223372036854775807) #t)
(test (complex? 3) #t )
(test (complex? +inf.0) #t)
(test (complex? -inf.0) #t)
(test (complex? nan.0) #t) ; this should be #f
(test (complex? pi) #t)

(for-each
 (lambda (arg) 
   (if (not (complex? arg))
       (format #t ";(complex? ~A) -> #f?~%" arg)))
 (list 1 1.0 1.0+0.5i 1/2))

(if with-bignums
    (begin
      (test (complex? 1234567891234567890/1234567) #t)
      (test (complex? 9223372036854775808) #t)
      (test (complex? 9223372036854775808.1) #t)
      (test (complex? 9223372036854775808.1+1.5i) #t)
      (test (complex? 0+92233720368547758081.0i) #t)
      (test (complex? 9223372036854775808/3) #t)
      ))

(test (complex?) 'error)
(test (complex? 1 2) 'error)
