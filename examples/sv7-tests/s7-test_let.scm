(test (let ((x 2) (y 3)) (* x y)) 6)
(test (let ((x 32)) (let ((x 3) (y x)) y)) 32)
(test (let ((x 32)) (let* ((x 3) (y x)) y)) 3)
(test (let ((x 2) (y 3)) (let ((x 7) (z (+ x y))) (* z x))) 35)
(test (let ((x 2) (y 3)) (let* ((x 7)  (z (+ x y))) (* z x))) 70)
(test (letrec ((is-even (lambda (n)  (if (zero? n) #t (is-odd (- n 1))))) (is-odd (lambda (n)  (if (zero? n) #f (is-even (- n 1)))))) (is-even 88))  #t)
(test (let loop ((numbers '(3 -2 1 6 -5)) 
		 (nonneg '()) 
		 (neg '())) 
	(cond ((null? numbers) 
	       (list nonneg neg)) 
	      ((>= (car numbers) 0)  
	       (loop (cdr numbers) (cons (car numbers) nonneg)  neg)) 
	      ((< (car numbers) 0)  
	       (loop (cdr numbers) nonneg (cons (car numbers) neg))))) 
      '((6 1 3) (-5 -2)))
(test(let((i 1)(j 2))(+ i j))3)

(test (let ((x 3)) (define x 5) x) 5)
(test (let* () (define x 8) x) 8)
(test (letrec () (define x 9) x) 9)
(test (letrec ((x 3)) (define x 10) x) 10)
(test (let foo () 1) 1)
(test (let ((f -)) (let f ((n (f 1))) n)) -1)
(test (let () 1 2 3 4) 4)
(test (+ 3 (let () (+ 1 2))) 6)

(test (let ((x 1)) (let ((x 32) (y x)) y)) 1)
(test (let ((x 1)) (letrec ((y (if #f x 1)) (x 32)) 1)) 1)
(test (let ((x 1)) (letrec ((y (lambda () (+ 1 x))) (x 32)) (y))) 33) 
(test (let ((x 1)) (letrec ((y (* 0 x)) (x 32)) y)) 'error)
(test (let* ((x 1) (f (letrec ((y (lambda () (+ 1 x))) (x 32)) y))) (f)) 33)
(test (letrec ((x 1) (y (let ((x 2)) x))) (+ x y)) 3)
(test (letrec ((f (lambda () (+ x 3))) (x 2)) (f)) 5)
(test (let* ((x 1) (x 2)) x) 2)
(test (let* ((x 1) (y x)) y) 1)
(test (let ((x 1)) (let ((x 32) (y x)) (+ x y))) 33)
(test (let ((x 1)) (let* ((x 32) (y x)) (+ x y))) 64)
(test (let ((x 'a) (y '(b c))) (cons x y)) '(a b c))
(test (let ((x 0) (y 1)) (let ((x y) (y x)) (list x y))) (list 1 0))
(test (let ((x 0) (y 1)) (let* ((x y) (y x)) (list x y))) (list 1 1))
(test (letrec ((sum (lambda (x) (if (zero? x) 0 (+ x (sum (- x 1))))))) (sum 5)) 15)
(test (let ((divisors (lambda (n) (let f ((i 2)) (cond ((>= i n) '()) ((integer? (/ n i)) (cons i (f (+ i 1)))) (else (f (+ i 1)))))))) (divisors 32)) '(2 4 8 16))
(test (let ((a -1)) (let loop () (if (not (positive? a)) (begin (set! a (+ a 1)) (loop)))) a) 1)
(test (let () (let () (let () '()))) '())
(test (let ((x 1)) (let ((y 0)) (begin (let ((x (* 2 x))) (set! y x))) y)) 2)
(test (let* ((x 1) (x (+ x 1)) (x (+ x 2))) x) 4)
(test (let ((.. 2) (.... 4) (..... +)) (..... .. ....)) 6)

(test (let () (begin (define x 1)) x) 1)
(test (let ((define 1)) define) 1)
(test (let ((y 1)) (begin (define x 1)) (+ x y)) 2)
(test (let ((: 0)) (- :)) 0) 
;; this only works if we haven't called (string->symbol "") making : into a keyword (see also other cases below)
;; perhaps I should document this weird case -- don't use : as a variable name

;;; optimizer troubles
(test (let () (define (f x) (let asd ())) (f 1)) 'error)
(test (let () (define (f x) (let ())) (f 1)) 'error)

(test (let ((pi 3)) pi) 'error)
(test (let ((:key 1)) :key) 'error)
(test (let ((:3 1)) 1) 'error)
(test (let ((3 1)) 1) 'error)
(test (let ((3: 1)) 1) 'error)
(test (let ((optional: 1)) 1) 'error)
(test (let ((x_x_x 32)) (let () (define-constant x_x_x 3) x_x_x) (set! x_x_x 31) x_x_x) 'error)
(test (let ((x 1)) (+ (let ((a (begin (define x 2) x))) a) x)) 4)
(test (let ((x 1)) (+ (letrec ((a (begin (define x 2) x))) a) x)) 3)
(test (let ((a #<eof>)) (eof-object? a)) #t)
(test (let ((a #<unspecified>)) (eq? a #<unspecified>)) #t)

(test ((let ((x 2))
	 (let ((x 3))
	   (lambda (arg) (+ arg x))))
       1)
      4)

(test ((let ((x 2))
	 (define (inner arg) (+ arg x))
	 (let ((x 32))
	   (lambda (arg) (inner (+ arg x)))))
       1)
      35)

(test ((let ((inner (lambda (arg) (+ arg 1))))
	 (let ((inner (lambda (arg) (inner (+ arg 2)))))
	   inner))
       3)
      6)

(test ((let ()
	 (define (inner arg) (+ arg 1))
	 (let ((inner (lambda (arg) (inner (+ arg 2)))))
	   inner))
       3)
      6)

(test ((let ((x 11))
	 (define (inner arg) (+ arg x))
	 (let ((inner (lambda (arg) (inner (+ (* 2 arg) x)))))
	   inner))
       3)
      28)

(test ((let ((x 11))
	 (define (inner arg) (+ arg x))
	 (let ((x 2))
	   (lambda (arg) (inner (+ (* 2 arg) x)))))
       3)
      19)

(test (let ((f1 (lambda (arg) (+ arg 1))))
	(let ((f1 (lambda (arg) (f1 (+ arg 2)))))
	  (f1 1)))
      4)

(test (let ((f1 (lambda (arg) (+ arg 1))))
	(let* ((f1 (lambda (arg) (f1 (+ arg 2)))))
	  (f1 1)))
      4)

(test (let ((f1 (lambda (arg) (+ arg 1))))
	(let* ((x 32)
	       (f1 (lambda (arg) (f1 (+ x arg)))))
	  (f1 1)))
      34)

(test ((let ((x 11))
	 (define (inner arg) (+ arg x))
	 (let ((x 2)
	       (inner (lambda (arg) (inner (+ (* 2 arg) x)))))
	   inner))
       3)
      28)

(test ((let ((x 11))
	 (define (inner arg) (+ arg x))
	 (let* ((x 2)
		(inner (lambda (arg) (inner (+ (* 2 arg) x)))))
	   inner))
       3)
      19)

(test (let ((x 1))
	(let* ((f1 (lambda (arg) (+ x arg)))
	       (x 32))
	  (f1 1)))
      2)

(test (let ((inner (lambda (arg) (+ arg 1))))
	(let ((inner (lambda (arg) (+ (inner arg) 1))))
	  (inner 1)))
      3)
(test (let ((inner (lambda (arg) (+ arg 1))))
	(let* ((inner (lambda (arg) (+ (inner arg) 1))))
	  (inner 1)))
      3)

(test (let ((caller #f)) (let ((inner (lambda (arg) (+ arg 1)))) (set! caller inner)) (caller 1)) 2)
(test (let ((caller #f)) (let ((x 11)) (define (inner arg) (+ arg x)) (set! caller inner)) (caller 1)) 12)

(test (let ((caller #f)) 
	(let ((x 11)) 
	  (define (inner arg) 
	    (+ arg x)) 
	  (let ((y 12))
	    (let ((inner (lambda (arg) 
			   (+ (inner x) y arg)))) ; 11 + 11 + 12 + arg
	      (set! caller inner))))
	(caller 1))
      35)

(test (let ((caller #f)) 
	(let ((x 11)) 
	  (define (inner arg) 
	    (+ arg x)) 
	  (let* ((y 12) 
		 (inner (lambda (arg) 
			  (+ (inner x) y arg)))) ; 11 + 11 + 12 + arg
	    (set! caller inner))) 
	(caller 1))
      35)


(test (let* ((f1 3) (f1 4)) f1) 4)
(test (let ((f1 (lambda () 4))) (define (f1) 3) (f1)) 3)

(test (let ((j -1)
	    (k 0))
	(do ((i 0 (+ i j))
	     (j 1))
	    ((= i 3) k)
	  (set! k (+ k i))))
      3)

(test (let ((j (lambda () -1))
	    (k 0))
	(do ((i 0 (+ i (j)))
	     (j (lambda () 1)))
	    ((= i 3) k)
	  (set! k (+ k i))))
      3)


(test (let ((j (lambda () 0))
	    (k 0))
	(do ((i (j) (j))
	     (j (lambda () 1) (lambda () (+ i 1))))
	    ((= i 3) k)
	  (set! k (+ k i))))
      3) ; 6 in Guile which follows the spec

(test (let ((k 0)) (do ((i 0 (+ i 1)) (j 0 (+ j i))) ((= i 3) k) (set! k (+ k j)))) 1)

#|
(test (let ((j (lambda () 0))
	    (i 2)
	    (k 0))
	(do ((i (j) (j))
	     (j (lambda () i) (lambda () (+ i 1))))
	    ((= i 3) k)
	  (set! k (+ k i))))
      3) ; or 2?

(test (let ((f #f))
	(do ((i 0 (+ i 1)))
	    ((= i 3))
	  (let ()
	    (define (x) i)
	    (if (= i 1) (set! f x))))
	(f))
      1)
|#

(test (let ((x 1))
	(let ()
	  (define (f) x)
	  (let ((x 0))
	    (define (g) (set! x 32) (f))
	    (g))))
      1)

(test (let ((a 1))
	(let ()
	  (if (> a 1)
	      (begin
		(define a 2)))
	  a))
      1)

(test (let ((a 1))
	(let ()
	  (if (= a 1)
	      (begin
		(define a 2)))
	  a))
      2)

(let ((x 123))
  (define (hi b) (+ b x))
  (let ((x 321))
    (test (hi 1) 124)
    (set! x 322)
    (test (hi 1) 124))
  (set! x 124)
  (test (hi 1) 125)
  (let ((x 321)
	(y (hi 1)))
    (test y 125))
  (let* ((x 321)
	 (y (hi 1)))
    (test y 125))
  (test (hi 1) 125))

(test (let ((j 0)
	    (k 0))
	(let xyz
	    ((i 0))
	  (let xyz
	      ((i 0))
	    (set! j (+ j 1))
	    (if (< i 3)
		(xyz (+ i 1))))
	  (set! k (+ k 1))
	  (if (< i 3)
	      (xyz (+ i 1))))
	(list j k))
      (list 16 4))

(test (let ((x 123)) (begin (define x 0)) x) 0) ; this strikes me as weird, since (let ((x 123) (x 0)) x) is illegal, so...
(test (let ((x 0)) (define x 1) (define x 2) x) 2) 
(test (let ((x 123)) (begin (define (hi a) (+ x a)) (define x 0)) (hi 1)) 1) ; is non-lexical reference?
(test (let ((x 123)) (define (hi a) (+ x a)) (define x 0) (hi 1)) 1)
(test (let ((x 123) (y 0)) (define (hi a) (+ y a)) (define y x) (define x 0) (hi 1)) 124)

(for-each
 (lambda (arg)
   (test (let ((x arg)) x) arg))
 (list "hi" -1 #\a "" '() '#() (current-output-port) 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t abs (list 1 2 3) '(1 . 2)))

(test (let ((x 1)) (= 1 (let ((y 2)) (set! x y) x)) (+ x 1)) 3)
(test (let ((x 1)) (let ((xx (lambda (a) (set! x a) a))) (= 1 (xx 2))) (+ x 1)) 3)
(test (let ((x 32)) (begin (define x 123) (define (hi a) (+ a 1))) (hi x)) 124)
(test (let () (begin (define x 123) (define (hi a) (+ a 1))) (hi x)) 124)


					;(let ((initial-chars "aA!$%&*/:<=>?^_~")
					;      (subsequent-chars "9aA!$%&*+-./:<=>?@^_~")
					;      (ctr 0))
					;  (format #t ";(let (")
					;  (do ((i 0 (+ i 1)))
					;      ((= i (string-length initial-chars)))
					;    (format #t ";(~A ~D) " (string (string-ref initial-chars i)) ctr)
					;    (set! ctr (+ ctr 1)))
					;
					;  (do ((i 0 (+ i 1)))
					;      ((= i (string-length initial-chars)))
					;    (do ((k 0 (+ k 1)))
					;	((= k (string-length subsequent-chars)))
					;      (format #t ";(~A ~D) " (string (string-ref initial-chars i) (string-ref subsequent-chars k)) ctr)
					;      (set! ctr (+ ctr 1))))
					;
					;  (format #t ")~%  (+ ")
					;  (do ((i 0 (+ i 1)))
					;      ((= i (string-length initial-chars)))
					;    (format #t "~A " (string (string-ref initial-chars i))))
					;
					;  (do ((i 0 (+ i 1)))
					;      ((= i (string-length initial-chars)))
					;    (do ((k 0 (+ k 1)))
					;	((= k (string-length subsequent-chars)))
					;      (format #t "~A " (string (string-ref initial-chars i) (string-ref subsequent-chars k)))))
					;
					;  (format #t "))~%"))

(num-test (let ((a 0) (A 1) (! 2) ($ 3) (% 4) (& 5) (| 8) (? 12) (^ 13) (_ 14) (~ 15) (a9 16) (aa 17) (aA 18) (a! 19) (a$ 20) (a% 21) (a& 22) (a* 23) (a+ 24) (a- 25) (a. 26) (a/ 27) (a| 28) (a< 29) (a= 30) (a> 31) (a? 32) (a@ 33) (a^ 34) (a_ 35) (a~ 36) (A9 37) (Aa 38) (AA 39) (A! 40) (A$ 41) (A% 42) (A& 43) (A* 44) (A+ 45) (A- 46) (A. 47) (A/ 48) (A| 49) (A< 50) (A= 51) (A> 52) (A? 53) (A@ 54) (A^ 55) (A_ 56) (A~ 57) (!9 58) (!a 59) (!A 60) (!! 61) (!$ 62) (!% 63) (!& 64) (!* 65) (!+ 66) (!- 67) (!. 68) (!/ 69) (!| 70) (!< 71) (!= 72) (!> 73) (!? 74) (!@ 75) (!^ 76) (!_ 77) (!~ 78) ($9 79) ($a 80) ($A 81) ($! 82) ($$ 83) ($% 84) ($& 85) ($* 86) ($+ 87) ($- 88) ($. 89) ($/ 90) ($| 91) ($< 92) ($= 93) ($> 94) ($? 95) ($@ 96) ($^ 97) ($_ 98) ($~ 99) (%9 100) (%a 101) (%A 102) (%! 103) (%$ 104) (%% 105) (%& 106) (%* 107) (%+ 108) (%- 109) (%. 110) (%/ 111) (%| 112) (%< 113) (%= 114) (%> 115) (%? 116) (%@ 117) (%^ 118) (%_ 119) (%~ 120) (&9 121) (&a 122) (&A 123) (&! 124) (&$ 125) (&% 126) (&& 127) (&* 128) (&+ 129) (&- 130) (&. 131) (&/ 132) (&| 133) (&< 134) (&= 135) (&> 136) (&? 137) (&@ 138) (&^ 139) (&_ 140) (&~ 141) (*9 142) (*a 143) (*A 144) (*! 145) (*$ 146) (*% 147) (*& 148) (** 149) (*+ 150) (*- 151) (*. 152) (*/ 153) (*| 154) (*< 155) (*= 156) (*> 157) (*? 158) (*@ 159) (*^ 160) (*_ 161) (*~ 162) (/9 163) (/a 164) (/A 165) (/! 166) (/$ 167) (/% 168) (/& 169) (/* 170) (/+ 171) (/- 172) (/. 173) (// 174) (/| 175) (/< 176) (/= 177) (/> 178) (/? 179) (/@ 180) (/^ 181) (/_ 182) (/~ 183) (|9 184) (ca 185) (CA 186) (|! 187) (|$ 188) (|% 189) (|& 190) (|* 191) (|+ 192) (|- 193) (|. 194) (|/ 195) (cc 196) (|< 197) (|= 198) (|> 199) (|? 200) (|@ 201) (|^ 202) (|_ 203) (|~ 204) (<9 205) (<a 206) (<A 207) (<! 208) (<$ 209) (<% 210) (<& 211) (<* 212) (<+ 213) (<- 214) (<. 215) (</ 216) (<| 217) (<< 218) (<> 220) (<? 221) (<@ 222) (<^ 223) (<_ 224) (<~ 225) (=9 226) (=a 227) (=A 228) (=! 229) (=$ 230) (=% 231) (=& 232) (=* 233) (=+ 234) (=- 235) (=. 236) (=/ 237) (=| 238) (=< 239) (== 240) (=> 241) (=? 242) (=@ 243) (=^ 244) (=_ 245) (=~ 246) (>9 247) (>a 248) (>A 249) (>! 250) (>$ 251) (>% 252) (>& 253) (>* 254) (>+ 255) (>- 256) (>. 257) (>/ 258) (>| 259) (>< 260) (>> 262) (>? 263) (>@ 264) (>^ 265) (>_ 266) (>~ 267) (?9 268) (?a 269) (?A 270) (?! 271) (?$ 272) (?% 273) (?& 274) (?* 275) (?+ 276) (?- 277) (?. 278) (?/ 279) (?| 280) (?< 281) (?= 282) (?> 283) (?? 284) (?@ 285) (?^ 286) (?_ 287) (?~ 288) (^9 289) (^a 290) (^A 291) (^! 292) (^$ 293) (^% 294) (^& 295) (^* 296) (^+ 297) (^- 298) (^. 299) (^/ 300) (^| 301) (^< 302) (^= 303) (^> 304) (^? 305) (^@ 306) (^^ 307) (^_ 308) (^~ 309) (_9 310) (_a 311) (_A 312) (_! 313) (_$ 314) (_% 315) (_& 316) (_* 317) (_+ 318) (_- 319) (_. 320) (_/ 321) (_| 322) (_< 323) (_= 324) (_> 325) (_? 326) (_@ 327) (_^ 328) (__ 329) (_~ 330) (~9 331) (~a 332) (~A 333) (~! 334) (~$ 335) (~% 336) (~& 337) (~* 338) (~+ 339) (~- 340) (~. 341) (~/ 342) (~| 343) (~< 344) (~= 345) (~> 346) (~? 347) (~@ 348) (~^ 349) (~_ 350) (~~ 351) )
	    (+ a A ! $ % & | ? ^ _ ~ a9 aa aA a! a$ a% a& a* a+ a- a. a/ a| a< a= a> a? a@ a^ a_ a~ A9 Aa AA A! A$ A% A& A* A+ A- A. A/ A| A< A= A> A? A@ A^ A_ A~ !9 !a !A !! !$ !% !& !* !+ !- !. !/ !| !< != !> !? !@ !^ !_ !~ $9 $a $A $! $$ $% $& $* $+ $- $. $/ $| $< $= $> $? $@ $^ $_ $~ %9 %a %A %! %$ %% %& %* %+ %- %. %/ %| %< %= %> %? %@ %^ %_ %~ &9 &a &A &! &$ &% && &* &+ &- &. &/ &| &< &= &> &? &@ &^ &_ &~ *9 *a *A *! *$ *% *& ** *+ *- *. */ *| *< *= *> *? *@ *^ *_ *~ /9 /a /A /! /$ /% /& /* /+ /- /. // /| /< /= /> /? /@ /^ /_ /~ |9 ca CA |! |$ |% |& |* |+ |- |. |/ cc |< |= |> |? |@ |^ |_ |~ <9 <a <A <! <$ <% <& <* <+ <- <. </ <| << <> <? <@ <^ <_ <~ =9 =a =A =! =$ =% =& =* =+ =- =. =/ =| =< == => =? =@ =^ =_ =~ >9 >a >A >! >$ >% >& >* >+ >- >. >/ >| >< >> >? >@ >^ >_ >~ ?9 ?a ?A ?! ?$ ?% ?& ?* ?+ ?- ?. ?/ ?| ?< ?= ?> ?? ?@ ?^ ?_ ?~ ^9 ^a ^A ^! ^$ ^% ^& ^* ^+ ^- ^. ^/ ^| ^< ^= ^> ^? ^@ ^^ ^_ ^~ _9 _a _A _! _$ _% _& _* _+ _- _. _/ _| _< _= _> _? _@ _^ __ _~ ~9 ~a ~A ~! ~$ ~% ~& ~* ~+ ~- ~. ~/ ~| ~< ~= ~> ~? ~@ ~^ ~_ ~~ ))
	  61253)

(test (let ()(+ (let ((x 0) (y 1) (z 2) )(+ x y (let ((x 3) )(+ x (let ()(+ (let ()
									      (+ (let ((x 0) (y 1) (z 2) )(+ x y z (let ((x 3) )(+ x (let ((x 4) (y 5) (z 6) )
																       (+ x y z (let ()(+ (let ((x 7) )(+ x (let ()(+ (let ((x 8) (y 9) )
																							(+ x (let ((x 10) (y 11) (z 12) )(+ x  ))))))))))))))))))))))))))
      50)
(test  (let* ((x 0) (y x) )(+ x y (let ()(+ (let ((x 2) )(+ x (let ()(+ (let ((x 4) )
									  (+ x (let ((x 5) )(+ x (let ((x 6) (y x) (z y) )(+ x (let ((x 7) (y x) )
																 (+ x (let ((x 8) (y x) )(+ x y (let ((x 9) (y x) (z y) )(+ x ))))))))))))))))))))
       48)
(test (let* ((x 0) (y x) )(+ x y (let* ()(+ (let* ((x 2) )(+ x (let* ()(+ (let* ((x 4) )
									    (+ x (let* ((x 5) )(+ x (let* ((x 6) (y x) (z y) )(+ x (let* ((x 7) (y x) )
																     (+ x (let* ((x 8) (y x) )(+ x y (let* ((x 9) (y x) (z y) )(+ x ))))))))))))))))))))
      49)

(test (let ((!@$%^&*~|}{?><.,/`_-+=:! 1)) (+ !@$%^&*~|}{?><.,/`_-+=:! 1)) 2)
(test (let ((:hi 1)) :hi) 'error)
(test (let ((:hi: 1)) :hi:) 'error)
(test (let ((hi: 1)) hi) 'error)
(let ((1.0+2j (lambda (a) (+ a 1.0+2i))))
  (num-test (1.0+2j 3+i) 4.0+3i))
(test (let ((*1.11* 3)) *1.11*) 3)

(test (let func ((a 1) (b 2)) (set! b a) (if (> b 0) (func (- a 1) b)) b) 1)
(test (let func ((a 1) (b 2)) (set! b a) (if (> b 0) (func (- a 1) b) b)) 0)
(test (let loop ((numbers '(3 -2 1 6 -5))
		 (nonneg '())
		 (neg '()))
	(cond ((null? numbers) (list nonneg neg))
	      ((>= (car numbers) 0)
	       (loop (cdr numbers)
		     (cons (car numbers) nonneg)
		     neg))
	      ((< (car numbers) 0)
	       (loop (cdr numbers)
		     nonneg
		     (cons (car numbers) neg)))))   
      '((6 1 3) (-5 -2)))
(test (let ((b '(1 2 3)))
	(let* ((a b)
	       (b (cons 0 a)))
	  (let b ((a b))
	    (if (null? a)
		'done
		(b (cdr a))))))
      'done)
(test (let lp ((x 100))
	(if (positive? x)
	    (lp (- x 1))
	    x))
      0)
(test (let func ((a 1) (b 2) (c 3)) (+ a b c (if (> a 1) (func (- a 1) (- b 1) (- c 1)) 0))) 6)
(test (let func ((a 1) (b 2) (c 3)) (+ a b c (if (> a 1) (func (- a 1) (- b 1)) 0))) 6) ; these work only because we don't try to call func -- maybe they should anyway?
(test (let func ((a 1) (b 2) (c 3)) (+ a b c (if (> a 1) (func (- a 1)) 0))) 6)
(test (let func ((a 1) (b 2) (c 3)) (+ a b c (if (> a 1) (func) 0))) 6)
(test (let func ((a 1) (b 2) (c 3)) (+ a b c (if (> a 0) (func (- a 1) (- b 1) (- c 1)) 0))) 9)

(test (let func ((a 1) (b 2) (c 3)) (+ a b c (if (> a 0) (func (- a 1) (- b 1)) 0))) 'error)
(test (let func () 1) 1)
(test (let ((a 1)) (let func () (if (> a 1) (begin (set! a (- a 1)) (func)) 0))) 0)
(test (let func1 ((a 1)) (+ (let func2 ((a 2)) a) a)) 3)
(test (let func1 ((a 1)) (+ (if (> a 0) (func1 (- a 1)) (let func2 ((a 2)) (if (> a 0) (func2 (- a 1)) 0))) a)) 1)
(test (let func ((a (let func ((a 1)) a))) a) 1)
(test (let ((i 3)) (let func () (set! i (- i 1)) (if (> i 0) (func))) i) 0)
(test (let func ((a 1)) (define (func a) 2) (func 1)) 2)
(test (let func ((a 1)) (define func (lambda (a) (func a))) (if (> a 1) (func (- a 1)) 0)) 0)
(test (let loop ((i 0)) (let loop ((i 0)) (if (< i 1) (loop (+ i 1)))) i) 0)
(test (let ((j 123)) (define (f g) (set! j 0) (g 0)) (let loop ((i 1)) (if (> i 0) (f loop))) j) 0)
(test (procedure? (let loop () loop)) #t)
(test (let loop1 ((func 0)) (let loop2 ((i 0)) (if (not (procedure? func)) (loop1 loop2)) func)) 0)
(test (let ((k 0)) (let ((x (let xyz ((i 0)) (set! k (+ k 1)) xyz))) (x 0)) k) 2)
(test (let ((hi' 3) (a'b 2)) (+ hi' a'b)) 5)
(test (let ((hi''' 3) (a'''b 2)) (+ hi''' a'''b)) 5)
(test (let ((f (let func ((i 0)) (if (= i 0) func (if (> i 1) (+ i (func (- i 1))) 1))))) (map f '(1 2 3))) '(1 3 6))
(test (let ((x 0)) (let ((f (lambda (a) (+ a x)))) (map (let () (set! x (+ x 1)) f) '(1 2 3)))) '(2 3 4))
(test (let x ((x (lambda (y) y))) (x 2)) 2)

(let ((enter 0)
      (exit 0)
      (inner 0))
  (define (j1) 
    (set! enter (+ enter 1))
    (let ((result 
	   (let hiho
	       ((i 0))
	     (set! inner (+ inner 1))
	     (if (< i 3) 
		 hiho
		 i))))
      (set! exit (+ exit 1))
      result))

  (let ((j2 (j1)))
    (test (and (procedure? j2) (= enter 1) (= exit 1) (= inner 1)) #t)
    (let ((result (j2 1)))
      (test (and (procedure? result) (= enter 1) (= exit 1) (= inner 2)) #t)
      (set! result (j2 3))
      (test (and (= result 3) (= enter 1) (= exit 1) (= inner 3)) #t))))


(let ()
  (define (block-comment-test a b c)
    (+ a b c))

  (let ((val (block-comment-test 
#|
	    a comment
|#
	    1 #| this is a |# 
#|
            another comment
|#
 2 #| this is b |# 3)))

    (test val 6)))


(test (letrec* ((p (lambda (x)
		     (+ 1 (q (- x 1)))))
		(q (lambda (y)
		     (if (zero? y)
			 0
			 (+ 1 (p (- y 1))))))
		(x (p 5))
		(y x))
	       y)
      5)
(test (letrec ((p (lambda (x)
		     (+ 1 (q (- x 1)))))
		(q (lambda (y)
		     (if (zero? y)
			 0
			 (+ 1 (p (- y 1))))))
		(x (p 5))
		(y x))
	       y)
      'error)
(test (let* ((p (lambda (x)
		     (+ 1 (q (- x 1)))))
		(q (lambda (y)
		     (if (zero? y)
			 0
			 (+ 1 (p (- y 1))))))
		(x (p 5))
		(y x))
	       y)
      'error)

(test (let ((x 1) ((y 2))) x) 'error)
(test (let ((x 1 2 3)) x) 'error)
(test (let ((+ 1 2)) 2) 'error)
(test (let* ((x 1 2)) x) 'error)
(test (letrec ((x 1 2)) x) 'error)
(test (letrec* ((x 1 2)) x) 'error)
(test (let ((x 1 . 2)) x) 'error)
(test (let ((x 1 , 2)) x) 'error)
(test (let ((x . 1)) x) 'error)
(test (let* ((x . 1)) x) 'error)
(test (letrec ((x . 1)) x) 'error)
(test (letrec* ((x . 1)) x) 'error)
(test (let hi ()) 'error)
(test (let* ((x -1) 2) 3) 'error)
(test (let ((x -1) 2) 3) 'error)
(test (letrec ((x -1) 2) 3) 'error)
(test (let ((pi 3)) pi) 'error)
(test (let* ((pi 3)) pi) 'error)
(test (letrec ((pi 3)) pi) 'error)

(test (let hiho ((a 3) (hiho 4)) a) 3)
(test (let hiho ((hiho 4)) hiho) 4)                ; guile=4
(test (let hiho ((hiho hiho)) hiho) 'error)        ; guile sez error
(test (let ((hiho 4) (hiho 5)) hiho) 'error)       ; guile sez error
(test (let hiho ((a (hiho 1))) a) 'error)          ; guile sez error
(test (let hiho ((hiho 3)) (hiho hiho)) 'error)    ; guile sez error

(test (let) 'error)
(test (let*) 'error)
(test (letrec) 'error)
(test (let . 1) 'error)
(test (let* (x)) 'error)
(test (let (x) 1) 'error)
(test (let ((x)) 3) 'error)
(test (let ((x 1) y) x) 'error)
(test (let* x ()) 'error)
(test (let* ((1 2)) 3) 'error)
(test (let () ) 'error)
(test (let '() 3) 'error)
(test (let* ((x 1))) 'error)
(test (let ((x 1)) (letrec ((x 32) (y x)) (+ 1 y))) 'error) ; #<unspecified> seems reasonable if not the 1+ 
(test (let ((x 1)) (letrec ((y x) (x 32)) (+ 1 y))) 'error)
(test (let ((x 1)) (letrec ((y x) (x 32)) 1)) 1)
(test (let ((x 1)) (letrec ((y (let () (+ x 1))) (x 32)) (+ 1 y))) 'error)
(test (let ((x 1)) (letrec ((y (let ((xx (+ x 1))) xx)) (x 32)) (+ 1 y))) 'error)
(test (let ((x 32)) (letrec ((y (apply list `(* ,x 2))) (x 1)) y)) '(* #<undefined> 2))
(test (letrec) 'error)
(test (letrec*) 'error)
(test (let ((x . 1)) x) 'error)
(test (letrec* ((and #2D((1 2) (3 4)) 3/4))) 'error)
(test (letrec* ((hi "" #\a))) 'error)

(test (let #((a 1)) a) 'error)
(test (let* #((a 1)) a) 'error)
(test (letrec #((a 1)) a) 'error)
(test (letrec* #((a 1)) a) 'error)

;; (let *((a 1)) a) -> 1 ; * is named let name?
(test (letrec *((a 1)) a) 'error)
(test (letrec* *((a 1)) a) 'error)
(test (letrec* (((a 1) 2)) a) 'error)
(test (letrec* (#(a 1) 2) a) 'error)
(test (letrec* ((a a)) a) #<undefined>) ; hmm -- guile says Variable used before given a value: a
(test (let . (((a 1)) a)) 1)
(test (let '((a 1)) a) 'error)
(test (let (((x 1)) 2) 3) 'error)
(test (let ((#f 1)) #f) 'error)
(test (let (()) #f) 'error)
(test (let (lambda () ) #f) 'error)
(test (let ((f1 3) (f1 4)) f1) 'error) ; not sure about this
;;   (let () (define (f1) 3) (define (f1) 4) (f1))
(test (let ((asdf (lambda (a) (if (> a 0) (asdf (- a 1)) 0)))) (asdf 3)) 'error)
(test (let* ((asdf (lambda (a) (if (> a 0) (asdf (- a 1)) 0)))) (asdf 3)) 'error)
(test (let (('a 3)) 1) 'error)
(test (let ((#\a 3)) #\a) 'error)
;;      (test (let ((#z1 2)) 1) 'error)
(test (let ('a 3) 1) 'error)
(test (let 'a 1) 'error)
(test (let* func ((a 1)) a) 1)
(test (letrec func ((a 1)) a) 'error)
(test (letrec* func ((a 1)) a) 'error)

(test (let ((1 3)) 3) 'error)
(test (let ((#t 3)) 3) 'error)
(test (let ((() 3)) 3) 'error)
(test (let ((#\c 3)) 3) 'error)
(test (let (("hi" 3)) 3) 'error)
(test (let ((:hi 3)) 3) 'error)

(test (let 1 ((i 0)) i) 'error)
(test (let #f ((i 0)) i) 'error)
(test (let "hi" ((i 0)) i) 'error)
(test (let #\c ((i 0)) i) 'error)
(test (let :hi ((i 0)) i) 'error)
(test (let pi () #f) 'error)

(test (let func ((a 1) . b) a) 'error)
(test (let func a . b) 'error)
(test (let let func ((a 1)) func) 'error)
(test (let func 1 ((x 1)) x) 'error)
(test (let func ((a 1) . b) (if (> a 0) (func (- a 1) 2 3) b)) 'error)
(test (let func ((a . 1)) a) 'error)
(test (let func (a . 1) a) 'error)
(test (let ((a 1) . b) a) 'error)
(test (let* ((a 1) . b) a) 'error)
(test (let func ((a func) (i 1)) i) 'error)
(test (let func ((i 0)) (if (< i 1) (func))) 'error)
(test (let func (let ((i 0)) (if (< i 1) (begin (set! i (+ i 1)) (func))))) 'error)
(test (let ((x 0)) (set! x (+ x 1)) (begin (define y 1)) (+ x y)) 2)
(test (let loop loop) 'error)
(test (let loop (loop)) 'error)
(test (let loop ((i 0) (loop 1)) i) 0) ; this used to be an error, Guile also returns 0

(test (letrec ((cons 1 (quote ())) . #(1)) 1) 'error)
(test (letrec ((a 1) . 2) 1) 'error)
(test (let* ((a 1) (b . 2) . 1) (())) 'error)
(test (let "" 1) 'error)
(test (let "hi" 1) 'error)
(test (let #(1) 1) 'error)
(test (let __hi__ #t) 'error)
(test (letrec (1 2) #t) 'error)
(test (letrec* (1 2) #t) 'error)
(test (let hi (()) 1) 'error)
(test (let hi a 1) 'error)

;;; named let*
(test (let* hi #t) 'error)
(test (let* "hi" () #f) 'error)
(test (let* hi ()) 'error)
(test (let* pi () #f) 'error)
(test (let* hi x 1) 'error)
(test (let* hi (c) 1) 'error)
(test (let* hi ((x . 1)) #f) 'error)
;(test (let* hi . a 1) 'error) -- reader error in this context
(test (let* hi ((a 1) . b) a) 'error)
(test (let* hi ((a 1) :key b) a) 'error)
(test (let* hi ((a 1) :allow-other-keys) a) 'error)
(test (let* hi (a b) a) 'error)

(test (let* hi () 1) 1)
(test (let* func ((i 1) (j 2)) (+ i j (if (> i 0) (func (- i 1)) 0))) 5)
(test (let* func ((i 1) (j 2) (k (+ j 1))) (+ i j k (if (> i 0) (func (- i 1)) 0))) 11)
(test (let* func ((i 1) (j 2) (k (+ j 1))) (+ i j k (let () (set! j -123) (if (> i 0) (func (- i 1)) 0)))) 11)
(test (let* func1 ((a 1) (b 2)) (+ a b (let* func2 ((a -1) (b (- a 1))) (if (< a 0) (func2 (+ a 1)) b)))) 1) ; 2nd b is -2
(test (procedure? (let* func ((i 1) (j 2) (k (+ j 1))) func)) #t)
(test (let* func ((a 1) (b 2)) (+ a b (if (> a 0) (func (- a 1) (- b 1)) 0))) 4)
(test (let* func ((a 1) (b 2)) (+ a b)) 3)
(test (let* func ((a (+ 1 2)) (b (+ a 2))) (+ a b)) 8)
(test (let* func ((a 1) (b 2)) (+ a b (if (> a 0) (func (- a 1) :b (- b 1)) 0))) 4)
(test (let* func ((a 1) (b 2)) (+ a b (if (> a 0) (func :a (- a 1) :b (- b 1)) 0))) 4)
(test (let* func ((a 1) (b 2)) (+ a b (if (> a 0) (func :b (- b 1) :a (- a 1)) 0))) 4)
(test (let* func ((a 1) (b 2)) (+ a b (if (> a 0) (func :a (- a 1)) 0))) 5)

;;; these ought to work, but see s7.c under EVAL: (it's a speed issue)
;(test (let let ((i 0)) (if (< i 3) (let (+ i 1)) i)) 3)
;(test (let () (define (if a) a) (if 1)) 1)
;(test (let begin ((i 0)) (if (< i 3) (begin (+ i 1)) i)) 3)


;;; from the scheme wiki
;;; http://community.schemewiki.org/?sieve-of-eratosthenes

(let ((results '(2)))
  (define (primes n) 
    (let ((pvector (make-vector (+ 1 n) #t))) ; if slot k then 2k+1 is a prime 
      (let loop ((p 3) ; Maintains invariant p = 2j + 1 
		 (q 4) ; Maintains invariant q = 2j + 2jj 
		 (j 1) 
		 (k '()) 
		 (vec pvector)) 
	(letrec ((lp (lambda (p q j k vec) 
		       (loop (+ 2 p) 
			     (+ q (- (* 2 (+ 2 p)) 2)) 
			     (+ 1 j) 
			     k 
			     vec))) 
		 (eradicate (lambda (q p vec) 
			      (if (<= q n) 
				  (begin (vector-set! vec q #f) 
					 (eradicate (+ q p) p vec)) 
				  vec)))) 
          (if (<= j n) 
	      (if (eq? #t (vector-ref vec j)) 
		  (begin (set! results (cons p results))
			 (lp p q j q (eradicate q p vec))) 
		  (lp p q j k vec)) 
	      (reverse results))))))
  (test (primes 10) '(2 3 5 7 11 13 17 19)))

(test (let ((gvar 32)) (define (hi1 a) (+ a gvar)) (let ((gvar 0)) (hi1 2))) 34)
(test (let ((gvar 32)) (define-macro (hi2 b) `(* gvar ,b)) (define (hi1 a) (+ (hi2 a) gvar)) (let ((gvar 0)) (hi1 2))) 96)
(test (let ((gvar 32)) (define-macro (hi2 b) `(* gvar ,b)) (define (hi1 a) (+ a gvar)) (let ((gvar 0)) (hi1 (hi2 2)))) 32)
(test (let ((gvar 32)) (define-macro (hi2 b) `(* gvar ,b)) (define (hi1 a) (+ (a 2) gvar)) (let ((gvar 0)) (define (hi2 a) (* a 2)) (hi1 hi2))) 36)
(test (let ((gvar 32)) (define-macro (hi2 b) `(* gvar ,b)) (define (hi1 a) (+ (a 2) gvar)) (let ((gvar 0) (hi2 (lambda (a) (hi2 a)))) (hi1 hi2))) 96)
(test (let ((gvar 32)) (define-macro (hi2 b) `(* gvar ,b)) (define (hi1 a) (+ (a 2) gvar)) (let* ((gvar 0) (hi2 (lambda (a) (hi2 a)))) (hi1 hi2))) 32)
(test (let () ((let ((gvar 32)) (define-macro (hi2 b) `(* gvar ,b)) (define (hi1 a) (+ (hi2 2) gvar)) hi1) 2)) 96)
(test (let ((gvar 0)) ((let ((gvar 1)) (define-macro (hi2 b) `(+ gvar ,b)) (define (hi1 a) (let ((gvar 2)) (hi2 a))) hi1) 2)) 4)
(test (let ((gvar 0)) (define-macro (hi2 b) `(+ gvar ,b)) ((let ((gvar 1)) (define (hi1 a) (let ((gvar 2)) (a 2))) hi1) hi2)) 4)
(test (let ((gvar 0)) (define-macro (hi2 b) `(+ gvar ,b)) ((let ((gvar 1)) (define (hi1 a) (a 2)) hi1) hi2)) 3)
(test (let () (define-macro (hi2 b) `(+ gvar ,b)) ((let ((gvar 1)) (define (hi1 a) (a 2)) hi1) hi2)) 3)
(test (let ((y 1) (x (let ((y 2) (x (let ((y 3) (x 4)) (+ x y)))) (+ x y)))) (+ x y)) 10)
(test (let ((x 0)) 
	(+ (let ((x 1) (y (+ x 1))) 
	  (+ (let ((x 2) (y (+ x 1))) 
	    (+ (let ((x 3) (y (+ x 1))) 
	      (+ (let ((x 4) (y (+ x 1))) 
		(+ (let ((x 5) (y (+ x 1)))
		  (+ (let ((x 6) (y (+ x 1))) 
		    (+ (let ((x 7) (y (+ x 1)))
			 (+ x y)) x)) x)) x)) x)) x)) x)) x)) 35)

(test (let loop ((lst (list 1 2)) 
		 (i 0) 
		 (sum 0))
	(if (or (null? lst)
		(> i 10))
	    sum
	    (begin
	      (set-cdr! (cdr lst) lst)
	      (loop (cdr lst) (+ i 1) (+ sum (car lst))))))
      16)

;;; these are confusing:
;(letrec ((if 0.0)) ((lambda () (if #t "hi")))) -> "hi"
;(let ((let 0)) let) -> 0
;(let* ((lambda 0)) ((lambda () 1.5))) -> 1.5 ; syntax error in Guile
;(let* ((lambda 0)) lambda) -> 0

;; from test-submodel.scm, from MIT I think
(test (letrec ((factorial
		(lambda (n)
		  (if (<= n 0) 1 (* n (factorial (- n 1)))))))
	(factorial 3))
      6)

(test (letrec ((iter-fact
		(lambda (n)
		  (letrec
		      ((helper (lambda (n p)
				 (if (<= n 0) p (helper (- n 1) (* n p))))))
		    (helper n 1)))))
	(iter-fact 3))
      6)

(test (letrec ((y-factorial
		(lambda (n)
		  (letrec ((y
			    (lambda (f)
			      ((lambda (x)
				 (f (lambda (z) ((x x) z))))
			       (lambda (x)
				 (f (lambda (z) ((x x) z)))))))
			   (fact-def
			    (lambda (fact)
			      (lambda (n)
				(if (<= n 0)
				    1
				    (* n (fact (- n 1))))))))
		    ((y fact-def) n)))))
	(y-factorial 3))
      6)

(test (let ((x 1)) (let ((x 0) (y x)) (cons x y))) '(0 . 1))
(test (let ((x 1)) (let* ((x 0) (y x)) (cons x y))) '(0 . 0))
(test (let ((x 1)) (letrec ((x 0) (y x)) (cons x y))) '(0 . #<undefined>))
(test (let ((x 1)) (letrec* ((x 0) (y x)) (cons x y))) '(0 . 0))

(test (let ((x 1)) (let ((x 0) (y (let () (set! x 2) x))) (cons x y))) '(0 . 2))
(test (let ((x 1)) (letrec ((x 0) (y (let () (set! x 2) x))) (cons x y))) '(0 . 2))
(test (let ((x 1)) (let* ((x 0) (y (let () (set! x 2) x))) (cons x y))) '(2 . 2))
(test (let ((x 1)) (letrec* ((x 0) (y (let () (set! x 2) x))) (cons x y))) '(2 . 2))

(test (letrec ((x x)) x) #<undefined>) ; weird
(test (letrec ((x y) (y x)) x) #<undefined>)

(test (procedure? (letrec ((x (lambda () x))) x)) #t)
(test (procedure? (letrec ((x (lambda () x))) (x))) #t)
(test (letrec ((x (lambda () x))) (equal? x (x))) #t)  ; !
(test (letrec ((x (lambda () x))) (equal? x ((x)))) #t)  ; !

(test (letrec* ()) 'error)
(test (letrec* ((x 1 x)) x) 'error)
;(test (letrec ((x (let () (set! y 1) y)) (y (let () (set! y (+ y 1)) y))) (list x y)) '(1 2)) ; ! this depends on letrec binding order

(test (letrec ((x 1) (y x)) (list x y)) '(1 #<undefined>)) ; guile says '(1 1)
(test (letrec ((y x) (x 1)) (list x y)) '(1 #<undefined>)) ; guile says '(1 1)
(test (letrec ((x 1) (y (let () (set! x 2) x))) (list x y)) '(1 2))
(test (letrec ((history (list 9))) ((lambda (n) (begin (set! history (cons history n)) history)) 8)) '((9) . 8))
(test (((call/cc (lambda (k) k)) (lambda (x) x)) 'HEY!) 'HEY!)

(let ((sequence '()))
  ((call-with-current-continuation
    (lambda (goto)
      (letrec ((start
		(lambda ()
		  (begin (set! sequence (cons 'start sequence))
			 (goto next))))
	       (froz
		(lambda ()
		  (begin (set! sequence (cons 'froz sequence))
			 (goto last))))
	       (next
		(lambda ()
		  (begin (set! sequence (cons 'next sequence))
			 (goto froz))))
	       (last
		(lambda ()
		  (begin (set! sequence (cons 'last sequence))
			 #f))))
	start))))
  (test (reverse sequence) '(start next froz last)))

(let ()
  (define thunk 'dummy-thunk)

  (define (make-fringe-thunk tree)
    (call-with-exit
     (lambda (return-to-repl)
       (cond ((pair? tree) (begin (make-fringe-thunk (car tree))
				  (make-fringe-thunk (cdr tree))))
	     ((null? tree) (begin (set! thunk (lambda () 'done)) 'null))
	     (else (call/cc
		    (lambda (cc)
		      (begin
			(set! thunk
			      (lambda ()
				(begin (display tree) (cc 'leaf))))
			(return-to-repl 'thunk-set!)))))))))

  (define tr '(() () (((1 (( (() 2 (3 4)) (((5))) )) ))) ))
  (test (make-fringe-thunk tr) 'null)
  (test (thunk) 'done))

;;; evaluation order matters, but in s7 it's always left -> right
(test (let ((x 1)) (+ x (let () (define x 2) x))) 3)
(test (let ((x 1)) (+ (begin (define x 2) x) x)) 4)
(test (let ((x 1)) (+ x (begin (define x 2) x))) 3) 
(test (let ((x 1)) (+ x (begin (set! x 2) x))) 3)
(test (let ((x 1)) (+ (begin (set! x 2) x) x)) 4)
(test (let ((x 1)) ((if (= x 1) + -) x (begin (set! x 2) x))) 3) 

(let ()
  (define-constant _letrec_x_ 32)
  (test (letrec ((_letrec_x_ 1)) _letrec_x_) 'error))
(let ()
  (define-constant _let_x_ 32)
  (test (let ((_let_x_ 1)) _let_x_) 'error))
(let ()
  (define-constant _let*_x_ 32)
  (test (let* ((_let*_x_ 1)) _let*_x_) 'error))

#|
  ;; Al Petrovky says this should return #t, but in s7 it is #f
  (letrec ((x (call/cc list)) (y (call/cc list)))
    (cond ((procedure? x) (x (pair? y)))
          ((procedure? y) (y (pair? x))))
    (let ((x (car x)) (y (car y)))
      (and (call/cc x) (call/cc y) (call/cc x))))
|#
