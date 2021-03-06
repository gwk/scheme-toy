(test (equal? 'a 3) #f)
(test (equal? #t 't) #f)
(test (equal? "abs" 'abc) #f)
(test (equal? "hi" '(hi)) #f)
(test (equal? "()" '()) #f)
(test (equal? '(1) '(1)) #t)
(test (equal? '(#f) '(#f)) #t)
(test (equal? '(()) '(() . ())) #t)
(test (equal? #\a #\b) #f)
(test (equal? #\a #\a) #t)
(test (let ((x (string-ref "hi" 0))) (equal? x x)) #t)
(test (equal? #t #t) #t)
(test (equal? #f #f) #t)
(test (equal? #f #t) #f)
(test (equal? (null? '()) #t) #t)
(test (equal? (null? '(a)) #f) #t)
(test (equal? (cdr '(a)) '()) #t)
(test (equal? 'a 'a) #t)
(test (equal? 'a 'b) #f)
(test (equal? 'a (string->symbol "a")) #t)
(test (equal? '(a) '(b)) #f)
(test (equal? '(a) '(a)) #t)
(test (let ((x '(a . b))) (equal? x x)) #t)
(test (let ((x (cons 'a 'b))) (equal? x x)) #t)
(test (equal? (cons 'a 'b) (cons 'a 'b)) #t)
(test (equal?(cons 'a 'b)(cons 'a 'b)) #t) ; no space
(test (equal? "abc" "cba") #f)
(test (equal? "abc" "abc") #t)
(test (let ((x "hi")) (equal? x x)) #t)
(test (equal? (string #\h #\i) (string #\h #\i)) #t)
(test (equal? '#(a) '#(b)) #f)
(test (equal? '#(a) '#(a)) #t)
(test (let ((x (vector 'a))) (equal? x x)) #t)
(test (equal? (vector 'a) (vector 'a)) #t)
(test (equal? '#(1 2) (vector 1 2)) #t)
(test (equal? '#(1.0 2/3) (vector 1.0 2/3)) #t)
(test (equal? '#(1 2) (vector 1 2.0)) #f) ; 2 not equal 2.0!
(test (equal? '(1 . 2) (cons 1 2)) #t)
(test (equal? '(1 #||# . #||# 2) (cons 1 2)) #t)
(test (- '#||#1) -1) ; hmm
(test (equal? '#(1 "hi" #\a) (vector 1 "hi" #\a)) #t)
(test (equal? '#((1 . 2)) (vector (cons 1 2))) #t)
(test (equal? '#(1 "hi" #\a (1 . 2)) (vector 1 "hi" #\a (cons 1 2))) #t)
(test (equal? '#(#f hi (1 2) 1 "hi" #\a (1 . 2)) (vector #f 'hi (list 1 2) 1 "hi" #\a (cons 1 2))) #t)
(test (equal? '#(#(1) #(1)) (vector (vector 1) (vector 1))) #t)
(test (equal? '#(()) (vector '())) #t)
(test (equal? '#("hi" "ho") (vector "hi" '"ho")) #t)
(test (equal? `#(1) '#(1)) #t)
(test (equal? ``#(1) #(1)) #t)
(test (equal? '`#(1) #(1)) #t)
(test (equal? ''#(1) #(1)) #f)
(test (equal? ''#(1) '#(1)) #f)
(test (equal? (list 1 "hi" #\a) '(1 "hi" #\a)) #t)
(test (equal? (list 1.0 2/3) '(1.0 2/3)) #t)
(test (equal? (list 1 2) '(1 2.0)) #f)
(test (equal? '#(1.0+1.0i) (vector 1.0+1.0i)) #t)
(test (equal? (list 1.0+1.0i) '(1.0+1.0i)) #t)
(test (equal? '((())) (list (list (list)))) #t)
(test (equal? '((())) (cons (cons () ()) ())) #t)
(test (equal? car car) #t)
(test (equal? car cdr) #f)
(test (let ((x (lambda () 1))) (equal? x x)) #t)
(test (equal? (lambda () 1) (lambda () 1)) #f)
(test (equal? 9/2 9/2) #t)
(test (equal? #((())) #((()))) #t)
(test (equal? "123""123") #t);no space
(test (equal? """") #t)#|nospace|#
(test (equal? #()#()) #t)
(test (equal? #()()) #f)
(test (equal? ()"") #f)
(test (equal? "hi""hi") #t)
(test (equal? #<eof> #<eof>) #t)
(test (equal? #<undefined> #<undefined>) #t)
(test (equal? #<unspecified> #<unspecified>) #t)
(test (equal? (if #f #f) #<unspecified>) #t)
(test (equal? #<eof> #<undefined>) #f)
(test (equal? (values) #<eof>) #f)
(test (equal? (values) (values)) #t)
(test (equal? #<eof> #<unspecified>) #f)
(test (equal? (values) #<unspecified>) #t)
(test (equal? #<unspecified> (values)) #t)
(test (equal? #<eof> '()) #f)
(test (let () (define-macro (hi a) `(+ 1 ,a)) (equal? hi hi)) #t)
(test (let () (define (hi a) (+ 1 a)) (equal? hi hi)) #t)
(test (let ((x (lambda* (hi (a 1)) (+ 1 a)))) (equal? x x)) #t)
(test (equal? ``"" '"") #t)
(test (let ((pws (make-procedure-with-setter (lambda () 1) (lambda (x) x)))) (equal? pws pws)) #t)
(test (equal? if :if) #f)
(test (equal? (list 'abs 'cons) '(abs cons)) #t)

(test (equal? most-positive-fixnum most-positive-fixnum) #t)
(test (equal? most-positive-fixnum most-negative-fixnum) #f)
(test (equal? pi pi) #t)
(test (equal? 9223372036854775807 9223372036854775806) #f)
(test (equal? 9223372036854775807 -9223372036854775808) #f)
(test (equal? -9223372036854775808 -9223372036854775808) #t)
(test (equal? 123456789/2 123456789/2) #t)
(test (equal? 123456789/2 123456787/2) #f)
(test (equal? -123456789/2 -123456789/2) #t)
(test (equal? 2/123456789 2/123456789) #t)
(test (equal? -2/123456789 -2/123456789) #t)
(test (equal? 2147483647/2147483646 2147483647/2147483646) #t)
(test (equal? 3/4 12/16) #t)
(test (equal? 1/1 1) #t)
(test (equal? 312689/99532 833719/265381) #f)
(test (let ((x 3.141)) (equal? x x)) #t)
(test (let ((x 1+i)) (equal? x x)) #t)
(test (let* ((x 3.141) (y x)) (equal? x y)) #t)
(test (let* ((x 1+i) (y x)) (equal? x y)) #t)
(test (let* ((x 3/4) (y x)) (equal? x y)) #t)
(test (equal? '(+ '1) '(+ 1)) #f) ; !?

(test (equal? '(1/0) '(1/0)) #f)
(test (equal? '1/0 '1/0) #f) 
(test (let ((+nan.0 1/0)) (equal? '(+nan.0) '(+nan.0))) #t)
(test (let ((+nan.0 1/0)) (equal? (list +nan.0) (list +nan.0))) #f)
;;; in the 1st case we're looking at the symbol, not its value
(test (let ((+nan.0 1/0)) (equal? (vector +nan.0) (vector +nan.0))) #f)
(test (let ((+nan.0 1/0)) (equal? #(1/0) #(1/0))) #f)

(test (let ((x 3.141)) (equal? x x)) #t)
(test (equal? 3 3) #t)
(test (equal? 3 3.0) #f)
(test (equal? 3.0 3.0) #t)
(test (equal? 3-4i 3-4i) #t)
(test (equal? (string #\c) "c") #t)
(test (equal? equal? equal?) #t)
(test (equal? (cons 1 (cons 2 3)) '(1 2 . 3)) #t)
(test (equal? '() '()) #t)
(test (equal? '() (list)) #t)
(test (equal? (cdr '   ''0) '((quote 0))) #t)
(test (equal? "\n" "\n") #t)
(test (equal? #f ((lambda () #f))) #t)
(test (equal? (+) 0) #t)
(test (equal? (recompose 32 list '(1)) (recompose 32 list (list 1))) #t)
(test (equal? (recompose 100 list '(1)) (recompose 100 list (list 1))) #t)
(test (equal? (recompose 32 vector 1) (recompose 32 vector 1)) #t)
(test (equal? (reinvert 32 list vector 1) (reinvert 32 list vector 1)) #t)
(test (equal? (recompose 32 (lambda (a) (cons 1 a)) '()) (recompose 32 (lambda (a) (cons 1 a)) '())) #t)
(test (equal? (recompose 32 (lambda (a) (list 1 a)) '()) (recompose 32 (lambda (a) (list 1 a)) '())) #t)

(test (equal? "asd""asd") #t) ; is this the norm?
(let ((streq (lambda (a b) (equal? a b)))) (test (streq "asd""asd") #t))

(let ((things (vector #t #f #\space '() "" 0 1 3/4 1+i 1.5 '(1 .2) '#() (vector 1) (list 1) 'f 't #\t)))
  (do ((i 0 (+ i 1)))
      ((= i (- (vector-length things) 1)))
    (do ((j (+ i 1) (+ j 1)))
	((= j (vector-length things)))
      (if (equal? (vector-ref things i) (vector-ref things j))
	  (format #t ";(equal? ~A ~A) -> #t?~%" (vector-ref things i) (vector-ref things j))))))

(test (equal?) 'error)
(test (equal? #t) 'error)
(test (equal? #t #t #t) 'error)
(test (equal #t #t) 'error)

(test (call-with-exit (lambda (return) (return (equal? return return)))) #t)
(test (call-with-exit (lambda (return) (call-with-exit (lambda (quit) (return (equal? return quit)))))) #f)
(test (call/cc (lambda (return) (return (equal? return return)))) #t)
(test (let hiho ((i 0)) (equal? hiho hiho)) #t)
(test (let hiho ((i 0)) (let hoho ((i 0)) (equal? hiho hoho))) #f)
(test (equal? + *) #f)
(test (equal? lambda lambda) #t)
(test (equal? lambda lambda*) #f)
(test (equal? let let) #t)
(test (equal? let letrec) #f)
(test (equal? define define) #t)
(test (equal? + ((lambda (a) a) +)) #t)
(test (let ((x "hi")) (define (hi) x) (equal? (hi) (hi))) #t)

;; so (eq? 3/4 3/4) is #f, (eqv? 3/4 3/4) is #t,
;;    (eqv? #(1) #(1)) is #f, (equal? #(1) #(1)) is #t
;;    (equal? 3 3.0) is #f, (= 3 3.0) is #t
;; in s7 
;;    (eq? 0.0 0.0) is #t,
;;    (eq? 2.0 2.0) is #f
(test (equal? .0 0.) #t)
(test (equal? 
       (list "hi" (integer->char 65) 1 'a-symbol (make-vector 3) (list) (cons 1 2) abs quasiquote 3 3/4 1.0+1.0i #\f (if #f #f) #<eof> #<undefined>)
       (list "hi" (integer->char 65) 1 'a-symbol (make-vector 3) (list) (cons 1 2) abs quasiquote 3 3/4 1.0+1.0i #\f (if #f #f) #<eof> #<undefined>))
      #t)
(test (equal? 
       (vector "hi" (integer->char 65) 1 'a-symbol (make-vector 3) abs quasiquote 3 3/4 1.0+1.0i #\f (if #f #f) #<eof> #<undefined>)
       (vector "hi" (integer->char 65) 1 'a-symbol (make-vector 3) abs quasiquote 3 3/4 1.0+1.0i #\f (if #f #f) #<eof> #<undefined>))
      #t)
(test (equal? (make-string 3) (make-string 3)) #t)
(test (equal? (make-list 3) (make-list 3)) #t)
(test (equal? (make-vector 3) (make-vector 3)) #t)
(test (equal? (make-random-state 100) (make-random-state 100)) #t)

(test (equal? (current-input-port) (current-input-port)) #t)
(test (equal? (current-input-port) (current-output-port)) #f)
(test (equal? *stdin* *stderr*) #f)
(test (let ((l1 (list 'a 'b)) 
	    (l2 (list 'a 'b 'a 'b))) 
	(set! (cdr (cdr l1)) l1) 
	(set! (cdr (cdr (cdr (cdr l2)))) l2)
	(equal? l1 l2))
      #t)
(test (let ((l1 (list 'a 'b)) 
	    (l2 (list 'a 'b 'a))) 
	(set! (cdr (cdr l1)) l1) 
	(set! (cdr (cdr (cdr l2))) l2)
	(equal? l1 l2))
      #f)
(test (let ((v1 (vector 1 2 3))
	    (v2 (vector 1 2 3)))
	(set! (v1 1) v1)
	(set! (v2 1) v2)
	(equal? v1 v2))
      #t)
(test (let ((v1 (vector 1 2 3))
	    (v2 (vector 1 2 4)))
	(set! (v1 1) v1)
	(set! (v2 1) v2)
	(equal? v1 v2))
      #f)

(if with-bignums
    (begin
      (test (equal? (/ (* 5 most-positive-fixnum) (* 3 most-negative-fixnum)) -46116860184273879035/27670116110564327424) #t)
      ))
