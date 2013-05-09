(test (odd? 3) #t )
(test (odd? 2) #f )
(test (odd? -4) #f )
(test (odd? -1) #t )
(test (odd? 0) #f)
(test (odd? -0) #f)
(test (odd? -9223372036854775808) #f)
(test (odd? 9223372036854775807) #t)
(test (odd? most-positive-fixnum) #t)
(test (odd? most-negative-fixnum) #f)
(test (odd? -2147483647) #t)
(test (odd? -2147483648) #f)
(test (odd? -2147483649) #t)
(test (odd? 2147483647) #t)
(test (odd? 2147483648) #f)
(test (odd? 2147483649) #t)

(for-each
 (lambda (n)
   (if (odd? n)
       (format #t ";(odd? ~A) -> #t?~%" n)))
 (list 0 2 1234 -4 -10000002 1000000006))

(for-each
 (lambda (n)
   (if (not (odd? n))
       (format #t ";(odd? ~A) -> #f?~%" n)))
 (list 1 -1 31 50001 543321))

(if with-bignums
    (begin
      (test (odd? 12345678901234567891) #t)
      (test (odd? 12345678901234567890) #f)
      (test (odd? -1231234567891234567891) #t)
      (test (odd? -1231234567891234567891) #t)
      (test (odd? -1239223372036854775808) #f)
      (test (odd? -9223372036854775808) #f)
      (test (odd? 1231234567891234567891) #t)
      (test (odd? 1234567891234567891) #t)
      (test (odd? 1239223372036854775808) #f)
      (test (odd? 9223372036854775808) #f)
      (test (odd? 9223372036854775808/9223372036854775807) 'error)
      (test (odd? 0+92233720368547758081.0i) 'error)
      ))

(test (odd?) 'error)
(test (odd? 1.23) 'error)
(test (odd? 1.0) 'error)
(test (odd? 1+i) 'error)
(test (odd? 123 123) 'error)
(test (odd? inf.0) 'error)
(test (odd? nan.0) 'error)
(test (odd? 1/2) 'error)

(for-each
 (lambda (arg)
   (test (odd? arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))
