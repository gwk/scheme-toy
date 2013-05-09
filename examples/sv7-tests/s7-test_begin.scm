(test (begin) '()) ; I think Guile returns #<unspecified> here
(test (begin (begin)) '())
(test (let () (begin) #f) #f)
(test (let () (begin (begin (begin (begin)))) #f) #f)
(test (let () (begin (define x 2) (define y 1)) (+ x y)) 3)
(test (let () (begin (define x 0)) (begin (set! x 5) (+ x 1)))  6)
(test (let () (begin (define first car)) (first '(1 2))) 1)
(test (let () (begin (define x 3)) (begin (set! x 4) (+ x x))) 8)
(test (let () (begin (define x 0) (define y x) (set! x 3) y)) 0)         ; the let's block confusing global defines
(test (let () (begin (define x 0) (define y x) (begin (define x 3) y))) 0)
(test (let () (begin (define y x) (define x 3) y)) 'error)               ; guile says 3
(test (let ((x 12)) (begin (define y x) (define x 3) y)) 12)             ; guile says 3 which is letrec-style?
(test (begin (define (x) y) (define y 4) (x)) 4)
;; (let ((x 12)) (begin (define y x) y)) is 12
(test (let ((x 3)) (begin x)) 3)
(test (begin 3) 3)
(test (begin . (1 2)) 2)
(test (begin . ()) (begin))
(test (begin . 1) 'error)
(test (begin 1 . 2) 'error)
(test (begin ("hi" 1)) #\i)

(if (equal? (begin 1) 1)
    (begin
      (test (let () (begin (define x 0)) (set! x (begin (begin 5))) (begin ((begin +) (begin x) (begin (begin 1))))) 6)      
      
      (test (let ((x 5))
	      (begin (begin (begin)
			    (begin (begin (begin) (define foo (lambda (y) (bar x y)))
					  (begin)))
			    (begin))
		     (begin)
		     (begin)
		     (begin (define bar (lambda (a b) (+ (* a b) a))))
		     (begin))
	      (begin)
	      (begin (foo (+ x 3))))
	    45)
      
      (for-each
       (lambda (arg)
	 (test (begin arg) arg))
       (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))
      
      (test (if (= 1 1) (begin 2) (begin 3)) 2)
      ))

(test ((lambda (x) (begin (set! x 1) (let ((a x)) (+ a 1)))) 2) 2)
;;; apparently these can be considered errors or not (guile says error, stklos and gauche do not)
(test (begin (define x 0) (+ x 1)) 1)
(test ((lambda () (begin (define x 0) (+ x 1)))) 1)
(test (let ((f (lambda () (begin (define x 0) (+ x 1))))) (f)) 1)

(test ((lambda () (begin (define x 0)) (+ x 1))) 1)
(test (let ((f (lambda () (begin (define x 0)) (+ x 1)))) (f)) 1)
(test (let ((x 32)) (begin (define x 3)) x) 3)
(test ((lambda (x) (begin (define x 3)) x) 32) 3)
(test (let* ((x 32) (y x)) (define x 3) y) 32)

(test (let ((z 0)) (begin (define x 32)) (begin (define y x)) (set! z y) z) 32)
(test (let((z 0))(begin(define x 32))(begin(define y x))(set! z y)z) 32)
(test (let ((z 0)) (begin (define x 32) (define y x)) (set! z y) z) 32)        
(test (let () (begin (define b 1) (begin (define a b) (define b 3)) a)) 1)
(test (let () (begin (begin (define a1 1) (begin (define a1 b1) (define b1 3))) a1)) 'error)
(test (let () (begin (begin (define (a3) 1)) (begin (define (a3) b3) (define b3 3)) (a3))) 3) ; yow
(test (let () (begin (begin (define (a) 1)) (a))) 1)
(test (let ((a 1)) (begin (define a 2)) a) 2)
(test (+ 1 (begin (values 2 3)) 4) 10)
(test (+ 1 (begin (values 5 6) (values 2 3)) 4) 10)
(test (let ((hi 0)) (begin (values (define (hi b) (+ b 1))) (hi 2))) 3)
