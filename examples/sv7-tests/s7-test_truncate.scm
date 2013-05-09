(num-test (truncate (- (+ 1 -1/123400000))) 0)
(num-test (truncate (- 1 1/123400000)) 0)
(num-test (truncate (/ (- most-positive-fixnum 1) most-positive-fixnum)) 0)
(num-test (truncate (/ -1 most-positive-fixnum)) 0)
(num-test (truncate (/ 1 most-positive-fixnum)) 0)
(num-test (truncate (/ most-negative-fixnum most-positive-fixnum)) -1)
(num-test (truncate (/ most-positive-fixnum (- most-positive-fixnum 1))) 1)
(num-test (truncate -0) 0)
(num-test (truncate -0.0) 0)
(num-test (truncate -0.1) 0)
(num-test (truncate -0.9) 0)
(num-test (truncate -1) -1)
(num-test (truncate -1.1) -1)
(num-test (truncate -1.9) -1)
(num-test (truncate -1/10) 0)
(num-test (truncate -1/123400000) 0)
(num-test (truncate -1/2) 0)
(num-test (truncate -100/3) -33)
(num-test (truncate -11/10) -1)
(num-test (truncate -17/2) -8)
(num-test (truncate -19/10) -1)
(num-test (truncate -2.225073858507201399999999999999999999996E-308) 0)
(num-test (truncate -2/3) 0)
(num-test (truncate -200/3) -66)
(num-test (truncate -3/2) -1)
(num-test (truncate -9/10) 0)
(num-test (truncate -9223372036854775808) -9223372036854775808)
(num-test (truncate 0) 0)
(num-test (truncate 0.0) 0)
(num-test (truncate 0.1) 0)
(num-test (truncate 0.9) 0)
(num-test (truncate 1) 1)
(num-test (truncate 1.1) 1)
(num-test (truncate 1.110223024625156799999999999999999999997E-16) 0)
(num-test (truncate 1.9) 1)
(num-test (truncate 1/10) 0)
(num-test (truncate 1/123400000) 0)
(num-test (truncate 1/2) 0)
(num-test (truncate 100/3) 33)
(num-test (truncate 11/10) 1)
(num-test (truncate 17.3) 17)
(num-test (truncate 19) 19)
(num-test (truncate 19/10) 1)
(num-test (truncate 2.4) 2)
(num-test (truncate 2.5) 2)
(num-test (truncate 2.6) 2)
(num-test (truncate 2/3) 0)
(num-test (truncate 200/3) 66)
(num-test (truncate 3/2) 1)
(num-test (truncate 9/10) 0)
(num-test (truncate 9223372036854775807) 9223372036854775807)
(num-test (truncate most-negative-fixnum) most-negative-fixnum)
(num-test (truncate most-positive-fixnum) most-positive-fixnum)
(num-test (truncate 1+0i) 1)

(if with-bignums
    (begin
      (num-test (truncate 8388608.9999999995) 8388608)
      (num-test (truncate -8388609.0000000005) -8388609)
      (num-test (truncate -8388609.9999999995) -8388609)))

(test (= (truncate (* 111738283365989051/177100989030047175 1.0)) (truncate 130441933147714940/206745572560704147)) #t)
(test (= (truncate (* 114243/80782 114243/80782 1.0)) (truncate (* 275807/195025 275807/195025))) #f)
(test (= (truncate (* 131836323/93222358 131836323/93222358 1.0)) (truncate (* 318281039/225058681 318281039/225058681))) #f)
(test (= (truncate (* 1393/985 1393/985 1.0)) (truncate (* 3363/2378 3363/2378))) #f)
(test (= (truncate (* 1607521/1136689 1607521/1136689 1.0)) (truncate (* 3880899/2744210 3880899/2744210))) #f)
(if with-bignums (test (= (truncate (* 1855077841/1311738121 1855077841/1311738121 1.0)) (truncate (* 4478554083/3166815962 4478554083/3166815962))) #f))
(test (= (truncate (* 19601/13860 19601/13860 1.0)) (truncate (* 47321/33461 47321/33461))) #f)
(test (= (truncate (* 275807/195025 275807/195025 1.0)) (truncate (* 1607521/1136689 1607521/1136689))) #t)
(if with-bignums (test (= (truncate (* 318281039/225058681 318281039/225058681 1.0)) (truncate (* 1855077841/1311738121 1855077841/1311738121))) #t))
(test (= (truncate (* 3363/2378 3363/2378 1.0)) (truncate (* 19601/13860 19601/13860))) #t)
(test (= (truncate (* 3880899/2744210 3880899/2744210 1.0)) (truncate (* 9369319/6625109 9369319/6625109))) #f)
(test (= (truncate (* 47321/33461 47321/33461 1.0)) (truncate (* 114243/80782 114243/80782))) #f)
(test (= (truncate (* 54608393/38613965 54608393/38613965 1.0)) (truncate (* 131836323/93222358 131836323/93222358))) #f)
(test (= (truncate (* 9369319/6625109 9369319/6625109 1.0)) (truncate (* 54608393/38613965 54608393/38613965))) #t)

(if with-bignums
    (begin
      (num-test (truncate (+ (expt 2.0 62) 512)) 4611686018427388416)
      (num-test (truncate (+ (expt 2.0 62) 513)) 4611686018427388417)
      (num-test (truncate (exact->inexact most-negative-fixnum)) most-negative-fixnum)
      (test (truncate (exact->inexact most-positive-fixnum)) most-positive-fixnum)

      (num-test (truncate 1e19) 10000000000000000000)
      (num-test (truncate 1e32) 100000000000000000000000000000000)
      (num-test (truncate -1e19) -10000000000000000000)
      (num-test (truncate -1e32) -100000000000000000000000000000000)
      (num-test (truncate 100000000000000000000000000000000/3) 33333333333333333333333333333333)
      (num-test (truncate -100000000000000000000000000000000/3) -33333333333333333333333333333333)
      (num-test (truncate 200000000000000000000000000000000/3) 66666666666666666666666666666666)
      (num-test (truncate -200000000000000000000000000000000/3) -66666666666666666666666666666666)

      (let ((old-prec (bignum-precision)))
	(set! (bignum-precision) 512)

      (test (= (truncate (* 111760107268250945908601/79026329715516201199301 111760107268250945908601/79026329715516201199301 1.0)) 
	       (truncate (* 269812766699283348307203/190786436983767147107902 269812766699283348307203/190786436983767147107902))) #f)
      (test (= (truncate (* 1180872205318713601/835002744095575440 1180872205318713601/835002744095575440 1.0)) 
	       (truncate (* 2850877693509864481/2015874949414289041 2850877693509864481/2015874949414289041))) #f)
      (test (= (truncate (* 1362725501650887306817/963592443113182178088 1362725501650887306817/963592443113182178088 1.0)) 
	       (truncate (* 3289910387877251662993/2326317944764069484905 3289910387877251662993/2326317944764069484905))) #f)
      (test (= (truncate (* 14398739476117879/10181446324101389 14398739476117879/10181446324101389 1.0)) 
	       (truncate (* 34761632124320657/24580185800219268 34761632124320657/24580185800219268))) #f)
      (test (= (truncate (* 1572584048032918633353217/1111984844349868137938112 1572584048032918633353217/1111984844349868137938112 1.0)) 
	       (truncate (* 3796553736732654909229441/2684568892382786771291329 3796553736732654909229441/2684568892382786771291329))) #f)
      (test (= (truncate (* 16616132878186749607/11749380235262596085 16616132878186749607/11749380235262596085 1.0)) 
	       (truncate (* 40114893348711941777/28365513113449345692 40114893348711941777/28365513113449345692))) #f)
      (test (= (truncate (* 19175002942688032928599/13558774610046711780701 19175002942688032928599/13558774610046711780701 1.0)) 
	       (truncate (* 46292552162781456490001/32733777552734744709300 46292552162781456490001/32733777552734744709300))) #f)
      (test (= (truncate (* 202605639573839043/143263821649299118 202605639573839043/143263821649299118 1.0)) 
	       (truncate (* 489133282872437279/345869461223138161 489133282872437279/345869461223138161))) #f)
      (test (= (truncate (* 269812766699283348307203/190786436983767147107902 269812766699283348307203/190786436983767147107902 1.0)) 
	       (truncate (* 1572584048032918633353217/1111984844349868137938112 1572584048032918633353217/1111984844349868137938112))) #t)
      (test (= (truncate (* 2850877693509864481/2015874949414289041 2850877693509864481/2015874949414289041 1.0)) 
	       (truncate (* 16616132878186749607/11749380235262596085 16616132878186749607/11749380235262596085))) #t)
      (test (= (truncate (* 3289910387877251662993/2326317944764069484905 3289910387877251662993/2326317944764069484905 1.0)) 
	       (truncate (* 19175002942688032928599/13558774610046711780701 19175002942688032928599/13558774610046711780701))) #t)
      (test (= (truncate (* 34761632124320657/24580185800219268 34761632124320657/24580185800219268 1.0)) 
	       (truncate (* 202605639573839043/143263821649299118 202605639573839043/143263821649299118))) #t)
      (test (= (truncate (* 46292552162781456490001/32733777552734744709300 46292552162781456490001/32733777552734744709300 1.0)) 
	       (truncate (* 111760107268250945908601/79026329715516201199301 111760107268250945908601/79026329715516201199301))) #f)
      (test (= (truncate (* 489133282872437279/345869461223138161 489133282872437279/345869461223138161 1.0)) 
	       (truncate (* 1180872205318713601/835002744095575440 1180872205318713601/835002744095575440))) #f)
      (test (= (truncate (* 564459384575477049359/399133058537705128729 564459384575477049359/399133058537705128729 1.0)) 
	       (truncate (* 1362725501650887306817/963592443113182178088 1362725501650887306817/963592443113182178088))) #f)
      (test (= (truncate (* 5964153172084899/4217293152016490 5964153172084899/4217293152016490 1.0)) 
	       (truncate (* 14398739476117879/10181446324101389 14398739476117879/10181446324101389))) #f)

      (set! (bignum-precision) old-prec))
      ))

(test (truncate) 'error)
(test (truncate 1.23+1.0i) 'error)

(for-each
 (lambda (arg)
   (test (truncate arg) 'error))
  (list "hi" '() (integer->char 65) #f #t '(1 2) _ht_ 'a-symbol (cons 1 2) (make-vector 3) abs 
        #<eof> '(1 2 3) #\newline (lambda (a) (+ a 1)) #<unspecified> #<undefined>))
