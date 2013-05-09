(test (and (= 2 2) (> 2 1)) #t)
(test (and (= 2 2) (< 2 1)) #f)
(test (and 1 2 'c '(f g)) '(f g))
(test (and) #t)
(test (and . ()) (and))
(test (and 3) 3)
(test (and (memq 'b '(a b c)) (+ 3 0)) 3)
(test (and 3 9) 9)
(test (and #f 3 asdf) #f) ; "evaluation stops immediately"
(test (and 3 (zero? 1) (/ 1 0) (display "and is about to exit!") (exit)) #f)
(test (if (and) 1 2) 1)
(test (if (+) 1 2) 1)
(test (if (*) 1 2) 1)
(test (and (if #f #f)) (if #f #f))
(test (let ((x '(1))) (eq? (and x) x)) #t)

(for-each
 (lambda (arg)
   (test (and arg) arg)
   (test (and #t arg) arg)
   (test (and arg #t) #t))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (call-with-input-file "s7test.scm"
	(lambda (p)
	  (let ((loc 0))
	    (let loop ((val (read-char p)))
	      (and (not (eof-object? val))
		   (< loc 1000)
		   (begin
		     (set! loc (+ 1 loc))
		     (loop (read-char p)))))
	    (>= loc 1000))))
      #t)

(test (and (or (and (> 3 2) (> 3 4)) (> 2 3)) 4) #f)
(test (and and) and)
(test (and (and (and))) #t)
(test (and (and (and (and (or))))) #f)
(test (let ((a 1)) (and (let () (set! a 2) #t) (= a 1) (let () (set! a 3) #f) (and (= a 3) a) (let () (set! a 4) #f) a)) #f)
(test (and '#t '()) '())
(test (call/cc (lambda (r) (and #t (> 3 2) (r 123) 321))) 123)
(test (call/cc (lambda (r) (and #t (< 3 2) (r 123) 321))) #f)
(test (+ (and (null? '()) 3) (and (zero? 0) 2)) 5)

(test (and . #t) 'error)
(test (and 1 . 2) 'error)
(test (and . (1 2)) 2)

(test (let () (and (define (hi a) a)) (hi 1)) 1)
(test (let () (and #f (define (hi a) a)) (hi 1)) 'error)
(test (+ 1 (and (define (hi a) a) (hi 2))) 3)

;;; from some net site 
(let ()
  (define (fold fn accum list)
    (if (null? list)
	accum
	(fold fn
	      (fn accum
		  (car list))
	      (cdr list))))

  (test (fold and #t '(#t #f #t #t)) #f))

;;; here are some tests from S. Lewis in the r7rs mailing list
(let ()
  (define myand and)
  (test (myand #t (+ 1 2 3)) 6)
  (define (return-op) and)
  (define myop (return-op))
  (test (myop #t (+ 1 2 3)) 6)
  (test (and #t (+ 1 2 3)) 6)
  (test ((return-op) #t (+ 1 2 3)) 6)
  (test ((and and) #t (+ 1 2 3)) 6)
  (define ops `(,* ,and))
  (test ((car ops) 2 3) 6)
  (test ((cadr ops) #t #f) #f)
  (test (and #f never) #f)
  (test (and #f and) #f)
  (test ((and #t and) #t (+ 1 2 3)) 6))
