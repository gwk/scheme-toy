(test (rational? 3) #t)
(test (rational? 1/2) #t)
(test (rational? 2) #t)
(test (rational? (sqrt 2)) #f)
(test (rational? 1.0) #f)
(test (rational? 1+i) #f)
(test (rational? most-negative-fixnum) #t)
(test (rational? 0/0) #f)  ; I like this
(test (rational? 1/0) #f)
(test (rational? (/ 1 2)) #t)
(test (rational? (/ -4 4)) #t)
(test (rational? (/ 1.0 2)) #f)
(test (rational? 1/2+i) #f)
(test (rational? -1.797693134862315699999999999999999999998E308) #f)
(test (rational? -2.225073858507201399999999999999999999996E-308) #f)
(test (rational? -9223372036854775808) #t)
(test (rational? 1.110223024625156799999999999999999999997E-16) #f)
(test (rational? 9223372036854775807) #t)
(test (rational? +inf.0) #f)
(test (rational? -inf.0) #f)
(test (rational? nan.0) #f)
(test (rational? pi) #f)
(test (rational? 9223372036854775806/9223372036854775807) #t)
(test (rational? 1+0i) #f) ; ?? 
(test (rational? 1+0.0i) #f) ; ?? see integer? 

(if with-bignums
    (begin
      (test (rational? 1234567891234567890/1234567) #t)
      (test (rational? 9223372036854775808) #t)
      (test (rational? 9223372036854775808.1) #f)
      (test (rational? 9223372036854775808.1+1.5i) #f)
      (test (rational? 9223372036854775808/3) #t)
      ))

(test (rational?) 'error)
(test (rational? 1 2) 'error)
