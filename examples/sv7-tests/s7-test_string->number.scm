(test (string->number "+#.#") #f)
(test (string->number "-#.#") #f)
(test (string->number "#.#") #f)
(test (string->number "#i") #f)
(test (string->number "#e") #f)
(test (string->number "#") #f)

(for-each
 (lambda (n)
   (if (not (eqv? n (string->number (number->string n))))
       (format #t ";(string->number (number->string ~A)) = ~A?~%" n (string->number (number->string n)))))
 (list 1 2 3 10 1234 1234000000 500029 362880 0/1 0/2 0/3 0/10 0/1234 0/1234000000 0/500029 
       0/362880 1/1 1/2 1/3 1/10 1/1234 1/1234000000 1/500029 1/362880 2/1 2/2 2/3 2/10 2/1234 
       2/1234000000 2/500029 2/362880 3/1 3/2 3/3 3/10 3/1234 3/1234000000 3/500029 3/362880 
       10/1 10/2 10/3 10/10 10/1234 10/1234000000 10/500029 10/362880 1234/1 1234/2 1234/3 
       1234/10 1234/1234 1234/1234000000 1234/500029 1234/362880 1234000000/1 1234000000/2 1234000000/3 
       1234000000/10 1234000000/1234 1234000000/1234000000 1234000000/500029 1234000000/362880 
       500029/1 500029/2 500029/3 500029/10 500029/1234 500029/1234000000 500029/500029 500029/362880 
       362880/1 362880/2 362880/3 362880/10 362880/1234 362880/1234000000 362880/500029 362880/362880))

(let ((fequal? (lambda (a b) (< (magnitude (- a b)) 1e-14))))
  (for-each
   (lambda (x)
     (if (not (fequal? x (string->number (number->string x))))
	 (format #t ";(string->number (number->string ~A)) -> ~A?~%" x (string->number (number->string x)))))
   (list 0.000000 1.000000 3.141593 2.718282 1234.000000 1234000000.000000 0.000000+0.000000i 0.000000+0.000000i 0.000000+1.000000i 
	 0.000000+3.141593i 0.000000+2.718282i 0.000000+1234.000000i 0.000000+1234000000.000000i 0.000000+0.000000i 0.000000+0.000000i 
	 0.000000+1.000000i 0.000000+3.141593i 0.000000+2.718282i 0.000000+1234.000000i 0.000000+1234000000.000000i 1.000000+0.000000i 
	 1.000000+0.000000i 1.000000+1.000000i 1.000000+3.141593i 1.000000+2.718282i 1.000000+1234.000000i 1.000000+1234000000.000000i 
	 3.141593+0.000000i 3.141593+0.000000i 3.141593+1.000000i 3.141593+3.141593i 3.141593+2.718282i 3.141593+1234.000000i 
	 3.141593+1234000000.000000i 2.718282+0.000000i 2.718282+0.000000i 2.718282+1.000000i 2.718282+3.141593i 2.718282+2.718282i 
	 2.718282+1234.000000i 2.718282+1234000000.000000i 1234.000000+0.000000i 1234.000000+0.000000i 1234.000000+1.000000i 
	 1234.000000+3.141593i 1234.000000+2.718282i 1234.000000+1234.000000i 1234.000000+1234000000.000000i 1234000000.000000+0.000000i 
	 1234000000.000000+0.000000i 1234000000.000000+1.000000i 1234000000.000000+3.141593i 1234000000.000000+2.718282i 1234000000.000000+1234.000000i 
	 1234000000.000000+1234000000.000000i)))

(test (string->number "1+1+i") #f)
(test (string->number "1+i+i") #f)
(test (string->number "1+.i") #f)
(test (string->number ".") #f)
(test (string->number "8.41470984807896506652502321630298999622563060798371065672751709991910404391239668948639743543052695.") #f)
(test (string->number "8.41470184807816506652502321630218111622563060718371065672751701111110404311231668148631743543052695" 9) #f)
(test (number->string -9223372036854775808) "-9223372036854775808")
(test (number->string 9223372036854775807) "9223372036854775807")

(test (number->string 123 8) "173")
(test (number->string 123 16) "7b")
(test (number->string 123 2) "1111011")
(test (number->string -123 8) "-173")
(test (number->string -123 16) "-7b")
(test (number->string -123 2) "-1111011")

(test (number->string 0 8) "0")
(test (number->string 0 2) "0")
(test (number->string 0 16) "0")
(test (number->string 1 8) "1")
(test (number->string 1 2) "1")
(test (number->string 1 16) "1")
(test (number->string -1 8) "-1")
(test (number->string -1 2) "-1")
(test (number->string -1 16) "-1")
(test (string->number "- 1") #f)
(num-test (string->number "1+0i") 1.0)
(num-test (string->number "0-0i") 0.0)
(num-test (string->number "0-0e10i") 0.0)
(num-test (string->number "0-0e40i") 0.0)
(num-test (string->number "0-0e100i") 0.0)
(test (string->number "0e10e100") #f)

;;; @ exponent added 26-Mar-12
(if (provided? '@-exponent)
    (begin
      (num-test 0.0 0@0)
      (num-test 0.0 0@-0)
      (num-test 0.0 0@+0)
      (num-test 1.0 1@0)
      (num-test 10.0 1@1)
      (num-test 10.0 1@+1)
      (num-test 0.1 1@-1)

      (num-test (string->number "1@0" 16) 1.0)
      (num-test (string->number "e@0" 16) 14.0)
      (num-test (string->number "a@1" 16) 160.0)
      (num-test (string->number "#xa@1") 160.0)
      (num-test (string->number ".a@0" 12) 0.83333333333333)
      (num-test (string->number "a.@0" 16) 10.0)
      (num-test (string->number "0a" 16) 10)
      (num-test (string->number "#e0a" 16) 10)
      (num-test (string->number "a@-1" 16) 0.625)

      (num-test 1@0+1@0i 1+1i)
      (num-test (string->number "1@1" 12) 12.0)
      (num-test (string->number "1@-1" 16) 0.0625)
      (num-test (string->number "1.0@1+0.1@2i" 16) 16+16i)
      (num-test (string->number "#b.0@2") 0.0)
      (num-test (string->number ".2@-22") 2e-23)
      (num-test (string->number "+02@02") 200.0)
      (num-test (string->number "2fe2@2" 16) 3138048.0)
      (num-test (string->number "#i1@01" 16) 16.0)
      (num-test (string->number "1@-0-bc/di" 16) 1-14.461538461538i)
      (num-test (string->number ".f-a.c1@0i" 16) 0.9375-10.75390625i)
      (num-test (string->number "df2@2-ccfi" 16) 913920-3279i)
      (num-test (string->number "0/0de-0@2i" 16) 0.0)
      (num-test (string->number "-1a12cd.@1" 16) -27339984.0)
      (num-test (string->number "fb/2ea+2@+1i" 16) 0.33646112600536+32i)
      (num-test (string->number "af.e0@-0+0b/efefd11i" 16) 175.875+4.3721589140015e-08i)
      (num-test (string->number "bb10@1-i" 12) 247248-1i)
      (num-test (string->number "b.+0@01i" 12) 11.0)
      (num-test (string->number "-0@-0221" 12) 0.0)
      (num-test (string->number "-a-01@2i" 12) -10-144i)
      (num-test (string->number "#d.0@-11" 10) 0.0)
      (num-test (string->number "#i+1@002" 10) 100.0)
      (num-test (string->number "-111@-1-1i" 10) -11.1-1i)
      (num-test (string->number "122@9-2@0i" 10) 122000000000-2i)
      (num-test (string->number "-0@+10-20i" 10) 0-20i)
      (num-test (string->number "+2@-909221" 10) 0.0)
      ))

;; s7.html claims this '=' is guaranteed...
(test (= .6 (string->number ".6")) #t)
(test (= 0.60 (string->number "0.60")) #t)
(test (= 60e-2 (string->number "60e-2")) #t)
(test (= #i3/5 (string->number "#i3/5")) #t)
(test (= 0.11 (string->number "0.11")) #t)
(test (= 0.999 (string->number "0.999")) #t)
(test (= 100.000 (string->number "100.000")) #t)
(test (= 1e10 (string->number "1e10")) #t)
(test (= 0.18 (string->number "0.18")) #t)
(test (= 0.3 (string->number "0.3")) #t)
(test (= 0.333 (string->number "0.333")) #t)
(test (= -1/10 (string->number "-1/10")) #t)
(test (= -110 (string->number "-110")) #t)
(test (= 1+i (string->number "1+i")) #t)
(test (= 0.6-.1i (string->number "0.6-.1i")) #t)

;; but is this case also guaranteed??
(test (= .6 (string->number (number->string .6))) #t)
(test (= 0.6 (string->number (number->string 0.6))) #t)
(test (= 0.60 (string->number (number->string 0.60))) #t)
(test (= 60e-2 (string->number (number->string 60e-2))) #t)
;(test (= #i3/5 (string->number (number->string #i3/5))) #t)
(test (= 0.11 (string->number (number->string 0.11))) #t)
(test (= 0.999 (string->number (number->string 0.999))) #t)
(test (= 100.000 (string->number (number->string 100.000))) #t)
(test (= 1e10 (string->number (number->string 1e10))) #t)
(test (= 0.18 (string->number (number->string 0.18))) #t)
(test (= 0.3 (string->number (number->string 0.3))) #t)
(test (= 0.333 (string->number (number->string 0.333))) #t)
(test (= -1/10 (string->number (number->string -1/10))) #t)
(test (= -110 (string->number (number->string -110))) #t)
(test (= 1+i (string->number (number->string 1+i))) #t)
(test (= 0.6-.1i (string->number (number->string 0.6-.1i))) #t)

(test (= 0.6 0.600) #t)
(test (= 0.6 6e-1 60e-2 .06e1 6.e-1) #t)
(test (= 0.6 6e-1 60e-2 .06e1 600e-3 6000e-4 .0006e3) #t)
(test (= 0.3 0.3000) #t)
(test (= 0.345 0.345000 345.0e-3) #t)

#|
;; scheme spec says (eqv? (number->string (string->number num radix) radix) num) is always #t
;;   (also that radix is 10 if num is inexact)
;; currently in s7, if m below is 0, s7 is ok, but if there's a true integer part, we sometimes lose by 1e-15 or so
(let ()
  (do ((m 0 (+ m 1)))
      ((= m 10))
    (do ((i 0 (+ i 1)))
	((= i 10))
      (do ((j 0 (+ j 1)))
	  ((= j 10))
	(do ((k 0 (+ k 1)))
	    ((= k 10))
	  (let* ((str (string (integer->char (+ (char->integer #\0) i))
			      (integer->char (+ (char->integer #\0) j))
			      (integer->char (+ (char->integer #\0) k))))
		 (strd (string (integer->char (+ (char->integer #\0) m))))
		 (str1 (string-append strd "." str))
		 (str2 (string-append (if (= m 0) "" strd) "." str "000"))
		 (str3 (string-append strd str "e-3"))
		 (str4 (string-append strd str ".e-3"))
		 (str5 (string-append "0.0" strd str "e2"))
		 (str6 (string-append ".00000" strd str "e6"))
		 (str7 (string-append strd str "00e-5"))
		 (args (list (string->number str1)
			     (string->number str2)
			     (string->number str3)
			     (string->number str4)
			     (string->number str5)
			     (string->number str6)
			     (string->number str7))))
	    (if (not (apply = args))
		(format #t "~A.~A: ~{~D~^~4T~}~%" strd str
			(map (lambda (val)
			       (let ((ctr 0))
				 (for-each
				  (lambda (arg)
				    (if (not (equal? val arg))
					(set! ctr (+ ctr 1))))
				  args)
				 ctr))
			     args)))))))))
|#

(test (number->string 1/0) "nan.0")
(test (number->string 1/0 2) "nan.0")
(test (number->string 1/0 10) "nan.0")
(test (number->string 1/0 16) "nan.0")
(test (number->string 1000000000000000000000000000000000/0) "nan.0")
(test (number->string 0/1000000000000000000000000000000000) "0")
(test (object->string 1/0) "nan.0")
(test (format #f "~F" 1/0) "nan.0")
(test (format #f "~E" 1/0) "nan.0")
(test (format #f "~G" 1/0) "nan.0")
(test (format #f "~D" 1/0) "nan.0")
(test (format #f "~X" 1/0) "nan.0")
(test (format #f "~B" 1/0) "nan.0")
(test (format #f "~O" 1/0) "nan.0")
(test (format #f "~A" 1/0) "nan.0")
(test (format #f "~S" 1/0) "nan.0")
(test (format #f "~P" 1/0) "s")
(test (nan? (string->number "nan.0")) #t)
(test (nan? (string->number "nan.0" 2)) #t)

(test (number->string (real-part (log 0.0))) "-inf.0")
(test (number->string (real-part (log 0.0)) 2) "-inf.0")
(test (number->string (real-part (log 0.0)) 16) "-inf.0")
(test (number->string (- (real-part (log 0.0)))) "inf.0")
(test (number->string (- (real-part (log 0.0))) 2) "inf.0")
(test (format #f "~G" (real-part (log 0))) "-inf.0")
(test (format #f "~E" (real-part (log 0))) "-inf.0")
(test (format #f "~F" (real-part (log 0))) "-inf.0")
(test (format #f "~D" (real-part (log 0))) "-inf.0")
(test (format #f "~X" (real-part (log 0))) "-inf.0")
(test (format #f "~B" (real-part (log 0))) "-inf.0")
(test (format #f "~O" (real-part (log 0))) "-inf.0")
(test (format #f "~A" (real-part (log 0))) "-inf.0")
(test (format #f "~S" (real-part (log 0))) "-inf.0")
(test (format #f "~P" (real-part (log 0))) "s")
(test (infinite? (string->number "inf.0")) #t)
(test (infinite? (string->number "inf.0" 16)) #t)
(test (infinite? (string->number "-inf.0")) #t)
(test (infinite? (string->number "-inf.0" 16)) #t)
(test (negative? (string->number "-inf.0")) #t)

;(test (number->string 0+0/0i 2) "0-nani") ; there are too many possible correct choices

(test (equal? 0.0 0e0) #t)
(test (equal? 0.0 -0.0) #t)
(test (eqv? 0.0 -0.0) #t)
(test (equal? 0.0 0e-0) #t)
(test (equal? 0.0 .0e+0) #t)
(test (equal? 0.0 00000000000000000000000000000000000000000000000000000e100) #t)
(test (equal? 0.0 .0000000000000000000000000000000000000000000000000000e100) #t)
(test (equal? 0.0 00000000000000000000000000000000000000000000000000000.0000000000000000000000000000000000000000000000000000000000e100) #t)
(test (equal? 0.0 0e100000000000000000000000000000000000000000000000000000000000000000000000) #t)

(num-test 0 0/1000000000)
(num-test 0 0/100000000000000000000000000000000000000)
(num-test 0 0/100000000000000000000000000000000000000000000000000000000000000)
(num-test 0 0/100000000000000000000000000000000000000000000000000000000000000000000)
(num-test 0 -0/100000000000000000000000000000000000000000000000000000000000000000000)

(num-test 0 0/1000000000+0/1000000000i)
(num-test 0 0/100000000000000000000000000000000000000-0/100000000000000000000000000000000000000i)
(num-test 0 0/100000000000000000000000000000000000000000000000000000000000000+0/100000000000000000000000000000000000000000000000000000000000000i)
(num-test 0 0/100000000000000000000000000000000000000000000000000000000000000000000-0/100000000000000000000000000000000000000000000000000000000000000000000i)

(num-test 0 0+0/1000000000i)
(num-test 0 0-0/100000000000000000000000000000000000000i)
(num-test 0 0+0/100000000000000000000000000000000000000000000000000000000000000i)
(num-test 0 0-0/100000000000000000000000000000000000000000000000000000000000000000000i)

(num-test 0 0/1000000000+0i)
(num-test 0 0/100000000000000000000000000000000000000-0i)
(num-test 0 0/100000000000000000000000000000000000000000000000000000000000000+0i)
(num-test 0 0/100000000000000000000000000000000000000000000000000000000000000000000-0i)

(test (< 0 1000000000000000000000000000000000) #t)
(test (> 0 -1000000000000000000000000000000000) #t)

#|
;;; are these worth fixing?
:(* 0 1000000000000000000000000000000000)
nan.0
:(* 0.0 1000000000000000000000000000000000)
nan.0
:(integer? 1000000000000000000000000000000000)
#f
:(positive? 1/1000000000000000000000000000000000)
#f
:(exact? 1/1000000000000000000000000000000000)
#f
:(floor  1/1000000000000000000000000000000000)
;floor argument 1, nan.0, is out of range (argument is NaN)
etc....

10000000000000000000000000000/10000000000000000000000000000 
|#

(test (equal? 0.0 0.0e10) #t)
(test (equal? 0.0 0e100) #t)
(test (equal? 0.0 0.0e1000) #t)
(test (equal? 0.0 0e+1000) #t)
(test (equal? 0.0 0.0e-1) #t)
(test (equal? 0.0 0e-10) #t)
(test (equal? 0.0 0.0e-100) #t)
(test (equal? 0.0 0e-1000) #t)
(test (equal? 0.0 0.0e0123456789) #t)

(test (equal? 0.0 0-0e10i) #t)
(test (equal? 0.0 0-0.0e100i) #t)
(test (equal? 0.0 0-0e1000i) #t)
(test (equal? 0.0 0-0.0e+1000i) #t)
(test (equal? 0.0 0-0e-1i) #t)
(test (equal? 0.0 0-0.0e-10i) #t)
(test (equal? 0.0 0-0e-100i) #t)
(test (equal? 0.0 0-0.0e-1000i) #t)
(test (equal? 0.0 0.0+0e0123456789i) #t)
(num-test 0.0 1e-1000)

(num-test 0e123412341231231231231231231231231231 0.0)
(num-test 0e-123412341231231231231231231231231231 0.0)
(num-test 0.00000e123412341231231231231231231231231231 0.0)
(num-test .0e-123412341231231231231231231231231231 0.0)
(num-test 2e-123412341231231231231 0.0)
(num-test 2e-123412341231231231231231231231231231 0.0)
(num-test 2.001234e-123412341231231231231 0.0)
(num-test .00122e-123412341231231231231231231231231231 0.0)
(num-test 2e00000000000000000000000000000000000000001 20.0)
(num-test 2e+00000000000000000000000000000000000000001 20.0)
(num-test 2e-00000000000000000000000000000000000000001 0.2)
(num-test 2e-9223372036854775807 0.0)
(num-test 2000.000e-9223372036854775807 0.0)

(if (not with-bignums)
    (begin
      (test (infinite? 2e123412341231231231231) #t)
      (test (infinite? 2e12341234123123123123123123) #t)
      (test (infinite? 2e12341234123123123123213123123123) #t)
      (test (infinite? 2e9223372036854775807) #t)
      ))
      
(if (provided? 'dfls-exponents)
    (begin
      (test (> 1.0L10 1.0e9) #t)
      (test (> 1.0l10 1.0e9) #t)
      (test (> 1.0s10 1.0e9) #t)
      (test (> 1.0S10 1.0e9) #t)
      (test (> 1.0d10 1.0e9) #t)
      (test (> 1.0D10 1.0e9) #t)
      (test (> 1.0f10 1.0e9) #t)
      (test (> 1.0F10 1.0e9) #t)
      
      (test (> (real-part 1.0L10+i) 1.0e9) #t)
      (test (> (real-part 1.0l10+i) 1.0e9) #t)
      (test (> (real-part 1.0s10+i) 1.0e9) #t)
      (test (> (real-part 1.0S10+i) 1.0e9) #t)
      (test (> (real-part 1.0d10+i) 1.0e9) #t)
      (test (> (real-part 1.0D10+i) 1.0e9) #t)
      (test (> (real-part 1.0f10+i) 1.0e9) #t)
      (test (> (real-part 1.0F10+i) 1.0e9) #t)
      
      (test (> (imag-part 1.0+1.0L10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0l10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0s10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0S10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0d10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0D10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0f10i) 1.0e9) #t)
      (test (> (imag-part 1.0+1.0F10i) 1.0e9) #t)
      
      (test (> (string->number "1.0L10") 1.0e9) #t)
      (test (> (string->number "1.0l10") 1.0e9) #t)
      (test (> (string->number "1.0s10") 1.0e9) #t)
      (test (> (string->number "1.0S10") 1.0e9) #t)
      (test (> (string->number "1.0d10") 1.0e9) #t)
      (test (> (string->number "1.0D10") 1.0e9) #t)
      (test (> (string->number "1.0f10") 1.0e9) #t)
      (test (> (string->number "1.0F10") 1.0e9) #t)
      
      (test (> (real-part (string->number "1.0L10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0l10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0s10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0S10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0d10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0D10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0f10+i")) 1.0e9) #t)
      (test (> (real-part (string->number "1.0F10+i")) 1.0e9) #t)
      
      (test (> (imag-part (string->number "1.0+1.0L10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0l10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0s10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0S10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0d10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0D10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0f10i")) 1.0e9) #t)
      (test (> (imag-part (string->number "1.0+1.0F10i")) 1.0e9) #t)

      (if with-bignums
	  (begin
	    (test (> (string->number "1.0L100") 1.0e98) #t)
	    (test (> (string->number "1.0l100") 1.0e98) #t)
	    (test (> (string->number "1.0s100") 1.0e98) #t)
	    (test (> (string->number "1.0S100") 1.0e98) #t)
	    (test (> (string->number "1.0d100") 1.0e98) #t)
	    (test (> (string->number "1.0D100") 1.0e98) #t)
	    (test (> (string->number "1.0f100") 1.0e98) #t)
	    (test (> (string->number "1.0F100") 1.0e98) #t)
	    (test (> (string->number "1.0E100") 1.0e98) #t)
	    
	    (test (> 1.0L100 1.0e98) #t)
	    (test (> 1.0l100 1.0e98) #t)
	    (test (> 1.0s100 1.0e98) #t)
	    (test (> 1.0S100 1.0e98) #t)
	    (test (> 1.0d100 1.0e98) #t)
	    (test (> 1.0D100 1.0e98) #t)
	    (test (> 1.0f100 1.0e98) #t)
	    (test (> 1.0F100 1.0e98) #t)
	    
	    (test (> (real-part (string->number "1.0L100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0l100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0s100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0S100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0d100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0D100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0f100+i")) 1.0e98) #t)
	    (test (> (real-part (string->number "1.0F100+i")) 1.0e98) #t)
	    
	    (test (> (real-part 1.0L100+i) 1.0e98) #t)
	    (test (> (real-part 1.0l100+i) 1.0e98) #t)
	    (test (> (real-part 1.0s100+i) 1.0e98) #t)
	    (test (> (real-part 1.0S100+i) 1.0e98) #t)
	    (test (> (real-part 1.0d100+i) 1.0e98) #t)
	    (test (> (real-part 1.0D100+i) 1.0e98) #t)
	    (test (> (real-part 1.0f100+i) 1.0e98) #t)
	    (test (> (real-part 1.0F100+i) 1.0e98) #t)
	    
	    (test (> (imag-part (string->number "1.0+1.0L100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0l100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0s100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0S100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0d100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0D100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0f100i")) 1.0e98) #t)
	    (test (> (imag-part (string->number "1.0+1.0F100i")) 1.0e98) #t)
	    
	    (test (> (imag-part 1.0+1.0L100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0l100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0s100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0S100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0d100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0D100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0f100i) 1.0e98) #t)
	    (test (> (imag-part 1.0+1.0F100i) 1.0e98) #t)
	    ))))

(if with-bignums
    (begin
      (test (number? (string->number "#e1.0e564")) #t)
      (test (number? (string->number "#e1.0e307")) #t)
      (test (number? (string->number "#e1.0e310")) #t)
      (num-test (string->number "#e1624540914719833702142058941") 1624540914719833702142058941)
      (num-test (string->number "#i1624540914719833702142058941") 1.624540914719833702142058941E27)
      (num-test (string->number "#e8978167593632120808315265/5504938256213345873657899") 8978167593632120808315265/5504938256213345873657899)
      (num-test (string->number "#i8978167593632120808315265/5504938256213345873657899") 1.630929753571457437099527114342760854299E0)
      (num-test (string->number "#i119601499942330812329233874099/12967220607") 9.223372036854775808414213562473095048798E18)
      ;; this next test needs more bits to compare with other schemes -- this is the result if 128 bits
      (num-test (string->number "#e005925563891587147521650777143.74135805596e05") 826023606487248364518118333837545313/1394)
      (num-test (string->number "#e-1559696614.857e28") -15596966148570000000000000000000000000)
      (test (integer? (string->number "#e1e310")) #t)
      (test (number? (string->number "#e1.0e310")) #t)
      ))
;; in the non-gmp case #e1e321 is a read error -- should s7 return NaN silently?

(if (not with-bignums)
    (begin
      (test (string->number "#e1e307") #f)
      (test (eval-string "(number? #e1.0e564)") 'error)
      (test (string->number "#e005925563891587147521650777143.74135805596e05") #f)
      (test (string->number "#e78.5e65") #f)
      (test (string->number "#e1e543") #f)
      (test (string->number "#e120d21") #f)
      (test (string->number "#e-2.2e021") #f)
      (if (provided? '@-exponent)
	  (test (infinite? (string->number "9221.@9129" 10)) #t))
      (test (string->number "#e120@21" 12) #f)
      (test (string->number "#d#e120@21") #f)
      (test (string->number "#b#e120@21") #f)
      (test (string->number "#e#b120@21") #f)
      (test (string->number "#e#d120@21") #f)
      (test (nan? (string->number "0f0/00" 16)) #t)
      (test (string->number "#e-1559696614.857e28") #f)))

(test (string->number "#e1+1i") #f)
(test (= 0 00 -000 #e-0 0/1 #e#x0 #b0000 #e#d0.0 -0 +0) #t)

;;  (do ((i 0 (+ i 1)) (n 1 (* n 2))) ((= i 63)) (display n) (display " ") (display (number->string n 16)) (newline))

(test (number->string 3/4 2) "11/100")
(test (number->string 3/4 8) "3/4")
(test (number->string 3/4 16) "3/4")
(test (number->string -3/4 2) "-11/100")
(test (number->string -3/4 8) "-3/4")
(test (number->string -3/4 16) "-3/4")

(num-test (string->number "1/2") 1/2)
(test (nan? (string->number "1/0")) #t)
(test (nan? (string->number "0/0")) #t)
(test (nan? 0/0) #t)
(test (string->number "1.0/0.0") #f)
(test (string->number "'1") #f)
(test (string->number "`1") #f)
(num-test (string->number "10111/100010" 2) 23/34) 
(num-test (string->number "27/42" 8) 23/34) 
(num-test (string->number "17/22" 16) 23/34) 
(num-test (string->number "-10111/100010" 2) -23/34) 
(num-test (string->number "-27/42" 8) -23/34) 
(num-test (string->number "-17/22" 16) -23/34) 
(num-test (string->number "11/100" 2) 3/4)

(test (number->string 23/34 2) "10111/100010")
(test (number->string 23/34 8) "27/42")
(test (number->string 23/34 16) "17/22")
(test (number->string -23/34 2) "-10111/100010")
(test (number->string -23/34 8) "-27/42")
(test (number->string -23/34 16) "-17/22")
(test (number->string -1 16) "-1")
;(test (number->string #xffffffffffffffff 16) "-1") -- is this a bug?  it's correct in 64-bit land

(num-test (string->number "3/4+1/2i") 0.75+0.5i)
(num-test (string->number "3/4+i") 0.75+i)
(num-test (string->number "0+1/2i") 0+0.5i)
(test (string->number "3+0i/4") #f)
(num-test (string->number "3/4+0i") 0.75)

(test (string->number " 1.0") #f)
(test (string->number "1.0 ") #f)
(test (string->number "1.0 1.0") #f)
;(test (string->number (string #\1 (integer->char 0) #\0)) 1) ; ?? Guile returns #f
(test (string->number "1+1 i") #f)
(test (string->number "1+ei") #f)
(test (string->number " #b1") #f)
(test (string->number "#b1 ") #f)
(test (string->number "#b1 1") #f)
(test (string->number "#b 1") #f)
(test (string->number "# b1") #f)
(test (string->number "#b12") #f)
(test (string->number "000+1") #f)
(test (string->number (string (integer->char 216))) #f) ; slashed 0
(test (string->number (string (integer->char 189))) #f) ; 1/2 as single char
(test (string->number (string #\1 (integer->char 127) #\0)) #f) ; backspace

(test (string->number "1\
2") 12)

(test (string->number "1E1") 10.0)
(test (string->number "1e1") 10.0)
(if (provided? 'dfls-exponents)
    (begin
      (test (string->number "1D1") 10.0)
      (test (string->number "1S1") 10.0)
      (test (string->number "1F1") 10.0)
      (test (string->number "1L1") 10.0)
      (test (string->number "1d1") 10.0)
      (test (string->number "1s1") 10.0)
      (test (string->number "1f1") 10.0)
      (test (string->number "1l1") 10.0)))

(num-test (string->number "1234567890123456789012345678901234567890.123456789e-30") 1234567890.1235)
(num-test (string->number "123456789012345678901234567890123456789012345678901234567890.123456789e-50") 1234567890.1235)
(num-test (- 1234567890123456789012345678901234567890123456789012345678901234567890.123456789e-60 12345678901234567890123456789012345678901234567890.123456789e-40) 0.0)
(num-test (string->number "#b000100111110110010011010100001.10111010011000100e1" 2) 167136579.45612)
(num-test (string->number "000100111110110010011010100001.10111010011000100e1" 2) 167136579.45612)
(num-test (string->number "#b1010100100110001111001001100101010011111010100110110.00011001001011101111101111111000110100100111011100100e-59") 5.163418497654431203689554326589836167902E-3)
(num-test (string->number "#b01010011000101001010000101011001111110000010110010.1000000000111001011010110110011111101011100000100e-3") 4.567403573967031260951910866285885504112E13)

(num-test 0000000000000000000000000001.0 1.0)
(num-test 1.0000000000000000000000000000 1.0)
(num-test 1000000000000000000000000000.0e-40 1.0e-12)
(num-test 0.0000000000000000000000000001e40 1.0e12)
(num-test 1.0e00000000000000000001 10.0)
(num-test 12341234.56789e12 12341234567889999872.0)
(num-test -1234567890123456789.0 -1234567890123456768.0)
(num-test 12345678901234567890.0 12345678901234567168.0)
(num-test 123.456e30 123456000000000012741097792995328.0)
(num-test 12345678901234567890.0e12 12345678901234569054409354903552.0)
(num-test 1.234567890123456789012e30 1234567890123456849145940148224.0)
(num-test 1e20 100000000000000000000.0)
(num-test 1234567890123456789.0 1234567890123456768.0)
(num-test 123.456e16 1234560000000000000.0)
(num-test 98765432101234567890987654321.0e-5 987654321012345728401408.0)
(num-test 98765432101234567890987654321.0e-10 9876543210123456512.0)
(num-test 0.00000000000000001234e20 1234.0)
(num-test 0.000000000000000000000000001234e30 1234.0)
(num-test 0.0000000000000000000000000000000000001234e40 1234.0)
(num-test 0.000000000012345678909876543210e15 12345.678909877)
(num-test 98765432101234567890987654321.0e-20 987654321.012346)
(num-test 98765432101234567890987654321.0e-29 0.98765432101235)
(num-test 98765432101234567890987654321.0e-30 0.098765432101235)
(num-test 98765432101234567890987654321.0e-28 9.8765432101235)
(num-test 1.0123456789876543210e1 10.12345678987654373771)
(num-test 1.0123456789876543210e10 10123456789.87654304504394531250)
(num-test 0.000000010000000000000000e10 100.0)
(num-test 0.000000010000000000000000000000000000000000000e10 100.0)
(num-test 0.000000012222222222222222222222222222222222222e10 122.22222222222222)
(num-test 0.000000012222222222222222222222222222222222222e17 1222222222.222222)
(num-test (- (string->number "769056139124082.") (string->number "769056139124080.")) 2.0)

(num-test (string->number "0000000000000000000000000001.0") 1.0)
(num-test (string->number "1.0000000000000000000000000000") 1.0)
(num-test (string->number "1000000000000000000000000000.0e-40") 1.0e-12)
(num-test (string->number "0.0000000000000000000000000001e40") 1.0e12)
(num-test (string->number "1.0e00000000000000000001") 10.0)
(num-test (string->number "12341234.56789e12") 12341234567889999872.0)
(num-test (string->number "-1234567890123456789.0") -1234567890123456768.0)
(num-test (string->number "12345678901234567890.0") 12345678901234567168.0)
(num-test (string->number "123.456e30") 123456000000000012741097792995328.0)
(num-test (string->number "12345678901234567890.0e12") 12345678901234569054409354903552.0)
(num-test (string->number "1.234567890123456789012e30") 1234567890123456849145940148224.0)
(num-test (string->number "1e20") 100000000000000000000.0)
(num-test (string->number "1234567890123456789.0") 1234567890123456768.0)
(num-test (string->number "123.456e16") 1234560000000000000.0)
(num-test (string->number "98765432101234567890987654321.0e-5") 987654321012345728401408.0)
(num-test (string->number "98765432101234567890987654321.0e-10") 9876543210123456512.0)
(num-test (string->number "0.00000000000000001234e20") 1234.0)
(num-test (string->number "0.000000000000000000000000001234e30") 1234.0)
(num-test (string->number "0.0000000000000000000000000000000000001234e40") 1234.0)
(num-test (string->number "0.000000000012345678909876543210e15") 12345.678909877)
(num-test (string->number "98765432101234567890987654321.0e-20") 987654321.012346)
(num-test (string->number "98765432101234567890987654321.0e-29") 0.98765432101235)
(num-test (string->number "98765432101234567890987654321.0e-30") 0.098765432101235)
(num-test (string->number "98765432101234567890987654321.0e-28") 9.8765432101235)
(num-test (string->number "1.0123456789876543210e1") 10.12345678987654373771)
(num-test (string->number "1.0123456789876543210e10") 10123456789.87654304504394531250)
(num-test (string->number "0.000000010000000000000000e10") 100.0)
(num-test (string->number "0.000000010000000000000000000000000000000000000e10") 100.0)
(num-test (string->number "0.000000012222222222222222222222222222222222222e10") 122.22222222222222)
(num-test (string->number "0.000000012222222222222222222222222222222222222e17") 1222222222.222222)
(num-test (string->number "1.1001001000011111101101010100010001000010110100010011" 2) 1.5707963267949)

(num-test #x0000000000000000000000000001.0 1.0)
(num-test #x1.0000000000000000000000000000 1.0)
;(test (number->string 1222222222.222222 16) "48d9a18e.38e38c")
(num-test (string->number (number->string 1222222222.222222222222222222 16) 16) 1222222222.222222222222222222)

(if with-bignums
    (num-test (string->number "179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.0")
	      179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.0)
    (num-test (string->number "179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.0")
	      1.7976931348623e+308))

(if with-bignums
    (begin
      (num-test (string->number (number->string (bignum "12345.67890987654321") 2) 2) 12345.67890987654321)
      (test (number->string 1234.5678909876543212345 16) "4d2.91614dc3ab1f80e55a563311b8f308")
      (test (number->string -1234.5678909876543212345 16) "-4d2.91614dc3ab1f80e55a563311b8f308")
      (test (number->string 1234.5678909876543212345e8 16) "1cbe991a6a.c3f35c11868cb7e3fb75536")
      (test (number->string 1234.5678909876543212345e-8 16) "0.0000cf204983a27e1eff701c562a870641e50")
      (test (number->string 123456789098765432.12345e-8 16) "499602d2.fcd6e9e1748ba5adccc12c5a8")
      (test (number->string 123456789098765432.1e20 16) "949b0f70beeac8895e74b18b9680000.00")))

(num-test (string->number "12345678900000000000.0") 1.23456789e+19)
(num-test (string->number "1234567890000000000000000000000000000000000000000000000000000000000000.0") 1.23456789e+69)
(num-test (string->number "1234567890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0") 1.23456789e+129)

(num-test (string->number "1.1e4" 5) 750.0)
(num-test (string->number "1.1e4" 4) 320.0)
(num-test (string->number "1.1e4" 3) 108.0)
(num-test (string->number "1.1e4" 2) 24.0)

(num-test #b111111111111111111111111111111111111111111111111111111111111111 most-positive-fixnum)
(num-test #o777777777777777777777 most-positive-fixnum)
(num-test #x7fffffffffffffff most-positive-fixnum)
(num-test #d9223372036854775807 most-positive-fixnum)

(num-test #d-9223372036854775808 most-negative-fixnum)
(num-test #o-1000000000000000000000 most-negative-fixnum)
(num-test #x-8000000000000000 most-negative-fixnum)
(num-test #b-1000000000000000000000000000000000000000000000000000000000000000 most-negative-fixnum)

(test (number->string 1.0 most-negative-fixnum) 'error)
(test (number->string 1.0 most-positive-fixnum) 'error)
(test (string->number "1.0" most-negative-fixnum) 'error)
(test (string->number "1.0" most-positive-fixnum) 'error)
(test (number->string 16 17) 'error)
(test (number->string -0. 11 -) 'error)
(test (string->number "11" 2 -) 'error)

(test (string->number "1.0F") #f)
(test (string->number "1F") #f)
(test (string->number "1d") #f)
(test (string->number "1.0L") #f)
(test (string->number "1.0+1.0Ei") #f)
(test (string->number "0xff") #f)

;; duplicate various non-digit chars
(for-each
 (lambda (str)
   (test (string->number str) #f))
 (list "..1" "1.." "1..2" "++1" "+-1" "-+1" "--1" "-..1" "+..1" "1+i+" "1+i."
       "1++i" "1--i" "1.ee1" "1+1..i" "1+ii" "1+1ee1i" "1e1e1" "1+2i.i"
       "1//2" "1+.1/2i" "1+1//2i" "1+1/2" "1i" "1ii" "1+.i" "1+..i"))

(test (number->string most-positive-fixnum 2) "111111111111111111111111111111111111111111111111111111111111111")
(test (number->string most-positive-fixnum 8) "777777777777777777777")
(test (number->string most-positive-fixnum 16) "7fffffffffffffff")
(test (number->string most-positive-fixnum 10) "9223372036854775807")
(test (number->string most-negative-fixnum 10) "-9223372036854775808")
(test (number->string most-negative-fixnum 8) "-1000000000000000000000")
(test (number->string most-negative-fixnum 16) "-8000000000000000")
(test (number->string most-negative-fixnum 2) "-1000000000000000000000000000000000000000000000000000000000000000")

(test (string->number "111111111111111111111111111111111111111111111111111111111111111" 2) most-positive-fixnum)
(test (string->number "777777777777777777777" 8) most-positive-fixnum)
(test (string->number "7fffffffffffffff" 16) most-positive-fixnum)
(test (string->number "9223372036854775807" 10) most-positive-fixnum)
(test (string->number "-9223372036854775808" 10) most-negative-fixnum)
(test (string->number "-1000000000000000000000" 8) most-negative-fixnum)
(test (string->number "-8000000000000000" 16) most-negative-fixnum)
(test (string->number "-1000000000000000000000000000000000000000000000000000000000000000" 2) most-negative-fixnum)

(test (string->number (string #\1 #\. #\0 (integer->char 128) #\1)) #f)
(test (string->number (string #\1 #\. #\0 (integer->char 20) #\1)) #f)
(test (string->number (string #\1 #\. #\0 (integer->char 200) #\1)) #f)
(test (string->number (string #\1 #\. #\0 (integer->char 255) #\1)) #f)
(test (string->number (string #\1 #\. #\0 (integer->char 2) #\1)) #f)
(test (string->number (string #\1 #\. (integer->char 128) #\1)) #f)
(test (string->number (string #\1 #\. (integer->char 20) #\1)) #f)
(test (string->number (string #\1 #\. (integer->char 200) #\1)) #f)
(test (string->number (string #\1 #\. (integer->char 255) #\1)) #f)
(test (string->number (string #\1 #\. (integer->char 2) #\1)) #f)
(test (string->number (string #\1 (integer->char 128) #\1)) #f)
(test (string->number (string #\1 (integer->char 20) #\1)) #f)
(test (string->number (string #\1 (integer->char 200) #\1)) #f)
(test (string->number (string #\1 (integer->char 255) #\1)) #f)
(test (string->number (string #\1 (integer->char 2) #\1)) #f)
(test (string->number (string (integer->char 128) #\1)) #f)
(test (string->number (string (integer->char 20) #\1)) #f)
(test (string->number (string (integer->char 200) #\1)) #f)
(test (string->number (string (integer->char 255) #\1)) #f)
(test (string->number (string (integer->char 2) #\1)) #f)
(test (string->number (string (integer->char 128) #\/ #\2)) #f)
(test (string->number (string (integer->char 20) #\/ #\2)) #f)
(test (string->number (string (integer->char 200) #\/ #\2)) #f)
(test (string->number (string (integer->char 255) #\/ #\2)) #f)
(test (string->number (string (integer->char 2) #\/ #\2)) #f)
(do ((i 103 (+ i 1)))
    ((= i 256))
  (test (string->number (string (integer->char i))) #f)
  (test (string->number (string (integer->char i) #\. #\0)) #f))
(test (string->number "1,000") #f)
(test (string->number "1 000") #f)
(test (string->number "1 / 2") #f)
(test (string->number "1 .2") #f)
(test (string->number "1:") #f)
(test (string->number "#b 1") #f)

#|
(do ((i 20 (+ i 1)))
    ((= i 128))
  (let ((str (string-append "#" (string (integer->char i)) "1.0e8")))
    (catch #t (lambda ()
		(let ((val (eval-string str)))
		  (format #t "~A -> ~S~%" str val)))
	   (lambda args 'error))))
|#
(num-test #b1.0e8 256.0)
(num-test #o1.0e8 16777216.0)
(num-test #d1.0e8 100000000.0)
(num-test #x1.0e8 1.056640625) ; e is a digit
(num-test #e1.0e8 100000000)
(num-test #i1.0e8 100000000.0)

(if with-bignums
    (num-test #b1.1111111111111111111111111111111111111111111111111110011101010100100100011001011011111011000011001110110101010011110011000100111E1023 1.7976931348623156E308))

(test (number->string 1/9 2) "1/1001")
(test (number->string -11/4 2) "-1011/100")
(test (number->string -11/4 8) "-13/4")
(test (number->string -15/4 16) "-f/4")
(test (string->number "f/4" 16) 15/4)
(test (string->number "#b'0") #f)
(test (string->number "#b0/0") #f)
(test (string->number "#b-1/0") #f)
(test (string->number "#b#i0/0") #f)
(test (string->number "#b#e0/0") #f)
(test (string->number "#b#e1/0+i") #f) ; inf+i?
(test (string->number "1e1/2") #f)
(test (string->number "1e#b0") #f)
(test (string->number "#B0") #f)
(test (string->number "0+I") #f)
(test (string->number "#e#b0/0") #f)
(test (string->number "#i#b0/0") #f)
(test (string->number "#e0/0") #f)
(test (number? (string->number "#i0/0")) #t) ; nan since (number? 0/0) is #t
(test (string->number "#e#b1/0") #f)
(test (string->number "#i#b1/0") #f)
(test (string->number "#e1/0") #f)
(test (number? (string->number "#i1/0")) #t)
(test (string->number "#e#b1/0+i") #f)
(test (string->number "#i#b1/0+i") #f) ; inf+i?
(test (string->number "#e1/0+i") #f)
(test (number? (string->number "#i1/0+i")) #t) 
(test (number? (string->number "#i0/0+i")) #t) 
(test (nan? #i0/0) #t) ; but #i#d0/0 is a read error?

(num-test (string->number "#b#e11e30") 3221225472) ; very confusing!
(num-test (string->number "#b#i11e30") 3221225472.0)
(num-test (string->number "#e#b11e30") 3221225472) 
(num-test (string->number "#i#b11e30") 3221225472.0)
(num-test (string->number "#b#e+1e+1+0e+10i") 2)
(num-test (string->number "#e+.0e-00-0i") 0)
(num-test (string->number "#x1e0/e+0/ei") 34.285714285714)
(num-test (string->number "#e-0/1110010") 0)
(num-test (string->number "#x+1e1.+e10i") 481+3600i)
(num-test (string->number "#xe/e+e/ei") 1+1i)
(num-test (string->number "1e-0-.11e+1i") 1-1.1i)
(num-test (string->number "00.-1.1e-00i") 0-1.1i)
(num-test (string->number "+01.e+1+.00i") 10.0)
(num-test (string->number "#x#e00110e") 4366)
(num-test (string->number "+01e0+00.i") 1.0)
(num-test (string->number "#e#x-e/001") -14)
(num-test (string->number "+0/0100+0i") 0.0)
(num-test (string->number "#e.001e-11") 0)
(num-test (string->number "#x#e00/00e") 0)
(num-test (string->number "#x-e1e/eee") -139/147)
(num-test (string->number "#x-0101.+00/11i") -257.0)
(num-test (string->number "#x+ee.-e00e0110i") 238-3759014160i)
(num-test (string->number "#x-e0/1ee") -112/247)
(num-test (string->number "#e#x+1e.01e10100") 65366158/2178339)
(num-test (string->number "#i#x0e10-000i") 3600.0)
(num-test (string->number "#x0/e010-e/1i") 0-14i)
(num-test (string->number "#i-1/1-1.0e1i") -1-10i)
(num-test (string->number "-1.-00.0e+10i") -1.0)
(num-test (string->number "#e#x001ee11e1") 32379361)
(num-test (string->number "#x+e/00011ee0") 7/36720)
(num-test (string->number "#e#x010e10.e1") 17699041/256)
(num-test (string->number "#x10+10i") 16+16i)
(num-test 00-10e+001i 0-100i)
(num-test #b#i.110e-1 0.375)
(num-test #e01.1e1+00.i 11)

(if (provided? 'dfls-exponents)
    (begin
      (num-test (string->number "#d.0d1+i") 0+1i)
      (num-test (string->number "+.0d-1+i") 0+1i)
      (num-test (string->number "#d1d+0-1d-1i") 1-0.1i)
      (num-test (string->number "#i+1+0.d-0i") 1.0)
      (num-test (string->number "#o#i-101d+0") -65.0)
      (num-test (string->number "+001.110d+1") 11.1)
      (num-test (string->number "#e01+0d000i") 1)
      (num-test (string->number "#d1d0-0.d0i") 1.0)
      (num-test (string->number "#d#i001d+00") 1.0)
      (num-test (string->number "#o0010111/1") 4169)
      (num-test (string->number "0d00-0.d+0i") 0.0)
      (num-test (string->number "#o1.d0+10.d00i") 1+8i)
      (num-test (string->number "0d+01+1e+1i") 0+10i)
      (num-test (string->number "10.d-005" 2) 0.0625)
      (num-test (string->number "+7f2-73i" 8) 448-59i)
      ))

(num-test (string->number "#e#d+11.e-0") 11)
(num-test (string->number "#d.0e011110") 0.0)
(num-test (string->number "+01e01+0/1i") 10.0)
(num-test (string->number "#i#d1e1+.0i") 10.0)
(num-test (string->number "1.-0.0e+00i") 1.0)

(test (string->number "#o#e10.+1.i") #f)
(test (string->number "#x#e1+i") #f)
(test (string->number "#x#1+#e1i") #f)
(test (string->number "#x#e1+#e1i") #f)
(test (string->number "#b#e1+i") #f)
(test (string->number "#o#e1-110.i") #f)
(num-test (string->number "#e1+0i") 1)
(num-test (string->number "#x#e1+0i") 1)
(num-test (string->number "#e#x1+0i") 1)
(num-test (string->number "#x1/7e2") 1/2018)

(num-test (string->number "0.1e00" 2) 0.5)
(num-test (string->number "10.101" 2) 2.625)
(num-test (string->number "0e1010" 2) 0.0)
(num-test (string->number ".1e010" 2) 512.0)
(num-test (string->number "1/000100" 2) 1/4)
(num-test (string->number "1000e+03" 2) 64.0)
(num-test (string->number "-1e+1-1i" 2) -2-1i)
(num-test (string->number ".1-110e03i" 2) 0.5-48i)
(num-test (string->number "1e9" 2) 512.0)

(num-test (string->number "52/7" 8) 6)
(num-test (string->number "130." 8) 88.0)
(num-test (string->number "121.-16i" 8) 81-14i)
(num-test (string->number "12/15150" 8) 1/676)
(num-test (string->number "612444175735" 8) 52958395357)
(num-test (string->number "31005331+.4i" 8) 6556377+0.5i)
(num-test (string->number "42220e-2" 8) 274.25)
(num-test (string->number "1e9" 8) 134217728.0)
(test (string->number "1e9" 12) #f) ; this may not be ideal...
(num-test (string->number "1b9/64" 12) 15/4)
(num-test (string->number "a880+i" 12) 18528+1i)
(num-test (string->number "dc-i" 16) 220-1i)
(num-test (string->number "dcd-fi" 16) 3533-15i)
(num-test (string->number "d/ebee" 16) 1/4646)
(num-test (string->number "a.d-ci" 16) 10.8125-12i)
(num-test (string->number "fac/ed" 16) 4012/237)
(num-test (string->number "-ccdebef.a" 16) -214821871.625)
(num-test (string->number "+dfefc/c" 16) 76437)
(num-test (string->number "acd/eabf" 16) 79/1717)
(num-test (string->number "-1e-1-1e-1i") -0.1-0.1i)
(num-test (string->number "+1e+1+1e+1i") 10+10i)
(num-test (string->number "#i#d+1e+1+1e+1i") 10+10i)
(test (string->number "#e+1e+1+1e+1i") #f)

;;; these depend on rationalize's default error I think
;;; and they cause valgrind to hang!!
;(num-test (string->number "#e.1e-11") 0)
;(num-test (string->number "#e1e-12") 0)
(num-test (string->number "#e1e-11") 1/90909090910)
(test (string->number "#e#f1") #f)

(if with-bignums
    (begin
      (test (= (string->number "#e1e19") (string->number "#e.1e20")) #t)
      (test (= (string->number "#e1e19") (* 10 (string->number "#e1e18"))) #t)
      (test (= (string->number "#e1e20") (* 100 (string->number "#e1e18"))) #t)))

(test (= #i1e19 #i.1e20) #t)
(test (= 1e19 .1e20) #t)

(test (string->number "15+b7a9+8bbi-95+4e" 16) #f)
(num-test (string->number "776.0a9b863471095a93" 12) 1098.0752175102)
(num-test (string->number "a72972b301/398371448" 12) 54708015601/1637213240)
(num-test (string->number "+ac946/b72ddf4847ce6" 16) 353443/1611261179739763)
(num-test (string->number "b85.361c23cec099e742" 15) 2600.2272029731)
(num-test (string->number "ade2411.a1422432dea8" 15) 1.24494541672338806082296187159063753079E8)
(num-test (string->number "da99007963b182/8a66b" 15) 26681038227104972/440201)
(num-test (string->number "74cc.d+b44.02a11ee5i" 15) 24717.866666667+2539.0118742348i)
(num-test (string->number "d+7a5d40di" 14) 13+58313541i)

(test (nan? (string->number "1/0")) #t)
(test (nan? (string->number "5639d72702b62527/0" 14)) #t)
(test (nan? (string->number "-28133828f9421ef5/0" 16)) #t)
(test (nan? (string->number "+4a11654f7e00d5f2/0" 16)) #t)

(if with-bignums 
    (begin
      (test (number->string (/ most-positive-fixnum most-negative-fixnum) 2) "-111111111111111111111111111111111111111111111111111111111111111/1000000000000000000000000000000000000000000000000000000000000000")
      (test (string->number "-111111111111111111111111111111111111111111111111111111111111111/1000000000000000000000000000000000000000000000000000000000000000" 2) -9223372036854775807/9223372036854775808)
      (num-test (string->number "#b#e-11e+111") -7788445287802241442795744493830144)
      (num-test (string->number "#i#b-11e+111") -7.788445287802241442795744493830144E33)
      (num-test (string->number "#b#i-11e+111") -7.788445287802241442795744493830144E33)
      (num-test (string->number "#i3e+111") 3.0e111)
      (num-test (string->number "#e3e30") 3000000000000000000000000000000)
      (num-test (string->number "#i3e30") 3.000E30)
      
      (num-test (string->number "#b#e11e80") 3626777458843887524118528)
      (num-test (string->number "#b#i11e80") 3626777458843887524118528.0)
      (num-test (string->number "#e#b11e80") 3626777458843887524118528)
      (num-test (string->number "#i#b11e80") 3626777458843887524118528.0)

      (num-test (string->number "b2706b3d3e8e46ad5aae" 15) 247500582888444441302414)
      (num-test (string->number "ceec932122d7c22289da9144.4b7836de0a2f5ef" 16) 6.403991331575236168367699181229480307503E28)
      (num-test (string->number "c23177c20fb1296/fcf15a82c8544613721236e2" 16) 437284287268358475/39141000511500755277510679409)

      (num-test (string->number "775f81b8fee51b723f" 16) 2202044529881940455999)
      (num-test (string->number "5d9eb6d6496f5c9b6e" 16) 1726983762769631550318)
      (num-test (string->number "+775f81b8fee51b723f" 16) 2202044529881940455999)
      (num-test (string->number "+5d9eb6d6496f5c9b6e" 16) 1726983762769631550318)
      (num-test (string->number "-775f81b8fee51b723f" 16) -2202044529881940455999)
      (num-test (string->number "-5d9eb6d6496f5c9b6e" 16) -1726983762769631550318)
      (num-test (string->number "+d053d635e581a5c4/d7" 16) 15011577509928084932/215)
      (num-test (string->number "+a053a635a581a5a4/a7" 16) 11552760218475668900/167)
      (num-test (string->number "-d053d635e581a5c4/d7" 16) -15011577509928084932/215)
      (num-test (string->number "-a053a635a581a5a4/a7" 16) -11552760218475668900/167)
      (num-test (string->number "+6/a47367025481df6c8" 16) 1/31599808811326133196)
      (num-test (string->number "d053d635e581a5c4/d7" 16) 15011577509928084932/215)
      (num-test (string->number "+074563336d48564b774" 16) 2146033681147780970356)
      (num-test (string->number "e/4246061597ec79345a" 15) 7/204584420774687563055)
      (num-test (string->number "c57252467ff.cfd94d" 16) 1.3568424830975811909496784210205078125E13)
      (num-test (string->number "f309e9b9ba.7c52ff2" 16) 1.043843365306485641427338123321533203125E12)
      (num-test (string->number "+42e-0106653" 10) 4.199999999999999999999999999999999999999E-106652)
      (test (infinite? (string->number "8e7290491476" 10)) #t)
      (num-test (string->number "4ff7da4d/ab09e16255c06a55c5cb7193ebb2fbb" 16) 1341643341/14209330580250438592763227155654717371)

      (num-test (string->number "#d3000000000000000000000000000000") 3000000000000000000000000000000)
      (num-test (string->number "#x400000000000000000") (expt 2 70))

      (for-each
       (lambda (op)
	 (if (not (= (op 1e19) (op .1e20)))
	     (format #t ";(~A 1e19) = ~A, but (~A .1e20) = ~A?~%"
		     op (op 1e19)
		     op (op .1e20))))
       (list floor ceiling truncate round inexact->exact exact->inexact))

       (for-each
	(lambda (op)
	  (if (not (= (op -1e19) (op -.1e20)))
	      (format #t ";(~A -1e19) = ~A, but (~A -.1e20) = ~A?~%"
		      op (op -1e19)
		      op (op -.1e20))))
	(list floor ceiling truncate round inexact->exact exact->inexact))
      )

    (begin
      ;; not with-bignums!

      ;;(test (/ most-positive-fixnum most-negative-fixnum) 'error) ; why not -1?
      (test (nan? (/ most-negative-fixnum)) #t)
      ;; (/ most-positive-fixnum most-negative-fixnum) -> 9223372036854775807/-9223372036854775808 
      ;; so
      ;; (positive? (/ most-positive-fixnum most-negative-fixnum)) -> #t!

      (test (infinite? (string->number "775f81b8fee51b723f" 16)) #t) ; and others similarly -- is this a good idea?

      ))

(num-test #b+01 1)
(num-test #b-01 -1)
(num-test #d-1/2 -1/2)
(num-test #d+1/2 1/2)

(num-test #b1.0e-8 0.00390625)
(num-test #o1.0e-8 5.9604644775391e-08)
(num-test #d1.0e-8 1.0e-8)

(num-test #b-.1 -0.5)
(num-test #o-.1 -0.125)
(num-test #d-.1 -0.1)
(num-test #x-.1 -0.0625)

(num-test #b+.1 +0.5)
(num-test #o+.1 +0.125)
(num-test #d+.1 +0.1)
(num-test #x+.1 +0.0625)

(num-test #b+.1e+1 1.0)
(num-test #d+.1e+1 1.0)
(num-test #o+.1e+1 1.0)

(num-test #b000000001 1)
(num-test #b1e1 2.0)
(num-test #b1.e1 2.0)

(num-test #b#e-.1 -1/2)
(num-test #o#e-.1 -1/8)
(num-test #d#e-.1 -1/10)
(num-test #x#e-.1 -1/16)
(num-test #e-.0 0)
(num-test #e-123.0 -123)
(num-test #i-123 -123.0)
(num-test #e+123.0 123)
(num-test #i+123 123.0)

(num-test #b#e1.1e2 6)
(num-test #o#e1.1e2 72)
(num-test #d#e1.1e2 110)

(num-test #b#i-1.1e-2 -0.375)
(num-test #o#i-1.1e-2 -0.017578125)
(num-test #d#i-1.1e-2 -0.011)
(num-test #i-0 0.0)
(num-test #e-0.0 0)
;;; in guile #e1e-10 is 7737125245533627/77371252455336267181195264
(num-test #e#b1e-10 1/1024)

(num-test #e#b+1.1 3/2)
(num-test #e#o+1.1 9/8)
(num-test #e#d+1.1 11/10)
(num-test #e#x+1.1 17/16)

(num-test #e#b+1.1e+2 6)
(num-test #e#o+1.1e+2 72)
(num-test #e#d+1.1e+2 110)

(num-test #i#b.001 0.125)
(num-test #i#b000000000011 3.0)
(num-test #i#b-000000000011e1 -6.0)
(num-test #i#b-000000000011e+11 -6144.0)

(num-test #x-AAF -2735)
(num-test #x-aAf -2735)

(num-test #b1+1.1i 1+1.5i)  ; yow...
;(num-test #b#e0+i 0+1i)    ; these 2 are now read-errors (#e0+i is an error because inexact->exact does not accept complex args in s7)
;(num-test #b#e0+1.1i 0+1.5i) 
(test (string->number "#b#e0+i") #f)

(num-test #xf/c 5/4)
(num-test #x+f/c 5/4)
(num-test #x-f/c -5/4)
(num-test #i#xf/c 1.25)
(num-test #e#x1.4 5/4)
(num-test #d1/2 1/2)
(num-test #e2/3 2/3)

;; nutty: #e+inf.0 #e+nan.0 
;;    these don't arise in s7 because we don't define inf.0 and nan.0
(if with-bignums (num-test #e9007199254740995.0 9007199254740995))

(num-test #b0/1 0)
;(test #b0/0 'division-by-zero) ; read-error
(num-test #d3/4 3/4)
(num-test #o7/6 7/6)
(num-test #o11/2 9/2)
(num-test #d11/2 11/2)
(num-test #x11/2 17/2)
(num-test #b111/11 7/3)
(num-test #b111111111111111111111111111111111111111111111111111111111111111/111 1317624576693539401)
(num-test #d9223372036854775807/7 1317624576693539401)
(num-test (* 1317624576693539401 7) most-positive-fixnum)
(num-test #o777777777777777777777/7 1317624576693539401)
(num-test #x7fffffffffffffff/7 1317624576693539401)
(num-test (string->number "#x1234/12") (string->number "1234/12" 16))
(num-test #e#x1234/12 (string->number "#x#e1234/12"))
(num-test #x#e.1 #e#x.1)
(num-test #d#i1/10 #i#d1/10)

(test (equal? 0.0 #b0e0) #t)
(test (equal? 0.0 #b0e-0) #t)
(test (equal? 0.0 #b.0e+0) #t)
(test (equal? 0.0 #b00000000000000000000000000000000000000000000000000000e100) #t)
(test (equal? 0.0 #b.0000000000000000000000000000000000000000000000000000e100) #t)
(test (equal? 0.0 #b00000000000000000000000000000000000000000000000000000.0000000000000000000000000000000000000000000000000000000000e100) #t)
(test (equal? 0.0 #b0e100000000000000000000000000000000000000000000000000000000000000000000000) #t)
(num-test 0 #b0/1000000000)
(num-test 0 #b0/100000000000000000000000000000000000000)
(num-test 0 #b0/100000000000000000000000000000000000000000000000000000000000000)
(if with-bignums
    (begin
      (num-test (string->number "#b0/100000000000000000000000000000000000000000000000000000000000000000000") 0)
      (num-test (string->number "#b-0/100000000000000000000000000000000000000000000000000000000000000000000") 0)))
;;; there's a problem here -- the reader tries to make sense of every form even if it can't actually
;;;    be evaluated, so in the block above in the non-bignum case, if the #b... is not in double quotes, it tries to read
;;;    the value as a number.  make_atom however returns NaN because it can't represent the integer in 64 bits, and
;;;    the #... code interprets that as #b<not-a-number> and it raises a read error!  Ideally, we'd distinguish
;;;    between #b... that can't possibly be right and the same that might be ok if the bits are available.

(test (equal? 0.0 #b0.0e10) #t)
(test (equal? 0.0 #b0e100) #t)
(test (equal? 0.0 #b0.0e1000) #t)
(test (equal? 0.0 #b0e+1000) #t)
(test (equal? 0.0 #b0.0e-1) #t)
(test (equal? 0.0 #b0e-10) #t)
(test (equal? 0.0 #b0.0e-100) #t)
(test (equal? 0.0 #b0e-1000) #t)
(test (equal? 0.0 #b0.0e0123456789) #t)

(test (equal? 0.0 #b0-0e10i) #t)
(test (equal? 0.0 #b0-0.0e100i) #t)
(test (equal? 0.0 #b0-0e1000i) #t)
(test (equal? 0.0 #b0-0.0e+1000i) #t)
(test (equal? 0.0 #b0-0e-1i) #t)
(test (equal? 0.0 #b0-0.0e-10i) #t)
(test (equal? 0.0 #b0-0e-100i) #t)
(test (equal? 0.0 #b0-0.0e-1000i) #t)
(test (equal? 0.0 #b0.0+0e0123456789i) #t)
(num-test 0.0 #b1e-1000)

(num-test #b+0+i 0+1i)
(num-test #b0.-i 0-1i)
(num-test #b0/01 0)
(num-test #b-0/1 0)
(num-test #b1.+.1i 1+0.5i)
(num-test #b#i0-0i 0.0)
(num-test #b#e1e01 2)
(num-test #b#e1e-0 1)
(num-test 1e-0 1.0)
(num-test #b#e11e-1 3/2)
(num-test #b0100/10 2)
(num-test #b0e+1-0.i 0.0)
(num-test #b.1-0/01i 0.5)
;(num-test #b#e-0/1+i 0+1i)
(num-test #b0e+1-0.i 0.0)
(num-test #b#e+.1e+1 1)
(num-test #b1.+01.e+1i 1+2i)
(num-test #b#e.011-0.i 3/8)
(num-test #b#i1.1e0-.0i 1.5)
(num-test #b#e1.1e0-.0i 3/2)
(num-test #b0+.0e10101i 0.0)
(num-test #b#e-1.00e+001 -2)
(num-test #b#e+.01011100 23/64)
(num-test #b#i-00-0/001i 0.0)
(num-test #b00e+0-.00e11i 0.0)
(num-test #b-000e+10110001 0.0)
(test (string->number "#b#e-1/1+01.1e1i") #f)
(test (string->number "#d#i0/0") #f)
(test (string->number "#i#x0/0") #f)

(test (exact? #i1) #f)
(test (exact? #e1.0) #t)
(test (exact? #i1.0) #f)
(test (exact? #e1) #t)
(test (exact? #i#b1) #f)
(test (exact? #e#b1) #t)
(num-test #x#e1.5 21/16)
(num-test #x#i3 3.0)
(test (number? ''1) #f)
(test (symbol? ''1) #f)
(test (string->number "''1") #f)

(test 00 0)
(test (string->number "00") 0)
(test 000 0)
(test (string->number "000") 0)
(test 00.00 0.0)
(test (string->number "00.00") 0.0)
(test (number? '0-0) #f)
(test (string->number "0-0") #f)
(test (number? '00-) #f)
(test (string->number "00-") #f)

(num-test #e0.1 1/10)
(num-test #i1/1 1.0)
(num-test #o-11 -9)
(num-test #o-0. 0.0)
(num-test #o+.0 0.0)
(num-test #x#if 15.0)
(num-test #xe/1 14)
(num-test #xe/a 7/5)
(num-test #xfad 4013)
(num-test #xd/1 13)
(num-test #x0/f 0)
(num-test #x+00 0)
(num-test #x.c0 0.75)
(num-test #x-fc -252)
(test (equal? #e1.5 3/2) #t)
(test (equal? #e1.0 1) #t)
(test (equal? #e-.1 -1/10) #t)
(test (equal? #e1 1) #t)
(test (equal? #e3/2 3/2) #t)
(test (< (abs (- #i3/2 1.5)) 1e-12) #t)
(test (< (abs (- #i1 1.0)) 1e-12) #t)
(test (< (abs (- #i-1/10 -0.1)) 1e-12) #t)
(test (< (abs (- #i1.5 1.5)) 1e-12) #t)
(num-test (= 0e-1 0.0) #t)
;;; (/ (/ 0))??
(num-test #x.a+i 0.625+1i)
(num-test #b1.+i 1+1i)
(num-test 0.e-0 0.0)

(if (provided? 'dfls-exponents)
    (begin
      (num-test (string->number "#i1s0") 1.0) ; need the s->n to avoid confusing reader in non-dfls case
      (num-test -0d-0 0.0)
      (num-test +1d+1 10.0)
      (num-test +1s00 1.0)
      ))

(let ((str (make-string 3)))
   (set! (str 0) #\#)
   (set! (str 1) #\b)
   (set! (str 2) #\null)
   (test (string->number str) #f))
(let ((str (make-string 4)))
   (set! (str 0) #\#)
   (set! (str 1) #\b) 
   (set! (str 2) #\0)
   (set! (str 3) #\null)          ; #\space here -> #f
   (test (string->number str) 0)) ; this is consistent with other (non-#) cases

(do ((i 2 (+ i 1)))
    ((= i 17)) 
  (num-test (string->number (number->string 12345.67890987654321 i) i) 12345.67890987654321))

(let ()
  (define (make-number radix)
    (let* ((max-len (+ 1 (vector-ref (vector 0 0 62 39 31 26 23 22 20 19 18 17 17 16 16 15 15) radix)))
	   (int-len (floor (* max-len (random 1.0) (random 1.0) (random 1.0))))
	   (frac-len (floor (* max-len (random 1.0) (random 1.0) (random 1.0))))
	   (exp-len 1)
	   (has-frac (> (random 1.0) 0.2))
	   (has-exp (and (<= radix 10)
			 (< int-len 9)
			 (> (random 1.0) 0.5)))
	   (signed (> (random 1.0) 0.5))
	   (exp-signed (> (random 1.0) 0.5)))
      (if (and (= int-len 0)
	       (or (not has-frac)
		   (= frac-len 0)))
	  (set! int-len 1))
      (let ((str (make-string (+ int-len
				 (if signed 1 0)
				 (if has-frac (+ frac-len 1) 0) ; extra 1 for "."
				 (if has-exp (+ (+ exp-len 1)   ; extra 1 for exponent char
						(if exp-signed 1 0))
				     0))))
	    (loc 0))
	
	(define (digit->char digit)
	  (if (< digit 10)
	      (integer->char (+ (char->integer #\0) digit))
	      (integer->char (+ (char->integer #\a) (- digit 10)))))
	
	(define (exponent-marker)
	  (if (provided? 'dfls-exponents)
	      (string-ref "eEsSfFdDlL" (random 10))
	      (string-ref "eE" (random 2))))
	
	(if signed 
	    (begin
	      (set! (str 0) #\-)
	      (set! loc (+ loc 1))))
	
	(do ((i 0 (+ i 1)))
	    ((= i int-len))
	  (set! (str loc) (digit->char (random radix)))
	  (set! loc (+ loc 1)))
	
	(if has-frac
	    (begin
	      (set! (str loc) #\.)
	      (set! loc (+ loc 1))
	      (do ((i 0 (+ i 1)))
		  ((= i frac-len))
		(set! (str loc) (digit->char (random radix)))
		(set! loc (+ loc 1)))))
	
	(if has-exp
	    (begin
	      (set! (str loc) (exponent-marker))
	      (set! loc (+ loc 1))
	      (if exp-signed
		  (begin
		    (set! (str loc) #\-)
		    (set! loc (+ loc 1))))
	      (do ((i 0 (+ i 1)))
		  ((= i exp-len))
		(set! (str loc) (digit->char (random 10)))
		(set! loc (+ loc 1)))))
	
	str)))
  
  (let ((tries 1000))
    (do ((i 0 (+ i 1)))
	((= i tries))
      (let ((rad (+ 2 (random 15))))
	(let ((str (make-number rad)))
	  (if (not (number? (string->number str rad)))
	      (format #t ";(1) trouble in string->number ~A ~S: ~A~%"
		      rad str
		      (string->number str rad))
	      (if (not (string? (number->string (string->number str rad) rad)))
		  (format #t ";(2) trouble in number->string ~A ~S: ~A ~S~%"
			  rad str
			  (string->number str rad)
			  (number->string (string->number str rad) rad))
		  (if (not (number? (string->number (number->string (string->number str rad) rad) rad)))
		      (format #t ";(3) trouble in number->string ~A ~S: ~A ~S ~A~%"
			      rad str
			      (string->number str rad)
			      (number->string (string->number str rad) rad)
			      (string->number (number->string (string->number str rad) rad) rad))
		      (let ((diff (abs (- (string->number (number->string (string->number str rad) rad) rad) (string->number str rad)))))
			(if (> diff 1e-5)
			    (format #t "(string->number ~S ~D): ~A, n->s: ~S, s->n: ~A, diff: ~A~%"
				    str rad
				    (string->number str rad)
				    (number->string (string->number str rad) rad)
				    (string->number (number->string (string->number str rad) rad) rad)
				    diff)))))))))))

(let ()
  (define (no-char str radix)
    (let ((len (length str)))
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(if (and (not (char=? (str i) #\.))
		 (>= (string->number (string (str i)) 16) radix))
	    (format #t ";~S in base ~D has ~C?" str radix (str i))))))

  (no-char (number->string (* 1.0 2/3) 9) 9)
  (no-char (number->string (string->number "0.05" 9) 9) 9)
  ;; (number->string (string->number "-5L-4" 9) 9) -> "-0.00049" if rounding is stupid
  ;; (number->string (string->number "5.e-8" 6) 6) -> "0.000000046"
  (no-char (number->string (* 1.0 6/7) 7) 7)
  
  (do ((i 2 (+ i 1)))
      ((= i 17))
    (no-char (number->string (* 1.0 (/ 1 i)) i) i)
    (no-char (number->string (* 1.0 (/ 1 (* i i))) i) i)
    (no-char (number->string (* 0.99999999999999 (/ 1 i)) i) i)
    (no-char (number->string (* 0.999999 (/ 1 i)) i) i)))

(let ((happy #t))
  (do ((i 2 (+ i 1)))
      ((or (not happy)
	   (= i 17)))
    (if (not (eqv? 3/4 (string->number (number->string 3/4 i) i)))
	(begin 
	  (set! happy #f) 
	  (format #t ";(string<->number 3/4 ~A) -> ~A?~%" i (string->number (number->string 3/4 i) i))))
    (if (not (eqv? 1234/11 (string->number (number->string 1234/11 i) i)))
	(begin 
	  (set! happy #f) 
	  (format #t ";(string<->number 1234/11 ~A) -> ~A?~%" i (string->number (number->string 1234/11 i) i))))
    (if (not (eqv? -1234/11 (string->number (number->string -1234/11 i) i)))
	(begin 
	  (set! happy #f) 
	  (format #t ";(string<->number -1234/11 ~A) -> ~A?~%" i (string->number (number->string -1234/11 i) i))))))

(test (< (abs (- (string->number "3.1415926535897932384626433832795029") 3.1415926535897932384626433832795029)) 1e-7) #t)

(num-test (string->number "111.01" 2) 7.25)
(num-test (string->number "-111.01" 2) -7.25)
(num-test (string->number "0.001" 2) 0.125)
(num-test (string->number "1000000.001" 2) 64.125)

(num-test (string->number "111.01" 8) 73.015625)
(num-test (string->number "-111.01" 8) -73.015625)
(num-test (string->number "0.001" 8) 0.001953125)
(num-test (string->number "1000000.001" 8) 262144.001953125)

(num-test (string->number "111.01" 16) 273.00390625)
(num-test (string->number "-111.01" 16) -273.00390625)
(num-test (string->number "0.001" 16) 0.000244140625)
(num-test (string->number "1000000.001" 16) 16777216.000244)

(num-test (string->number "11.+i" 2) 3+1i)
(num-test (string->number "0+.1i" 2) 0+0.5i)
(num-test (string->number "1.+0.i" 2) 1.0)
(num-test (string->number ".01+.1i" 2) 0.25+0.5i)
(num-test (string->number "1+0.i" 2) 1.0)
(num-test (string->number "1+0i" 2) 1.0)

(test (number->string 0.75 2) "0.11")
(test (number->string 0.125 8) "0.1")
(test (number->string 12.5 8) "14.4")
(test (number->string 12.5 16) "c.8")
(test (number->string 12.5 2) "1100.1")
(test (number->string -12.5 8) "-14.4")
(test (number->string -12.5 16) "-c.8")
(test (number->string -12.5 2) "-1100.1")
(test (number->string 12.0+0.75i 2) "1100.0+0.11i")
(test (number->string -12.5-3.75i 2) "-1100.1-11.11i")
(test (number->string 12.0+0.75i 8) "14.0+0.6i")
(test (number->string -12.5-3.75i 8) "-14.4-3.6i")
(test (number->string 12.0+0.75i 16) "c.0+0.ci")
(test (number->string -12.5-3.75i 16) "-c.8-3.ci")
(test (string->number "2/#b1" 10) #f)
(test (string->number "2.i" 10) #f)
(num-test (string->number "6+3.i" 10) 6+3i)
(num-test (string->number "#e8/2" 11) 4)
(num-test (string->number "-61" 7) -43)
;(num-test (string->number "#eb8235.9865c01" 13) 19132998081/57607)
; this one depends on the underlying size (32/64)
(num-test (string->number "10100.000e11+011110111.1010110e00i" 2) 40960+247.671875i)
(num-test (string->number "#i-0.e11" 2) 0.0)
(num-test (string->number "+4a00/b" 16) 18944/11)

(num-test (string->number "#i+9/9" 10) 1.0)
(num-test (string->number "#e9e-999" 10) 0)
(num-test (string->number "#e-9.e-9" 10) -1/111098767)
(num-test (string->number "#e-.9e+9" 10) -900000000)
(num-test (string->number "9-9.e+9i" 10) 9-9000000000i)
(num-test (string->number "-9+9e-9i" 10) -9+9e-09i)  ; why the 09?
(num-test (string->number "#e-.9e+9" 10) -900000000)
(num-test (string->number "9-9.e+9i" 10) 9-9000000000i)

(num-test #e+32/1-0.i 32)
(num-test #e+32.-0/1i 32)
(num-test #e-32/1+.0i -32)
(num-test #e+2.-0/31i 2)
(num-test +2-0.e-1i 2.0)
(num-test +2.-0e-1i 2.0)
(num-test #b#e.01 1/4)
(num-test #e#b.01 1/4)
(num-test #b#e10. 2)
(num-test #e#b10. 2)
(num-test #b#e0.e11 0)
(num-test #b#e1.e10 1024)
(num-test #b#e-0.e+1 0)
(num-test #b#e+.1e-0 1/2)
(num-test #b#e+1.e-0 1)
(num-test #b#e-1.e+0 -1)

;; weird cases:
(num-test (string->number "#b1000" 8) 8)
(num-test (string->number "#b1000" 2) 8)
(num-test (string->number "#b1000" 16) 8)
(num-test (string->number "11" 2) 3)
(num-test (string->number "#x11" 2) 17)
(num-test (string->number "#b11" 16) 3)
(num-test (string->number "#xffff" 2) 65535)
(num-test (string->number "#xffff" 10) 65535)
(num-test (string->number "#xffff" 6) 65535)
(num-test (string->number "#xffff" 16) 65535)
(num-test (string->number "#d9.11" 16) 9.11)
(num-test (string->number "#d9.11" 10) 9.11)
(num-test (string->number "#x35/3de" 10) 53/990)

(num-test (string->number "#e87" 16) 135)
(num-test (string->number "#e87" 10) 87)
(num-test (string->number "#e#x87" 10) 135)
(num-test (string->number "#e#x87" 16) 135)
(num-test (string->number "#x#e87" 10) 135)
(num-test (string->number "#i87" 16) 135.0)
(num-test (string->number "#i87" 12) 103.0)
(num-test (string->number "#ee" 16) 14)
(num-test (string->number "#if" 16) 15.0)

(num-test (string->number "#e10.01" 2) 9/4)
(num-test (string->number "#e10.01" 6) 217/36)
(num-test (string->number "#e10.01" 10) 1001/100)
(num-test (string->number "#e10.01" 14) 2745/196)
(num-test (string->number "#i10.01" 2) 2.25)
(num-test (string->number "#i10.01" 6) 6.0277777777778)
(num-test (string->number "#i10.01" 10) 10.01)
(num-test (string->number "#i10.01" 14) 14.005102040816)
(num-test (string->number "#i-.c2e9" 16) -0.76136779785156)

(test (string->number "#x#|1|#1") #f)
(test (string->number "#||#1") #f)
(test (string->number "#<") #f)
(test (string->number "+.e1") #f)
(test (string->number ".e1") #f)

(num-test (string->number "4\x32\x37") 427)
(num-test (string->number "\x32.\x39") 2.9)
(num-test (string->number "#i\x32\x38\x36") 286.0)
(num-test (string->number "4\x31+3\x36i") 41+36i)

(if with-bignums
    (begin
      (num-test (string->number "101461074055444526136" 8) 1181671265888545886)
      (num-test (string->number "-67330507011755171566102306711560321" 8) -35128577239298592313751007322321)
      (num-test (string->number "35215052773447206642040260+177402503313573563274751i" 8) 1.38249897923920622272688E23+1.176027342049207220713E21i))
    (begin
      (test (or (nan? -22161050056534423736715535510711123) 
		(infinite? -22161050056534423736715535510711123)) 
	    #t)
      ;; there is some randomness here: 1.0e309 -> inf, but 1.0e310 -> -nan and others equally scattered
      ))

(test (string=? (substring (number->string pi 16) 0 14) "3.243f6a8885a3") #t)

(for-each
 (lambda (expchar)
   (let ((exponent (string expchar)))
     (do ((base 2 (+ base 1)))
	 ((= base 11))
       (let ((val (string->number (string-append "1" exponent "1") base)))
	 (if (and (number? val)
		  (> (abs (- val base)) 1e-9))
	     (format #t ";(string->number ~S ~A) returned ~A?~%" 
		     (string-append "1" exponent "1") base (string->number (string-append "1" exponent "1") base)))))
     
     (do ((base 2 (+ base 1)))
	 ((= base 11))
       (let ((val (string->number (string-append "1.1" exponent "1") base)))
	 (if (and (number? val)
		  (> (abs (- val (+ base 1))) 1e-9))
	     (format #t ";(string->number ~S ~A) returned ~A?~%" 
		     (string-append "1.1" exponent "1") base (string->number (string-append "1.1" exponent "1") base)))))
     
     (do ((base 2 (+ base 1)))
	 ((= base 11))
       (let ((val (string->number (string-append "1" exponent "+1") base)))
	 (if (and (number? val)
		  (> (abs (- val base)) 1e-9))
	     (format #t ";(string->number ~S ~A) returned ~A?~%"
		     (string-append "1" exponent "+1") base (string->number (string-append "1" exponent "+1") base)))))
					; in base 16 this is still not a number because of the + (or -)
					; but "1e+1i" is a number -- gad!
     
     (do ((base 2 (+ base 1)))
	 ((= base 11))
       (let ((val (string->number (string-append "1" exponent "-1+1i") base)))
	 (if (and (number? val)
		  (> (magnitude (- val (make-rectangular (/ base) 1))) 1e-6))
	     (format #t ";(string->number ~S ~A) returned ~A?~%" 
		     (string-append "1" exponent "-1+1i") base (string->number (string-append "1" exponent "-1+1i") base)))))))
 
 (list #\e #\d #\f #\s #\l))

(test (< (abs (- (string->number "3.1415926535897932384626433832795029" 10) 3.1415926535897932384626433832795029)) 1e-7) #t)
(num-test (string->number "2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427" 16) 2.4433976119657)
(num-test (string->number "2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427" 11) 2.6508258818757)

(let ((happy #t))
  (do ((i 2 (+ i 1)))
      ((or (not happy)
	   (= i 17)))
    (let ((val (+ 1.0 i)))
      (do ((k 1 (+ k 1))
	   (incr (/ 1.0 i) (/ incr i)))
	  ((< incr 1e-14))
	(set! val (+ val incr)))
      (if (> (abs (- val (string->number "11.111111111111111111111111111111111111111111111111111111111111111111111111111111111111" i))) 1e-7)
	  (begin
	    (set! happy #f) 
	    (display "(string->number 11.111... ") (display i) (display ") -> ") 
	    (display (string->number "11.111111111111111111111111111111111111111111111111111111111111111111111111111111111111" i))
	    (display " but expected ") (display val) (newline))))
    
    (let* ((digits "00123456789abcdef")
	   (str (make-string 80 (string-ref digits i))))
      (string-set! str 2 #\.)
      (let ((val (exact->inexact (* i i))))
	(if (> (abs (- val (string->number str i))) 1e-7)
	    (begin
	      (set! happy #f) 
	      (format #t ";(string->number ~S ~A) -> ~A (expected ~A)?~%" str i (string->number str i) val)))))
    
    (let* ((radlim (list 0 0 62 39 31 26 23 22 20 19 18 17 17 16 16 15 15))
	   (digits "00123456789abcdef"))
      (do ((k (- (list-ref radlim i) 3) (+ k 1)))
	  ((= k (+ (list-ref radlim i) 4)))
	(let ((str (make-string (+ k 3) (string-ref digits i))))
	  (string-set! str 2 #\.)
	  (let ((val (exact->inexact (* i i))))
	    (if (> (abs (- val (string->number str i))) 1e-7)
		(begin
		  (set! happy #f) 
		  (format #t ";(string->number ~S ~A) -> ~A (expected ~A)?~%" str i (string->number str i) val)))))))))

(let ((happy #t))
  (do ((i 2 (+ i 1)))
      ((or (not happy)
	   (= i 17)))
    (if (> (abs (- 0.75 (string->number (number->string 0.75 i) i))) 1e-6)
	(begin 
	  (set! happy #f) 
	  (format #t ";(string->number (number->string 0.75 ~A) ~A) -> ~A?~%" i i (string->number (number->string 0.75 i) i))))
    
    (if (> (abs (- 1234.75 (string->number (number->string 1234.75 i) i))) 1e-6)
	(begin 
	  (set! happy #f) 
	  (format #t ";(string->number (number->string 1234.75 ~A) ~A) -> ~A?~%" i i (string->number (number->string 1234.75 i) i))))
    
    (if (> (abs (- -1234.25 (string->number (number->string -1234.25 i) i))) 1e-6)
	(begin 
	  (set! happy #f) 
	  (format #t ";(string->number (number->string -1234.75 ~A) ~A) -> ~A?~%" i i (string->number (number->string -1234.75 i) i))))
    
    (let ((val (string->number (number->string 12.5+3.75i i) i)))
      (if (or (not (number? val))
	      (> (abs (- (real-part val) 12.5)) 1e-6)
	      (> (abs (- (imag-part val) 3.75)) 1e-6))
	  (begin 
	    (set! happy #f) 
	    (format #t ";(string->number (number->string 12.5+3.75i ~A) ~A) -> ~A?~%" i i (string->number (number->string 12.5+3.75i i) i)))))
    
    (let ((happy #t))
      (do ((base 2 (+ base 1)))
	  ((or (not happy)
	       (= base 11))) ;;; see s7.c for an explanation of this limit
	(do ((i 0 (+ i 1)))
	    ((= i 10))
	  (let* ((rl (- (random 200.0) 100.0))
		 (im (- (random 200.0) 100.0))
		 (rlstr (number->string rl base))
		 (imstr (number->string im base))
		 (val (make-rectangular rl im))
		 (str (string-append rlstr 
				     (if (or (negative? im)
					     (char=? (string-ref imstr 0) #\-)) ; sigh -- -0.0 is not negative!
					 "" "+") 
				     imstr 
				     "i")))
	    (let* ((sn (string->number str base))
		   (nsn (and (number? sn) (number->string sn base)))
		   (nval (and (string? nsn) (string->number nsn base))))
	      (if (or (not nval)
		      (> (abs (- (real-part nval) (real-part val))) 1e-3)
		      (> (abs (- (imag-part nval) (imag-part val))) 1e-3))
		  (begin
		    (set! happy #f)
		    (format #t ";(number<->string ~S ~A) -> ~A? [~A ~S]~%" str base nval sn nsn)
		    )))))))))
    

(let ((val (number->string 1.0-1.0i)))
  (if (and (not (string=? val "1-1i"))
	   (not (string=? val "1.0-1.0i"))
	   (not (string=? val "1-i"))
	   (not (string=? val "1.0-i")))
      (begin
	(display "(number->string 1.0-1.0i) returned ") (display val) (display "?") (newline))))

(let ()
  (define (make-integer str j digits radix zero-ok)
    (do ((k 0 (+ k 1)))
	((= k digits))
      (if zero-ok
	  (set! (str j) (#(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\a #\b #\c #\d #\e #\f) (random radix)))
	  (set! (str j) (#(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\a #\b #\c #\d #\e #\f) (random (- radix 1)))))
      (set! j (+ j 1)))
    j)
  
  (define (make-ratio str j ndigits ddigits radix)
    (set! j (make-integer str j (+ 1 ndigits) radix #t))
    (set! (str j) #\/)
    (make-integer str (+ j 1) (+ 1 ddigits) radix #f))
  
  (define (make-real str j digits edigits radix)
    (let ((nj (make-integer str j (random digits) radix #t)))
      (set! (str nj) #\.)
      (set! j (make-integer str (+ nj 1) (+ (if (= j nj) 1 0) (random digits)) radix #t))
      (if (and (> edigits 0)
	       (<= radix 10))
	  (begin
	    (set! (str j) #\e)
	    (set! j (make-integer str (+ j 1) (+ 1 (random edigits)) radix #t))))
      j))
  
  (define (make-complex str j digits edigits radix)
    (set! j (make-real str j digits edigits radix))
    (set! (str j) (#(#\+ #\-) (random 2)))
    (set! j (make-real str (+ j 1) digits edigits radix))
    (set! (str j) #\i)
    (+ j 1))
  
  (let ((str (make-string 512))
	(max-digits 10)
	(edigits 2))
    
    (do ((i 0 (+ i 1)))
	((= i 100))
      (let ((j 0)
	    (radix (+ 2 (random 15)))
	    (choice (case (random 10)
		      ((0 1) 'integer)
		      ((2 3) 'ratio)
		      ((4 5 6) 'real)
		      (else 'complex))))
	
	;; possible #e or #i
	(if (and (not (eq? choice 'complex))
		 (> (random 10) 8))
	    (begin
	      (set! (str j) #\#)
	      (set! j (+ j 1))
	      (set! (str j) (#(#\e #\i) (random 2)))
	      (if (char=? (str j) #\e) (set! edigits 0))
	      (set! j (+ j 1))))
	
	;; possible #x etc
	(if (> (random 10) 7)
	    (begin
	      (set! (str j) #\#)
	      (set! j (+ j 1))
	      (let ((rchoice (random 4)))
		(set! (str j) (#(#\b #\d #\o #\x) rchoice))
		(set! radix (#(2 10 8 16) rchoice)))
	      (set! j (+ j 1))))
	
	;; possible sign
	(if (> (random 10) 5)
	    (begin
	      (set! (str j) (#(#\+ #\-) (random 2)))
	      (set! j (+ j 1))))
	
	(set! j (case choice
		  ((integer) (make-integer str j (+ 1 (random max-digits)) radix #t))
		  ((ratio)   (make-ratio str j (random max-digits) (random max-digits) radix))
		  ((real)    (make-real str j max-digits edigits radix))
		  ((complex) (make-complex str j max-digits edigits radix))))
	
	(let ((num (catch #t (lambda () (string->number (substring str 0 j) radix)) (lambda args 'error))))
	  (if (not (number? num))
	      (format *stderr* "(string->number ~S ~D) ~60T~A~%" (substring str 0 j) radix num)))))))

(let ((string->number-2 (lambda (str radix)
			  (let ((old-str (if (string? str) (string-copy str) str)))
			    (let ((val (string->number str radix)))
			      (if (not (string=? str old-str))
				  (error 'string->number-messed-up)
				  val)))))
      (string->number-1 (lambda (str)
			  (let ((old-str (if (string? str) (string-copy str) str)))
			    (let ((val (string->number str)))
			      (if (not (string=? str old-str))
				  (error 'string->number-messed-up)
				  val))))))

  (num-test (string->number-1 "100") 100)
  (num-test (string->number-2 "100" 16) 256)
  (num-test (string->number-2 "100" 2) 4)
  (num-test (string->number-2 "100" 8) 64)
  (num-test (string->number-2 "100" 10) 100)
  (num-test (string->number-2 "11" 16) 17)
  (num-test (string->number-2 "-11" 16) -17)
  (num-test (string->number-2 "+aa" 16) 170)
  (num-test (string->number-2 "-aa" 16) -170)
  
  (for-each
   (lambda (str rval fval)
     (let ((happy #t))
       (do ((radix 3 (+ radix 1)))
	   ((or (not happy)
		(= radix 16)))
	 (let ((val (string->number-2 str radix)))
	   (if (and (number? val)
		    (not (fval val (rval radix) radix)))
	       (begin
		 (display "(string->number \"") (display str) (display "\" ") (display radix) (display ") = ") (display val) (display "?") (newline)
		 (set! happy #f)))))))
   (list "101"
	 "201.02"
	 "1/21"
	 "2e1"
	 "10.1e-1"
	 )
   (list (lambda (radix) (+ 1 (* radix radix)))
	 (lambda (radix) (+ 1.0 (* 2 radix radix) (/ 2.0 (* radix radix))))
	 (lambda (radix) (/ 1 (+ 1 (* 2 radix))))
	 (lambda (radix) (if (< radix 15) (* 2 radix) (+ 1 (* 14 radix) (* 2 radix radix))))
	 (lambda (radix) (+ 1 (/ 1.0 (* radix radix))))
	 )
   (list (lambda (a b radix) (= a b))
	 (lambda (a b radix) (< (abs (- a b)) (/ 1.0 (* radix radix))))
	 (lambda (a b radix) (= a b))
	 (lambda (a b radix) (= a b))
	 (lambda (a b radix) (< (abs (- a b)) (/ 1.0 (* radix radix radix))))
	 ))
  
  (num-test (string->number-2 "34" 2) #f)
  (num-test (string->number-2 "19" 8) #f)
  (num-test (string->number-2 "1c" 10) #f)
  (num-test (string->number-2 "1c" 16) 28)
  
  (test (string->number-1 "") #f )
  (test (string->number-1 ".") #f )
  (test (string->number-1 "d") #f )
  (test (string->number-1 "D") #f )
  (test (string->number-1 "i") #f )
  (test (string->number-1 "I") #f )
  (test (string->number-1 "3i") #f )
  (test (string->number-1 "3I") #f )
  (test (string->number-1 "33i") #f )
  (test (string->number-1 "33I") #f )
  (test (string->number-1 "3.3i") #f )
  (test (string->number-1 "3.3I") #f )
  (test (string->number-1 "-") #f )
  (test (string->number-1 "+") #f )
  
  (test (string->number-1 "#i1-1ei") #f)
  (test (string->number-1 "#i-2e+i") #f)
  (test (string->number-1 "#i1+i1i") #f)
  (test (string->number-1 "#i1+1") #f)
  (test (string->number-1 "#i2i.") #f)
  
  (test (string->number "1e0+i") 1+i)
  (test (string->number "1+ie0") #f)
  (test (string->number "1+e0") #f)
  (test (string->number "1+1e0i") 1+i)
  (test (string->number "1+1e0e0i") #f)
  (test (string->number "1+1e00i") 1+i)
  (test (string->number "1L") #f)
  (test (string->number "1.L") #f)
  (test (string->number "0+I") #f)
  
  (num-test (string->number-1 "3.4e3") 3400.0)
  (num-test (string->number-1 "0") 0)
  (num-test (string->number-1 "#x#e-2e2") -738)
  )

(test (let* ((str "1+0i") (x (string->number str))) (and (number? x) (string=? str "1+0i"))) #t)

(test (= 1 #e1 1/1 #e1/1 #e1.0 #e1e0 #b1 #x1 #o1 #d1 #o001 #o+1 #o#e1 #e#x1 #e1+0i #e10e-1 #e0.1e1 #e+1-0i #e#b1) #t)
;(test (= 0.3 3e-1 0.3e0 3e-1) #t)
(test (= 0 +0 0.0 +0.0 0/1 +0/24 0+0i #e0 #b0 #x0 #o0 #e#b0) #t)

(let ((things (vector 123 #e123 #b1111011 #e#b1111011 #b#e1111011 #o173 #e#o173 #o#e173 
		      #x7b #e#x7b #x#e7b (string->number "123") 246/2 #e123/1 #d123 #e#d123 #d#e123)))
  (do ((i 0 (+ i 1)))
      ((= i (- (vector-length things) 1)))
    (do ((j (+ i 1) (+ j 1)))
	((= j (vector-length things)))
      (if (not (eqv? (vector-ref things i) (vector-ref things j)))
	  (begin
	    (display "(eqv? ") (display (vector-ref things i)) (display " ") (display (vector-ref things j)) (display ") -> #f?") (newline))))))

(for-each
 (lambda (n)
   (let ((nb 
	  (catch #t
		 (lambda ()
		   (number? n))
		 (lambda args
		   'error))))
     (if (not nb)
	 (begin
	   (display "(number? ") (display n) (display ") returned #f?") (newline)))))
 (if (provided? 'dfls-exponents)
     (list 1 -1 +1 +.1 -.1 .1 .0 0. 0.0 -0 +0 -0. +0.
	   +1.1 -1.1 1.1
	   '1.0e2 '-1.0e2 '+1.0e2
	   '1.1e-2 '-1.1e-2 '+1.1e-2
	   '1.1e+2 '-1.1e+2 '+1.1e+2
	   '1/2 '-1/2 '+1/2
	   '1.0s2 '-1.0s2 '+1.0s2
	   '1.0d2 '-1.0d2 '+1.0d2
	   '1.0f2 '-1.0f2 '+1.0f2
	   '1.0l2 '-1.0l2 '+1.0l2
	   '1.0+1.0i '1.0-1.0i '-1.0-1.0i '-1.0+1.0i
	   '1+i '1-i '-1-i '-1+i
	   '2/3+i '2/3-i '-2/3+i
	   '1+2/3i '1-2/3i '2/3+2/3i '2.3-2/3i '2/3-2.3i
	   '2e2+1e3i '2e2-2e2i '2.0e2+i '1+2.0e2i '2.0e+2-2.0e-1i '2/3-2.0e3i '2e-3-2/3i
	   '-2.0e-2-2.0e-2i '+2.0e+2+2.0e+2i '+2/3-2/3i '2e2-2/3i
	   '1e1-i '1.-i '.0+i '-.0-1e-1i '1.+.1i '0.-.1i
	   '.1+.0i '1.+.0i '.1+.1i '1.-.1i '.0+.00i '.10+.0i '-1.+.0i '.1-.01i '1.0+.1i 
	   '1e1+.1i '-1.-.10i '1e01+.0i '0e11+.0i '1.e1+.0i '1.00-.0i '-1e1-.0i '1.-.1e0i 
	   '1.+.001i '1e10-.1i '1e+0-.1i '-0e0-.1i
	   '-1.0e-1-1.0e-1i '-111e1-.1i '1.1-.1e11i '-1e-1-.11i '-1.1-.1e1i '-.1+.1i)
     (list 1 -1 +1 +.1 -.1 .1 .0 0. 0.0 -0 +0 -0. +0.
	   +1.1 -1.1 1.1
	   '1.0e2 '-1.0e2 '+1.0e2
	   '1.1e-2 '-1.1e-2 '+1.1e-2
	   '1.1e+2 '-1.1e+2 '+1.1e+2
	   '1/2 '-1/2 '+1/2
	   '1.0+1.0i '1.0-1.0i '-1.0-1.0i '-1.0+1.0i
	   '1+i '1-i '-1-i '-1+i
	   '2/3+i '2/3-i '-2/3+i
	   '1+2/3i '1-2/3i '2/3+2/3i '2.3-2/3i '2/3-2.3i
	   '2e2+1e3i '2e2-2e2i '2.0e2+i '1+2.0e2i '2.0e+2-2.0e-1i '2/3-2.0e3i '2e-3-2/3i
	   '-2.0e-2-2.0e-2i '+2.0e+2+2.0e+2i '+2/3-2/3i '2e2-2/3i
	   '1e1-i '1.-i '.0+i '-.0-1e-1i '1.+.1i '0.-.1i
	   '.1+.0i '1.+.0i '.1+.1i '1.-.1i '.0+.00i '.10+.0i '-1.+.0i '.1-.01i '1.0+.1i 
	   '1e1+.1i '-1.-.10i '1e01+.0i '0e11+.0i '1.e1+.0i '1.00-.0i '-1e1-.0i '1.-.1e0i 
	   '1.+.001i '1e10-.1i '1e+0-.1i '-0e0-.1i
	   '-1.0e-1-1.0e-1i '-111e1-.1i '1.1-.1e11i '-1e-1-.11i '-1.1-.1e1i '-.1+.1i)))

(for-each
 (lambda (n rl im)
   (if (not (number? n))
       (begin
	 (display "(number? ") (display n) (display ") returned #f?") (newline))
       (begin
	 (if (> (abs (- (real-part n) rl)) .000001)
	     (begin
	       (display "real-part: ") (display n) (display " ") (display (real-part n)) (display " ") (display rl) (newline)))
	 (if (> (abs (- (imag-part n) im)) .000001)
	     (begin
	       (display "imag-part: ") (display n) (display " ") (display (imag-part n)) (display " ") (display im) (newline)))
	 )))
 (list 1 -1 +1 +.1 -.1 .1 .0 0. 0.0 -0 +0 -0. +0.
       +1.1 -1.1 1.1
       '1.0e2 '-1.0e2 '+1.0e2
       '1.1e-2 '-1.1e-2 '+1.1e-2
       '1.1e+2 '-1.1e+2 '+1.1e+2
       '1/2 '-1/2 '+1/2

       '1.0+1.0i '1.0-1.0i '-1.0-1.0i '-1.0+1.0i
       '1+i '1-i '-1-i '-1+i
       '2/3+i '2/3-i '-2/3+i
       '1+2/3i '1-2/3i '2/3+2/3i '2.3-2/3i '2/3-2.3i
       '2e2+1e3i '2e2-2e2i '2.0e2+i '1+2.0e2i '2.0e+2-2.0e-1i '2/3-2.0e3i '2e-3-2/3i
       '-2.0e-2-2.0e-2i '+2.0e+2+2.0e+2i '+2/3-2/3i '2e2-2/3i
       '1e1-i '1.-i '.0+i '-.0-1e-1i '1.+.1i '0.-.1i
       '.1+.0i '1.+.0i '.1+.1i '1.-.1i '.0+.00i '.10+.0i '-1.+.0i '.1-.01i '1.0+.1i 
       '1e1+.1i '-1.-.10i '1e01+.0i '0e11+.0i '1.e1+.0i '1.00-.0i '-1e1-.0i '1.-.1e0i 
       '1.+.001i '1e10-.1i '1e+0-.1i '-0e0-.1i
       '-1.0e-1-1.0e-1i '-111e1-.1i '1.1-.1e11i '-1e-1-.11i '-1.1-.1e1i)
 
 (list 1.0 -1.0 1.0 0.1 -0.1 0.1 0.0 0.0 0.0 0.0 0.0 -0.0 0.0 1.1 -1.1 1.1 100.0 -100.0 
       100.0 0.011 -0.011 0.011 110.0 -110.0 110.0 0.5 -0.5 0.5 
       1.0 1.0 -1.0 -1.0 1.0 1.0 -1.0 
       -1.0 0.66666666666667 0.66666666666667 -0.66666666666667 1.0 1.0 0.66666666666667 
       2.3 0.66666666666667 200.0 200.0 200.0 1.0 200.0 0.66666666666667 0.002 -0.02 200.0 
       0.66666666666667 200.0 10.0 1.0 0.0 -0.0 1.0 0.0 0.1 1.0 0.1 1.0 0.0 0.1 -1.0 0.1 
       1.0 10.0 -1.0 10.0 0.0 10.0 1.0 -10.0 1.0 1.0 10000000000.0 1.0 -0.0 -0.1 -1110.0 
       1.1 -0.1 -1.1)
 
 (list 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 
       0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 -1.0 
       -1.0 1.0 1.0 -1.0 -1.0 1.0 1.0 -1.0 1.0 0.66666666666667 -0.66666666666667 
       0.66666666666667 -0.66666666666667 -2.3 1000.0 -200.0 1.0 200.0 -0.2 -2000.0 
       -0.66666666666667 -0.02 200.0 -0.66666666666667 -0.66666666666667 -1.0 -1.0 1.0 
       -0.1 0.1 -0.1 0.0 0.0 0.1 -0.1 0.0 0.0 0.0 -0.01 0.1 0.1 -0.1 0.0 0.0 0.0 0.0 
       0.0 -0.1 0.001 -0.1 -0.1 -0.1 -0.1 -0.1 -10000000000.0 -0.11 -1.0))


(for-each
 (lambda (n name)
   (if (number? n)
       (begin
	 (display "(number? ") (display name) (display ") returned #t?") (newline)))
   (if (or (not (symbol? n))
	   (boolean? n))
       (begin
	 (display "(symbol? ") (display name) (display ") returned #f?") (newline)))
   (if (number? (string->number name))
       (begin
	 (display "(string->number ") (display name) (display ") returned ") (display (string->number name)) (display "?") (newline))))
 
 (list '1e '--1 '++1 '+. '+.+ '.. '.- '1e- '+ '- '-e1
       '1/2/3 '1/2+/2 '/2 '2/ '1+2 '1/+i '1/2e1 '1/2.
       '1..0 '1.+0 '1--1 '1+- '1.0++i '1.0-ie++2 '1+1 '1.0. '1.0e
       '1ee2 '1.0e2e2 '1es2 '1e1.0 '1.0.0 '1/2.0 '1+i2 '1+1.0i0
       '+.i 'i 'e 'e1 '1e.1 '1+.i '1.0e.1
       '-.1ei '-1.0+1.0 '1.0+1.0i+1.0 '1.1/2 '1/2.0
       '1/e '1/i 'e/i '1e2/3 '2/1e2 '1e2+1e2ii '1i-1.0 '1.0-i/2
       '1/2i '2i/3 '2+/i '2+2/i '2+2/-i '2/- '2/+ '2/+3
       '1e1.0 '1e1e2 '1+ie2 '1ei1 '1e/2 '0-- '1+ '1- '.1. '.1+
       '1//2 '1/-/2 '1/2/ '1// '+/1 '.0.
       '+0ei '0e++i '+0e+i '0e+-i '+0e-i '+00ei '+.0ei '0+0ei '-01ei '+.1ei 
       '1-1ei '-1.ei '0+.i '0-.i '1+e0i '1+/0i '1-/0i '1+e1i '1+/1i '10+.i 
       '.0+.i '-0+.i '.1+.i '0.+.i '00-.i '.1-.i '1.-.i '1e++0i '1e--1i '.1e++i 
       '+10e+i '1+0e+i '+01e+i '+0e+-i '.1e+-i '1-10ei '0e++00i '1e--.1i '1.e-+1i 
       '1-0.e+i '1.+1e+i '-1.e--i '1.e+-.0i '1-e+01i '1-/101i '1+/10i '1-e10i 
       '-1+e+1i '.1-e-1i '1-/0e1i '1e10+.i '1/1.1+i '1/11.+i 
       '1/2e1-i '-1.0e-1-1-1.0e-1i '-1.0e-1-1.0e-1-1i
       '1.0e2/3 '-1e--1.e1i '-11e--1e1i '1e--1.1e1i '1.e-1-1.ei '-1.e--1.ei 
       '-1.1e1-e1i '-1.e1-e-1i '.1e1-e-11i 
       '3.-3. '1'2 '+-2 '1?
       '1a '1.a '-a '+a '1.. '..1 '-..1 '1ee1 '1ef2 '1+ief2 '1.+ '1.0- '1/2+/3
       '1'2 '1-#i '1-i. '1-ie '1... '1/1/1/1 '1//1 '-.e1
       )
 (list "1e" "--1" "++1" "+." "+.+" ".." ".-" "1e-" "+" "-" "-e1"
       "1/2/3" "1/2+/2" "/2" "2/" "1+2" "1/+i" "1/2e1" "1/2."
       "1..0" "1.+0" "1--1" "1+-" "1.0++i" "1.0-ie++2" "1+1" "1.0." "1.0e"
       "1ee2" "1.0e2e2" "1es2" "1e1.0" "1.0.0" "1/2.0" "1+i2" "1+1.0i0" 
       "+.i" "i" "e" "e1" "1e.1" "1+.i" "1.0e.1" 
       "-.1ei" "-1.0+1.0" "1.0+1.0i+1.0" "1.1/2" "1/2.0" 
       "1/e" "1/i" "e/i" "1e2/3" "2/1e2" "1e2+1e2ii" "1i-1.0" "1.0-i/2" 
       "1/2i" "2i/3" "2+/i" "2+2/i" "2+2/-i" "2/-" "2/+" "2/+3" 
       "1e1.0" "1e1e2" "1+ie2" "1ei1" "1e/2" "0--" "1+" "1-" ".1." ".1+" 
       "1//2" "1/-/2" "1/2/" "1//" "+/1" ".0."
       "+0ei" "0e++i" "+0e+i" "0e+-i" "+0e-i" "+00ei" "+.0ei" "0+0ei" "-01ei" "+.1ei" 
       "1-1ei" "-1.ei" "0+.i" "0-.i" "1+e0i" "1+/0i" "1-/0i" "1+e1i" "1+/1i" "10+.i" 
       ".0+.i" "-0+.i" ".1+.i" "0.+.i" "00-.i" ".1-.i" "1.-.i" "1e++0i" "1e--1i" ".1e++i" 
       "+10e+i" "1+0e+i" "+01e+i" "+0e+-i" ".1e+-i" "1-10ei" "0e++00i" "1e--.1i" "1.e-+1i" 
       "1-0.e+i" "1.+1e+i" "-1.e--i" "1.e+-.0i" "1-e+01i" "1-/101i" "1+/10i" "1-e10i" 
       "-1+e+1i" ".1-e-1i" "1-/0e1i" "1e10+.i" "1/1.1+i" "1/11.+i" 
       "1/2e1-i" "-1.0e-1-1-1.0e-1i" "-1.0e-1-1.0e-1-1i" 
       "1.0e2/3" "-1e--1.e1i" "-11e--1e1i" "1e--1.1e1i" "1.e-1-1.ei" "-1.e--1.ei" 
       "-1.1e1-e1i" "-1.e1-e-1i" ".1e1-e-11i" 
       "3.-3." "'1'2" "'+-2" "'1?"
       "1a" "1.a" "-a" "+a" "1.." "..1" "-..1" "1ee1" "1ef2" "1+ief2" "1.+" "1.0-" "1/2+/3"
       "'1'2" "1-#i" "1-i." "1-ie" "1..." "1/1/1/1" "1//1" "-.e1"
       ))

(let ((val (catch #t 
		  (lambda ()
		    (= 1 
		       
		       01 +1 1. 
		       
		       001 +01 1/1 1.0 1e0 01. +1. #b1 #d1 #e1 #o1 #x1 2/2 3/3 4/4 5/5 6/6 7/7 8/8 9/9
		       1E0 1e0
		       
		       0001 +001 1/01 .1e1 01/1 +1/1 1.00 1e00 01.0 +1.0 1e+0 1e-0 01e0 +1e0 1.e0 001. +01. 1+0i 1-0i 
		       #b+1 #b01 #b1. #d+1 #d01 #d1. #e+1 #e01 #e1. #i+1 #i01 #i1. #o+1 #o01 #o1. #x+1 #x01 #x1.
		       +1E0 +1e0 +2/2 +3/3 +4/4 +5/5 +6/6 +7/7 +8/8 +9/9
		       .1E1 0001 001. 01.0 01/1 01E0
		       02/2 03/3 04/4 05/5 06/6 07/7 08/8 09/9  
		       1.E0 1/01 1E+0 1E-0 1E00 
		       2/02 3/03 4/04 5/05 6/06 7/07 8/08 9/09 
		       
		       11/11 00001 +0001 1/001 .1e01 01/01 +1/01 .1e+1 10e-1 0.1e1 +.1e1 .10e1 001/1 +01/1 10/10 1.000 1e000 
		       01.00 +1.00 1e+00 1e-00 01e00 +1e00 1.e00 001.0 +01.0 01e+0 +1e+0 1.e+0 01e-0 +1e-0 1.e-0 001e0 +01e0 
		       1.0e0 01.e0 +1.e0 0001. +001. 1+00i 1-00i 1+.0i 1-.0i 01+0i +1+0i 1.+0i 01-0i +1-0i 1.-0i 1+0.i 1-0.i 
		       
		       11/011 011/11 +11/11 000001 +00001 1/0001 .1e001 01/001 +1/001 .1e+01 10e-01 0.1e01 +.1e01 .10e01 001/01 
		       +01/01 0.1e+1 +.1e+1 .10e+1 010e-1 +10e-1 10.e-1 00.1e1 +0.1e1 0.10e1 +.10e1 .100e1 0001/1 +001/1 10/010 
		       010/10 +10/10 1.0000 1e0000 01.000 +1.000 1e+000 1e-000 01e000 +1e000 1.e000 001.00 +01.00 01e+00 +1e+00 
		       1.e+00 01e-00 +1e-00 1.e-00 001e00 +01e00 1.0e00 01.e00 +1.e00 0001.0 +001.0 001e+0 +01e+0 1.0e+0 01.e+0 
		       +1.e+0 001e-0 +01e-0 1.0e-0 01.e-0 +1.e-0 0001e0 +001e0 1.00e0 01.0e0 +1.0e0 001.e0 +01.e0 00001. +0001. 
		       1+0e1i 1-0e1i 1+0/1i 1-0/1i 1+000i 1-000i 1+.00i 1-.00i 01+00i +1+00i 1.+00i 01-00i +1-00i 1.-00i 1+0.0i 
		       1-0.0i 01+.0i +1+.0i 1.+.0i 01-.0i +1-.0i 1.-.0i 001+0i +01+0i 1/1+0i 1.0+0i 1e0+0i 01.+0i +1.+0i 001-0i 
		       +01-0i 1/1-0i 1.0-0i 1e0-0i 01.-0i +1.-0i 1+0e0i 1-0e0i 1+00.i 1-00.i 01+0.i +1+0.i 1.+0.i 01-0.i +1-0.i 
		       1.-0.i 
		       
		       111/111 11/0011 011/011 +11/011 0011/11 +011/11 101/101 0000001 +000001 1/00001 .1e0001 01/0001 +1/0001 
		       .1e+001 10e-001 0.1e001 +.1e001 .10e001 001/001 +01/001 0.1e+01 +.1e+01 .10e+01 010e-01 +10e-01 10.e-01 
		       00.1e01 +0.1e01 0.10e01 +.10e01 .100e01 0001/01 +001/01 00.1e+1 +0.1e+1 0.10e+1 +.10e+1 .100e+1 0010e-1 
		       +010e-1 10.0e-1 010.e-1 +10.e-1 000.1e1 +00.1e1 00.10e1 +0.10e1 0.100e1 +.100e1 .1000e1 00001/1 +0001/1 
		       110/110 10/0010 010/010 +10/010 0010/10 +010/10 100/100 1.00000 1e00000 01.0000 +1.0000 1e+0000 1e-0000 
		       01e0000 +1e0000 1.e0000 001.000 +01.000 01e+000 +1e+000 1.e+000 01e-000 +1e-000 1.e-000 001e000 +01e000 
		       1.0e000 01.e000 +1.e000 0001.00 +001.00 001e+00 +01e+00 1.0e+00 01.e+00 +1.e+00 001e-00 +01e-00 1.0e-00 
		       01.e-00 +1.e-00 0001e00 +001e00 1.00e00 01.0e00 +1.0e00 001.e00 +01.e00 00001.0 +0001.0 0001e+0 +001e+0 
		       1.00e+0 01.0e+0 +1.0e+0 001.e+0 +01.e+0 0001e-0 +001e-0 1.00e-0 01.0e-0 +1.0e-0 001.e-0 +01.e-0 00001e0 
		       +0001e0 1.000e0 01.00e0 +1.00e0 001.0e0 +01.0e0 0001.e0 +001.e0 000001. +00001. 1+0e11i 1-0e11i 1+0/11i 
		       1-0/11i 1+0e01i 1-0e01i 1+0/01i 1-0/01i 1+0e+1i 1-0e+1i 1+0e-1i 1-0e-1i 1+00e1i 1-00e1i 1+.0e1i 1-.0e1i 
		       01+0e1i +1+0e1i 1.+0e1i 01-0e1i +1-0e1i 1.-0e1i 1+0.e1i 1-0.e1i 1+00/1i 1-00/1i 01+0/1i +1+0/1i 1.+0/1i 
		       01-0/1i +1-0/1i 1.-0/1i 1+0e10i 1-0e10i 1+0/10i 1-0/10i 1+0000i 1-0000i 1+.000i 1-.000i 01+000i +1+000i 
		       1.+000i 01-000i +1-000i 1.-000i 1+0.00i 1-0.00i 01+.00i +1+.00i 1.+.00i 01-.00i +1-.00i 1.-.00i 001+00i 
		       +01+00i 1/1+00i 1.0+00i 1e0+00i 01.+00i +1.+00i 001-00i +01-00i 1/1-00i 1.0-00i 1e0-00i 01.-00i +1.-00i 
		       1+0e00i 1-0e00i 1+00.0i 1-00.0i 01+0.0i +1+0.0i 1.+0.0i 01-0.0i +1-0.0i 1.-0.0i 001+.0i +01+.0i 1/1+.0i 
		       1.0+.0i 1e0+.0i 01.+.0i +1.+.0i 001-.0i +01-.0i 1/1-.0i 1.0-.0i 1e0-.0i 01.-.0i +1.-.0i 0001+0i +001+0i 
		       1/01+0i .1e1+0i 01/1+0i +1/1+0i 1.00+0i 1e00+0i 01.0+0i +1.0+0i 1e+0+0i 1e-0+0i 01e0+0i +1e0+0i 1.e0+0i 
		       001.+0i +01.+0i 1+0e+0i 1-0e+0i 0001-0i +001-0i 1/01-0i .1e1-0i 01/1-0i +1/1-0i 1.00-0i 1e00-0i 01.0-0i 
		       +1.0-0i 1e+0-0i 1e-0-0i 01e0-0i +1e0-0i 1.e0-0i 001.-0i +01.-0i 1+0e-0i 1-0e-0i 1+00e0i 1-00e0i 1+.0e0i 
		       1-.0e0i 01+0e0i +1+0e0i 1.+0e0i 01-0e0i +1-0e0i 1.-0e0i 1+0.e0i 1-0.e0i 1+000.i 1-000.i 01+00.i +1+00.i 
		       1.+00.i 01-00.i +1-00.i 1.-00.i 001+0.i +01+0.i 1/1+0.i 1.0+0.i 1e0+0.i 01.+0.i +1.+0.i 001-0.i +01-0.i 
		       1/1-0.i 1.0-0.i 1e0-0.i 01.-0.i +1.-0.i 
		       
		       111/0111 0111/111 +111/111 11/00011 011/0011 +11/0011 0011/011 +011/011 00011/11 +0011/11 101/0101 0101/101 
		       +101/101 00000001 +0000001 1/000001 .1e00001 01/00001 +1/00001 .1e+0001 10e-0001 0.1e0001 +.1e0001 .10e0001 
		       001/0001 +01/0001 0.1e+001 +.1e+001 .10e+001 010e-001 +10e-001 10.e-001 00.1e001 +0.1e001 0.10e001 +.10e001 
		       .100e001 0001/001 +001/001 00.1e+01 +0.1e+01 0.10e+01 +.10e+01 .100e+01 0010e-01 +010e-01 10.0e-01 010.e-01 
		       +10.e-01 000.1e01 +00.1e01 00.10e01 +0.10e01 0.100e01 +.100e01 .1000e01 00001/01 +0001/01 000.1e+1 +00.1e+1 
		       00.10e+1 +0.10e+1 0.100e+1 +.100e+1 .1000e+1 00010e-1 +0010e-1 10.00e-1 010.0e-1 +10.0e-1 0010.e-1 +010.e-1 
		       0000.1e1 +000.1e1 000.10e1 +00.10e1 00.100e1 +0.100e1 0.1000e1 +.1000e1 .10000e1 000001/1 +00001/1 110/0110 
		       0110/110 +110/110 10/00010 010/0010 +10/0010 0010/010 +010/010 00010/10 +0010/10 100/0100 0100/100 +100/100 
		       1.000000 1e000000 01.00000 +1.00000 1e+00000 1e-00000 01e00000 +1e00000 1.e00000 001.0000 +01.0000 01e+0000 
		       +1e+0000 1.e+0000 01e-0000 +1e-0000 1.e-0000 001e0000 +01e0000 1.0e0000 01.e0000 +1.e0000 0001.000 +001.000 
		       001e+000 +01e+000 1.0e+000 01.e+000 +1.e+000 001e-000 +01e-000 1.0e-000 01.e-000 +1.e-000 0001e000 +001e000 
		       1.00e000 01.0e000 +1.0e000 001.e000 +01.e000 00001.00 +0001.00 0001e+00 +001e+00 1.00e+00 01.0e+00 +1.0e+00 
		       001.e+00 +01.e+00 0001e-00 +001e-00 1.00e-00 01.0e-00 +1.0e-00 001.e-00 +01.e-00 00001e00 +0001e00 1.000e00 
		       01.00e00 +1.00e00 001.0e00 +01.0e00 0001.e00 +001.e00 000001.0 +00001.0 00001e+0 +0001e+0 1.000e+0 01.00e+0 
		       +1.00e+0 001.0e+0 +01.0e+0 0001.e+0 +001.e+0 00001e-0 +0001e-0 1.000e-0 01.00e-0 +1.00e-0 001.0e-0 +01.0e-0
		       0001.e-0 +001.e-0 000001e0 +00001e0 1.0000e0 01.000e0 +1.000e0 001.00e0 +01.00e0 0001.0e0 +001.0e0 00001.e0 
		       +0001.e0 0000001. +000001.))
		  (lambda args 'error))))
  (if (not (eq? val #t))
      (format #t ";funny 1's are not all equal to 1? ~A~%" val)))


(for-each
 (lambda (lst)
   (for-each
    (lambda (str)
      (let ((val (catch #t (lambda () (string->number str)) (lambda args 'error))))
	(if (or (not (number? val))
		(> (abs (- val 1.0)) 1.0e-15))
	    (format #t ";(string->number ~S) = ~A?~%" str val))))
    lst))
 (list
  (list "1")
  
  (list "01" "+1" "1.")
  
  (list "001" "+01" "#e1" "#i1" "1/1" "#b1" "#x1" "#d1" "#o1" "1.0" "1e0" "9/9" "01." "+1." "1E0")
  
  (list "0001" "+001" "#e01" "#i01" "1/01" "#b01" "#x01" "#d01" "#o01" "#e+1" "#i+1" "#b+1" "#x+1" "#d+1" "#o+1" ".1e1" "01/1" "+1/1" "1.00" "1e00" "01.0" "+1.0" "1e+0" "1e-0" "01e0" "+1e0" "1.e0" "9/09" "09/9" "+9/9" "001." "+01." "#e1." "#i1." "1+0i" "1-0i" "#d1.")
  
  (list "11/11" "00001" "+0001" "#e001" "#i001" "1/001" "#b001" "#x001" "#d001" "#o001" "#e+01" "#i+01" "#b+01" "#x+01" "#d+01" "#o+01" ".1e01" "01/01" "+1/01" "91/91" ".1e+1" "10e-1" "0.1e1" "+.1e1" ".10e1" "#b#e1" "#x#e1" "#d#e1" "#o#e1" "#b#i1" "#x#i1" "#d#i1" "#o#i1" "001/1" "+01/1" "#e1/1" "#i1/1" "#b1/1" "#x1/1" "#d1/1" "#o1/1" "#e#b1" "#i#b1" "#e#x1" "#i#x1" "#e#d1" "#i#d1" "#e#o1" "#i#o1" "10/10" "1.000" "1e000" "01.00" "+1.00" "1e+00" "1e-00" "01e00" "+1e00" "1.e00" "90/90" "001.0" "+01.0" "#e1.0" "#i1.0" "01e+0" "+1e+0" "1.e+0" "01e-0" "+1e-0" "1.e-0" "001e0" "+01e0" "#e1e0" "#i1e0" "1.0e0" "01.e0" "+1.e0" "19/19" "9/009" "09/09" "+9/09" "99/99" "009/9" "+09/9" "#e9/9" "#i9/9" "#x9/9" "#d9/9" "0001." "+001." "#e01." "#i01." "#e+1." "#i+1." "#xe/e" "1+00i" "1-00i" "1+.0i" "1-.0i" "01+0i" "+1+0i" "1.+0i" "01-0i" "+1-0i" "1.-0i" "1+0.i" "1-0.i" "#xb/b" "#xd/d" "#xf/f")
  
  ;; remove "9":
  
  (list "11/011" "011/11" "+11/11" "000001" "+00001" "#e0001" "#i0001" "1/0001" "#b0001" "#x0001" "#d0001" "#o0001" "#e+001" "#i+001" "#b+001" "#x+001" "#d+001" "#o+001" ".1e001" "01/001" "+1/001" ".1e+01" "10e-01" "0.1e01" "+.1e01" ".10e01" "#b#e01" "#x#e01" "#d#e01" "#o#e01" "#b#i01" "#x#i01" "#d#i01" "#o#i01" "001/01" "+01/01" "#e1/01" "#i1/01" "#b1/01" "#x1/01" "#d1/01" "#o1/01" "#e#b01" "#i#b01" "#e#x01" "#i#x01" "#e#d01" "#i#d01" "#e#o01" "#i#o01" "0.1e+1" "+.1e+1" ".10e+1" "#b#e+1" "#x#e+1" "#d#e+1" "#o#e+1" "#b#i+1" "#x#i+1" "#d#i+1" "#o#i+1" "#e#b+1" "#i#b+1" "#e#x+1" "#i#x+1" "#e#d+1" "#i#d+1" "#e#o+1" "#i#o+1" "010e-1" "+10e-1" "10.e-1" "00.1e1" "+0.1e1" "#e.1e1" "#i.1e1" "0.10e1" "+.10e1" ".100e1" "0001/1" "+001/1" "#e01/1" "#i01/1" "#b01/1" "#x01/1" "#d01/1" "#o01/1" "#e+1/1" "#i+1/1" "#b+1/1" "#x+1/1" "#d+1/1" "#o+1/1" "10/010" "010/10" "+10/10" "1.0000" "1e0000" "01.000" "+1.000" "1e+000" "1e-000" "01e000" "+1e000" "1.e000" "001.00" "+01.00" "#e1.00" "#i1.00" "01e+00" "+1e+00" "1.e+00" "01e-00" "+1e-00" "1.e-00" "001e00" "+01e00" "#e1e00" "#i1e00" "1.0e00" "01.e00" "+1.e00" "0001.0" "+001.0" "#e01.0" "#i01.0" "#e+1.0" "#i+1.0" "001e+0" "+01e+0" "#e1e+0" "#i1e+0" "1.0e+0" "01.e+0" "+1.e+0" "001e-0" "+01e-0" "#e1e-0" "#i1e-0" "1.0e-0" "01.e-0" "+1.e-0" "0001e0" "+001e0" "#e01e0" "#i01e0" "#e+1e0" "#i+1e0" "1.00e0" "01.0e0" "+1.0e0" "001.e0" "+01.e0" "#e1.e0" "#i1.e0" "00001." "+0001." "#e001." "#i001." "#e+01." "#i+01." "#xe/0e" "#x0e/e" "#x+e/e" "1+0e1i" "1-0e1i" "1+0/1i" "1-0/1i" "1+000i" "1-000i" "1+.00i" "1-.00i" "01+00i" "+1+00i" "1.+00i" "01-00i" "+1-00i" "1.-00i" "1+0.0i" "1-0.0i" "01+.0i" "+1+.0i" "1.+.0i" "01-.0i" "+1-.0i" "1.-.0i" "001+0i" "+01+0i" "#e1+0i" "#i1+0i" "1/1+0i" "1.0+0i" "1e0+0i" "01.+0i" "+1.+0i" "001-0i" "+01-0i" "#e1-0i" "#i1-0i" "1/1-0i" "1.0-0i" "1e0-0i" "01.-0i" "+1.-0i" "1+0e0i" "1-0e0i" "1+00.i" "1-00.i" "01+0.i" "+1+0.i" "1.+0.i" "01-0.i" "+1-0.i" "1.-0.i" "#xb/0b" "#x0b/b" "#x+b/b" "#xd/0d" "#x0d/d" "#x+d/d" "#xf/0f" "#x0f/f" "#x+f/f")
  
  (list "111/111" "11/0011" "011/011" "+11/011" "0011/11" "+011/11" "#e11/11" "#i11/11" "#b11/11" "#x11/11" "#d11/11" "#o11/11" "101/101" "0000001" "+000001" "#e00001" "#i00001" "1/00001" "#b00001" "#x00001" "#d00001" "#o00001" "#e+0001" "#i+0001" "#b+0001" "#x+0001" "#d+0001" "#o+0001" ".1e0001" "01/0001" "+1/0001" ".1e+001" "10e-001" "0.1e001" "+.1e001" ".10e001" "#b#e001" "#x#e001" "#d#e001" "#o#e001" "#b#i001" "#x#i001" "#d#i001" "#o#i001" "001/001" "+01/001" "#e1/001" "#i1/001" "#b1/001" "#x1/001" "#d1/001" "#o1/001" "#e#b001" "#i#b001" "#e#x001" "#i#x001" "#e#d001" "#i#d001" "#e#o001" "#i#o001" "0.1e+01" "+.1e+01" ".10e+01" "#b#e+01" "#x#e+01" "#d#e+01" "#o#e+01" "#b#i+01" "#x#i+01" "#d#i+01" "#o#i+01" "#e#b+01" "#i#b+01" "#e#x+01" "#i#x+01" "#e#d+01" "#i#d+01" "#e#o+01" "#i#o+01" "010e-01" "+10e-01" "10.e-01" "1.00000" "1e00000" "01.0000" "+1.0000" "1e+0000" "1e-0000" "01e0000" "+1e0000" "1.e0000" "001.000" "+01.000" "#e1.000" "#i1.000" "#d1.000" "01e+000" "+1e+000" "1.e+000" "01e-000" "+1e-000" "1.e-000" "001e000" "+01e000" "#e1e000" "#i1e000" "#d1e000" "1.0e000" "+1.e000" "0001.00" "+001.00" "#e01.00" "#i01.00" "#d01.00" "#e+1.00" "#i+1.00" "#d+1.00" "001e+00" "+01e+00" "#e1e+00" "#i1e+00" "#d1e+00" "1.0e+00" "01.e+00" "+1.e+00" "001e-00" "+01e-00" "#e1e-00" "#i1e-00" "#d1e-00" "1.0e-00" "01.e-00" "+1.e-00" "000001." "+00001." "#e0001." "#i0001." "#d0001." "#e+001." "#i+001." "#d+001." "#d#e01." "#d#i01." "#e#d01." "#i#d01." "#d#e+1." "#d#i+1." "#e#d+1." "#i#d+1." "#x1e/1e" "#xe/00e" "#x0e/0e" "#x+e/0e" "#xee/ee" "#x00e/e" "#x+0e/e" "#x#ee/e" "#x#ie/e" "#e#xe/e" "#i#xe/e" "#xbe/be" "#xde/de" "1+0e11i" "1-0e11i" "1+0/11i" "1-0/11i" "1+0e01i" "1-0e01i" "1+0/01i" "1-0/01i" "1+0e+1i" "1-0e+1i" "1+0e-1i" "1-0e-1i" "1+00e1i" "1-00e1i" "1+.0e1i" "1-.0e1i" "01+0e1i" "+1+0e1i" "1.+0e1i" "01-0e1i" "+1-0e1i" "1.-0e1i" "1+0.e1i" "1-0.e1i" "1+00/1i" "1-00/1i" "01+0/1i" "+1+0/1i" "1.+0/1i" "01-0/1i" "+1-0/1i" "1.-0/1i" "1+0e10i" "1-0e10i" "1+0/10i" "1-0/10i" "1+0000i" "1-0000i" "1+.000i" "1-.000i" "01+000i" "+1+000i" "1.+000i" "01-000i" "+1-000i" "1.-000i" "1+0.00i" "1-0.00i" "01+.00i" "+1+.00i" "1.+.00i" "01-.00i" "+1-.00i" "1.-.00i" "001+00i" "+01+00i" "#e1+00i" "#i1+00i" "1/1+00i" "#b1+00i" "#x1+00i" "#d1+00i" "#o1+00i" "1.0+00i" "1e0+00i" "01.+00i" "+1.+00i" "001-00i" "+01-00i" "#e1-00i" "#i1-00i" "1/1-00i" "#b1-00i" "#x1-00i" "#d1-00i" "#o1-00i" "1.0-00i" "1e0-00i" "01.-00i" "+1.-00i" "1+0e00i" "1-0e00i" "1+00.0i" "1-00.0i" "01+0.0i" "+1+0.0i" "1.+0.0i" "01-0.0i" "+1-0.0i" "1.-0.0i" "001+.0i" "+01+.0i" "#e1+.0i" "#i1+.0i" "1/1+.0i" "#d1+.0i" "1.0+.0i" "1e0+.0i" "01.+.0i" "+1.+.0i" "001-.0i" "+01-.0i" "#e1-.0i" "#i1-.0i" "1/1-.0i" "#d1-.0i" "1.0-.0i" "1e0-.0i" "01.-.0i" "+1.-.0i" "0001+0i" "+001+0i" "#e01+0i" "#i01+0i" "1/01+0i" "#b01+0i" "#x01+0i" "#d01+0i" "#o01+0i" "#e+1+0i" "#i+1+0i" "#b+1+0i" "#x+1+0i" "#d+1+0i" "#o+1+0i" ".1e1+0i" "01/1+0i" "+1/1+0i" "1.00+0i" "1e00+0i" "01.0+0i" "+1.0+0i" "1e+0+0i" "1e-0+0i" "01e0+0i" "+1e0+0i" "1.e0+0i" "001.+0i" "+01.+0i" "#e1.+0i" "#i1.+0i" "#d1.+0i" "1+0e+0i" "1-0e+0i" "0001-0i" "+001-0i" "#e01-0i" "#i01-0i" "1/01-0i" "#b01-0i" "#x01-0i" "#d01-0i" "#o01-0i" "#e+1-0i" "#i+1-0i" "#b+1-0i" "#x+1-0i" "#d+1-0i" "#o+1-0i" ".1e1-0i" "01/1-0i" "+1/1-0i" "1.00-0i" "1e00-0i" "01.0-0i" "+1.0-0i" "1e+0-0i" "1e-0-0i" "01e0-0i" "+1e0-0i" "1.e0-0i" "001.-0i" "+01.-0i" "#e1.-0i" "#i1.-0i" "#d1.-0i" "1+0e-0i" "1-0e-0i" "1+00e0i" "1-00e0i" "1+.0e0i" "1-.0e0i" "01+0e0i" "+1+0e0i" "1.+0e0i" "01-0e0i" "+1-0e0i" "1.-0e0i" "1+0.e0i" "1-0.e0i"	"1+000.i" "1-000.i" "01+00.i" "+1+00.i" "1.+00.i" "01-00.i" "+1-00.i" "1.-00.i" "001+0.i" "+01+0.i" "#e1+0.i" "#i1+0.i" "1/1+0.i" "#d1+0.i" "1.0+0.i" "1e0+0.i" "+1.+0.i" "001-0.i" "+01-0.i" "#e1-0.i" "#i1-0.i" "1/1-0.i" "#d1-0.i" "1.0-0.i" "1e0-0.i" "01.-0.i" "+1.-0.i" "#xb/00b" "#x0b/0b" "#x+b/0b" "#xeb/eb" "#x00b/b" "#x+0b/b" "#x#eb/b" "#x#ib/b" "#e#xb/b" "#i#xb/b" "#xbb/bb" "#xdb/db" "#xd/00d" "#x0d/0d" "#x+d/0d" "#xed/ed")
  
;;; selected ones...
  
  (list "#i+11/011" "+101/0101" "#o#e11/11" "#d+11/011" "#e1/0001" "#e#b+001" "#e10e-1"
	"#x#e1/001" "000000001" "#i+.1e+01" "#d+.1e+01" "00.10e+01" "+0.10e+01" "#e.10e+01" "#i.10e+01" "#d.10e+01"
	"#e.10e+01" "#i10.0e-01" "+010.e-01" "#e10.e-01" "#e00.1e01" "#e#d.1e01" "#i#d1e0+0e0i" 
	"#e#d10e-1+0e-2i" "#e#d1e0+0e-2i" "#i#d+0.001e+03+0.0e-10i" "#i#d+1/1-0/1i"
	)
  ))

(for-each
 (lambda (str)
   (let ((val (catch #t (lambda () (string->number str)) (lambda args 'error))))
     (if (or (not (number? val))
	     (= val 1))
	 (format #t ";(string->number ~S = ~A?~%" str val))))
 (list "011e0" "11e-00" "00.e01-i" "+10e10+i" "+1.110+i" "10011-0i" "-000.111" "0.100111" "-11.1111" "10.00011" "110e00+i" 
       "1e-011+i" "101001+i" "+11e-0-0i" "11+00e+0i" "-11101.-i" "1110e-0-i"))

(for-each
 (lambda (str)
   (test (string->number str) #f)) ; an error but string->number is not supposed to return an error -- just #f or a number
 (list "#e1+i" "#e1-i" "#e01+i" "#e+1+i" "#e1.+i" "#e01-i" "#e+1-i" "#e1.-i" "#e1+1i" "#e1-1i"))

(num-test (let ((0- 1) (1+ 2) (-0+ 3) (1e 4) (1/+2 5) (--1 6)) (+ 0- 1+ -0+ 1e 1/+2 --1)) 21)

(for-each
 (lambda (str)
   (let ((val (catch #t (lambda () (string->number str)) (lambda args 'error))))
     (if val ;(number? val)
	 (format #t ";(string->number ~S) = ~A?~%" str val))))
 (list "#b#e#e1" "#x#e#e1" "#d#e#e1" "#o#e#e1" "#b#i#e1" "#x#i#e1" "#d#i#e1" "#o#i#e1" "#e#b#e1" "#i#b#e1" "#e#x#e1" "#i#x#e1" 
       "#e#d#e1" "#i#d#e1" "#e#o#e1" "#i#o#e1" "#e#b#i1" "#e#x#i1" "#e#d#i1" "#e#o#i1" "#b#e#b1" "#x#e#b1" "#d#e#b1" "#o#e#b1" 
       "#b#i#b1" "#x#i#b1" "#d#i#b1" "#o#i#b1" "#b#e#x1" "#x#e#x1" "#d#e#x1" "#o#e#x1" "#b#i#x1" "#x#i#x1" "#d#i#x1" "#o#i#x1" 
       "#b#e#d1" "#x#e#d1" "#d#e#d1" "#o#e#d1" "#b#i#d1" "#x#i#d1" "#d#i#d1" "#o#i#d1" "#b#e#o1" "#x#e#o1" "#d#e#o1" "#o#e#o1" 
       "#b#i#o1" "#x#i#o1" "#d#i#o1" "#o#i#o1"  
       
       "+1ei" "-1ei" "+0ei" "-0ei" "+1di" "-1di" "+0di" "-0di" "+1fi" "-1fi" "+0fi" "-0fi" "0e-+i" "1d-+i" 
       "0d-+i" "1f-+i" "0f-+i" "1e++i" "0e++i" "1d++i" ".10-10." "-1.e++i" "0e--01i" "1-00." "0-00." "#xf+b" 
       "#x1+d" "0f++1i" "1+0d-i" ".0f--i" "1-0d-i" "#xe-ff" "0-" "0-e0"
       
       "-#b1" "#b.i" "#b+i" "#b1e.1" "#b1+1" "#b#e#e1" "#b#ee1" "#b#e0e" "#d#d1" "#d#1d1"
       "#b+1ei" "#b-1ei" "#b+0ei" "#b-0ei" "#b+1di" "#b-1di" "#b+0di" "#b-0di" "#b+1fi" "#b-1fi" "#b+0fi" "#b-0fi" "#b0e-+i" "#b1d-+i" 
       ))

(num-test (string->number "2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427") 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427)

;; from testbase-report.ps Vern Paxson (with some changes)
;; resultant strings are thanks to clisp
(let ((cases 
       (list 
	(list '(* 49517601571415211 (expt 2 -94)) "2.5e-12")
	(list '(* 49517601571415211 (expt 2 -95)) "1.25e-12")
	(list '(* 54390733528642804 (expt 2 -133)) "4.995e-24")
	(list '(* 71805402319113924 (expt 2 -157)) "3.9305e-31")
	(list '(* 40435277969631694 (expt 2 -179)) "5.27705e-38")
	(list '(* 57241991568619049 (expt 2 -165)) "1.223955e-33")
	(list '(* 65224162876242886 (expt 2.0 58)) "1.8799585e+34")
	(list '(* 70173376848895368 (expt 2 -138)) "2.01387715e-25")
	(list '(* 37072848117383207 (expt 2 -99)) "5.849064105e-14")
	(list '(* 56845051585389697 (expt 2 -176)) "5.9349003055e-37")
	(list '(* 54791673366936431 (expt 2 -145)) "1.22847180395e-27")
	(list '(* 66800318669106231 (expt 2 -169)) "8.927076718085e-35")
	(list '(* 66800318669106231 (expt 2 -170)) "4.4635383590425e-35")
	(list '(* 66574323440112438 (expt 2 -119)) "1.00169908625495e-19")
	(list '(* 65645179969330963 (expt 2 -173)) "5.482941262802465e-36")
	(list '(* 61847254334681076 (expt 2 -109)) "9.529078328103644e-17")
	(list '(* 39990712921393606 (expt 2 -145)) "8.966227936640557e-28")
	(list '(* 59292318184400283 (expt 2 -149)) "8.308623441805854e-29")
	(list '(* 69116558615326153 (expt 2 -143)) "6.1985873566126555e-27")
	(list '(* 69116558615326153 (expt 2 -144)) "3.0992936783063277e-27")
	(list '(* 39462549494468513 (expt 2 -152)) "6.912351250617602e-30")
	(list '(* 39462549494468513 (expt 2 -153)) "3.456175625308801e-30")
	(list '(* 50883641005312716 (expt 2 -172)) "8.5e-36")
	(list '(* 38162730753984537 (expt 2 -170)) "2.55e-35")
	(list '(* 50832789069151999 (expt 2 -101)) "2.005e-14")
	(list '(* 51822367833714164 (expt 2 -109)) "7.984499999999999e-17")
	(list '(* 66840152193508133 (expt 2 -172)) "1.11655e-35")
	(list '(* 55111239245584393 (expt 2 -138)) "1.581615e-25")
	(list '(* 71704866733321482 (expt 2 -112)) "1.3809855e-17")
	(list '(* 67160949328233173 (expt 2 -142)) "1.20464045e-26")
	(list '(* 53237141308040189 (expt 2 -152)) "9.325140545e-30")
	(list '(* 62785329394975786 (expt 2 -112)) "1.2092014595e-17")
	(list '(* 48367680154689523 (expt 2 -77)) "3.20070458385e-07")
	(list '(* 42552223180606797 (expt 2 -102)) "8.391946324355e-15")
	(list '(* 63626356173011241 (expt 2 -112)) "1.2253990460585e-17")
	(list '(* 43566388595783643 (expt 2 -99)) "6.87356414897605e-14")
	(list '(* 54512669636675272 (expt 2 -159)) "7.459816430480385e-32")
	(list '(* 52306490527514614 (expt 2 -167)) "2.7960588398142556e-34")
	(list '(* 52306490527514614 (expt 2 -168)) "1.3980294199071278e-34")
	(list '(* 41024721590449423 (expt 2 -89)) "6.627901237305737e-11")
	(list '(* 37664020415894738 (expt 2 -132)) "6.917788004396807e-24")
	(list '(* 37549883692866294 (expt 2 -93)) "3.791569310834971e-12")
	(list '(* 69124110374399839 (expt 2 -104)) "3.408081767659137e-15")
	(list '(* 69124110374399839 (expt 2 -105)) "1.7040408838295685e-15")
	(list '(* 9 (expt 10 26)) "9e+26")
	(list '(* 79 (expt 10 -8)) "7.9e-07")
	(list '(* 393 (expt 10.0 26)) "3.93e+28")
	(list '(* 9171 (expt 10 -40)) "9.171e-37")
	(list '(* 56257 (expt 10 -16)) "5.6257e-12")
	(list '(* 281285 (expt 10 -17)) "2.81285e-12")
	(list '(* 4691113 (expt 10 -43)) "4.691113e-37")
	(list '(* 29994057 (expt 10 -15)) "2.9994057e-08")
	(list '(* 834548641 (expt 10 -46)) "8.34548641e-38")
	(list '(* 1058695771 (expt 10 -47)) "1.058695771e-38")
	(list '(* 87365670181 (expt 10 -18)) "8.7365670181e-08")
	(list '(* 872580695561 (expt 10 -36)) "8.72580695561e-25")
	(list '(* 6638060417081 (expt 10 -51)) "6.638060417081e-39")
	(list '(* 88473759402752 (expt 10 -52)) "8.8473759402752e-39")
	(list '(* 412413848938563 (expt 10 -27)) "4.12413848938563e-13")
	(list '(* 5592117679628511 (expt 10 -48)) "5.592117679628511e-33")
	(list '(* 83881765194427665 (expt 10 -50)) "8.388176519442766e-34")
					;(list '(* 638632866154697279 (expt 10 -35)) "6.3863286615469725e-18")
					;(list '(* 3624461315401357483 (expt 10 -53)) "3.6244613154013574e-35")
					;(list '(* 75831386216699428651 (expt 10 -30)) "7.583138621669942e-11")
					;(list '(* 356645068918103229683 (expt 10 -42)) "3.566450689181032e-22")
					;(list '(* 7022835002724438581513 (expt 10 -33)) "7.022835002724439e-12")
	(list '(* 7 (expt 10 -27)) "7e-27")
	(list '(* 37 (expt 10 -29)) "3.7e-28")
	(list '(* 743 (expt 10 -18)) "7.43e-16")
	(list '(* 7861 (expt 10 -33)) "7.861e-30")
	(list '(* 46073 (expt 10 -30)) "4.6073e-26")
	(list '(* 774497 (expt 10 -34)) "7.74497e-29")
	(list '(* 8184513 (expt 10 -33)) "8.184513e-27")
	(list '(* 89842219 (expt 10 -28)) "8.9842219e-21")
	(list '(* 449211095 (expt 10 -29)) "4.49211095e-21")
	(list '(* 8128913627 (expt 10 -40)) "8.128913627e-31")
	(list '(* 87365670181 (expt 10 -18)) "8.7365670181e-08")
	(list '(* 436828350905 (expt 10 -19)) "4.36828350905e-08")
	(list '(* 5569902441849 (expt 10 -49)) "5.569902441849e-37")
	(list '(* 60101945175297 (expt 10 -32)) "6.0101945175297e-19")
	(list '(* 754205928904091 (expt 10 -51)) "7.54205928904091e-37")
	(list '(* 5930988018823113 (expt 10 -37)) "5.930988018823113e-22")
	(list '(* 51417459976130695 (expt 10 -27)) "5.14174599761307e-11")
	(list '(* 826224659167966417 (expt 10 -41)) "8.262246591679665e-24")
					;(list '(* 9612793100620708287 (expt 10 -57)) "9.612793100620708e-39")
					;(list '(* 93219542812847969081 (expt 10 -39)) "9.321954281284797e-20")
					;(list '(* 544579064588249633923 (expt 10 -48)) "5.445790645882496e-28")
					;(list '(* 4985301935905831716201 (expt 10 -48)) "4.9853019359058315e-27")
	(list '(* 12676506 (expt 2 -102)) "2.499999999549897e-24")
	(list '(* 12676506 (expt 2 -103)) "1.2499999997749484e-24")
	(list '(* 15445013 (expt 2.0 86)) "1.1949999999989506e+33")
	(list '(* 13734123 (expt 2 -138)) "3.941499999999621e-35")
	(list '(* 12428269 (expt 2 -130)) "9.13084999999985e-33")
	(list '(* 15334037 (expt 2 -146)) "1.719004999999994e-37")
	(list '(* 11518287 (expt 2 -41)) "5.237910499999998e-06")
	(list '(* 12584953 (expt 2 -145)) "2.82164405e-37")
	(list '(* 15961084 (expt 2 -125)) "3.752432815e-31")
	(list '(* 14915817 (expt 2 -146)) "1.6721209165e-37")
	(list '(* 10845484 (expt 2 -102)) "2.13889458145e-24")
	(list '(* 16431059 (expt 2 -61)) "7.125835945615e-12")
	(list '(* 16093626 (expt 2.0 69)) "9.500000001279935e+27")
	(list '(* 9983778 (expt 2.0 25)) "335000000004096.0")
	(list '(* 12745034 (expt 2.0 104)) "2.5850000000046706e+38")
	(list '(* 12706553 (expt 2.0 72)) "6.000500000000674e+28")
	(list '(* 11005028 (expt 2.0 45)) "3.8720500000001465e+20")
	(list '(* 15059547 (expt 2.0 71)) "3.555835000000006e+28")
	(list '(* 16015691 (expt 2 -99)) "2.5268305000000024e-23")
	(list '(* 8667859 (expt 2.0 56)) "6.24585065e+23")
	(list '(* 14855922 (expt 2 -82)) "3.072132665e-18")
	(list '(* 14855922 (expt 2 -83)) "1.5360663325e-18")
	(list '(* 10144164 (expt 2 -110)) "7.81477968335e-27")
	(list '(* 13248074 (expt 2.0 95)) "5.248102799365e+35")
	(list '(* 5 (expt 10 -20)) "5e-20")
	(list '(* 67 (expt 10.0 14)) "6.7e+15")
	(list '(* 985 (expt 10.0 15)) "9.85e+17")
	(list '(* 7693 (expt 10 -42)) "7.693e-39")
	(list '(* 55895 (expt 10 -16)) "5.5895e-12")
	(list '(* 996622 (expt 10 -44)) "9.96622e-39")
	(list '(* 7038531 (expt 10 -32)) "7.038531e-26")
	(list '(* 60419369 (expt 10 -46)) "6.0419369e-39")
	(list '(* 702990899 (expt 10 -20)) "7.02990899e-12")
	(list '(* 6930161142 (expt 10 -48)) "6.930161142e-39")
	(list '(* 25933168707 (expt 10.0 13)) "2.5933168707e+23")
	(list '(* 596428896559 (expt 10.0 20)) "5.96428896559e+31")
	(list '(* 3 (expt 10 -23)) "3e-23")
	(list '(* 57 (expt 10.0 18)) "5.7e+19")
	(list '(* 789 (expt 10 -35)) "7.89e-33")
	(list '(* 2539 (expt 10 -18)) "2.539e-15")
	(list '(* 76173 (expt 10.0 28)) "7.6173e+32")
	(list '(* 887745 (expt 10 -11)) "8.87745e-06")
	(list '(* 5382571 (expt 10 -37)) "5.382571e-31")
	(list '(* 82381273 (expt 10 -35)) "8.2381273e-28")
	(list '(* 750486563 (expt 10 -38)) "7.50486563e-30")
	(list '(* 3752432815 (expt 10 -39)) "3.752432815e-30")
	(list '(* 75224575729 (expt 10 -45)) "7.5224575729e-35")
	(list '(* 459926601011 (expt 10.0 15)) "4.59926601011e+26") ; 10.0 (and 2.0 above) because we aren't interested here in numeric overflows
	)))
  (let ((maxdiff 0.0)
	(maxdiff-case '()))
    (do ((lst cases (cdr lst)))
	((null? lst))
      (let* ((form (caar lst))
	     (str (cadar lst))
	     (num (eval form))
	     (fnum (* 1.0 num))
	     (n2s (number->string fnum))
	     (s2n (string->number n2s))
	     (mnum (string->number str))
	     (diff (let ()
		     (if (not (string? n2s))
			 (format #t "(number->string ~A) #f?~%" fnum))
		     (if (not (number? s2n))
			 (format #t "(string->number ~S) #f?~%" n2s))
		     (/ (abs (- mnum s2n)) (max (expt 2 -31.0) (abs fnum))))))
	(if (> diff maxdiff)
	    (begin
	      (set! maxdiff diff)
	      (set! maxdiff-case (car lst))))))
    (if (> maxdiff 1e-15) ; we're only interested in real problems
	(format #t ";number->string rounding checks worst case relative error ~A ~A ~S~%" maxdiff (car maxdiff-case) (cadr maxdiff-case)))
    ))


(for-each
 (lambda (p)
   (let ((sym (car p))
	 (num (cdr p)))
     (let ((tag (catch #t (lambda () (string->number sym)) (lambda args 'error))))
       (if (not (equal? num tag))
	   (format #t ";(string->number ~S) = ~A [~A]~%" sym tag num)))))
 '(("#xe/d" . 14/13) ("#xb/d" . 11/13) ("#xf/d" . 15/13) ("#x1/f" . 1/15) ("#xd/f" . 13/15) ("#xe/f" . 14/15) ("#d.1" . .1) ("#d01" . 1)
   ("#d+1" . 1) ("#d+0" . 0) ("#d0+i" . 0+i) ("#xe+i" . 14.0+1.0i) ("#xf+i" . 15.0+1.0i) ("#d1-i" . 1.0-1.0i); ("#e1+i" . 1+i)
   ))

#|
;;; here's code to generate all (im)possible numbers (using just a few digits) of a given length

(define file (open-output-file "ntest.scm"))
(define chars (list #\1 #\0 #\9 #\# #\. #\+ #\- #\e #\i #\/ #\b #\x #\d #\o #\l #\s #\f #\@))

(define (all-syms f len with-file)
  (let ((sym (make-string len))
	(num-chars (length chars))
	(ctrs (make-vector len 0)))
    (do ((i 0 (+ i 1)))
	((= i (expt num-chars len)))
      (let ((carry #t))
	(do ((k 0 (+ k 1)))
	    ((or (= k len)
		 (not carry)))
	  (vector-set! ctrs k (+ 1 (vector-ref ctrs k)))
	  (if (= (vector-ref ctrs k) num-chars)
	      (vector-set! ctrs k 0)
	      (set! carry #f)))
	(do ((k 0 (+ k 1)))
	    ((= k len))
	  (string-set! sym k (list-ref chars (vector-ref ctrs k)))))
      (let ((tag (catch #t (lambda () (string->number sym)) (lambda args (car args)))))
	(if (not with-file)
	    (if (and (number? tag)
		     (= tag 1))
		(format #t "~S " sym))
	    (begin
	      (if (number? tag)
		  (display (format file "(if (not (number? (string->number ~S))) (begin (display ~S) (display #\space)))"))
		  (display (format file "(if (number? (string->number ~S)) (begin (display ~S) (display #\space)))")))
	      (newline file)))))))

(do ((len 1 (+ len 1)))
    ((= len 12))
  (all-syms file len #f)
  (newline))

(close-output-port file)
|#

(let ()
  (define (~ !) (* 2 !))
  (test (~ 3) 6)
  (define (~~ !) (* 2 !))
  (test (~~ 3) 6)
  (define (\x00 !) (* 2 !))
  (test (\x00 3) 6))

(for-each
 (lambda (n name)
   (if (number? n)
       (format #t ";(number? ~A) returned #t?~%" name)))
 (list
  'a9 'aa 'aA 'a! 'a$ 'a% 'a& 'a* 'a+ 'a- 'a. 'a/ 'a: 'a< 'a= 'a> 'a? 'a@ 'a^ 'a_ 'a~ 'A9 'Aa 'AA 'A! 'A$ 'A% 'A& 'A* 'A+ 'A- 'A. 'A/ 'A: 'A< 'A= 'A> 'A? 'A@ 'A^ 'A_ 'A~ '!9 '!a '!A '!! '!$ '!% '!& '!* '!+ '!- '!. '!/ '!: '!< '!= '!> '!? '!@ '!^ '!_ '!~ '$9 '$a '$A '$! '$$ '$% '$& '$* '$+ '$- '$. '$/ '$: '$< '$= '$> '$? '$@ '$^ '$_ '$~ '%9 '%a '%A '%! '%$ '%% '%& '%* '%+ '%- '%. '%/ '%: '%< '%= '%> '%? '%@ '%^ '%_ '%~ '&9 '&a '&A '&! '&$ '&% '&& '&* '&+ '&- '&. '&/ '&: '&< '&= '&> '&? '&@ '&^ '&_ '&~ '*9 '*a '*A '*! '*$ '*% '*& '** '*+ '*- '*. '*/ '*: '*< '*= '*> '*? '*@ '*^ '*_ '*~ '/9 '/a '/A '/! '/$ '/% '/& '/* '/+ '/- '/. '// '/: '/< '/= '/> '/? '/@ '/^ '/_ '/~ ':9 ':a ':A ':! ':$ ':% ':& ':* ':+ ':- ':. ':/ ':: ':< ':= ':> ':? ':@ ':^ ':_ ':~ '<9 '<a '<A '<! '<$ '<% '<& '<* '<+ '<- '<. '</ '<: '<< '<= '<> '<? '<@ '<^ '<_ '<~ '=9 '=a '=A '=! '=$ '=% '=& '=* '=+ '=- '=. '=/ '=: '=< '== '=> '=? '=@ '=^ '=_ '=~ '>9 '>a '>A '>! '>$ '>% '>& '>* '>+ '>- '>. '>/ '>: '>< '>= '>> '>? '>@ '>^ '>_ '>~ '?9 '?a '?A '?! '?$ '?% '?& '?* '?+ '?- '?. '?/ '?: '?< '?= '?> '?? '?@ '?^ '?_ '?~ '^9 '^a '^A '^! '^$ '^% '^& '^* '^+ '^- '^. '^/ '^: '^< '^= '^> '^? '^@ '^^ '^_ '^~ '_9 '_a '_A '_! '_$ '_% '_& '_* '_+ '_- '_. '_/ '_: '_< '_= '_> '_? '_@ '_^ '__ '_~ '~9 '~a '~A '~! '~$ '~% '~& '~* '~+ '~- '~. '~/ '~: '~< '~= '~> '~? '~@ '~^ '~_ '~~)
 
 (list
  "'a9" "'aa" "'aA" "'a!" "'a$" "'a%" "'a&" "'a*" "'a+" "'a-" "'a." "'a/" "'a:" "'a<" "'a=" "'a>" "'a?" "'a@" "'a^" "'a_" "'a~" "'A9" "'Aa" "'AA" "'A!" "'A$" "'A%" "'A&" "'A*" "'A+" "'A-" "'A." "'A/" "'A:" "'A<" "'A=" "'A>" "'A?" "'A@" "'A^" "'A_" "'A~" "'!9" "'!a" "'!A" "'!!" "'!$" "'!%" "'!&" "'!*" "'!+" "'!-" "'!." "'!/" "'!:" "'!<" "'!=" "'!>" "'!?" "'!@" "'!^" "'!_" "'!~" "'$9" "'$a" "'$A" "'$!" "'$$" "'$%" "'$&" "'$*" "'$+" "'$-" "'$." "'$/" "'$:" "'$<" "'$=" "'$>" "'$?" "'$@" "'$^" "'$_" "'$~" "'%9" "'%a" "'%A" "'%!" "'%$" "'%%" "'%&" "'%*" "'%+" "'%-" "'%." "'%/" "'%:" "'%<" "'%=" "'%>" "'%?" "'%@" "'%^" "'%_" "'%~" "'&9" "'&a" "'&A" "'&!" "'&$" "'&%" "'&&" "'&*" "'&+" "'&-" "'&." "'&/" "'&:" "'&<" "'&=" "'&>" "'&?" "'&@" "'&^" "'&_" "'&~" "'*9" "'*a" "'*A" "'*!" "'*$" "'*%" "'*&" "'**" "'*+" "'*-" "'*." "'*/" "'*:" "'*<" "'*=" "'*>" "'*?" "'*@" "'*^" "'*_" "'*~" "'/9" "'/a" "'/A" "'/!" "'/$" "'/%" "'/&" "'/*" "'/+" "'/-" "'/." "'//" "'/:" "'/<" "'/=" "'/>" "'/?" "'/@" "'/^" "'/_" "'/~" "':9" "':a" "':A" "':!" "':$" "':%" "':&" "':*" "':+" "':-" "':." "':/" "'::" "':<" "':=" "':>" "':?" "':@" "':^" "':_" "':~" "'<9" "'<a" "'<A" "'<!" "'<$" "'<%" "'<&" "'<*" "'<+" "'<-" "'<." "'</" "'<:" "'<<" "'<=" "'<>" "'<?" "'<@" "'<^" "'<_" "'<~" "'=9" "'=a" "'=A" "'=!" "'=$" "'=%" "'=&" "'=*" "'=+" "'=-" "'=." "'=/" "'=:" "'=<" "'==" "'=>" "'=?" "'=@" "'=^" "'=_" "'=~" "'>9" "'>a" "'>A" "'>!" "'>$" "'>%" "'>&" "'>*" "'>+" "'>-" "'>." "'>/" "'>:" "'><" "'>=" "'>>" "'>?" "'>@" "'>^" "'>_" "'>~" "'?9" "'?a" "'?A" "'?!" "'?$" "'?%" "'?&" "'?*" "'?+" "'?-" "'?." "'?/" "'?:" "'?<" "'?=" "'?>" "'??" "'?@" "'?^" "'?_" "'?~" "'^9" "'^a" "'^A" "'^!" "'^$" "'^%" "'^&" "'^*" "'^+" "'^-" "'^." "'^/" "'^:" "'^<" "'^=" "'^>" "'^?" "'^@" "'^^" "'^_" "'^~" "'_9" "'_a" "'_A" "'_!" "'_$" "'_%" "'_&" "'_*" "'_+" "'_-" "'_." "'_/" "'_:" "'_<" "'_=" "'_>" "'_?" "'_@" "'_^" "'__" "'_~" "'~9" "'~a" "'~A" "'~!" "'~$" "'~%" "'~&" "'~*" "'~+" "'~-" "'~." "'~/" "'~:" "'~<" "'~=" "'~>" "'~?" "'~@" "'~^" "'~_" "'~~"))

					;(let ((initial-chars "aA!$%&*/:<=>?^_~")
					;      (subsequent-chars "9aA!$%&*+-./:<=>?@^_~"))
					;  (do ((i 0 (+ i 1)))
					;      ((= i (string-length initial-chars)))
					;    (do ((k 0 (+ k 1)))
					;	((= k (string-length subsequent-chars)))
					;      (format #t "'~A " (string (string-ref initial-chars i) (string-ref subsequent-chars k))))))


(for-each
 (lambda (z)
   (if (not (zero? z))
       (format #t "~A is not zero?~%" z))
   (if (and (real? z) (positive? z))
       (format #t "~A is positive?~%" z))
   (if (and (real? z) (negative? z))
       (format #t "~A is negative?~%" z)))
 '(0 -0 +0 0.0 -0.0 +0.0 0/1 -0/1 +0/24 0+0i 0-0i -0-0i +0-0i 0.0-0.0i -0.0+0i #b0 #o-0 #x000 #e0 #e0.0 #e#b0 #b#e0 #e0/1 #b+0 #d000/1111 000/111))


(for-each 
 (lambda (x) 
   (if (string->number x)
       (format #t ";(string->number ~A) returned ~A~%" x (string->number x))))
 '("" "q" "1q" "6+7iq" "8+9q" "10+11" "13+" "18@19q" "20@q" "23@"
   "+25iq" "26i" "-q" "-iq" "i" "5#.0" "8/" "10#11" ".#" "."
   "3.4q" "15.16e17q" "18.19e+q" ".q" ".17#18" "10q" "#b2" "#b12" "#b-12"
   "#b3" "#b4" "#b5" "#b6" "#b7" "#b8" "#b9" "#ba" "#bb" "#bc"
   "#bd" "#be" "#bf" "#q" "#b#b1" "#o#o1" "#d#d1" "#x#x1" "#e#e1" "#xag" "#x1x"
   "#o8" "#o9" "1/#e1" "#o#" "#e#i1" "#d--2" "#b#x1" "#i#x#b1" "#e#e#b1" "#e#b#b1" 
   "-#b1" "+#b1" "#b1/#b2" "#b1+#b1i" "1+#bi" "1+#b1i" "1#be1" "#b" "#o" "#" "#ea" "#e1a" "1+ie1" "1+i1" "1e+1i"
   "#e#b" "#b#b" "#b#b1" "1e3e4" "1.0e-3e+4" "1e3s" "1e3s3" "#o#x1" "#i#i1" "1e-i" "#be1" "1/i" "1/e1" "1+e1"
   "1e+" "1e1+" "1e1e1" "1e-+1" "1e0x1" "1e-" "1/#o2"
   "#i#i1" "12@12i"))

(for-each 
 (lambda (couple)
   (apply
    (lambda (x y)
      (let ((xx (string->number x)))
	(if (or (not xx)
		(not y)
		(and (rational? y)
		     (not (eqv? xx y)))
		(> (abs (- xx y)) 1e-12))
	    (format #t ";(string->number ~A) returned ~A but expected ~A (~A ~A ~A ~A)~%"
		    x (string->number x) y
		    xx (eq? xx #f)
		    (if (and xx y) (and (rational? y) (not (eqv? xx y))) #f)
		    (if (and xx y) (abs (- xx y)) #f)))))
    couple))
 '(
   ("#b0" 0)  ("#b1" 1) ("#o0" 0) ("#b-1" -1) ("#b+1" 1)
   ("#o1" 1)  ("#o2" 2) ("#o3" 3) ("#o-1" -1)
   ("#o4" 4)  ("#o5" 5) ("#o6" 6)
   ("#o7" 7)  ("#d0" 0) ("#d1" 1)
   ("#d2" 2)  ("#d3" 3) ("#d4" 4)
   ("#d5" 5)  ("#d6" 6) ("#d7" 7) ("#d-123" -123) ("#d+123" 123)
   ("#d8" 8)  ("#d9" 9) 
   ("#xa" 10) ("#xb" 11) ("#x-1" -1) ("#x-a" -10)
   ("#xc" 12) ("#xd" 13) 
   ("#xe" 14) ("#xf" 15) ("#x-abc" -2748)
   ("#b1010" 10)
   ("#o12345670" 2739128)
   ("#d1234567890" 1234567890)
   ("#x1234567890abcdef" 1311768467294899695)
   ("#e1" 1) ("#e1.2" 12/10)
   ("#i1.1" 1.1) ("#i1" 1.0)
   ("1" 1) ("23" 23) ("-1" -1) 
   ("-45" -45)                      ;("2#" 20.0) ("2##" 200.0) ("12##" 1200.0) ; this # = 0 is about the stupidest thing I've ever seen
   ("#b#i100" 4.0) ("#b#e100" 4) ("#i#b100" 4.0) ("#e#b100" 4)
   ("#b#i-100" -4.0) ("#b#e+100" 4) ("#i#b-100" -4.0) ("#e#b+100" 4)
   ("#o#i100" 64.0) ("#o#e100" 64) ("#i#o100" 64.0) ("#e#o100" 64)
   ("#d#i100" 100.0) ("#d#e100" 100) ("#i#d100" 100.0) ("#e#d100" 100)
   ("#x#i100" 256.0) ("#x#e100" 256) ("#i#x100" 256.0) ("#e#x100" 256)
   ("#e#xee" 238) ("#e#x1e1" 481)
   ("#xA" 10) ("#xB" 11) ("#x-1" -1) ("#x-A" -10)
   ("#xC" 12) ("#xD" 13) 
   ("#xE" 14) ("#xF" 15) ("#x-ABC" -2748)
   ("#xaBC" 2748) ("#xAbC" 2748) ("#xabC" 2748) ("#xABc" 2748)
   ("1/1" 1) ("1/2" 1/2) ("-1/2" -1/2) ("#e9/10" 9/10) ("#i6/8" 0.75) ("#i1/1" 1.0)
   ("1e2" 100.0) 
   ("1e+2" 100.0) ("1e-2" 0.01)
   (".1" .1) (".0123456789" 123456789e-10) 
   (".0123456789e10" 123456789.0)
   ("3." 3.0) ("3.e0" 3.0)
   ("1+i" 1+1i) ("1-i" 1-1i) 
   ("#e1e1" 10) ("#i1e1+i" 10.0+1.0i)
   ))

;;; some schemes are case insensitive throughout -- they accept 0+I, #X11 etc

(for-each
 (lambda (arg)
   (test (string->number arg) 'error))
 (list -1 #f #\a 1 _ht_ '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi abs '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))

(for-each
 (lambda (arg)
   (test (string->number "123" arg) 'error)
   (test (string->number "1" arg) 'error))
 (list -1 0 1 17 #f _ht_ #\a '#(1 2 3) 3.14 3/4 1.5+0.3i 1+i '() "" "12" #() :hi most-positive-fixnum most-negative-fixnum 'hi abs '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))

;; (string->number "0" 1) ?? why not?

(for-each
 (lambda (arg)
   (test (number->string arg) 'error))
 (list #\a '#(1 2 3) '() _ht_ 'hi abs "hi" '#(()) #f (list 1 2 3) '(1 . 2) (lambda () 1)))

(for-each
 (lambda (arg)
   (test (number->string 123 arg) 'error))
 (list -1 17 most-positive-fixnum most-negative-fixnum 0 1 512 _ht_ #\a #f '#(1 2 3) 3.14 2/3 1.5+0.3i 1+i '() 'hi abs "hi" '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))

(test (string->number "34.1" (+ 5 (expt 2 32))) 'error)
(test (number->string 34.1 (+ 5 (expt 2 32))) 'error)
(test (string->number) 'error)
(test (string->number 'symbol) 'error)
(test (string->number "1.0" "1.0") 'error)
(test (number->string) 'error)
(test (number->string "hi") 'error)
(test (number->string 1.0+23.0i 1.0+23.0i 1.0+23.0i) 'error)
(test (string->number "") #f)
(test (string->number "" 8) #f)
(test (string->number (make-string 0)) #f)
(test (string->number (string #\null)) #f)
(test (string->number (string)) #f)
(test (string->number (substring "hi" 0 0)) #f)
(test (string->number (string (integer->char 30))) #f)
(test (string->number "123" 10+0i) 'error) ; a real in s7

(if with-bignums
    (begin
      (test (number->string -46116860184273879035/27670116110564327424) "-46116860184273879035/27670116110564327424")
      (test (number->string 123 (bignum "10")) "123")
      (test (number->string 123 (bignum "2")) "1111011")
      (test (string->number "123" (bignum "10")) 123)
      (test (string->number "1111011" (bignum "2")) 123)
      (test (number->string 123 (bignum "17")) 'error)
      (test (number->string 123 (bignum "-1")) 'error)
      (test (number->string 123 (bignum "1")) 'error)
      (test (number->string 123 (bignum "1/2")) 'error)
      (test (string->number "101" (bignum "17")) 'error)
      (test (string->number "101" (bignum "1")) 'error)
      (test (string->number "101" (bignum "-1")) 'error)
      (test (string->number "101" (bignum "1/2")) 'error)))

(num-test (- (string->number "1188077266484631001.") (string->number "1.188077266484631001E18")) 0.0)

(num-test (- (string->number "1188077266484631001." 10) (string->number "1.188077266484631001E18" 10)) 0.0)
(num-test (- (string->number "118807726648463100.1" 10) (string->number "1.188077266484631001E17" 10)) 0.0)
(if with-bignums 
    (num-test (- (string->number "118807726648463.1001" 10) (string->number "1.188077266484631001E14" 10)) 0.0)
    (test (> (abs (- (string->number "118807726648463.1001" 10) (string->number "1.188077266484631001E14" 10))) 1e-1) #f))
(num-test (- (string->number "11880772664.84631001" 10) (string->number "1.188077266484631001E10" 10)) 0.0)
(num-test (- (string->number "11880772.66484631001" 10) (string->number "1.188077266484631001E7" 10)) 0.0)

(num-test (- (string->number "118807726648463100100." 9) (string->number "1.188077266484631001E20" 9)) 0.0)
(num-test (- (string->number "1188077266484631001." 9) (string->number "1.188077266484631001E18" 9)) 0.0)
(num-test (- (string->number "118807726648463100.1" 9) (string->number "1.188077266484631001E17" 9)) 0.0)
(if with-bignums
    (num-test (- (string->number "118807726648463.1001" 9) (string->number "1.188077266484631001E14" 9)) 0.0)
    (test (> (abs (- (string->number "118807726648463.1001" 9) (string->number "1.188077266484631001E14" 9))) 1e-1) #f))
(num-test (- (string->number "11880772664.84631001" 9) (string->number "1.188077266484631001E10" 9)) 0.0)
(num-test (- (string->number "11880772.66484631001" 9) (string->number "1.188077266484631001E7" 9)) 0.0)

;; (num-test (- (string->number "1177077266474631001000." 8) (string->number "1.177077266474631001E21" 8)) 0.0)
;; a fake unfortunately

(num-test 111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111e-300 1.111111111111111111111111111111111111113E-1)
(num-test 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300 1.0)
(num-test 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e309 1.0)
(num-test 0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123e309 1.23)
(num-test -.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123456e312 -1234.56)

(num-test (string->number "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111e-300") 1.111111111111111111111111111111111111113E-1)
(num-test (string->number "0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300") 1.0)
(num-test (string->number "0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e309") 1.0)
(num-test (string->number "0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123e309") 1.23)
(num-test (string->number "-.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123456e312") -1234.56)

(num-test #e0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300 1)
(num-test #e0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e309 1)
(num-test #e0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123e309 123/100)
(num-test #e-.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000123456e314 -123456)

(num-test #b0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300 1.0)
(num-test #d0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300 1.0)
(num-test #o0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300 1.0)
(num-test #x0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e300 1.0)

(num-test 0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e600 10.0)

(num-test 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-300 1.0)
(num-test 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309 1.0)
(num-test -1234000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309 -1.234)

(num-test (string->number "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-300") 1.0)
(num-test (string->number "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309") 1.0)
(num-test (string->number "-1234000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309") -1.234)

(num-test #e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-300 1)
(num-test #e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309 1)
(num-test #e-1234000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309 -617/500)

(num-test 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-300 1.0)
(num-test #e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-300 1)
(num-test (string->number "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-300") 1.0)

(num-test 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309 1.0)
(num-test #e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309 1)
(num-test (string->number "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e-309") 1.0)

(num-test (string->number "7218817.36503571385593731949749063134519967478471341285646368059547752954588980538968510599079437e7") 7.218817365035713855937319497490631345183E13)
(num-test (string->number "-8209943b.31283867353472bb21b" 12) -2.928292312585025742274395996260284298851E8)
(test (string->number "-8209943b.31283867353472bc21b" 12) #f)
(num-test (string->number "-25708892.1b6583269007366320788640bb79398b32a42" 12) -8.835044616346879740283599816201349374646E7)
(test (string->number "-25708892.1b6583269007366320788640bb79398b32ac2" 12) #f)
(num-test (string->number "9418.b89a40b0211a01147b75b23a529b0382775b32b+45936610b.a936586185a57b00ba4a90a139343235054b2i" 12) 1.614897792919114090019672485580641433273E4+1.926841115897881740778679262842131716289E9i)

(num-test (string->number "1.0e0000000000000000000000000000000000001") 10.0)
(num-test #e1.0e0000000000000000000000000000000000001 10)
(num-test #e1.0e-0000000000000000000000000000000000001 1/10)

(num-test 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 10.0)
(num-test #e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 10)
(num-test (string->number "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001") 10.0)

(num-test (string->number "\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
1.00000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
00e0000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0000000000000000000000000000000000000000\
0001") 10.0)

;;; this whitespace handling only works in string constants in s7, not in arbitrary code.

(num-test 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001/00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 1)
(num-test (string->number "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001/00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001") 1)
(num-test #i00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001/00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 1.0)

#|
;;; if not gmp:
:(string->number "0.999999999999999")
1.0
:(number->string 0.999999999999999)
"1.0"
also
:(string->number ".0999999999999995")
                 0.099999999999999
:(string->number ".0999999999999996")
                 0.1
:(string->number ".0fffffffffff" 16)
0.062499999999996
:(string->number ".0ffffffffffff" 16)
0.0625
but
:(number->string 0.062499999999996 16)
"0.0ffffffffffee"
:(number->string (string->number ".0fffffffffff" 16)  16)
"0.0fffffffffff"
 the 0.624... version is actually an approximation (off by 4.4408920985006e-16)
:(number->string 0.062499999999996 16)
"0.0ffffffffffedfc506118a9ea64de0c590"
more non-gmp:
:9999999999999999999
-8446744073709551617
:9999999999999999991
-8446744073709551625
:-9999999999999999991
8446744073709551625
:9223372036854775810
-9223372036854775806
etc
|#

(if with-bignums
    (begin
      (test (char=? ((number->string 9.999999999999999) 0) #\9) #t)
      (test (char=? ((number->string 0.999999999999999999) 3) #\9) #t)
      (num-test -0.1e309 -1e308)
      (num-test .01e310 1e308)
      (num-test .1e310 1e309)
      (num-test 0.0e310 0.0)
      ))
