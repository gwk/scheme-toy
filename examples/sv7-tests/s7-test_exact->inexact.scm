(num-test (exact->inexact 0+1.5i) 0+1.5i)
(num-test (exact->inexact 1) 1.0)
(num-test (exact->inexact 1.0) 1.0)
(num-test (exact->inexact 3/2) 1.5)
(num-test (exact->inexact -3/2) -1.5)
(test (infinite? (exact->inexact inf.0)) #t)
(test (nan? (exact->inexact nan.0)) #t)
(num-test (exact->inexact most-positive-fixnum) 9.223372036854775807E18)
(num-test (exact->inexact most-negative-fixnum) -9.223372036854775808E18)

(num-test (exact->inexact 17/12) 1.416666666666666666666666666666666666665E0)
(num-test (exact->inexact 41/29) 1.413793103448275862068965517241379310344E0)
(num-test (exact->inexact 99/70) 1.414285714285714285714285714285714285714E0)
(num-test (exact->inexact 577/408) 1.414215686274509803921568627450980392157E0)
(num-test (exact->inexact 1393/985) 1.414213197969543147208121827411167512692E0)
(num-test (exact->inexact 3363/2378) 1.414213624894869638351555929352396972245E0)
(num-test (exact->inexact 19601/13860) 1.414213564213564213564213564213564213564E0)
(num-test (exact->inexact 47321/33461) 1.414213562057320462628134245838438779476E0)
(num-test (exact->inexact 114243/80782) 1.414213562427273402490653858532841474586E0)
(num-test (exact->inexact 275807/195025) 1.414213562363799512882963722599666709396E0)
(num-test (exact->inexact 1607521/1136689) 1.414213562372821413772808569450394962913E0)
(num-test (exact->inexact 3880899/2744210) 1.414213562373141997150363856993451667326E0)
(num-test (exact->inexact 9369319/6625109) 1.414213562373086993738518113437831739826E0)
(num-test (exact->inexact 54608393/38613965) 1.414213562373094811682768138418315757008E0)
(num-test (exact->inexact 131836323/93222358) 1.414213562373095089484863706193743779791E0)
(num-test (exact->inexact 318281039/225058681) 1.414213562373095041821559418096829599746E0)
(num-test (exact->inexact 1855077841/1311738121) 1.414213562373095048596212902163571413046E0)
(num-test (exact->inexact 4478554083/3166815962) 1.414213562373095048836942801793292211529E0)

(num-test (exact->inexact -1.797693134862315699999999999999999999998E308) -1.797693134862315699999999999999999999998E308)
(num-test (exact->inexact -2.225073858507201399999999999999999999996E-308) -2.225073858507201399999999999999999999996E-308)
(num-test (exact->inexact -9223372036854775808) -9.223372036854775808E18)
(num-test (exact->inexact 1.110223024625156799999999999999999999997E-16) 1.110223024625156799999999999999999999997E-16)
(num-test (exact->inexact 9223372036854775807) 9.223372036854775807E18)

(num-test (exact->inexact 9007199254740991) 9.007199254740991E15)
(test (= (exact->inexact 9007199254740992) (exact->inexact 9007199254740991)) #f)

(if with-bignums 
    (begin
      (num-test (truncate (exact->inexact most-positive-fixnum)) 9223372036854775807)
      (test (= (exact->inexact 9007199254740993) (exact->inexact 9007199254740992)) #f)
      (num-test (exact->inexact 73786976294838206464) (expt 2.0 66))
      (num-test (exact->inexact (bignum "0+1.5i")) 0+1.5i)
      (test (< (abs (- (expt 2 66.5) (exact->inexact 19459393535087060477929284/186481))) 1e-9) #t)
      (test (< (abs (- (exact->inexact -186198177976134811212136169603791619/103863) (- (expt 2 100.5)))) 1e-9) #t)
      ))

(test (exact->inexact "hi") 'error)
(test (exact->inexact 1.0+23.0i 1.0+23.0i) 'error)
(test (exact->inexact) 'error)

(for-each
 (lambda (arg)
   (test (exact->inexact arg) 'error))
 (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
       #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))
