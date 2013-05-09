(test (or (= 2 2) (> 2 1)) #t)
(test (or (= 2 2) (< 2 1)) #t)
(test (or #f #f #f) #f)
(test (or) #f)
(test (or (memq 'b '(a b c)) (+ 3 0)) '(b c))
(test (or 3 9) 3)
(test (or #f 3 asdf) 3) ; "evaluation stops immediately"
(test (or 3 (/ 1 0) (display "or is about to exit!") (exit)) 3)

(for-each
 (lambda (arg)
   (test (or arg) arg)
   (test (or #f arg) arg)
   (test (or arg (error "oops or ")) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) #<eof> #<unspecified> '(1 . 2)))

(test (call-with-input-file "s7test.scm"
	(lambda (p)
	  (let ((loc 0))
	    (let loop ((val (read-char p)))
	      (or (eof-object? val)
		  (> loc 1000) ; try to avoid the read-error stuff
		  (begin
		    (set! loc (+ 1 loc))
		    (loop (read-char p)))))
	    (> loc 1000))))
      #t)

(test (or (and (or (> 3 2) (> 3 4)) (> 2 3)) 4) 4)
(test (or or) or)
(test (or (or (or))) #f)
(test (or (or (or) (and))) #t)
(test (let ((a 1)) (or (let () (set! a 2) #f) (= a 1) (let () (set! a 3) #f) (and (= a 3) a) (let () (set! a 4) #f) a)) 3)
(test (or '#f '()) '())
(test (call/cc (lambda (r) (or #f (> 3 2) (r 123) 321))) #t)
(test (call/cc (lambda (r) (or #f (< 3 2) (r 123) 321))) 123)
(test (+ (or #f (not (null? '())) 3) (or (zero? 1) 2)) 5)
(test (or 0) 0)
(test (if (or) 1 2) 2)

(test (or . 1) 'error)
(test (or #f . 1) 'error)
(test (or . (1 2)) 1)
(test (or . ()) (or))
; (test (or 1 . 2) 1) ; this fluctuates

(test (let () (or (define (hi a) a)) (hi 1)) 1)
(test (let () (or #t (define (hi a) a)) (hi 1)) 'error)
(test (let () (and (define (hi a) a) (define (hi a) (+ a 1))) (hi 1)) 2) ; guile agrees with this
(test ((lambda (arg) (arg #f 123)) or) 123)
(test (let ((oar or)) (oar #f 43)) 43)
(test (let ((oar #f)) (set! oar or) (oar #f #f 123)) 123)
