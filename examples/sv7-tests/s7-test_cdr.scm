(test (cdr (list 1 2 3)) '(2 3))
(test (cdr (cons 1 2)) 2)
(test (cdr (list 1)) '())
(test (cdr '(1 2 3)) '(2 3))
(test (cdr '(1)) '())
(test (cdr '(1 . 2)) 2)
(test (cdr '((1 2) 3)) '(3))
(test (cdr '(((1 . 2) . 3) 4)) '(4))
(test (cdr (list (list) (list 1 2))) '((1 2)))
(test (cdr '(a b c)) '(b c))
(test (cdr '((a) b c d)) '(b c d))
(test (equal? (cdr (reverse (list 1 2 3 4))) 4) #f)
(test (equal? (cdr (list 'a 'b 'c 'd 'e 'f 'g)) 'a) #f)
(test (cdr '((((((1 2 3) 4) 5) (6 7)) (((u v w) x) y) ((q w e) r) (a b c) e f) g)) '(g))
(test (cdr '(a)) '())
(test (cdr '(a b c d e f g)) '(b c d e f g))
(test (cdr '(((((1 2 3) 4) 5) (6 7)) (((u v w) x) y) ((q w e) r) (a b c) e f g)) '((((u v w) x) y) ((q w e) r) (a b c) e f g))
(test (cdr ''foo) '(foo))
(test (cdr (cons (cons 1 2) (cons 3 4))) '(3 . 4))
(test (cdr '(1 2 . 3)) '(2 . 3))
(test (cdr (if #f #f)) 'error)
(test (cdr '()) 'error)

(for-each
 (lambda (arg)
   (if (not (equal? (cdr (cons '() arg)) arg))
       (format #t ";(cdr '(() ~A) -> ~A?~%" arg (cdr (cons '() arg))))
   (test (cdr arg) 'error))
 (list "hi" (integer->char 65) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand (log 0) 
       3.14 3/4 1.0+1.0i #\f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(let* ((a (list 1 2 3))
       (b a))
  (set! (car a) (cadr a)) 
  (set! (cdr a) (cddr a))
  (test a (list 2 3))
  (test b a))

(define (cons-r a b n) (if (= 0 n) (cons a b) (cons (cons-r (+ a 1) (+ b 1) (- n 1)) (cons-r (- a 1) (- b 1) (- n 1)))))
(define (list-r a b n) (if (= 0 n) (list a b) (list (list-r (+ a 1) (+ b 1) (- n 1)) (list-r (- a 1) (- b 1) (- n 1)))))

(define lists (list (list 1 2 3)
		    (cons 1 2)
		    (list 1)
		    (list)
		    (list (list 1 2) (list 3 4))
		    (list (list 1 2) 3)
		    '(1 . 2)
		    '(a b c)
		    '((a) b (c))
		    '((1 2) (3 4))
		    '((1 2 3) (4 5 6) (7 8 9))
		    '(((1) (2) (3)) ((4) (5) (6)) ((7) (8) (9)))
		    '((((1 123) (2 124) (3 125) (4 126)) ((5) (6) (7) (8)) ((9) (10) (11) (12)) ((13) (14) (15) (16)))
		      (((21 127) (22 128) (23 129) (24 130)) ((25) (26) (27) (28)) ((29) (30) (31) (32)) ((33) (34) (35) (36)))
		      (((41 131) (42 132) (43 133) (44 134)) ((45) (46) (47) (48)) ((49) (50) (51) (52)) ((53) (54) (55) (56)))
		      (((61 135) (62 136) (63 137) (64 138)) ((65) (66) (67) (68)) ((69) (70) (71) (72)) ((73) (74) (75) (76)))
		      321)
		    (cons 1 (cons 2 (cons 3 4)))
		    (cons (cons 2 (cons 3 4)) 5)
		    (cons '() 1)
		    (cons 1 '())
		    (cons '() '())
		    (list 1 2 (cons 3 4) 5 (list (list 6) 7))
		    (cons-r 0 0 4)
		    (cons-r 0 0 5)
		    (cons-r 0 0 10)
		    (list-r 0 0 3)
		    (list-r 0 0 7)
		    (list-r 0 0 11)
		    ''a
		    ))
