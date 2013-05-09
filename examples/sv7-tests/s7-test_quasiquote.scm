(test `(1 2 3) '(1 2 3))
(test `() '())
(test `(list ,(+ 1 2) 4)  '(list 3 4))
(test `(1 ,@(list 1 2) 4) '(1 1 2 4))
(test `#(1 ,@(list 1 2) 4) '#(1 1 2 4))
(test `(a ,(+ 1 2) ,@(map abs '(4 -5 6)) b) '(a 3 4 5 6 b))
(if (eqv? 2 (sqrt 4))
    (test `#(10 5 ,(sqrt 4) ,@(map sqrt '(16 9)) 8) '#(10 5 2 4 3 8))) ; inexactness foolishness
(test `(a `(b ,(+ 1 2) ,(foo ,(+ 1 3) d) e) f) '(a `(b ,(+ 1 2) ,(foo 4 d) e) f))
(test (let ((name1 'x) (name2 'y)) `(a `(b ,,name1 ,',name2 d) e)) '(a `(b ,x ,'y d) e))
(test `(1 2 ,(* 9 9) 3 4) '(1 2 81 3 4))
(test `(1 ,(+ 1 1) 3) '(1 2 3))                     
(test `(,(+ 1 2)) '(3))
(test `(,'a . ,'b) (cons 'a 'b))
(test `(,@'() . foo) 'foo)
(test `(1 , 2) '(1 2))
(test `(1 , @(list 2 3)) 'error) ; ?? this is an error in Guile and Clisp
(test `(1 ,@ (list 2 3)) '(1 2 3)) ; seems a bit arbitrary
(test `(1 ,@(list)) '(1))
(test `(1 ,@()) '(1))
(test `(1 ,@'()) '(1))
(test `(1 . ,()) '(1))
(test `(1 , #|a comment|# 2) '(1 2))
(test `(1 ,@ #|a comment|# (list 2 3)) '(1 2 3))
(test `(1 , ;a comment
                       2) '(1 2))
(test `(1 #||#,2) '(1 2))
(test `(1 #||#,@(list #||# 2 3 #||#)) '(1 2 3))
(test (eval ``(+ 1 ,@,@'('(2 3)))) '(+ 1 2 3))
(test (eval ``(+ 1   ,@ #||#  ,@   '('(2 3)))) '(+ 1 2 3))
(test `(,1 ,1) '(1 1))
(test `(,1 ,`,1) '(1 1))
(test `(,1 ,`,@(list 1)) '(1 1))
(test `(,1 ,`,`,1) '(1 1))
(test `(,1 ,`,@'(1)) '(1 1))
(test `(,1 ,`,@`(1)) '(1 1))
(test `(,1 ,`,@`(,1)) '(1 1))
(test `(,1 ,@`,@(list (list 1))) '(1 1))
(test (eval ``(,,1 ,@,@(list (quote (list 1))))) '(1 1))
(test (eval ``(,,1 ,@,@(list `(list 1)))) '(1 1))
(test (eval (eval ```(,,,1 ,@,@,@(list '(list '(list 1)))))) '(1 1))
(test (+ 1 (eval (eval ```,@,,@(list ''(list 2 3))))) 6)
(test (+ 1 (eval (eval (eval ````,@,,,@(list '''(list 2 3)))))) 6)
(test (apply + `(1 ,@`(2 ,@(list 3)))) 6)
(test (eval `(- ,@()',1)) -1)
(test (eval `(,- ,@()'1)) -1)
(test (eval (eval ``(- ,@,@'(,1())))) -1)
(test (eval (eval ``(,@,@'(- ,1())))) -1)
(test (eval (eval ``(,- ,@,@'(1())))) -1)
(test (eval (eval ``(,- ,@'(,@()1)))) -1)
(test (eval (eval ``(- ,@,@',().(1)))) -1)
(test (quasiquote quote) 'quote)
(test (eval (list quasiquote (list values #t))) (list values #t))

(test (eq? (cadr `(a, b, c,)) 'b,) #t)
(test (eq? (cadr '(a, b, c,)) 'b,) #t)
(test (let ((b, 32)) `(a , b, c,)) '(a 32 c,))
(test (let ((b, 32)) `(a, , b, c,)) '(a, 32 c,))
(if (not (provided? 'immutable-unquote)) (test (equal? (let ((b, 32)) '(a, , b, c,)) '(a, (unquote b,) c,)) #t)) ; comma by itself (no symbol) is an error
(if (not (provided? 'immutable-unquote)) (test (equal? (let ((b, 32)) '(a, ,  , b, c,)) '(a, (unquote (unquote b,)) c,)) #t))
;(test (equal? (let ((b 32)) (let ((b, b)) ``(a, ,  , b, c,))) '({list} 'a, 32 'c,)) #t)

(if (provided? 'immutable-unquote)
    (begin
      (test (let () (macro? (eval (define-bacro* ,@ 1 (abs ))))) 'error)
      (test (let () (define-bacro* ,@ 1 (abs ))) 'error)
      (test (let () (define* ,() (abs ))) 'error)
      (test (let () (define-macro* ,(a) ,a)) 'error)
      (test (let (,'a) unquote) 'error)
      (test (let (, '1) unquote) 'error)
      (test (let (, (lambda (x) (+ x 1))) ,,,,'3) 'error)
      (test (let (,@ '(1)) unquote) 'error)
      (test (let (,@ ()) ,2) 'error)
      (test (let (' 1) quote) 1)
      )
    (begin
      (test (let () (macro? (eval (define-bacro* ,@ 1 (abs ))))) #t)
      (test (let () (define-bacro* ,@ 1 (abs ))) 'unquote)
      (test (let () (define* ,() (abs ))) 'error)
      (test (let () (define-macro* ,(a) ,a)) 'unquote)
      (test (let (,'a) unquote) 'a)
      (test (let (, '1) unquote) 1)
      (test (let (, (lambda (x) (+ x 1))) ,,,,'3) 7)
      (test (let (,@ '(1)) unquote) 1)
      (test (let (,@ ()) ,2) 2)
      (test (let (' 1) quote) 1)
      ))

;; from gauche
(let ((quasi0 99)
      (quasi1 101)
      (quasi2 '(a b))
      (quasi3 '(c d)))
  (test `,quasi0 99)
  (test `,quasi1 101)
  (test `(,(cons 1 2)) '((1 . 2)))
  (test `(,(cons 1 2) 3) '((1 . 2) 3))
  (test `(,quasi0 3) '(99 3))
  (test `(3 ,quasi0) '(3 99))
  (test `(,(+ quasi0 1) 3) '(100 3))
  (test `(3 ,(+ quasi0 1)) '(3 100))
  (test `(,quasi1 3) '(101 3))
  (test `(3 ,quasi1) '(3 101))
  (test `(,(+ quasi1 1) 3) '(102 3))
  (test `(3 ,(+ quasi1 1)) '(3 102))
  (test `(1 ,@(list 2 3) 4) '(1 2 3 4))
  (test `(1 2 ,@(list 3 4)) '(1 2 3 4))
  (test `(,@quasi2 ,@quasi3) '(a b c d))
  (test `(1 2 . ,(list 3 4)) '(1 2 3 4))
  (test `(,@quasi2 . ,quasi3) '(a b c d))
  (test `#(,(cons 1 2) 3) '#((1 . 2) 3))
;  (test `#(,quasi0 3) '#(99 3)) ; and (let ((quasi0 99)) (quasiquote #(,quasi0 3))) -> #((unquote quasi0) 3)
;  (test `#(,(+ quasi0 1) 3) '#(100 3))
;  (test `#(3 ,quasi1) '#(3 101))
;  (test `#(3 ,(+ quasi1 1)) '#(3 102))
  (test `#(1 ,@(list 2 3) 4) '#(1 2 3 4))
  (test `#(1 2 ,@(list 3 4)) '#(1 2 3 4))
;  (test `#(,@quasi2 ,@quasi3) '#(a b c d))
;  (test `#(,@quasi2 ,quasi3) '#(a b (c d)))
;  (test `#(,quasi2  ,@quasi3) '#((a b) c d))

;;; the vector quasiquote comma-eval takes place in the global environment so
;;;   (let ((x 0)) (let ((y `#(,(begin (define x 32) x)))) (list x y))) -> '(0 #(32)) and defines x=32 in the top level

  (test `#() '#())
  (test `#(,@(list)) '#())
  (test `(,@(list 1 2) ,@(list 1 2)) '(1 2 1 2))
  (test `(,@(list 1 2) a ,@(list 1 2)) '(1 2 a 1 2))
  (test `(a ,@(list 1 2) ,@(list 1 2)) '(a 1 2 1 2))
  (test `(,@(list 1 2) ,@(list 1 2) a) '(1 2 1 2 a))
  (test `(,@(list 1 2) ,@(list 1 2) a b) '(1 2 1 2 a b))
  (test `(,@(list 1 2) ,@(list 1 2) . a) '(1 2 1 2 . a))
  (test `(,@(list 1 2) ,@(list 1 2) . ,(cons 1 2)) '(1 2 1 2 1 . 2))
  (test `(,@(list 1 2) ,@(list 1 2) . ,quasi2) '(1 2 1 2 a b))
  (test `(,@(list 1 2) ,@(list 1 2) a . ,(cons 1 2)) '(1 2 1 2 a 1 . 2))
  (test `(,@(list 1 2) ,@(list 1 2) a . ,quasi3) '(1 2 1 2 a c d))
  (test `#(,@(list 1 2) ,@(list 1 2)) '#(1 2 1 2))
  (test `#(,@(list 1 2) a ,@(list 1 2)) '#(1 2 a 1 2))
  (test `#(a ,@(list 1 2) ,@(list 1 2)) '#(a 1 2 1 2))
  (test `#(,@(list 1 2) ,@(list 1 2) a) '#(1 2 1 2 a))
  (test `#(,@(list 1 2) ,@(list 1 2) a b) '#(1 2 1 2 a b))
;  (test `(1 `(1 ,2 ,,(+ 1 2)) 1) '(1 `(1 ,2 ,3) 1))
;  (test `(1 `(1 ,,quasi0 ,,quasi1) 1) '(1 `(1 ,99 ,101) 1))
  (test `(1 `(1 ,@2 ,@,(list 1 2))) '(1 `(1 ,@2 ,@(1 2))))
  (test `(1 `(1 ,@,quasi2 ,@,quasi3)) '(1 `(1 ,@(a b) ,@(c d))))
  (test `(1 `(1 ,(,@quasi2 x) ,(y ,@quasi3))) '(1 `(1 ,(a b x) ,(y c d))))
;  (test `#(1 `(1 ,2 ,,(+ 1 2)) 1) '#(1 `(1 ,2 ,3) 1))
;  (test `#(1 `(1 ,,quasi0 ,,quasi1) 1) '#(1 `(1 ,99 ,101) 1))
  (test `#(1 `(1 ,@2 ,@,(list 1 2))) '#(1 `(1 ,@2 ,@(1 2))))
;  (test `#(1 `(1 ,@,quasi2 ,@,quasi3)) '#(1 `(1 ,@(a b) ,@(c d))))
;  (test `#(1 `(1 ,(,@quasi2 x) ,(y ,@quasi3))) '#(1 `(1 ,(a b x) ,(y c d))))
;  (test `(1 `#(1 ,(,@quasi2 x) ,(y ,@quasi3))) '(1 `#(1 ,(a b x) ,(y c d))))
  )

(test `#2d((1 ,(* 3 2)) (,@(list 2) 3)) #2D((1 6) (2 3)))
(test `#3d() #3D())
(test `#3D((,(list 1 2) (,(+ 1 2) 4)) (,@(list (list 5 6)) (7 8))) #3D(((1 2) (3 4)) ((5 6) (7 8))))
(test (eval-string "`#2d(1 2)") 'error)
(test (eval-string "`#2d((1) 2)") 'error)
(test (eval-string "`#2d((1 2) (3 4) (5 6 7))") 'error)
(test `#2d((1 2)) #2D((1 2)))

(let ((x 3)
      (y '(a b c)))
  (test `(1 . ,2) '(1 . 2))
  (test `(1 2 . ,3) '(1 2 . 3))
  (test `(1 x . ,3) '(1 x . 3))
  (test `(1 x . ,x) '(1 x . 3))
  (test `(1 . ,(list 2 3)) '(1 2 3))
  (test `(1 ,@(list 2 3)) '(1 2 3))
;;;  (test `(1 . ,@('(2 3))) '(1 2 3))
  (test `(1 ,(list 2 3)) '(1 (2 3)))
  (test `(1 . (list 2 3)) '(1 list 2 3))
  (test `(x . ,x) '(x . 3))
  (test `(y . ,y) '(y a b c))
  (test `(,x ,@y ,x) '(3 a b c 3))
  (test `(,x ,@y . ,x) '(3 a b c . 3))
  (test `(,y ,@y) '((a b c) a b c))
  (test `(,@y . ,y) '(a b c a b c))

  (test (object->string `(,y . ,y)) "(#1=(a b c) . #1#)")
  (test (object->string `(y ,y ,@y ,y . y)) "(y #1=(a b c) a b c #1# . y)")

  (test (eval ``(1 . ,,2)) '(1 . 2))
  (test (eval ``(y . ,,x)) '(y . 3))
  (test (eval ``(,y . ,x)) '((a b c) . 3))
  (test (eval ``(,@y . x)) '(a b c . x))
  (test (eval ``(,x . ,y)) '(3 a b c))
  (test (eval ``(,,x . y)) '(3 . y))
  (test (eval ``(,,x ,@y)) '(3 a b c))  ;; in clisp `(,y . ,@(y)) -> *** - READ: the syntax `( ... . ,@form) is invalid
  )
(test (let ((.' '(1 2))) `(,@.')) '(1 2))

(test (let ((hi (lambda (a) `(+ 1 ,a))))
	(hi 2))
      '(+ 1 2))

(test (let ((hi (lambda (a) `(+ 1 ,@a))))
	(hi (list 2 3)))
      '(+ 1 2 3))

(test (let ((hi (lambda (a) `(let ((b ,a)) ,(+ 1 a)))))
	(hi 3))
      '(let ((b 3)) 4))

(test (let ((x '(a b c)))
	`(x ,x ,@x foo ,(cadr x) bar ,(cdr x) baz ,@(cdr x)))
      '(x (a b c) a b c foo b bar (b c) baz b c))

(test (let ((x '(a b c)))
	`(,(car `(,x))))
      '((a b c)))

(test (let ((x '(a b c)))
	`(,@(car `(,x))))
      '(a b c))

(test (let ((x '(a b c)))
	`(,(car `(,@x))))
      '(a))

(test (let ((x '(a b c)))
	``,,x)
      '(a b c))

(test (let ((x '(a b c)))
	`,(car `,x))
      'a)

(test (let ((x '(2 3)))
	`(1 ,@x 4))
      '(1 2 3 4))

(test `#(1 ,(/ 12 2)) '#(1 6))
(test ((lambda () `#(1 ,(/ 12 2)))) '#(1 6))

(test (let ((x '(2 3)))
	`(1 ,@(map (lambda (a) (+ a 1)) x)))
      '(1 3 4))

;;; these are from the scheme bboard
(test (let ((x '(1 2 3))) `(0 . ,x)) '(0 1 2 3))
(test (let ((x '(1 2 3))) `(0 ,x)) '(0 (1 2 3)))
;(test (let ((x '(1 2 3))) `#(0 ,x)) '#(0 (1 2 3)))
;(test (let ((x '(1 2 3))) `#(0 . ,x)) '#(0 1 2 3))

;; unbound variable x, but (let ((x '(1 2 3))) (quasiquote #(0 . ,x))) -> #(0 unquote x)
;; so ` and (quasiquote...) are not the same because they're handled at different points in the reader(?)


(test `#(,most-positive-fixnum 2) #(9223372036854775807 2))

(test (let () (define-macro (tryqv . lst) `(map abs ',lst)) (tryqv 1 2 3 -4 5)) '(1 2 3 4 5))
(test (let () (define-macro (tryqv . lst) `(map abs '(,@lst))) (tryqv 1 2 3 -4 5)) '(1 2 3 4 5))
(test (let () (define-macro (tryqv . lst) `(map abs (vector ,@lst))) (tryqv 1 2 3 -4 5)) '(1 2 3 4 5))

(for-each
 (lambda (str)
   (let ((val (catch #t
		     (lambda () (eval-string str))
		     (lambda args 'error))))
     (if (not (eqv? val -1))
	 (format #t "~S = ~S?~%" str val))))
 (list "( '(.1 -1)1)" "( - '`-00 1)" "( - .(,`1/1))" "( - .(`1) )" "( -(/ .(1)))" "( / 01 -1 )" "(' '` -1(/ ' 1))" "(' (-01 )0)" 
       "(' `'`` -1 1 01)" "(''-1 .(1))" "('(, -1 )0)" "('(,-1)'000)" "('(,-1)00)" "('(-1  -.0)0)" "('(-1 '1`)0)" "('(-1 .-/-)0)" "('(-1()),0)"
       "('(-1) 0)" "('(10. -1 )1)" "(-  '`1)" "(-  `1 1 1)" "(- '  1)" "(- ' 1)" "(- '1 .())" "(- '` ,``1)" "(- '` 1)" "(- '`, `1)" "(- '`,`1)" 
       "(- '``1)" "(- (''1 1))" "(- (- ' 1 0))" "(- (-(- `1)))" "(- (`  (1)0))" "(- ,`, `1)" "(- ,`1 . ,())" "(- . ( 0 1))" "(- . ( `001))" 
       "(- .(', 01))" "(- .('`,1))" "(- .('``1))" "(- .(,,1))" "(- .(01))" "(- .(1))" "(- .(`,1))" "(- .(`,`1))" "(- .(`1))" "(- ` ,'1)" 
       "(- ` -0 '1)" "(- ` 1 )" "(- ` `1)" "(- `, 1)" "(- `,1)" "(- `,`,1)" "(- `,`1)" "(- ``,,1)" "(- ``,1)" "(- ``1 )" "(- ```,1)" 
       "(- ```1)" "(-(  / 1))" "(-( -  -1 ))" "(-( `,- 1 0))" "(-(' (1)0))" "(-('(,1)00))" "(-(- '`1) 0)" "(-(- -1))" "(-(/(/(/ 1))))" 
       "(-(`'1 '1))" "(-(`(,1 )'0))" "(-(`,/ ,1))" "(/ '-1 '1 )" "(/ ,, `,-1)" "(/ ,11 -11)" "(/ 01 (- '1))" "(/ `1 '`-1)" 
       "(/(- '1)  )" "(/(- '1)1)" "(/(- 001)1)" "(/(- 1),,1)" "(/(/ -1))" "(` ,- 1)" "(` `,(-1)0)" "(`' , -1 1)" "(/(- -001(+)))"
       "(`' -1 '1/1)" "(`','-1 ,1)" "(`(,-1)-00)" "(`(-0 -1)1)" "(`(-1 -.')0)" "(`(-1 1')0)" "(`(` -1)'`0)" "(`, - 1)" "(`,- '1)" "(`,- .(1))" 
       "(`,- 1 )" "(`,- `,1)" "(`,- `1)" "(`,/ . (-1))" "(``,,- `01)" "('''-1 '1 '1)" "(/ `-1 1)" "(/ .( -1))" "(-(+(+)0)1)" "(/ ,`,`-1/1)" 
       "(-(*).())" "(*(- +1))" "(-(`,*))" "(-(+)'1)" "(+(-(*)))" "(-(+(*)))" "(-(+)(*))" "(-(/(*)))" "(*(-(*)))" "(-(*(*)))" "(/(-(*)))" "(-(+(*)))"
       "(/ .(-1))" "(-(*))" "(- 000(*))" "(-(*(+ 1)))" "(- .((*)))" "(- +0/10(*))" "(-(`,/ .(1)))" "(+ .(' -01))" "(-(''1 01))" "(- -1/1 +0)"
       "(- `,'0 `01)" "( - `,(+)'1)" "(+(- . (`1)))" "(* '`,``-1)" "(-(+ -0)1)" "(+ +0(-(*)))" "(+(- '+1 ))" "(+ '-01(+))" "(`, -(+)1)" 
       "(`,+ 0 -1)" "(-(/(/(*))))" "(`,* .( -1))" "(-(*(*(*))))" "(`,@(list +)-1)" "(* (- 1) )" "(`, - (* ))" "(/(- (* 1)))"
       "(- -0/1(*))" "(`(,-1)0)" "(/(-(*).()))" "(* ````-1)" "(-(+(*)0))" "(-(* `,(*)))" "(- +1(*)1)" "(- (` ,* ))" "(/(-(+ )1))" "(`,* -1(*))" 
       "(` ,- .(1))" "(+(`,-( *)))" "( /(`,- 1))" "(`(1 -1)1)" "(*( -(/(*))))" "(- -1(-(+)))" "(* ``,,-1)" "(-(+(+))1)" "( +(*(-(*))))"
       "(-(+)`0(*))" "(-(+(+(*))))" "(-(+ .(01)))" "(/(*(-(* ))))" "(/ (-(* 1)))" "( /(-(/(*))))" "(+ -1 0/1)" "(/(-( +(*))))" "(*( -(`,*)))"
       "(* 1(/ 1)-1)" "(+ 0(- ',01))" "(+(-(-(+ -1))))" "(- 0(/(+(* ))))" "(-(+)( *)0)"
       "(`,- '01/1)" "(`, - ',,1)"  "(/ .(`-1 1))"  "(- ``,,'`1)" "(- 10 0011)" "(-(- ``1 0))" "( -(/ 01/1))" "(-(- 1)`,0)" "(/(/ -1 .()))" 
       "(/ ,,``-1)" "( `,`, - 1)" "(- .(`1/01  ))" "('(-1) ',``0)" "('( ,/ -1 )1)" "(- ,,`,`0 +1)" "(`(-1) `,0)" "(+(* (-(*))))"
       "(-(`,* ,,1))" "(+(+ 0)-1)" "(+(-(+ ,1)))" "(* ,`-01/1)" "(*(- '` `1))" "(-(*(* 1 1)))" "(-(*(/ .(1))))" "(-(- 1(*)-1))" 
       "(- -00 (* 1))" "(- (*(+ ,01)))" "(-(*), +1(* ))" 
       ))

#|
(let ((chars (vector #\/ #\. #\0 #\1 #\- #\, #\( #\) #\' #\@ #\` #\space))
      (size 14))
  (let ((str (make-string size))
	(clen (length chars)))
    (set! (str 0) #\()
    (do ((i 0 (+ i 1)))
	((= i 10000000))
      (let ((parens 1))
	(do ((k 1 (+ k 1)))
	    ((= k size))
	  (set! (str k) (chars (random clen)))
	  (if (char=? (str k) #\()
	      (set! parens (+ parens 1))
	      (if (char=? (str k) #\))
		  (begin
		    (set! parens (- parens 1))
		    (if (negative? parens)
			(begin
			  (set! (str k) #\space)
			  (set! parens 0)))))))
	(let ((str1 str)
	      (happy (char=? (str (- size 1)) #\))))
	  (if (> parens 0)
	      (begin
		(set! str1 (make-string (+ size parens) #\)))
		(set! happy #t)
		(do ((k 0 (+ k 1)))
		    ((= k size))
		  (set! (str1 k) (str k)))))
	  (set! (-s7-symbol-table-locked?) #t)
	  (if (and happy
		   (not (char=? (str1 1) #\))))
	      (catch #t 
		     (lambda ()
		       (let ((num (eval-string str1)))
			 (if (and (number? num)
				  (eqv? num -1))
			     (format #t "~S ~%" str1))))
		     (lambda args
		       'error)))
	  (set! (-s7-symbol-table-locked?) #f))))))
|#

(test (= 1 '+1 `+1 '`1 `01 ``1) #t)
(test (''- 1) '-)
(test (`'- 1) '-)
(test (``- 1) '-)
(test ('`- 1) '-)
(test (''1 '1) 1)
(test ((quote (quote 1)) 1) 1) ; (quote (quote 1)) -> ''1 = (list 'quote 1), so ((list 'quote 1) 1) is 1!
(test (list 'quote 1) ''1) ; guile says #t
(test (list-ref ''1 1) 1)  ; same
(test (''1 ```1) 1)
(test (cond `'1) 1)
(test ```1 1)
(test ('''1 1 1) 1)
(test (`',1 1) 1)
(test (- `,-1) 1)
;;; some weirder cases...
(test (begin . `''1) ''1)
					;(test (`,@''1) 1) 
					;  (syntax-error ("attempt to apply the ~A ~S to ~S?" "symbol" quote (1))) ??
					;  (({apply} {values} ''values 1)) got error but expected 1
					;(test (`,@ `'1) 1)
					;  (({apply} {values} ''values 1)) got error but expected 1
					;(test (`,@''.'.) '.'.)
					;  (({apply} {values} ''values .'.)) got error but expected .'.
(test #(`,1) #(1))
(test `#(,@'(1)) #(1))
(test `#(,`,@''1) #(quote 1))
(test `#(,@'(1 2 3)) #(1 2 3))
(test `#(,`,@'(1 2 3)) #(1 2 3)) ; but #(`,@'(1 2 3)) -> #(({apply} {values} '(1 2 3)))
(test `#(,`#(1 2 3)) #(#(1 2 3)))
(test `#(,`#(1 ,(+ 2 3))) #(#(1 5)))
(test (quasiquote #(,`#(1 ,(+ 2 3)))) #(#(1 5)))
(test `#(,`#(1 ,(+ `,@'(2 3)))) #(#(1 5)))
(test `#(1 `,,(+ 2 3)) #(1 5))

(test (apply . `''1) 'error) ; '(quote quote 1)) ; (apply {list} 'quote ({list} 'quote 1)) -> ;quote: too many arguments '1
(test (apply - 1( )) -1)               ; (apply - 1 ())
(num-test (apply - 1.()) -1.0)
(num-test (apply - .1()) -0.1)
(num-test (apply - .1 .(())) -0.1)
(num-test (apply - .1 .('(1))) -0.9)
(test (apply - -1()) 1)                ; (apply - -1 ())
(test (apply . `(())) '())             ; (apply {list} ())
(test (apply . ''(1)) 1)               ; (apply quote '(1))
(test (apply . '`(1)) 1)               ; (apply quote ({list} 1))
(test (apply . `(,())) '())            ; (apply {list} ())
(test (apply . `('())) ''())           ; (apply {list} ({list} 'quote ()))
(test (apply . `(`())) '())            ; (apply {list} ())
(test (apply - `,1()) -1)              ; (apply - 1 ())
(test (apply - ``1()) -1)              ; (apply - 1 ())
(test (apply ''1 1()) 1)               ; (apply ''1 1 ())
(test (apply .(- 1())) -1)             ; (apply - 1 ())
(test (apply - .(1())) -1)             ; (apply - 1 ())
(test (apply . `(1())) '(1))           ; (apply {list} 1 ())
(test (apply . ''(())) '())
(test (apply . `((()))) '(()))

;; make sure the macro funcs really are constants
(test (defined? '{list}) #t)
(test (let () (set! {list} 2)) 'error)
(test (let (({list} 2)) {list}) 'error)
(test (defined? '{values}) #t)
(test (let () (set! {values} 2)) 'error)
(test (let (({values} 2)) {values}) 'error)
;(test (defined? '{apply}) #t)
;(test (let () (set! {apply} 2)) 'error)
;(test (let (({apply} 2)) {apply}) 'error)
(test (defined? '{append}) #t)
(test (let () (set! {append} 2)) 'error)
(test (let (({append} 2)) {append}) 'error)
(test (defined? '{multivector}) #t)
(test (let () (set! {multivector} 2)) 'error)
(test (let (({multivector} 2)) {multivector}) 'error)

(test (+ 1 ((`#(,(lambda () 0) ,(lambda () 2) ,(lambda () 4)) 1))) 3) ; this calls vector each time, just like using vector directly
(test (+ 1 ((`(,(lambda () 0)  ,(lambda () 2) ,(lambda () 4)) 1))) 3)

(test (object->string (list 'quote 1 2)) "(quote 1 2)")
(test (object->string (list 'quote 'quote 1)) "(quote quote 1)")
(test (object->string (list 'quote 1 2 3)) "(quote 1 2 3)")
(test (object->string (list 'quote 1)) "'1") ; confusing but this is (quote 1)
(test (equal? (quote 1) '1) #t)
(test (equal? (list 'quote 1) ''1) #t)
(test (equal? (list 'quote 1) '''1) #f)
;;; see comment s7.c in list_to_c_string -- we're following Clisp here
(test (object->string (cons 'quote 1)) "(quote . 1)")
(test (object->string (list 'quote)) "(quote)")
(let ((lst (list 'quote 1)))
  (set! (cdr (cdr lst)) lst)
  (test (object->string lst) "#1=(quote 1 . #1#)"))
(let ((lst (list 'quote)))
  (set! (cdr lst) lst)
  (test (object->string lst) "#1=(quote . #1#)"))
(test (object->string quasiquote) "quasiquote")

;; from Guile mailing list
(test (let ((v '(\())))
	(and (pair? v)
	     (symbol? (car v)) ; \ -> ((symbol "\\") ())
	     (null? (cadr v))))
      #t)

(test #(,1) #(1))
(test #(,,,1) #(1))
(test #(`'`1) #(''1))
(test `#(,@(list 1 2 3)) #(1 2 3)) ; but #(,@(list 1 2 3)) -> #((unquote ({apply} {values} (list 1 2 3))))
(test (',- 1) '-) ; this is implicit indexing

#|
(',,= 1) -> (unquote =)
(test (equal? (car (',,= 1)) 'unquote) #t) ; but that's kinda horrible

(',@1 1) -> ({apply} {values} 1)
#(,@1) -> #((unquote ({apply} {values} 1)))
(quasiquote #(,@(list 1 2 3))) -> #((unquote ({apply} {values} (list 1 2 3))))

(quote ,@(for-each)) -> (unquote ({apply} {values} (for-each)))
;;; when is (quote ...) not '...?
|#


(test (quasiquote) 'error)
(test (quasiquote 1 2 3) 'error)
(let ((d 1)) (test (quasiquote (a b c ,d)) '(a b c 1)))
(test (let ((a 2)) (quasiquote (a ,a))) (let ((a 2)) `(a ,a)))
(test (quasiquote 4) 4)
(if (not (provided? 'immutable-unquote)) (test (quasiquote (list (unquote (+ 1 2)) 4)) '(list 3 4)))
(test (quasiquote (1 2 3)) '(1 2 3))
(test (quasiquote ()) '())
(test (quasiquote (list ,(+ 1 2) 4))  '(list 3 4))
(test (quasiquote (1 ,@(list 1 2) 4)) '(1 1 2 4))
(test (quasiquote (a ,(+ 1 2) ,@(map abs '(4 -5 6)) b)) '(a 3 4 5 6 b))
(test (quasiquote (1 2 ,(* 9 9) 3 4)) '(1 2 81 3 4))
(test (quasiquote (1 ,(+ 1 1) 3)) '(1 2 3))                     
(test (quasiquote (,(+ 1 2))) '(3))
(test (quasiquote (,@'() . foo)) 'foo)
(test (quasiquote (1 , 2)) '(1 2))
(test (quasiquote (,1 ,1)) '(1 1))
(test (quasiquote (,1 ,(quasiquote ,1))) '(1 1))
(test (quasiquote (,1 ,(quasiquote ,@(list 1)))) '(1 1))
(test (quasiquote (,1 ,(quasiquote ,(quasiquote ,1)))) '(1 1))
(test (quasiquote (,1 ,(quasiquote ,@'(1)))) '(1 1))
(test (quasiquote (,1 ,(quasiquote ,@(quasiquote (1))))) '(1 1))
(test (quasiquote (,1 ,(quasiquote ,@(quasiquote (,1))))) '(1 1))
(test (quasiquote (,1 ,@(quasiquote ,@(list (list 1))))) '(1 1))
(test `(+ ,(apply values '(1 2))) '(+ 1 2))
(if (not (provided? 'immutable-unquote)) (test `(apply + (unquote '(1 2))) '(apply + (1 2))))
(test (eval (list (list quasiquote +) -1)) -1)

(test (apply quasiquote '((1 2 3))) '(1 2 3))
(test (quasiquote (',,= 1)) 'error)
(test (quasiquote (',,@(1 2) 1)) 'error)
(test (quasiquote 1.1 . -0) 'error)

(test `(1 ,@2) 'error)
(test `(1 ,@(2 . 3)) 'error)
(test `(1 ,@(2 3)) 'error)
(test `(1 , @ (list 2 3)) 'error) ; unbound @ ! (guile also)

(test (call-with-exit quasiquote) 'error)
(test (call-with-output-string quasiquote) 'error)
(test (map quasiquote '(1 2 3))  'error)
(test (for-each quasiquote '(1 2 3))  'error)
(test (sort! '(1 2 3) quasiquote) 'error)
(test (quasiquote . 1) 'error)
(test (let ((x 3)) (quasiquote . x)) 'error)
(num-test `,#e.1 1/10)
(num-test `,,,-1 -1)
(num-test `,``,1 1)
(test (equal? ` 1 ' 1) #t)
(test (+ ` 1 `  2) `   3)
(test ` ( + ,(- 3 2) 2) '(+ 1 2))
(test (quasiquote #(1)) `#(1))

(test `(+ ,@(map sqrt '(1 4 9)) 2) '(+ 1 2 3 2))
(test `(+ ,(sqrt 9) 4) '(+ 3 4))
(test `(+ ,(apply values (map sqrt '(1 4 9))) 2) '(+ 1 2 3 2))
