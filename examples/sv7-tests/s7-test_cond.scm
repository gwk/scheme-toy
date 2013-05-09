(test (cond ('a)) 'a)
(test (cond (3)) 3)
(test (cond (#f 'a) ('b)) 'b)
(test (cond (#t 'a) (#t 'b)) 'a)
(test (cond ((> 3 2) 'greater) ((< 3 2) 'less)) 'greater)
(test (cond((> 3 2)'greater)((< 3 2)'less)) 'greater)
(test (cond ((> 3 3) 'greater) ((< 3 3) 'less)  (else 'equal)) 'equal)
(test (cond ((assv 'b '((a 1) (b 2))) => cadr)  (else #f)) 2)
(test (cond (#f 2) (else 5)) 5)
(test (cond (1 2) (else 5)) 2)
(test (cond (1 => (lambda (x) (+ x 2))) (else 8)) 3)
(test (cond ((+ 1 2))) 3)
(test (cond ((zero? 1) 123) ((= 1 1) 321)) 321)
(test (cond ('() 1)) 1)
(test (let ((x 1)) (cond ((= 1 2) 3) (else (* x 2) (+ x 3)))) 4)
(test (let((x 1))(cond((= 1 2)3)(else(* x 2)(+ x 3)))) 4)
(test (let ((x 1)) (cond ((= x 1) (* x 2) (+ x 3)) (else 32))) 4)
(test (let ((x 1)) (cond ((= x 1) (let () (set! x (* x 2))) (+ x 3)) (else 32))) 5)
(test (let ((x 1)) (cond ((= x 2) (let () (set! x (* x 2))) (+ x 3)) (else 32))) 32)
(test (let ((x 1)) (cond ((= x 2) 3) (else (let () (set! x (* x 2))) (+ x 3)))) 5)
(test (cond ((= 1 2) 3) (else 4) (else 5)) 4) ; this should probably be an error
(test (cond (1 2 3)) 3)
(test (cond (1 2) (3 4)) 2)
(test (cond ((= 1 2) 3) ((+ 3 4))) 7)
(test (cond ((= 1 1) (abs -1) (+ 2 3) (* 10 2)) (else 123)) 20)
(test (let ((a 1)) (cond ((= a 1) (set! a 2) (+ a 3)))) 5)
(test (let ((a 1)) (cond ((= a 2) (+ a 2)) (else (set! a 3) (+ a 3)))) 6)
(test (cond ((= 1 1))) #t)
(test (cond ((= 1 2) #f) (#t)) #t)
(test (cond ((+ 1 2))) 3)
(test (cond ((cons 1 2))) '(1 . 2))
(test (cond (#f #t) ((string-append "hi" "ho"))) "hiho")
(test (cond ('() 3) (#t 4)) 3)
(test (cond ((list) 3) (#t 4)) 3)
;;; (cond (1 1) (asdf 3)) -- should this be an error?
(test (cond (+ 0)) 0)
(test (cond (lambda ())) ())
(test (cond . ((1 2) ((3 4)))) 2)
(test (cond (define #f)) #f)
(test (let () (cond ((> 2 1) (define x 32) x) (#t 1)) x) 32) ; ? a bit strange
(test (let ((x 1)) (+ x (cond ((> x 0) (define x 32) x)) x)) 65)
(test (cond (("hi" 1))) #\i)
(test (cond (()())) ())

(for-each
 (lambda (arg)
   (test (cond ((or arg) => (lambda (x) x))) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (cond ((+ 1 2) => (lambda (x) (+ 1 x)))) 4)
(test (cond ((cons 1 2) => car)) 1)
(test (cond ((values 1 2) => +)) 3)
(test (cond (1 2 => +)) 'error)
(test (cond ((begin 1 2) => +)) 2)
(test (cond ((values -1) => abs)) 1)
(test (cond ((= 1 2) => +) (#t => not)) #f)
(test (cond ((* 2 3) => (let () -))) -6)
(test (cond ((* 2 3) => (cond ((+ 3 4) => (lambda (a) (lambda (b) (+ b a))))))) 13)
(test (let ((x 1)) ((cond ((let () (set! x 2) #f) => boolean?) (lambda => (lambda (a) (apply a '((b) (+ b 123)))))) x)) 125)
(test (cond ((values 1 2 3) => '(1 (2 3 (4 5 6 7 8))))) 7)
(test (cond ((values #f #f) => equal?)) #t) ; (values #f #f) is not #f
(test (let () (cond (#t (define (hi a) a))) (hi 1)) 1)
(test (let () (cond (#f (define (hi a) a))) (hi 1)) 'error)
(test (let () (cond ((define (hi a) a) (hi 1)))) 1)

(test (cond (else 1)) 1)
(test (call/cc (lambda (r) (cond ((r 4) 3) (else 1)))) 4)
(test (cond ((cond (#t 1)))) 1)
(test (symbol? (cond (else else))) #f)
(test (equal? else (cond (else else))) #t)
(test (cond (#f 2) ((cond (else else)) 1)) 1)
(test (let ((x #f) (y #t)) (cond (x 1) (y 2))) 2)

(for-each
 (lambda (arg)
   (test (cond (#t arg)) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (cond (arg)) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (cond (#f 1) (else arg)) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (cond (arg => (lambda (x) x))) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (cond ((let () 1) => (let ((x 2)) (lambda (n) (+ n x))))) 3)
(test (cond ((let () 1) => (let ((x 2)) (cond (3 => (let ((y 4)) (lambda (n) (lambda (m) (+ n m x y))))))))) 10)

(test (let ((=> 3)) (cond (=> =>))) 3)
(test (cond (cond 'cond)) 'cond)
(test (cond (3 => (lambda args (car args)))) 3)
(test (cond (3 => (lambda (a . b) a))) 3)
(test (cond ((list 3 4) => (lambda (a . b) b))) '())
(test (cond) 'error)
					;(test (cond ((= 1 2) 3) (else 4) (4 5)) 'error) ; trailing ignored 
(test (cond ((+ 1 2) => (lambda (a b) (+ a b)))) 'error)
(test (equal? (cond (else)) else) #t)
(test (cond (#t => 'ok)) 'error)
(test (cond (else =>)) 'error)
(test (cond ((values -1) => => abs)) 'error)
(test (cond ((values -1) =>)) 'error)
(test (cond (cond (#t 1))) 'error)
(test (cond 1) 'error)
(test (cond) 'error)
(test (cond (1 . 2) (else 3)) 'error)
(test (cond (#f 2) (else . 4)) 'error)
(test (cond ((values 1 2) => (lambda (x y) #t))) #t)
(test (cond #t) 'error)
(test (cond 1 2) 'error)
(test (cond 1 2 3) 'error)
(test (cond 1 2 3 4) 'error)
(test (cond (1 => (lambda (x y) #t))) 'error)
(test (cond . 1) 'error)
(test (cond ((1 2)) . 3) 'error)
(test (cond (1 => + abs)) 'error)
(test (cond (1 =>)) 'error)
(test (cond ((values 1 2) => + abs)) 'error)
;(test (cond (else => not)) 'error) ; to heck with this
(test (let ((else 3)) (cond ((= else 3) 32) (#t 1))) 32)
(test (let ((else #f)) (cond (else 32) (#t 1))) 1)
(test (cond #((1 2))) 'error)

(test (let ((=> 3)) (cond (1 =>))) 3)
(test (let ((=> 3)) (cond (1 => abs))) abs)
(test (let ((=> 3) (else 4)) (cond (else => abs))) abs)
(test (let ((=> 3)) (cond (1 => "hi"))) "hi")

(test (let ((x 0))
	(cond ((let ((y x)) (set! x 1) (= y 1)) 0)
	      ((let ((y x)) (set! x 1) (= y 1)) 1)
	      (#t 2)))
      1)

(let ((c1 #f)
      (x 1))
  (let ((y (cond ((let ()
		    (call/cc
		     (lambda (r)
		       (set! c1 r)
		       (r x))))
		  => (lambda (n) (+ n 3)))
		 (#t 123))))
    (if (= y 4) (begin (set! x 2) (c1 321)))
    (test (list x y) '(2 324))))

(let ((c1 #f)
      (x 1))
  (let ((y (cond (x => (lambda (n) 
			 (call/cc
			  (lambda (r)
			    (set! c1 r)
			    (r (+ 3 x))))))
		 (#t 123))))
    (if (= y 4) (begin (set! x 2) (c1 321)))
    (test (list x y) '(2 321))))




;;; -------- cond-expand --------
;;; cond-expand

(test (let ()
	(cond-expand (guile )
		     (s7 (define (hi a) a)))
	(hi 1))
      1)
(test (let ((x 0))
	(cond-expand (guile (format #t ";oops~%"))
		     (else (set! x 32)))
	x)
      32)
(test (let ()
	(cond-expand
	 (guile 
	  (define (hi a) (+ a 1)))
	 ((or common-lisp s7)
	  (define (hi a) a)))
	(hi 1))
      1)
(test (let ()
	(cond-expand
	 ((not guile)
	  (define (hi a) a))
	 (else 
	  (define (hi a) (+ a 1))))
	(hi 1))
      1)

(test (let ()
	(cond-expand 
	 ((and s7 dfls-exponents)
	  (define (hi a) a))
	 (else 
	  (define (hi a) (+ a 1))))
	(hi 1))
      (if (provided? 'dfls-exponents) 1 2))
(test (let ()
	(cond-expand 
	 ((or s7 guile)
	  (define (hi a) a))
	 (else 
	  (define (hi a) (+ a 1))))
	(hi 1))
      1)
(test (let ()
	(cond-expand 
	 ((and s7 dfls-exponents unlikely-feature)
	  (define (hi a) a))
	 (else 
	  (define (hi a) (+ a 1))))
	(hi 1))
      2)
(test (let ()
	(cond-expand
	 ((and s7 (not s7)) 'oops)
	 (else 1)))
      1)
(test (let ()
	(cond-expand
	 ("not a pair" 1)
	 (2 2)
	 (#t 3)
	 ((1 . 2) 4)
	 (() 6)
	 (list 7)
	 (else 5)))
      'error)
