(let ((calls (make-vector 3 #f))
      (travels (make-vector 5 0))
      (ctr 0))
  (set! (travels 0) (+ (travels 0) 1))
  (call/cc (lambda (c0) (set! (calls 0) c0)))
  (set! (travels 1) (+ (travels 1) 1))
  (call/cc (lambda (c1) (set! (calls 1) c1)))
  (set! (travels 2) (+ (travels 2) 1))
  (call/cc (lambda (c2) (set! (calls 2) c2)))
  (set! (travels 3) (+ (travels 3) 1))
  (let ((ctr1 ctr))
    (set! ctr (+ ctr1 1))
    (if (< ctr1 3)
	((calls ctr1) ctr1)))
  (set! (travels 4) (+ (travels 4) 1))
  (test travels #(1 2 3 4 1)))

(let ((calls (make-vector 5 #f))
      (travels (make-vector 5 0))
      (ctr2 0))
  (let loop ((ctr 0))
    (if (< ctr 3)
	(begin
	  (set! (travels ctr) (+ (travels ctr) 1))
	  (call/cc (lambda (c0) (set! (calls ctr) c0)))
	  (loop (+ ctr 1)))))
  (set! (travels 3) (+ (travels 3) 1))
  (let ((ctr1 ctr2))
    (set! ctr2 (+ ctr1 1))
    (if (< ctr1 3)
	((calls ctr1) ctr1)))
  (set! (travels 4) (+ (travels 4) 1))
  (test travels #(1 2 3 4 1)))

(let ((c1 #f)
      (c2 #f)
      (c3 #f)
      (x0 0)
      (x1 0)
      (x2 0)
      (x3 0))
  (let ((x (+ 1 
	      (call/cc
	       (lambda (r1)
		 (set! c1 r1)
		 (r1 2)))
	      (call/cc
	       (lambda (r2)
		 (set! c2 r2)
		 (r2 3)))
	      (call/cc
	       (lambda (r3)
		 (set! c3 r3)
		 (r3 4)))
	      5)))
    (if (= x0 0) 
	(set! x0 x)
	(if (= x1 0)
	    (set! x1 x)
	    (if (= x2 0)
		(set! x2 x)
		(if (= x3 0)
		    (set! x3 x)))))
    (if (= x 15)
	(c1 6))
    (if (= x 19)
	(c2 7))
    (if (= x 23)
	(c3 8))
    (test (list x x0 x1 x2 x3) '(27 15 19 23 27))))

(let ((c1 #f) (c2 #f) (c3 #f) (x0 0) (x1 0) (x2 0) (x3 0) (y1 0) (z0 0) (z1 0) (z2 0) (z3 0))
  (let* ((y 101)
	 (x (+ y 
	      (call/cc
	       (lambda (r1)
		 (set! c1 r1)
		 (r1 2)))
	      (call/cc
	       (lambda (r2)
		 (set! c2 r2)
		 (r2 3)))
	      (call/cc
	       (lambda (r3)
		 (set! c3 r3)
		 (r3 4)))
	      5))
	 (z (+ x y)))
    (set! y1 y)
    (if (= x0 0) 
	(begin
	  (set! x0 x)
	  (set! z0 z))
	(if (= x1 0)
	    (begin
	      (set! x1 x)
	      (set! z1 z))
	    (if (= x2 0)
		(begin
		  (set! x2 x)
		  (set! z2 z))
		(if (= x3 0)
		    (begin
		      (set! x3 x)
		      (set! z3 z))))))
    (if (= x 115)
	(c1 6))
    (if (= x 119)
	(c2 7))
    (if (= x 123)
	(c3 8))
    (test (list x x0 x1 x2 x3 y1 z0 z1 z2 z3) '(127 115 119 123 127 101 216 220 224 228))))

(let ((c1 #f)
      (c2 #f)
      (c3 #f)
      (x0 0)
      (x1 0)
      (x2 0)
      (x3 0))
  (let ((x (+ 1 
	      (call/cc
	       (lambda (r1)
		 (set! c1 r1)
		 (r1 2)))
	      (call/cc
	       (lambda (r2)
		 (set! c2 r2)
		 (r2 3)))
	      (call/cc
	       (lambda (r3)
		 (set! c3 r3)
		 (r3 4)))
	      5)))
    (if (= x0 0) 
	(set! x0 x)
	(if (= x1 0)
	    (set! x1 x)
	    (if (= x2 0)
		(set! x2 x)
		(if (= x3 0)
		    (set! x3 x)))))
    (if (= x 15)
	(c1 6 1))
    (if (= x 20)
	(c2 7 2 3))
    (if (= x 29)
	(c3 8 3 4 5))
    (test (list x x0 x1 x2 x3) '(45 15 20 29 45))))
;; 45 = (+ 1 6 1 7 2 3 8 3 4 5 5)

(let ((x 0)
      (c1 #f)
      (results '()))
  (set! x (call/cc
	   (lambda (r1)
	     (set! c1 r1)
	     (r1 2))))
  (set! results (cons x results))
  (if (= x 2) (c1 32))
  (test results '(32 2)))

(let ((x #(0))
      (y #(0))
      (c1 #f))
  (set! ((call/cc
	   (lambda (r1)
	     (set! c1 r1)
	     (r1 x)))
	 0) 32)
  (if (= (y 0) 0) (c1 y))
  (test (and (equal? x #(32)) (equal? y #(32))) #t))

(test (call/cc (lambda (k) ((call/cc (lambda (top) (k (+ 1 (call/cc (lambda (inner) (top inner))))))) 2))) 3)

(let* ((next-leaf-generator (lambda (obj eot)
			      (letrec ((return #f)
				       (cont (lambda (x)
					       (recur obj)
					       (set! cont (lambda (x) (return eot)))
					       (cont #f)))
				       (recur (lambda (obj)
						(if (pair? obj)
						    (for-each recur obj)
						    (call-with-current-continuation
						     (lambda (c)
						       (set! cont c)
						       (return obj)))))))
				(lambda () (call-with-current-continuation
					    (lambda (ret) (set! return ret) (cont #f)))))))
       (leaf-eq? (lambda (x y)
		   (let* ((eot (list 'eot))
			  (xf (next-leaf-generator x eot))
			  (yf (next-leaf-generator y eot)))
		     (letrec ((loop (lambda (x y)
				      (cond ((not (eq? x y)) #f)
					    ((eq? eot x) #t)
					    (else (loop (xf) (yf)))))))
		       (loop (xf) (yf)))))))
  
  (test (leaf-eq? '(a (b (c))) '((a) b c)) #t)
  (test (leaf-eq? '(a (b (c))) '((a) b c d)) #f))

(test (let ((r #f)
	    (a #f)
	    (b #f)
	    (c #f)
	    (i 0))
	(let () 
	  (set! r (+ 1 (+ 2 (+ 3 (call/cc (lambda (k) (set! a k) 4))))
		     (+ 5 (+ 6 (call/cc (lambda (k) (set! b k) 7))))))
	  (if (not c) 
	      (set! c a))
	  (set! i (+ i 1))
	  (case i
	    ((1) (a 5))
	    ((2) (b 8))
	    ((3) (a 6))
	    ((4) (c 4)))
	  r))
      28)

(test (let ((r #f)
	    (a #f)
	    (b #f)
	    (c #f)
	    (i 0))
	(let () 
	  (set! r (+ 1 (+ 2 (+ 3 (call/cc (lambda (k) (set! a k) 4))))
		     (+ 5 (+ 6 (call/cc (lambda (k) (set! b k) 7))))))
	  (if (not c) 
	      (set! c a))
	  (set! i (+ i 1))
	  (case i
	    ((1) (b 8))
	    ((2) (a 5))
	    ((3) (b 7))
	    ((4) (c 4)))
	  r))
      28)

(test (let ((k1 #f)
	    (k2 #f)
	    (k3 #f)
	    (state 0))
	(define (identity x) x)
	(define (fn)
	  ((identity (if (= state 0)
			 (call/cc (lambda (k) (set! k1 k) +))
			 +))
	   (identity (if (= state 0)
			 (call/cc (lambda (k) (set! k2 k) 1))
			 1))
	   (identity (if (= state 0)
			 (call/cc (lambda (k) (set! k3 k) 2))
			 2))))
	(define (check states)
	  (set! state 0)
	  (let* ((res '())
		 (r (fn)))
	    (set! res (cons r res))
	    (if (null? states)
		res
		(begin (set! state (car states))
		       (set! states (cdr states))
		       (case state
			 ((1) (k3 4))
			 ((2) (k2 2))
			 ((3) (k1 -)))))))
	(map check '((1 2 3) (1 3 2) (2 1 3) (2 3 1) (3 1 2) (3 2 1))))
      '((-1 4 5 3) (4 -1 5 3) (-1 5 4 3) (5 -1 4 3) (4 5 -1 3) (5 4 -1 3)))

(let () ; Matt Might perhaps or maybe Paul Hollingsworth?
  (define (current-continuation)
    (call/cc (lambda (cc) (cc cc))))
  (define fail-stack '())
  (define (fail)
    (if (not (pair? fail-stack))
	(error "back-tracking stack exhausted!")
	(begin
	  (let ((back-track-point (car fail-stack)))
	    (set! fail-stack (cdr fail-stack))
	    (back-track-point back-track-point)))))
  (define (amb choices)
    (let ((cc (current-continuation)))
      (cond
       ((null? choices)      (fail))
       ((pair? choices)      (let ((choice (car choices)))
			       (set! choices (cdr choices))
			       (set! fail-stack (cons cc fail-stack))
			       choice)))))
  (define (assert condition)
    (if (not condition)
	(fail)
	#t))
  (let ((a (amb (list 1 2 3 4 5 6 7)))
	(b (amb (list 1 2 3 4 5 6 7)))
	(c (amb (list 1 2 3 4 5 6 7))))
    (assert (= (* c c) (+ (* a a) (* b b))))
    (assert (< b a))
    (test (list a b c) (list 4 3 5))))

(let ((c1 #f))
  (let ((x ((call/cc (lambda (r1) (set! c1 r1) (r1 "hiho"))) 0)))
    (if (char=? x #\h)
	(c1 "asdf"))
    (test x #\a)))

(test (let ((x '())
	    (y 0))
	(call/cc 
	 (lambda (escape)
	   (let* ((yin ((lambda (foo) 
			  (set! x (cons y x))
			  (if (= y 10)
			      (escape x)
			      (begin
				(set! y 0)
				foo)))
			(call/cc (lambda (bar) bar))))
		  (yang ((lambda (foo) 
			   (set! y (+ y 1))
			   foo)
			 (call/cc (lambda (baz) baz)))))
	     (yin yang)))))
      '(10 9 8 7 6 5 4 3 2 1 0))

(let ()
  ;; taken from wikipedia
  (define readyList '())
 
  (define (i-run)
    (if (not (null? readyList))
	(let ((cont (car readyList)))
	  (set! readyList (cdr readyList))
	  (cont '()))))
 
  (define (fork fn arg)
    (set! readyList
	  (append readyList
		  (cons
		   (lambda (x)
		     (fn arg)
		     (i-run))
		   '()))))
 
  (define (yield)
    (call-with-current-continuation
     (lambda (thisCont)
       (set! readyList
	     (append readyList
		     (cons thisCont '())))
       (let ((cont (car readyList)))
	 (set! readyList (cdr readyList))
	 (cont '())))))

  (define data (make-vector 10 0))
  (define data-loc 0)

  (define (process arg)
    (if (< data-loc 10)
	(begin
	  (set! (data data-loc) arg)
	  (set! data-loc (+ data-loc 1))
	  (yield)
	  (process (+ arg 1)))
	(i-run)))

  (fork process 0)
  (fork process 10)
  (fork process 20)
  (i-run)

  (test data #(0 10 20 1 11 21 2 12 22 3)))

(test (let ((c #f))
	(let ((r '()))
	  (let ((w (let ((v 1))
		     (set! v (+ (call-with-current-continuation
				 (lambda (c0) (set! c c0) v))
				v))
		     (set! r (cons v r))
		     v)))
	    (if (<= w 1024) (c w) r))))
      '(2048 1024 512 256 128 64 32 16 8 4 2))

(test (let ((c #f))
	(let ((r '()))
	  (let ((w (let ((v 1))
		     (set! v (+ (values v (call-with-current-continuation
				 (lambda (c0) (set! c c0) v)))
				v))
		     (set! r (cons v r))
		     v)))
	    (if (<= w 1024) (c w) r))))
      '(2047 1023 511 255 127 63 31 15 7 3))

;;; the 1st v is 1, the 3rd reflects the previous call/cc which reflects the
;;;    env+slot that had the subsequent set! -- wierd.

(test (let ((cc #f)
	    (r '()))
	(let ((s (list 1 2 3 4 (call/cc (lambda (c) (set! cc c) 5)) 6 7 8)))
	  (if (null? r)
	      (begin (set! r s) (cc -1))
	      (list r s))))
      '((1 2 3 4 5 6 7 8) (1 2 3 4 -1 6 7 8)))

(test (let ((count 0))
        (let ((first-time? #t)
              (k (call/cc values)))
          (if first-time?
              (begin
                (set! first-time? #f)
                (set! count (+ count 1))
                (k values))
              (void)))
        count)
      2)

(let ((c #f)
      (vals '()))
  (let ((val (+ 1 2 (call/cc (lambda (r) (set! c r) (r 3))))))
    (set! vals (cons val vals))
    (if (< val 20) (c (+ val 1)))
    (test vals '(22 18 14 10 6))))
(let ((c #f)
      (vals '()))
  (let ((val (+ 1 2 (call/cc (lambda (r) (set! c r) (r 3))))))
    (set! vals (cons val vals))
    (if (< val 20) (apply c vals))
    (test vals '(36 18 9 6))))
(let ((c #f)
      (vals '()))
  (let ((val (+ 1 2 (call/cc (lambda (r) (set! c r) (r 3))))))
    (set! vals (cons val vals))
    (if (< val 20) (c (apply values vals)))
    (test vals '(36 18 9 6))))

(test (procedure? (call/cc call/cc)) #t)
(test (call/cc (lambda (c) (0 (c 1)))) 1)
(test (call/cc (lambda (k) (k "foo"))) "foo")
(test (call/cc (lambda (k) "foo")) "foo")
(test (call/cc (lambda (k) (k "foo") "oops")) "foo")
(test (call/cc (lambda (return) (catch #t (lambda () (error 'hi "")) (lambda args (return "oops"))))) "oops")
(test (call/cc (lambda (return) (catch #t (lambda () (return 1)) (lambda args (return "oops"))))) 1)
(test (catch #t (lambda () (call/cc (lambda (return) (return "oops")))) (lambda arg 1)) "oops")
(test (call/cc (if (< 2 1) (lambda (return) (return 1)) (lambda (return) (return 2) 3))) 2)
(test (call/cc (let ((a 1)) (lambda (return) (set! a (+ a 1)) (return a)))) 2)
(test (call/cc (lambda (return) (let ((hi return)) (hi 2) 3))) 2)
(test (let () (define (hi) (call/cc func)) (define (func a) (a 1)) (hi)) 1)
(test (((call/cc (call/cc call/cc)) call/cc) (lambda (a) 1)) 1)
(test (+ 1 (eval-string "(+ 2 (call-with-exit (lambda (return) (return 3))) 4)") 5) 15)
(test (+ 1 (eval '(+ 2 (call-with-exit (lambda (return) (return 3))) 4)) 5) 15)
(test (call-with-exit) 'error)
(test (call-with-exit s7-version s7-version) 'error)
(test (call/cc) 'error)
(test (call/cc s7-version s7-version) 'error)
(test (call/cc (lambda () 1)) 'error)
(test (call/cc (lambda (a b) (a 1))) 'error)
(test (+ 1 (call/cc (lambda (k) (k #\a)))) 'error)
(test (+ 1 (call-with-exit (lambda (k) (k #\a)))) 'error)
(test ((call/cc (lambda (return) (call/cc (lambda (cont) (return cont))) list)) 1) '(1)) ; from Guile mailing list -- this strikes me as very strange

(test (call/cc begin) 'error)
(test (call/cc quote) 'error)

(let ((p1 (make-procedure-with-setter (lambda (k) (k 3)) (lambda (k a) (k a)))))
  (test (call/cc p1) 3)
  (test (call-with-exit p1) 3))

;;; guile/s7 accept: (call/cc (lambda (a . b) (a 1))) -> 1
;;; same:            (call/cc (lambda arg ((car arg) 1))) -> 1

(test (let ((listindex (lambda (e l)
			 (call/cc (lambda (not_found)
				    (letrec ((loop 
					      (lambda (l)
						(cond
						 ((null? l) (not_found #f))
						 ((equal? e (car l)) 0)
						 (else (+ 1 (loop (cdr l))))))))
				      (loop l)))))))
	(listindex 1 '(0 3 2 4 8)))
      #f)

(test (let ((product (lambda (li)
		       (call/cc (lambda (return)
				  (let loop ((l li))
				    (cond
				     ((null? l) 1)
				     ((= (car l) 0) (return 0))
				     (else (* (car l) (loop (cdr l)))))))))))
	(product '(1 2 3 0 4 5 6)))
      0)

(test (let ((lst '()))
	((call/cc
	  (lambda (goto)
	    (letrec ((start (lambda () (set! lst (cons "start" lst)) (goto next)))
		     (next  (lambda () (set! lst (cons "next" lst))  (goto last)))
		     (last  (lambda () (set! lst (cons "last" lst)) (reverse lst))))
	      start)))))
      '("start" "next" "last"))

(test (let ((cont #f)) ; Al Petrovsky
	(letrec ((x (call-with-current-continuation (lambda (c) (set! cont c) 0)))
		 (y (call-with-current-continuation (lambda (c) (set! cont c) 0))))
	  (if cont
	      (let ((c cont))
		(set! cont #f)
		(set! x 1)
		(set! y 1)
		(c 0))
	      (+ x y))))
      0)

(test (letrec ((x (call-with-current-continuation
		   (lambda (c)
		     (list #t c)))))
	(if (car x)
	    ((cadr x) (list #f (lambda () x)))
	    (eq? x ((cadr x)))))
      #t)

(test (call/cc (lambda (c) (0 (c 1)))) 1)

(test (let ((member (lambda (x ls)
		      (call/cc
		       (lambda (return)
			 (do ((ls ls (cdr ls)))
			     ((null? ls) #f)
			   (if (equal? x (car ls))
			       (return ls))))))))
	(list (member 'd '(a b c))
	      (member 'b '(a b c))))
      '(#f (b c)))


;;; call-with-exit
(test (+ 2 (call/cc (lambda (k) (* 5 (k 4))))) 6)
(test (+ 2 (call/cc (lambda (k) (* 5 (k 4 5 6))))) 17)
(test (+ 2 (call/cc (lambda (k) (* 5 (k (values 4 5 6)))))) 17)
(test (+ 2 (call/cc (lambda (k) (* 5 (k 1 (values 4 5 6)))))) 18)
(test (+ 2 (call/cc (lambda (k) (* 5 (k 1 (values 4 5 6) 1))))) 19)
(test (+ 2 (call-with-exit (lambda (k) (* 5 (k 4))))) 6)
(test (+ 2 (call-with-exit (lambda (k) (* 5 (k 4 5 6))))) 17)
(test (+ 2 (call-with-exit (lambda (k) (* 5 (k (values 4 5 6)))))) 17)
(test (+ 2 (call-with-exit (lambda (k) (* 5 (k 1 (values 4 5 6)))))) 18)
(test (+ 2 (call-with-exit (lambda (k) (* 5 (k 1 (values 4 5 6) 1))))) 19)
(test (+ 2 (call-with-exit (lambda* ((hi 1)) (hi 1)))) 3)
(test (call-with-exit (lambda (hi) (((hi 1)) #t))) 1) ; !! (jumps out of list evaluation)
(test (call-with-exit (lambda* args ((car args) 1))) 1)
(test ((call-with-exit (lambda (return) (return + 1 2 3)))) 6)
(test ((call-with-exit (lambda (return) (apply return (list + 1 2 3))))) 6)
(test ((call/cc (lambda (return) (return + 1 2 3)))) 6)
(test (+ 2 (call-with-exit (lambda (return) (let ((rtn (copy return))) (* 5 (rtn 4)))))) 6)

(test (+ 2 (values 3 (call-with-exit (lambda (k1) (k1 4))) 5)) 14)
(test (+ 2 (call-with-exit (lambda (k1) (values 3 (k1 4) 5))) 8) 14)
(test (+ 2 (call-with-exit (lambda (k1) (values 3 (k1 4 -3) 5))) 8) 11)

(test (call-with-exit (let () (lambda (k1) (k1 2)))) 2)
(test (+ 2 (call/cc (let () (call/cc (lambda (k1) (k1 (lambda (k2) (k2 3)))))))) 5)
(test (+ 2 (call/cc (call/cc (lambda (k1) (k1 (lambda (k2) (k2 3))))))) 5)
(test (call-with-exit (lambda arg ((car arg) 32))) 32)
(test (call-with-exit (lambda arg ((car arg) 32)) "oops!") 'error)
(test (call-with-exit (lambda (a b) a)) 'error)
(test (call-with-exit (lambda (return) (apply return '(3)))) 3)
(test (call-with-exit (lambda (return) (apply return (list  (cons 1 2))) (format #t "; call-with-exit: we shouldn't be here!"))) (cons 1 2))
(test (call/cc (lambda (return) (apply return (list  (cons 1 2))) (format #t "; call/cc: we shouldn't be here!"))) (cons 1 2))
(test (procedure? (call-with-exit (lambda (return) (call-with-exit return)))) #t)
(test (call-with-exit (lambda (return) #f) 1) 'error)
(test (+ (call-with-exit ((lambda () (lambda (k) (k 1 2 3)))))) 6)

(test (call-with-exit (lambda (a . b) (a 1))) 1)
(test (call/cc (lambda (a . b) (a 1))) 1) 
(test (call-with-exit (lambda* (a b) (a 1))) 1)

(test (call-with-exit (lambda (c) (0 (c 1)))) 1)
(test (call-with-exit (lambda (k) (k "foo"))) "foo")
(test (call-with-exit (lambda (k) "foo")) "foo")
(test (call-with-exit (lambda (k) (k "foo") "oops")) "foo")
(test (let ((memb (lambda (x ls)
		    (call-with-exit
		     (lambda (break)
		       (do ((ls ls (cdr ls)))
			   ((null? ls) #f)
			 (if (equal? x (car ls))
			     (break ls))))))))
	(list (memb 'd '(a b c))
	      (memb 'b '(a b c))))
      '(#f (b c)))

(let* ((sum 0)
       (val1 (call-with-exit 
	      (lambda (return)
		(set! sum (+ sum 1))
		(let ((val2 (call-with-exit 
			     (lambda (return)
			       (set! sum (+ sum 1))
			       (if #t (return sum))
			       123))))
		  (set! sum (+ sum val2))
		  (return sum)
		  32)))))
  (test (list val1 sum) '(4 4)))

(let ()
  (define c #f)
  (define (yow f)
    (call-with-exit
     (lambda (return)
       (set! c return)
       (f))))
  (test (yow (lambda () (c 32))) 32))

(let ((x 1))
  (define y (call-with-exit (lambda (return) (set! x (return 32)))))
  (test (and (= x 1) (= y 32)) #t)
  (set! y (call-with-exit (lambda (return) ((lambda (a b c) (set! x a)) 1 2 (return 33)))))
  (test (and (= x 1) (= y 33)) #t)
  (set! y (call-with-exit (lambda (return) ((lambda (a b) (return a) (set! x b)) 2 3))))
  (test (and (= x 1) (= y 2)) #t))

(test (let ((x 0))
	(define (quit z1) (z1 1) (set! x 1))
	(call-with-exit
	 (lambda (z)
	   (set! x 2)
	   (quit z)
	   (set! x 3)))
	x)
      2)

(test (let ((x (call/cc (lambda (k) k))))
	(x (lambda (y) "hi")))
      "hi")

(test (((call/cc (lambda (k) k)) (lambda (x) x)) "hi") "hi")

(test (let ((return #f)
	    (lst '()))
	(let ((val (+ 1 (call/cc 
			 (lambda (cont) 
			   (set! return cont) 
			   1)))))
	  (set! lst (cons val lst)))
	(if (= (length lst) 1)
	    (return 10)
	    (if (= (length lst) 2)
		(return 20)))
	(reverse lst))
      '(2 11 21))

(test (let ((r1 #f)
	    (r2 #f)
	    (lst '()))
	(define (somefunc x y)
	  (+ (* 2 (expt x 2)) (* 3 y) 1))
	(let ((val (somefunc (call/cc
			      (lambda (c1)
				(set! r1 c1)
				(c1 1)))
			     (call/cc
			      (lambda (c2)
				(set! r2 c2)
				(c2 1))))))
	  (set! lst (cons val lst)))
	(if (= (length lst) 1)
	    (r1 2)
	    (if (= (length lst) 2)
		(r2 3)))
	(reverse lst))
      '(6 12 18))

(let ((tree->generator
       (lambda (tree)
	 (let ((caller '*))
	   (letrec
	       ((generate-leaves
		 (lambda ()
		   (let loop ((tree tree))
		     (cond ((null? tree) 'skip)
			   ((pair? tree)
			    (loop (car tree))
			    (loop (cdr tree)))
			   (else
			    (call/cc
			     (lambda (rest-of-tree)
			       (set! generate-leaves
				     (lambda ()
				       (rest-of-tree 'resume)))
			       (caller tree))))))
		   (caller '()))))
	     (lambda ()
	       (call/cc
		(lambda (k)
		  (set! caller k)
		  (generate-leaves)))))))))
  (let ((same-fringe? 
	 (lambda (tree1 tree2)
	   (let ((gen1 (tree->generator tree1))
		 (gen2 (tree->generator tree2)))
	     (let loop ()
	       (let ((leaf1 (gen1))
		     (leaf2 (gen2)))
		 (if (eqv? leaf1 leaf2)
		     (if (null? leaf1) #t (loop))
		     #f)))))))
    
    (test (same-fringe? '(1 (2 3)) '((1 2) 3)) #t)
    (test (same-fringe? '(1 2 3) '(1 (3 2))) #f)))

(let ()
  (define (a-func)
    (call-with-exit
     (lambda (go)
       (lambda ()
	 (go + 32 1)))))

  (define (b-func)
    (call/cc
     (lambda (go)
       (lambda ()
	 (go + 32 1)))))

  (test ((a-func)) 'error) ;invalid-escape-function
  (test ((b-func)) 33))

(test ((call-with-exit
	(lambda (go)
	  (lambda ()
	    (eval-string "(go + 32 1)")))))
      'error)


;;; (test ((call/cc (lambda (go) (lambda () (eval-string "(go + 32 1)"))))) 33)
;;; this is ok in the listener, but exits the load in this context

(test ((call/cc
	(lambda (go-1)
	  (call/cc
	   (lambda (go)
	     (lambda ()
	       (go (go-1 + 32 1))))))))
      33)

(for-each
 (lambda (arg)
   (test (let ((ctr 0))
	   (let ((val (call/cc (lambda (exit)
				 (do ((i 0 (+ i 1)))
				     ((= i 10) 'gad)
				   (set! ctr (+ ctr 1))
				   (if (= i 1)
				       (exit arg)))))))
	     (and (equal? val arg)
		  (= ctr 2))))
	 #t))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (let ((ctr 0))
	   (let ((val (call/cc (lambda (exit)
				 (do ((i 0 (+ i 1)))
				     ((= i 10) arg)
				   (set! ctr (+ ctr 1))
				   (if (= i 11)
				       (exit 'gad)))))))
	     (and (equal? val arg)
		  (= ctr 10))))
	 #t))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (let ((c #f)
	    (r (string-copy "testing-hiho")))
	(let ((v (call/cc (lambda (c0) (set! c c0) (list #\a 0)))))
	  (let ((chr (car v))
		(index (cadr v)))
	    (string-set! r index chr)
	    (set! index (+ index 1))
	    (if (<= index 8) 
		(c (list (integer->char (+ 1 (char->integer chr))) index)) 
		r))))
      "abcdefghiiho")

(test (let ((x 0)
	    (again #f))
	(call/cc (lambda (r) (set! again r)))
	(set! x (+ x 1))
	(if (< x 3) (again))
	x)
      3)

(test (let* ((x 0)
	     (again #f)
	     (func (lambda (r) (set! again r))))
	(call/cc func)
	(set! x (+ x 1))
	(if (< x 3) (again))
	x)
      3)

(test (let* ((x 0)
	     (again #f))
	(call/cc (let ()
		   (lambda (r) (set! again r))))
	(set! x (+ x 1))
	(if (< x 3) (again))
	x)
      3)

(test (let ((x 0)
	    (xx 0))
	(let ((cont #f))
	  (call/cc (lambda (c) (set! xx x) (set! cont c)))
	  (set! x (+ x 1))
	  (if (< x 3)	(cont))
	  xx))
      0)

(test (call/cc procedure?) #t)
(test (procedure? (call/cc (lambda (a) a))) #t)

(for-each
 (lambda (arg)
   (test (call/cc (lambda (a) arg)) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(let ((a (call/cc (lambda (a) a))))
  (test (eq? a a) #t)
  (test (eqv? a a) #t)
  (test (equal? a a) #t)
  (for-each
   (lambda (ques)
     (if (ques a)
	 (format #t ";(~A ~A) returned #t?~%" ques a)))
   question-ops))

(test (let ((conts (make-vector 4 #f)))
	(let ((lst '()))
	  (set! lst (cons (+ (call/cc (lambda (a) (vector-set! conts 0 a) 0))
			     (call/cc (lambda (a) (vector-set! conts 1 a) 0))
			     (call/cc (lambda (a) (vector-set! conts 2 a) 0))
			     (call/cc (lambda (a) (vector-set! conts 3 a) 0)))
			  lst))
	  (let ((len (length lst)))
	    (if (< len 4)
		((vector-ref conts (- len 1)) (+ len 1))
		(reverse lst)))))
      '(0 2 5 9))

(test (let ((conts '()))
	(let ((lst '()))
	  (set! lst (cons (+ (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) 1))
			     (* (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) 1))
				(+ (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) 1))
				   (* (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) 1)) 2))))
			  lst))
	  (let ((len (length lst)))
	    (if (<= len 4)
		((list-ref conts (- len 1)) (+ len 1))
		(reverse lst)))))
					; (+ 1 (* 1 (+ 1 (* 1 2)))) to start
					; (+ 1 ...          2     )
					; (+ 1 ...     3    [1]   )
					; (+ 1 ...4    [1]        )
					; (+ 5   [1]              )
      '(4 6 6 13 8))

(test (let ((conts (make-vector 4 #f)))
	(let ((lst '()))
	  (set! lst (cons (+ (call/cc (lambda (a) (if (not (vector-ref conts 0)) (vector-set! conts 0 a)) 0))
			     (call/cc (lambda (a) (if (not (vector-ref conts 1)) (vector-set! conts 1 a)) 0))
			     (call/cc (lambda (a) (if (not (vector-ref conts 2)) (vector-set! conts 2 a)) 0))
			     (call/cc (lambda (a) (if (not (vector-ref conts 3)) (vector-set! conts 3 a)) 0)))
			  lst))
	  (let ((len (length lst)))
	    (if (< len 4)
		((vector-ref conts (- len 1)) (+ len 1))
		(reverse lst)))))
      '(0 2 3 4))

(test (let ((conts '()))
	(let ((lst '()))
	  (set! lst (cons (+ (if (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) #f)) 1 0)
			     (* (if (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) #f)) 2 1)
				(+ (if (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) #f)) 1 0)
				   (* (if (call/cc (lambda (a) (if (< (length conts) 4) (set! conts (cons a conts))) #f)) 2 1) 2))))
			  lst))
	  (let ((len (length lst)))
	    (if (<= len 4)
		((list-ref conts (- len 1)) #t)
		(reverse lst)))))
					; (+ 0 (* 1 (+ 0 (* 1 2)))) to start
					; (+ 0 ...          2     )
					; (+ 0 ...     1   [1]    )
					; (+ 0 ...2   [0]         )
					; (+ 1   [1]              )
      '(2 4 3 4 3))

(test (let ((call/cc 2)) (+ call/cc 1)) 3)
(test (+ 1 (call/cc (lambda (r) (r 2 3 4))) 5) 15)
(test (string-ref (call/cc (lambda (s) (s "hiho" 1)))) #\i)

(let ((r5rs-ratify (lambda (ux err)
		     (if (= ux 0.0) 
			 0
			 (let ((tt 1) 
			       (a1 0) 
			       (b2 0) 
			       (a2 1) 
			       (b1 1) 
			       (a 0)  
			       (b 0)
			       (ctr 0)
			       (x (/ 1 ux)))
			   (call-with-current-continuation
			    (lambda (return)
			      (do ()
				  (#f)
				(set! a (+ (* a1 tt) a2)) 
				(set! b (+ (* tt b1) b2))
					;(format #t "~A ~A~%" a (- b a))
				(if (or (<= (abs (- ux (/ a b))) err)
					(> ctr 1000))
				    (return (/ a b)))
				(set! ctr (+ 1 ctr))
				(if (= x tt) (return))
				(set! x (/ 1 (- x tt))) 
				(set! tt (floor x))
				(set! a2 a1) 
				(set! b2 b1) 
				(set! a1 a) 
				(set! b1 b)))))))))
  
  (test (r5rs-ratify (/ (log 2.0) (log 3.0)) 1/10000000) 665/1054)
  (if (positive? 2147483648)
      (test (r5rs-ratify (/ (log 2.0) (log 3.0)) 1/100000000000) 190537/301994)))

#|
(let ((max-diff 0.0)
      (max-case 0.0)
      (err 0.01)
      (epsilon 1e-16))
  (do ((i 1 (+ i 1))) 
      ((= i 100)) 
    (let ((x (/ i 100.)))
      (let ((vals (cr x err))) 
	(if (not (= (car vals) (cadr vals))) 
	    (let ((r1 (car vals))
		  (r2 (cadr vals)))
	      (let ((diff (abs (- r1 r2))))
		(if (> diff max-diff)
		    (begin
		      (set! max-diff diff)
		      (set! max-case x))))
	      (if (> (abs (- r1 x)) (+ err epsilon))
		(format #t "(rationalize ~A ~A) is off: ~A -> ~A~%" x err r1 (abs (- r1 x))))
	      (if (> (abs (- r2 x)) (+ err epsilon))
		(format #t "(ratify ~A ~A) is off: ~A -> ~A~%" x err r2 (abs (- r2 x))))
	      (if (< (denominator r2) (denominator r1))
		  (format #t "(ratify ~A ~A) is simpler? ~A ~A~%" x err r1 r2)))))))
  (list max-case max-diff (cr max-case err)))
|#

(for-each
 (lambda (arg)
   (test (let ((ctr 0)) 
	   (let ((val (call/cc 
		       (lambda (exit) 
			 (for-each (lambda (a) 
				     (if (equal? a arg) (exit arg))
				     (set! ctr (+ ctr 1))) 
				   (list 0 1 2 3 arg 5)))))) 
	     (list ctr val)))
	 (list 4 arg)))
 (list "hi" -1 #\a 11 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t '(1 . 2)))

(test (+ 2 (call/cc (lambda (rtn) (+ 1 (let () (begin (define x (+ 1 (rtn 3)))) x))))) 5)


;;; others from stackoverflow.com Paul Hollingsworth etc:

(test (procedure? (call/cc (lambda (k) k))) #t)
(test (call/cc (lambda (k) (+ 56 (k 3)))) 3)
(test (apply
       (lambda (k i) 
	 (if (> i 5) 
	     i 
	     (k (list k (* 2 i)))))
       (call/cc (lambda (k) (list k 1))))
      8)
(test (apply
       (lambda (k i n) (if (= i 0) n (k (list k (- i 1) (* i n)))))
       (call/cc (lambda (k) (list k 6 1))))
      720)
(test (let* ((ka (call/cc (lambda (k) `(,k 1)))) (k (car ka)) (a (cadr ka)))
	(if (< a 5) (k `(,k ,(* 2 a))) a))
      8)

(test (apply (lambda (k i n) (if (eq? i 0) n (k (list k (- i 1) (* i n))))) (call/cc (lambda (k) (list k 6 1)))) 720)
(test ((call/cc (lambda (k) k)) (lambda (x) 5)) 5)

(let ()
  (define (generate-one-element-at-a-time a-list)
    (define (generator)
      (call/cc control-state)) 
    (define (control-state return)
      (for-each 
       (lambda (an-element-from-a-list)
	 (set! return
	       (call/cc
		(lambda (resume-here)
		  (set! control-state resume-here)
		  (return an-element-from-a-list)))))
       a-list)
      (return 'you-fell-off-the-end-of-the-list))
    generator)
  (let ((gen (generate-one-element-at-a-time (list 3 2 1))))
    (test (gen) 3)
    (test (gen) 2)
    (test (gen) 1)
    (test (gen) 'you-fell-off-the-end-of-the-list)))

;;; from Ferguson and Duego "call with current continuation patterns"
(test (let ()
	(define count-to-n
	  (lambda (n)
	    (let ((receiver 
		   (lambda (exit-procedure)
		     (let ((count 0))
		       (letrec ((infinite-loop
				 (lambda ()
				   (if (= count n)
				       (exit-procedure count)
				       (begin
					 (set! count (+ count 1))
					 (infinite-loop))))))
			 (infinite-loop))))))
	      (call/cc receiver))))
	(count-to-n 10))
      10)

(test (let ()
	(define product-list
	  (lambda (nums)
	    (let ((receiver
		   (lambda (exit-on-zero)
		     (letrec ((product
			       (lambda (nums)
				 (cond ((null? nums) 1)
				       ((zero? (car nums)) (exit-on-zero 0))
				       (else (* (car nums)
						(product (cdr nums))))))))
		       (product nums)))))
	      (call/cc receiver))))
	(product-list '(1 2 3 0 4 5)))
      0)

(begin
  (define fact
    ((lambda (f)
       ((lambda (u) (u (lambda (x)
			 (lambda (n) ((f (u x)) n)))))
	(call/cc (call/cc (call/cc 
			   (call/cc (call/cc (lambda (x) x))))))))
     (lambda (f) (lambda (n)
		   (if (<= n 0) 1 (* n (f (- n 1))))))))
  (test (map fact '(5 6 7)) '(120 720 5040)))

;; http://okmij.org/ftp/Scheme/callcc-calc-page.html

(test (let ()
	(define product-list
	  (lambda (nums)
	    (let ((receiver
		   (lambda (exit-on-zero)
		     (letrec ((product
			       (lambda (nums) 
				 (cond ((null? nums) 1)
				       ((number? (car nums))
					(if (zero? (car nums))
					    (exit-on-zero 0)
					    (* (car nums)
					       (product (cdr nums)))))
				       (else (* (product (car nums))
						(product (cdr nums))))))))
		       (product nums)))))
	      (call/cc receiver))))
	(product-list '(1 2 (3 4) ((5)))))
      120)

(test (call/cc (lambda () 0)) 'error)
(test (call/cc (lambda (a) 0) 123) 'error)
(test (call/cc) 'error)
(test (call/cc abs) 'error)
(for-each
 (lambda (arg)
   (test (call-with-exit arg) 'error)
   (test (call-with-current-continuation arg) 'error)
   (test (call/cc arg) 'error))
 (list "hi" -1 '() #(1 2) _ht_ #\a 1 'a-symbol 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test (call/cc . 1) 'error)
(test (call/cc abs) 'error)
(test (+ 1 (call/cc (lambda (r1) (call/cc (lambda (r2) (r1 2 3))))) 4) 10)
(test (+ 1 (call/cc (lambda (r1) (+ 5 (call/cc (lambda (r2) (r2 2 3)))))) 4) 15)


#|
;;; from bug-guile
(define k #f)
(define result #f)
(define results '())
(set! result (map (lambda (x)
                    (if x x (call/cc (lambda (c)
                                       (set! k c)
                                       1))))
                  '(#t #f)))
(set! results (cons result results))
(write results)
(newline)
(if (< (cadr result) 5)
    (k (+ 1 (cadr result))))
(newline)

the claim is that this should return 

((#t 1))
((#t 2) (#t 1))
((#t 3) (#t 2) (#t 1))
((#t 4) (#t 3) (#t 2) (#t 1))
((#t 5) (#t 4) (#t 3) (#t 2) (#t 1))

but I think that depends on how we interpret the sequence of top-level statements.
The test should be written:

(let* ((k #f)
       (results '()))
  (let ((result (map (lambda (x)
		       (if x x (call/cc (lambda (c)
					  (set! k c)
					  1))))
		     '(#t #f))))
    (set! results (cons result results))
    (write results)
    (newline)
    (if (< (cadr result) 5)
	(k (+ 1 (cadr result))))
    (newline)))

and then s7 is not following r6rs because it stops at 

((#t 1))
((1 . #1=(#t 2)) #1#)

saying cadr is not a number. I don't think this example is correct in any case --
who says the continuation has to restart the map from the top?
|#

(let ((cont #f))
  (let ((x (* (call/cc
	       (lambda (return)
		 (set! cont return)
		 (return 3 4))))))
    (if (= x 12)
	(cont 5 6 7))
    (test x 210)))

;; Guile handles this very differently


(test (let ((cont #f)) (call-with-exit (lambda (return) (set! cont return))) (cont 1)) 'error)
(test (let ((cont #f)) (call-with-exit (lambda (return) (set! cont return))) (apply cont)) 'error)
(test (let ((cont #f)) (call-with-exit (lambda (return) (set! cont return) (cont 1))) (apply cont)) 'error)
(test (let ((cont #f)) (call-with-exit (lambda (return) (set! cont return) (cont 1))) (cont 1)) 'error)
(test (procedure? (call-with-exit append)) #t)
(test (procedure? (call-with-exit values)) #t)
(test (procedure? (car (call-with-exit list))) #t)
(test (call-with-exit (call-with-exit append)) 'error)
(test (continuation? (call/cc (call/cc append))) #t)
(test (procedure? (call-with-exit call-with-exit)) #t)
(test (vector? (call-with-exit vector)) #t)
(test (call-with-exit ((lambda args procedure?))) #t)
(test (call-with-exit (let ((x 3)) (define (return y) (y x)) return)) 3)

(test (let ((c1 #f)) (call-with-exit (lambda (c2) (call-with-exit (lambda (c3) (set! c1 c3) (c2))))) (c1)) 'error)
(test (let ((c1 #f)) (call/cc (lambda (c2) (call-with-exit (lambda (c3) (set! c1 c3) (c2))))) (c1)) 'error)
(test (let ((cont #f)) (catch #t (lambda () (call-with-exit (lambda (return) (set! cont return) (error 'testing " a test")))) (lambda args 'error)) (apply cont)) 'error)
(test (let ((cont #f)) (catch #t (lambda () (call-with-exit (lambda (return) (set! cont return) (error 'testing " a test")))) (lambda args 'error)) (cont 1)) 'error)
(test (let ((e (call-with-exit (lambda (go) (lambda () (go 1)))))) (e)) 'error)

(test (let ((cc #f)
	    (doit #t)
	    (ctr 0))
	(let ((ok (call-with-exit
		   (lambda (c3)
		     (call/cc (lambda (ret) (set! cc ret)))
		     (c3 (let ((res doit)) (set! ctr (+ ctr 1)) (set! doit #f) res))))))
	  (if ok (cc)))
	ctr)
      2)

(test (let ((val (call-with-exit (lambda (ret) (let ((ret1 ret)) (ret1 2) 3))))) val) 2)
(test (call-with-exit (lambda (return) (sort! '(3 2 1) return))) 'error)

;;; this one from Rick
(test (eval '(call/cc (lambda (go) (go 9) 0))) 9)
(test (eval-string "(call/cc (lambda (go) (go 9) 0))") 9)
(test (call-with-exit (lambda (return) (call/cc (lambda (go) (go 9) 0)) (return 1) 2)) 1)

(num-test (/ 1 (call/cc (lambda (go) (go 9) 0))) 1/9)

(test (call/cc (lambda (g) (call/cc (lambda (f) (f 1)) (g 2)))) 2) ; !! guile agrees! (evaluating the extraneous arg jumps)
(test (call/cc (lambda (g) (abs -1 (g 2)))) 2)                     ; perhaps this should be an error
(test (call/cc (lambda (g) (if #t #f #f (g 2)))) 'error)

(test ((call-with-exit (lambda (go) (go go))) eval) 'error)
(test ((call/cc (lambda (go) (go go))) eval) eval)
(test (call-with-exit quasiquote) 'error)

(test (call-with-exit (lambda (go) (if (go 1) (go 2) (go 3)))) 1)
(test (call-with-exit (lambda (go) (set! (go 1) 2))) 'error) 
(test (call-with-exit (lambda (go) (let ((x 1) (y (go x))) #f))) 'error)
(test (call-with-exit (lambda (go) (let* ((x 1) (y (go x))) #f))) 1)
(test (call-with-exit (lambda (go) (letrec ((x 1) (y (go x))) #f))) #<undefined>)
(test (call-with-exit (lambda (go) (letrec* ((x 1) (y (go x))) #f))) 1)
(test (call-with-exit (lambda (go) (case (go 1) ((go 2) 3) (else 4)))) 1)
(test (call-with-exit (lambda (go) (case go ((go 2) 3) (else 4)))) 4)
(test (call-with-exit (lambda (go) (case 2 ((go 2) 3) (else 4)))) 3)
(test (call-with-exit (lambda (go) (eq? go go))) #t)
(test (call-with-exit (lambda (go) (case 'go ((go 2) 3) (else 4)))) 3)
(test (call-with-exit (lambda (go) (go (go (go 1))))) 1)
(test (call-with-exit (lambda (go) (quasiquote (go 1)))) '(go 1))

;; these tests were messed up -- I forgot the outer parens
(test (call-with-exit (lambda (go) ((lambda* ((a (go 1))) a) (go 2) 3))) 2)
(test (call-with-exit (lambda (go) ((lambda* ((a (go 1))) a)))) 1)

(test (call-with-exit (lambda (go) ((lambda (go) go) 1))) 1)
(test (call-with-exit (lambda (go) (quote (go 1)) 2)) 2)
(test (call-with-exit (lambda (go) (and (go 1) #f))) 1)
(test (call-with-exit (lambda (go) (dynamic-wind (lambda () (go 1) 11) (lambda () (go 2) 12) (lambda () (go 3) 13)))) 1)

(test (eval '(call/cc (lambda (go) (if (go 1) (go 2) (go 3))))) 1)
(test (eval '(call/cc (lambda (go) (set! (go 1) 2)))) 'error) 
(test (eval '(call/cc (lambda (go) (let ((x 1) (y (go x))) #f)))) 'error)
(test (eval '(call/cc (lambda (go) (let* ((x 1) (y (go x))) #f)))) 1)
(test (eval '(call/cc (lambda (go) (letrec ((x 1) (y (go x))) #f)))) #<undefined>)
(test (eval '(call/cc (lambda (go) (letrec* ((x 1) (y (go x))) #f)))) 1)
(test (eval '(call/cc (lambda (go) (case (go 1) ((go 2) 3) (else 4))))) 1)
(test (eval '(call/cc (lambda (go) (case go ((go 2) 3) (else 4))))) 4)
(test (eval '(call/cc (lambda (go) (case 2 ((go 2) 3) (else 4))))) 3)
(test (eval '(call/cc (lambda (go) (eq? go go)))) #t)
(test (eval '(call/cc (lambda (go) (case 'go ((go 2) 3) (else 4))))) 3)
(test (eval '(call/cc (lambda (go) (go (go (go 1)))))) 1)
(test (eval '(call/cc (lambda (go) (quasiquote (go 1))))) '(go 1))
(test (eval '(call/cc (lambda (go) ((lambda* (a (go 1)) a) (go 2))))) 2)
(test (eval '(call/cc (lambda (go) ((lambda* (a (go 1)) a) 2)))) 2)
(test (eval '(call/cc (lambda (go) ((lambda* (a (go 1)) a))))) #f)
(test (eval '(call/cc (lambda (go) ((lambda (go) go) 1)))) 1)
(test (eval '(call/cc (lambda (go) (quote (go 1)) 2))) 2)
(test (eval '(call/cc (lambda (go) (and (go 1) #f)))) 1)
(test (eval '(call/cc (lambda (go) (dynamic-wind (lambda () (go 1) 11) (lambda () (go 2) 12) (lambda () (go 3) 13))))) 1)

(test (call-with-exit (lambda (go) (eval '(go 1)) 2)) 1) 
(test (call-with-exit (lambda (go) (eval-string "(go 1)") 2)) 1)
(test (call-with-exit (lambda (go) `(,(go 1) 2))) 1)
;;; (test (call-with-exit (lambda (go) `#(,(go 1) 2))) 'error) ; this is s7's choice -- read time #(...)
(test (call-with-exit (lambda (go) (case 0 ((0) (go 1) (go 2))))) 1)
(test (call-with-exit (lambda (go) (cond (1 => go)) 2)) 1)
(test (call-with-exit (lambda (go) (((cond ((go 1) => go)) 2)))) 1)
(test (call-with-exit (lambda (go) (cond (1 => (go 2))))) 2)

(test (call-with-exit (lambda (go) (go (eval '(go 1))) 2)) 1)
(test (+ 10 (call-with-exit (lambda (go) (go (eval '(go 1))) 2))) 11)
(test (call-with-exit (lambda (go) (go (eval-string "(go 1)")) 2)) 1)
(test (call-with-exit (lambda (go) (eval-string "(go 1)") 2)) 1) 
(test (call-with-exit (lambda (go) ((eval 'go) 1) 2)) 1)  
(test (eval-string "(call/cc (lambda (go) (if (go 1) (go 2) (go 3))))") 1)
(test (call-with-exit (lambda (quit) ((lambda* ((a (quit 32))) a)))) 32)
(test ((call-with-exit (lambda (go) (go quasiquote))) go) 'go)

(test (let ((c #f))
	(let ((val -1))
	  (set! val (call/cc 
		     (lambda (c1)
		       (call-with-exit 
			(lambda (c2)
			  (call-with-exit 
			   (lambda (c3)
			     (call/cc 
			      (lambda (c4)
				(set! c c4)
				(c1 (c2 0)))))))))))
	  (if (= val 0) (c 5))
	  val))
      5)

(let ()
  (define-macro (while test . body)
    `(call-with-exit 
      (lambda (break) 
	(letrec ((continue (lambda () 
			     (if (let () ,test)
				 (begin 
				   (let () ,@body)
				   (continue))
				 (break)))))
	  (continue)))))
  (test (let ((i 0)
	      (sum 0)
	      (break 32)
	      (continue 48))
	  (while (begin 
		   (define break 10)
		   (define continue 0) 
		   (< i (+ break continue)))
		 (set! sum (+ sum 1))
		 (set! i (+ i 1))
		 (if (< i 5) (continue))
		 (set! sum (+ sum 10))
		 (if (> i 7) (break))
		 (set! sum (+ sum 100)))
	  sum)
	348))

;;; (define-macro (while test . body) `(do () ((not ,test)) ,@body)) ?


;;; with-baffle

(test (with-baffle
       (let ((x 0)
	     (c1 #f)
	     (results '()))
	 (set! x (call/cc
		  (lambda (r1)
		    (set! c1 r1)
		    (r1 2))))
	 (set! results (cons x results))
	 (if (= x 2) (c1 32))
	 results))
      '(32 2))

(test (let ((x 0)
	    (c1 #f)
	    (results '()))
	(with-baffle
	 (set! x (call/cc
		  (lambda (r1)
		    (set! c1 r1)
		    (r1 2))))
	 (set! results (cons x results)))
	(if (= x 2) (c1 32))
	results)
      'error)

(test (let ((what's-for-breakfast '())
	    (bad-dog 'fido))        ; bad-dog will try to sneak in
	(with-baffle               ; the syntax is (with-baffle . body)         
	 (set! what's-for-breakfast
	       (call/cc
		(lambda (biscuit?)
		  (set! bad-dog biscuit?) ; bad-dog smells a biscuit!
		  (biscuit? 'biscuit!)))))
	(if (eq? what's-for-breakfast 'biscuit!) 
	    (bad-dog 'biscuit!))  ; now, outside the baffled block, bad-dog tries to sneak back in
	results)                   ;   but s7 says "No!": baffled! ("continuation can't jump across with-baffle")
      'error)
