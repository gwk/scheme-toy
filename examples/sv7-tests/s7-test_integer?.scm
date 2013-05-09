(test (integer? 0.0) #f)
(test (integer? 3) #t)
(test (integer? 1/2) #f)
(test (integer? 1/1) #t)
(test (integer? 2) #t)
(test (integer? (sqrt 2)) #f)
(test (integer? 1.0) #f)
(test (integer? 1+i) #f)
(test (integer? most-negative-fixnum) #t)
(test (integer? 250076005727/500083) #t)
(test (integer? 1+0i) #f) ; hmmm -- guile says #t, but it thinks 1.0 is an integer
(test (integer? 0/0) #f)
(test (integer? 1/0) #f)
(test (integer? #e.1e010) #t)
(test (integer? (/ 2 1)) #t)
(test (integer? (/ 2 1.0)) #f)
(test (integer? -1.797693134862315699999999999999999999998E308) #f)
(test (integer? -2.225073858507201399999999999999999999996E-308) #f)
(test (integer? -9223372036854775808) #t)
(test (integer? 1.110223024625156799999999999999999999997E-16) #f)
(test (integer? 9223372036854775807) #t)
(test (integer? (expt 2.3 54)) #f)
(test (integer? 10000000000000000.5) #f)
(test (integer? (expt 2 54)) #t)
(test (integer? (expt 2.0 54)) #f)
(test (integer? most-positive-fixnum) #t)
(test (integer? (/ most-positive-fixnum most-positive-fixnum)) #t)
(test (integer? +inf.0) #f)
(test (integer? -inf.0) #f)
(test (integer? nan.0) #f)
(test (integer? pi) #f)
(test (integer? 9223372036854775806/9223372036854775807) #f)
(test (integer? 1+0.0i) #f)

(if with-bignums
    (begin
      (test (integer? 1234567891234567890/1234567) #f)
      (test (integer? 9223372036854775808) #t)
      (test (integer? 9223372036854775808.1) #f)
      (test (integer? 9223372036854775808.1+1.5i) #f)
      (test (integer? 9223372036854775808/3) #f)
      (test (integer? 9223372036854775808/9223372036854775808) #t)
      (test (integer? 21345678912345678912345678913456789123456789123456789) #t)
      ))

(test (integer?) 'error)
(test (integer? 1 2) 'error)