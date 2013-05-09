(test (case (* 2 3) ((2 3 5 7) 'prime) ((1 4 6 8 9) 'composite))  'composite)
(test (case (car '(c d)) ((a e i o u) 'vowel) ((w y) 'semivowel) (else 'consonant)) 'consonant)
(test (case 3.1 ((1.3 2.4) 1) ((4.1 3.1 5.4) 2) (else 3)) 2)
(test (case 3/2 ((3/4 1/2) 1) ((3/2) 2) (else 3)) 2)
(test (case 3 ((1) 1 2 3) ((2) 2 3 4) ((3) 3 4 5)) 5)
(test (case 1+i ((1) 1) ((1/2) 1/2) ((1.0) 1.0) ((1+i) 1+i)) 1+i)
(test (case 'abs ((car cdr) 1) ((+ cond) 2) ((abs) 3) (else 4)) 3)
(test (case #\a ((#\b) 1) ((#\a) 2) ((#\c) 3)) 2)
(test (case (boolean? 1) ((#t) 2) ((#f) 1) (else 0)) 1)
(test (case 1 ((1 2 3) (case 2 ((1 2 3) 3)))) 3)
(test (case 1 ((1 2) 1) ((3.14 2/3) 2)) 1)
(test (case 1 ((1 2) 1) ((#\a) 2)) 1)
(test (case 1 ((1 2) 1) ((#\a) 2) ((car cdr) 3) ((#f #t) 4)) 1)
(test (case #f ((1 2) 1) ((#\a) 2) ((car cdr) 3) ((#f #t) 4)) 4)
(test (case 1 ((#t) 2) ((#f) 1) (else 0)) 0)
(test (let ((x 1)) (case x ((x) "hi") (else "ho"))) "ho")
(test (let ((x 1)) (case x ((1) "hi") (else "ho"))) "hi")
(test (let ((x 1)) (case x (('x) "hi") (else "ho"))) "ho")
(test (let ((x 1)) (case 'x ((x) "hi") (else "ho"))) "hi")
(test (case '() ((()) 1)) 1)
(test (case #() ((#()) 1) (else 2)) 2)
(test (let ((x '(1))) (eval `(case ',x ((,x) 1) (else 0)))) 1)    ; but we can overcome that! (also via apply)
(test (let ((x #())) (eval `(case ',x ((,x) 1) (else 0)))) 1)
(test (case ''2 (('2) 1) (else 0)) 0)
(test (let ((otherwise else)) (case 1 ((0) 123) (otherwise 321))) 321)
(test (case 1 ((0) 123) (#t 321)) 'error)

(test (case else ((#f) 2) ((#t) 3) ((else) 4) (else 5)) 5)          ; (eqv? 'else else) is #f (Guile says "unbound variable: else")
(test (case #t ((#f) 2) ((else) 4) (else 5)) 5)                     ; else is a symbol here         
(test (equal? (case 0 ((0) else)) else) #t)
(test (cond ((case 0 ((0) else)) 1)) 1)

(test (let ((x 1)) (case x ((2) 3) (else (* x 2) (+ x 3)))) 4)
(test (let ((x 1)) (case x ((1) (* x 2) (+ x 3)) (else 32))) 4)
(test (let ((x 1)) (case x ((1) (let () (set! x (* x 2))) (+ x 3)) (else 32))) 5)
(test (let ((x 1)) (case x ((2) (let () (set! x (* x 2))) (+ x 3)) (else 32))) 32)
(test (let ((x 1)) (case x ((2) 3) (else (let () (set! x (* x 2))) (+ x 3)))) 5)
(test (let((x 1))(case x((2)3)(else(let()(set! x(* x 2)))(+ x 3)))) 5)
(test (let ((x 1)) (case x ((2) 3) (else 4) (else 5))) 'error)

(test (case '() ((()) 2) (else 1)) 2)    ; car: (), value: (), eqv: 1, null: 1 1
(test (case '() (('()) 2) (else 1)) 1)   ; car: (quote ()), value: (), eqv: 0, null: 0 1
(test (case () (('()) 2) (else 1)) 1)    ; car: (quote ()), value: (), eqv: 0, null: 0 1
(test (case () ((()) 2) (else 1)) 2)     ; car: (), value: (), eqv: 1, null: 1 1

;;; this is a difference between '() and () ?
;;; (eqv? '() '()) -> #t and (eqv? '() ()) is #t so it's the lack of evaluation in the search case whereas the index is evaluated
;;; equivalent to:
 
(test (case 2 (('2) 3) (else 1)) 1)      ; car: (quote 2), value: 2, eqv: 0, null: 0 0
(test (case '2 (('2) 3) (else 1)) 1)     ; car: (quote 2), value: 2, eqv: 0, null: 0 0
(test (case '2 ((2) 3) (else 1)) 3)      ; car: 2, value: 2, eqv: 1, null: 0 0
(test (case 2 ((2) 3) (else 1)) 3)       ; car: 2, value: 2, eqv: 1, null: 0 0

(test (case '(()) ((()) 1) (((())) 2) (('()) 3) (('(())) 4) ((((()))) 5) (('((()))) 6) (else 7)) 7) ; (eqv? '(()) '(())) is #f

(test (let ((x 1)) (case (+ 1 x) ((0 "hi" #f) 3/4) ((#\a 1+3i '(1 . 2)) "3") ((-1 'hi 2 2.0) #\f))) #\f)
(test (case (case 1 ((0 2) 3) (else 2)) ((0 1) 2) ((4 2) 3) (else 45)) 3)
(test (case 3/4 ((0 1.0 5/6) 1) (("hi" 'hi 3/4) 2) (else 3)) 2)
(test (case (case (+ 1 2) (else 3)) ((3) (case (+ 2 2) ((2 3) 32) ((4) 33) ((5) 0)))) 33)
(test (let ((x 1)) (case x ((0) (set! x 12)) ((2) (set! x 32))) x) 1)

(test (case 1 (else #f)) #f)
(test (let () (case 0 ((0) (define (hi a) a)) (else (define (hi a) (+ a 1)))) (hi 1)) 1)
(test (let () (case 1 ((0) (define (hi a) a)) (else (define (hi a) (+ a 1)))) (hi 1)) 2)
(test (let () (case (define (hi a) a) ((hi) (hi 1)))) 1)

(for-each
 (lambda (arg)
   (test (case 1 ((0) 'gad) ((1 2 3) arg) (else 'gad)) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (case arg ((0) 'gad) ((1 2 3) arg) (else 'gad)) 'gad))
 (list "hi" -1 #\a 0 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (call/cc (lambda (r) (case 1 ((1) (r 123) #t) (else #f)))) 123)
(test (call/cc (lambda (r) (case 1 ((0) 0) (else (r 123) #f)))) 123)

(test (case '() ((1) 1) ('() 2)) 2)
(test (case (list) ((1) 1) ('() 2)) 2)
(test (case '() ((1) 1) ((()) 2)) 2)
(test (case (list) ((1) 1) ((()) 2)) 2)
(test (case #<eof> ((#<eof>) 1)) 1)
(test (case #\newline ((#\newline) 1)) 1)
(test (case 'c (else => (lambda (x) (symbol? x)))) #t)
(test (case 1.0 ((1e0) 3) ((1.0) 4) (else 5)) 3)
(test (case 1.0 ((#i1) 2) ((1e0) 3) ((1.0) 4) (else 5)) 2)
(test (case 1 ((#i1) 2) ((1e0) 3) ((1.0) 4) (else 5)) 5)

; case uses eqv? -- why not case-equal?
(test (case "" (("") 1)) #<unspecified>)
(test (case abs ((abs) 1)) #<unspecified>)
(test (case (if #f #f) ((1) 1) ((#<unspecified>) 2) (else 3)) 2)

(test (case) 'error)
(test (case 1) 'error)
(test (case 1 . "hi") 'error)
(test (case 1 ("hi")) 'error)
(test (case 1 ("a" "b")) 'error)
(test (case 1 (else #f) ((1) #t)) 'error)
(test (case "hi" (("hi" "ho") 123) ("ha" 321)) 'error)
(test (case) 'error)
(test (case . 1) 'error)
(test (case 1 . 1) 'error)
(test (case 1 (#t #f) ((1) #t)) 'error)
(test (case 1 (#t #f)) 'error)
(test (case -1 ((-1) => abs)) 1)
(test (case 1 (else =>)) 'error)
(test (case 1 (else => + - *)) 'error)
(test (case #t ((1 2) (3 4)) -1) 'error)
(test (case 1 1) 'error)
(test (case 1 ((2) 1) . 1) 'error)
(test (case 1 (2 1) (1 1)) 'error)
(test (case 1 (else)) 'error)
(test (case () ((1 . 2) . 1) . 1) 'error)
(test (case 1 ((1))) 'error)
(test (case 1 ((else))) 'error)
(test (case 1 ((2) 3) ((1))) 'error)
(test (case 1 ((1)) 1 . 2) 'error)
(test (case () ((()))) 'error)
(test (case 1 (else 3) . 1) 'error)
(test (case 1 ((1 2)) (else 3)) 'error)
(test (case 1 ('(1 2) 3) (else 4)) 4)
(test (case 1 (('1 2) 3) (else 4)) 4)
(test (case 1 ((1 . 2) 3) (else 4)) 'error) ; ?? in guile it's an error
(test (case 1 ((1 2 . 3) 3) (else 4)) 'error)
(test (case 1 (('1 . 2) 3) (else 4)) 'error)
(test (case 1 ((1 . (2)) 3) (else 4)) 3)
(test (case 1 ((1 2) . (3)) (else 4)) 3)
(test (case 1 ((2) 3) (else)) 'error)
(test (case 1 ((2) 3) ()) 'error)
(test (case 1 ((2) 3) (() 2)) 'error) ; ?? in Guile this is #<unspecified>; our error is confusing: ;case clause key list () is not a list or 'else'
(test (case '() ('() 2)) 2)            ; ?? error??
(test (case '() ((()) 2)) 2) 
(test (case 1 else) 'error)
(test (case 1 (((1) 1) 2) (else 3)) 2) ; the (1) can't be matched -- should it be an error?
(test (case 1 ((1) . (else 3))) 3)     ; ?? guile says "unbound variable: else"
(test (case . (1 ((2) 3) ((1) 2))) 2)
(test (case 1 (#(1 2) 3)) 'error)
(test (case 1 #((1 2) 3)) 'error)
(test (case 1 ((2) 3) () ((1) 2)) 'error)
(test (case 1 ((2) 3) (1 2) ((1) 2)) 'error)
(test (case 1 ((2) 3) (1 . 2) ((1) 2)) 'error)
(test (case 1 ((2) 3) (1) ((1) 2)) 'error)
(test (case 1 ((2) 3) ((1)) ((1) 2)) 'error)
(test (case 1 ((1) 2) ((1) 3)) 2) ; should this be an errror?

(let ()
  (define (hi x) (case x ((a) 'a) ((b) 'b) (else 'c)))
  (test (hi 'a) 'a)
  (test (hi 'd) 'c))

(test (case 'case ((case) 1) ((cond) 3)) 1)
(test (case 101 ((0 1 2) 200) ((3 4 5 6) 600) ((7) 700) ((8) 800) ((9 10 11 12 13) 1300) ((14 15 16) 1600) ((17 18 19 20) 2000) ((21 22 23 24 25) 2500) ((26 27 28 29) 2900) ((30 31 32) 3200) ((33 34 35) 3500) ((36 37 38 39) 3900) ((40) 4000) ((41 42) 4200) ((43) 4300) ((44 45 46) 4600) ((47 48 49 50 51) 5100) ((52 53 54) 5400) ((55) 5500) ((56 57) 5700) ((58 59 60) 6000) ((61 62) 6200) ((63 64 65) 6500) ((66 67 68 69) 6900) ((70 71 72 73) 7300) ((74 75 76 77) 7700) ((78 79 80) 8000) ((81) 8100) ((82 83) 8300) ((84 85 86 87) 8700) ((88 89 90 91 92) 9200) ((93 94 95) 9500) ((96 97 98) 9800) ((99) 9900) ((100 101 102) 10200) ((103 104 105 106 107) 10700) ((108 109) 10900) ((110 111) 11100) ((112 113 114 115) 11500) ((116) 11600) ((117) 11700) ((118) 11800) ((119 120) 12000) ((121 122 123 124 125) 12500) ((126 127) 12700) ((128) 12800) ((129 130) 13000) ((131 132) 13200) ((133 134 135 136) 13600) ((137 138) 13800)) 10200)
(test (case most-positive-fixnum ((-1231234) 0) ((9223372036854775807) 1) (else 2)) 1)
(test (case most-negative-fixnum ((123123123) 0) ((-9223372036854775808) 1) (else 2)) 1)
(test (case 0 ((3/4 "hi" #t) 0) ((#f #() -1) 2) ((#\a 0 #t) 3) (else 4)) 3)
(test (case 3/4 ((3/4 "hi" #t) 0) ((#f #() hi) 2) ((#\a 0 #t) 3) (else 4)) 0)
(test (case 'hi ((3/4 "hi" #t) 0) ((#f #() hi) 2) ((#\a 0 #t) 3) (else 4)) 2)
(test (case #f ((3/4 "hi" #t) 0) ((#f #() hi) 2) ((#\a 0 #t) 3) (else 4)) 2)
(test (case 3 ((3/4 "hi" #t) 0) ((#f #() hi) 2) ((#\a 0 #t) 3) (else 4)) 4)
(test (case 0 ((values 0 1) 2) (else 3)) 2)

(test (let ((else 3)) (case 0 ((1) 2) (else 3))) 'error) ; also if else is set!
(test (let ((else 3)) (case else ((3) else))) 3)
(test (case 0 ((1) #t) ((2 else 3) #f) ((0) 0)) 0) ; should this be an error? (it isn't in Guile)
(test (case 0 ((1) #t) ((else) #f) ((0) 0)) 0)
(test (apply case 1 '(((0) -1) ((1) 2))) 2)
(test (let ((x #(1))) (apply case x (list (list (list #()) 1) (list (list #(1)) 2) (list (list x) 3) (list 'else 4)))) 3)


(test (let ((x 0)) (let ((y (case 1 ((2) (set! x (+ x 3))) ((1) (set! x (+ x 4)) (+ x 2))))) (list x y))) '(4 6))
(let ()
  (define (hi a)
    (case a
      ((0) 1)
      ((1) 2)
      (else 3)))
  (test (hi 1) 2)
  (test (hi 2) 3)
  (test (hi "hi") 3))

(if with-bignums
    (begin
      (test (case 8819522415901031498123 ((1) 2) ((8819522415901031498123) 3) (else 4)) 3) 
      (test (case -9223372036854775809 ((1 9223372036854775807) 2) (else 3)) 3)
      ))

;;; one thing that will hang case I think: circular key list
