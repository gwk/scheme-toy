(let ()
  (define (idf-test val1 val2)
    (test (cadr val1) (cadr val2))
    (test (caddr val1) (caddr val2))
    (test (< (abs (- (car val1) (car val2))) 1000) #t))

  (idf-test (integer-decode-float 0.0) '(0 0 1))
  (idf-test (integer-decode-float -0.0) '(0 0 1))
  (idf-test (integer-decode-float 1.0) '(4503599627370496 -52 1))
  (idf-test (integer-decode-float -1.0) '(4503599627370496 -52 -1))
  (idf-test (integer-decode-float 0.2) '(7205759403792794 -55 1))
  (idf-test (integer-decode-float -0.2) '(7205759403792794 -55 -1))
  (idf-test (integer-decode-float 3.0) '(6755399441055744 -51 1))
  (idf-test (integer-decode-float -3.0) '(6755399441055744 -51 -1))
  (idf-test (integer-decode-float 0.04) '(5764607523034235 -57 1))
  (idf-test (integer-decode-float -0.04) '(5764607523034235 -57 -1))
  (idf-test (integer-decode-float 50.0) '(7036874417766400 -47 1))
  (idf-test (integer-decode-float -50.0) '(7036874417766400 -47 -1))
  (idf-test (integer-decode-float 0.006) '(6917529027641082 -60 1))
  (idf-test (integer-decode-float -0.006) '(6917529027641082 -60 -1))
  (idf-test (integer-decode-float 7000.0) '(7696581394432000 -40 1))
  (idf-test (integer-decode-float -7000.0) '(7696581394432000 -40 -1))
  (idf-test (integer-decode-float 0.0008) '(7378697629483821 -63 1))
  (idf-test (integer-decode-float -0.0008) '(7378697629483821 -63 -1))
  (idf-test (integer-decode-float 90000.0) '(6184752906240000 -36 1))
  (idf-test (integer-decode-float -90000.0) '(6184752906240000 -36 -1))
  (idf-test (integer-decode-float 0.00001) '(5902958103587057 -69 1))
  (idf-test (integer-decode-float 1.0e-6) '(4722366482869645 -72 1))
  (idf-test (integer-decode-float 1.0e-8) '(6044629098073146 -79 1))
  (idf-test (integer-decode-float 1.0e-12) '(4951760157141521 -92 1))
  (idf-test (integer-decode-float 1.0e-16) '(8112963841460668 -106 1))
  (idf-test (integer-decode-float 1.0e-17) '(6490371073168535 -109 1))
  (idf-test (integer-decode-float 1.0e-18) '(5192296858534828 -112 1))
  (idf-test (integer-decode-float 1.0e-19) '(8307674973655724 -116 1))
  (idf-test (integer-decode-float 1.0e-25) '(8711228593176025 -136 1))
  (idf-test (integer-decode-float 1.0e6)  '(8589934592000000 -33 1))
  (idf-test (integer-decode-float 1.0e12) '(8192000000000000 -13 1))
  (idf-test (integer-decode-float 1.0e17) '(6250000000000000 4 1))
  (idf-test (integer-decode-float 1.0e18) '(7812500000000000 7 1))
  (idf-test (integer-decode-float 1.0e19) '(4882812500000000 11 1))
  (idf-test (integer-decode-float 1.0e20) '(6103515625000000 14 1))
  (idf-test (integer-decode-float 1.0e-100) '(7880401239278896 -385 1))
  (idf-test (integer-decode-float 1.0e100) '(5147557589468029 280 1))
  (idf-test (integer-decode-float 1.0e200) '(5883593420661338 612 1))
  (idf-test (integer-decode-float 1.0e-200) '(6894565328877484 -717 1))
  (idf-test (integer-decode-float 1.0e307) '(8016673440035891 967 1))
  )

(let ((val (integer-decode-float 1.0e-307)))
  (if (and (not (equal? val '(5060056332682765 -1072 1)))
	   (not (equal? val '(5060056332682766 -1072 1))))
      (format #t ";(integer-decode-float 1.0e-307) got ~A?~%" val)))

(test (integer-decode-float (/ 1.0e-307 100.0e0)) '(4706001880677807 -1075 1)) ; denormal
(test (integer-decode-float (/ (log 0.0))) '(6755399441055744 972 -1)) ; nan
(test (integer-decode-float (- (real-part (log 0.0)))) '(4503599627370496 972 1)) ; +inf
(test (integer-decode-float (real-part (log 0.0))) '(4503599627370496 972 -1)) ; -inf
(test (integer-decode-float 1.797e308) '(9003726357340310 971 1))
(test (integer-decode-float 1.0e-322) '(4503599627370516 -1075 1))
(test (integer-decode-float (expt 2.0 31)) (list #x10000000000000 -21 1))
(test (integer-decode-float (expt 2.0 52)) (list #x10000000000000 0 1))
(test (integer-decode-float 1e23) '(5960464477539062 24 1))

(if with-bignums
    (begin
      (test (integer-decode-float 2.225e-308) '(9007049763458157 -1075 1))
      (test (integer-decode-float (bignum "3.1")) (integer-decode-float 3.1))
      (test (integer-decode-float (bignum "1E430")) 'error)
      (test (integer-decode-float (bignum "1E310")) 'error)
      (test (integer-decode-float (bignum "-1E310")) 'error)
      ;(test (integer-decode-float (bignum "1/0")) 'error) -- see above: (6755399441055744 972 1)
      (test (integer-decode-float 0+92233720368547758081.0i) 'error)
      (test (integer-decode-float 92233720368547758081/123) 'error)
      )
    (begin
      (test (integer-decode-float 1/0) '(6755399441055744 972 1)) ; nan
      (test (integer-decode-float (real-part (log 0))) '(4503599627370496 972 -1)) ; -inf
      (test (integer-decode-float (- (real-part (log 0)))) '(4503599627370496 972 1)) ; inf
      (test (integer-decode-float (/ (real-part (log 0)) (real-part (log 0)))) '(6755399441055744 972 -1)) ; -nan
      (test (integer-decode-float (- (/ (real-part (log 0)) (real-part (log 0))))) '(6755399441055744 972 1)) ; nan
      ))


(do ((i 0 (+ i 1)))
    ((= i 100))
  (let ((val (- 1.0e6 (random 2.0e6))))
    (let* ((data (integer-decode-float val))
	   (signif (car data))
	   (expon (cadr data))
	   (sign (caddr data))) 
      (num-test (* sign signif (expt 2.0 expon)) val))))

(test (integer-decode-float) 'error)
(for-each
 (lambda (arg)
   (test (integer-decode-float arg) 'error))
 (list -1 0 #\a '#(1 2 3) 2/3 1.5+0.3i 1+i '() 'hi abs "hi" '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))
(test (integer-decode-float 1.0 1.0) 'error)
