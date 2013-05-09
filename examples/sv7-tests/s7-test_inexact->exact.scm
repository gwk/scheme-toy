(num-test (inexact->exact 0.0) 0)
(num-test (inexact->exact 1) 1)
(num-test (inexact->exact 1.0) 1)
(num-test (inexact->exact 1.5) 3/2)
(test (inexact->exact most-negative-fixnum) most-negative-fixnum)

(num-test (inexact->exact 1.0000000000000000000000000000+0.0000000000000000000000000000i) 1)
(num-test (inexact->exact 1.0+0.0000000000000000000000000000i) 1)
(num-test (inexact->exact 1.0000000000000000000000000000+0.0i) 1)
(num-test (inexact->exact 1.0000000000000000000000000000+0e10i) 1)
(num-test (inexact->exact 1.0+0.0000000000000000000000000000e10i) 1)
(num-test (inexact->exact 1.0000000000000000000000000000+0.0e10i) 1)
(num-test (inexact->exact -2.225073858507201399999999999999999999996E-308) 0)
(num-test (inexact->exact -9223372036854775808) -9223372036854775808)
(num-test (inexact->exact 1.110223024625156799999999999999999999997E-16) 0)
(num-test (inexact->exact 9223372036854775807) 9223372036854775807)
(num-test (inexact->exact -2305843009213693952/4611686018427387903) -2305843009213693952/4611686018427387903)

;(num-test (inexact->exact 9007199254740995.0) 9007199254740995)
;this can't work in the non-gmp case -- see s7.c under BIGNUM_PLUS
;#e4611686018427388404.0 -> 4611686018427387904

(if with-bignums
    (begin
      (num-test (inexact->exact .1e20) 10000000000000000000)
      (num-test (inexact->exact 1e19) 10000000000000000000)
      (num-test (inexact->exact 1e20) 100000000000000000000)
      (num-test (inexact->exact 9007199254740995.0) 9007199254740995)
      (num-test (inexact->exact 4611686018427388404.0) 4611686018427388404)
      (num-test #e9007199254740995.0 9007199254740995)
      (num-test #e4611686018427388404.0 4611686018427388404)
      (test (inexact->exact (bignum "0+1.5i")) 'error)
      ))

(if (not with-bignums)
    (begin
      (test (inexact->exact 1.1e54) 'error)
      (test (inexact->exact 1.1e564) 'error)
      (test (inexact->exact .1e20) 'error)
      (test (inexact->exact 1e19) 'error)
      (test (inexact->exact 1e20) 'error)
      ))

(test (inexact->exact inf.0) 'error)
(test (inexact->exact nan.0) 'error)
(test (inexact->exact "hi") 'error)
(test (inexact->exact 0+1.5i) 'error)
(test (inexact->exact 1+i) 'error)
(test (inexact->exact 1.0+23.0i 1.0+23.0i) 'error)
(test (inexact->exact) 'error)

(for-each
 (lambda (arg)
   (test (inexact->exact arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))
