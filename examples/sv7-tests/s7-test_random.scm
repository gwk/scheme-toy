(let ((v (lambda (n range chker) ; chi^2 or mus-random
	   (let ((hits (make-vector 100 0)))
	     (do ((i 0 (+ 1 i )))
		 ((= i n))
	       (let ((y (random range)))
		 (if (not (chker y))
		     (format #t ";(random ~A) -> ~A?~%" range y))
		 (let ((iy (min 99 (floor (* 100 (/ y range))))))
		   (vector-set! hits iy (+ 1 (vector-ref hits iy))))))
	     (let ((sum 0.0)
		   (p (/ n 100.0)))
	       (do ((i 0 (+ 1 i)))
		   ((= i 100) sum)
		 (let ((num (- (vector-ref hits i) p)))
		   (set! sum (+ sum (/ (* num num) p))))))))))
  
  (num-test (random 0) 0)
  (num-test (random 0.0) 0.0)
  
(let ()
  (define (rtest) (- (random 2.0) 1.0))
  (do ((i 0 (+ i 1)))
      ((= i 100))
    (let ((val (rtest)))
      (if (or (> val 1.0)
	      (< val -1.0))
	  (format #t "(- (random 2.0) 1.0): ~A~%" i val)))))

  (let ((vr (v 1000 
	       1.0
	       (lambda (val)
		 (and (real? val)
		      (not (negative? val))
		      (<= val 1.0))))))
    (if (or (< vr 40)
	    (> vr 400))
	(format #t ";(random 1.0) not so random? ~A~%" vr)))
  
  (let ((vr (v 1000 
	       100
	       (lambda (val)
		 (and (integer? val)
		      (not (negative? val))
		      (<= val 100))))))
    (if (or (< vr 40)
	    (> vr 400))
	(format #t ";(random 100) not so random? ~A~%" vr)))
  
  (let ((vr (v 1000 
	       1/2
	       (lambda (val)
		 (and (rational? val)
		      (not (negative? val))
		      (<= val 1/2))))))
    (if (or (< vr 40)
	    (> vr 400))
	(format #t ";(random 1/2) not so random? ~A~%" vr)))
  
  (let ((vr (v 1000 
	       -10.0
	       (lambda (val)
		 (and (real? val)
		      (not (positive? val))
		      (>= val -10.0))))))
    (if (or (< vr 40)
	    (> vr 400))
	(format #t ";(random -10.0) not so random? ~A~%" vr)))
  
  (let ((imax 0.0)
	(rmax 0.0)
	(imin 100.0)
	(rmin 100.0))
    (do ((i 0 (+ i 1)))
	((= i 100))
      (let ((val (random 1+i)))
	(set! imax (max imax (imag-part val)))
	(set! imin (min imin (imag-part val)))
	(set! rmax (max rmax (real-part val)))
	(set! rmin (min rmin (real-part val)))))
    (if (or (> imax 1.0)
	    (< imin 0.0)
	    (> rmax 1.0)
	    (< rmin 0.0)
	    (< rmax 0.001)
	    (< imax 0.001))
	(format #t ";(random 1+i): ~A ~A ~A ~A~%" rmin rmax imin imax)))
	
  (let ((imax 0.0)
	(rmax 0.0)
	(imin 100.0)
	(rmin 100.0))
    (do ((i 0 (+ i 1)))
	((= i 100))
      (let ((val (random 0+i)))
	(set! imax (max imax (imag-part val)))
	(set! imin (min imin (imag-part val)))
	(set! rmax (max rmax (real-part val)))
	(set! rmin (min rmin (real-part val)))))
    (if (or (> imax 1.0)
	    (< imin 0.0)
	    (> rmax 0.0)
	    (< rmin 0.0)
	    (< imax 0.001))
	(format #t ";(random 0+i): ~A ~A ~A ~A~%" rmin rmax imin imax)))
	
  (let ((imax 0.0)
	(rmax 0.0)
	(imin 100.0)
	(rmin 100.0))
    (do ((i 0 (+ i 1)))
	((= i 100))
      (let ((val (random 10.0+100.0i)))
	(set! imax (max imax (imag-part val)))
	(set! imin (min imin (imag-part val)))
	(set! rmax (max rmax (real-part val)))
	(set! rmin (min rmin (real-part val)))))
    (if (or (> imax 100.0)
	    (< imin 0.0)
	    (> rmax 10.0)
	    (< rmin 0.0)
	    (< imax 0.1)
	    (< rmax 0.01))
	(format #t ";(random 100+10i): ~A ~A ~A ~A~%" rmin rmax imin imax)))
	
  
  (do ((i 0 (+ i 1)))
      ((= i 100))
    (let ((val (random 1.0+1.0i)))
      (if (or (not (complex? val))
	      (> (real-part val) 1.0)
	      (> (imag-part val) 1.0)
	      (< (real-part val) 0.0))
	  (format #t ";(random 1.0+1.0i) -> ~A?~%" val))))
  
  (let ((rs (make-random-state 12345678)))
    (do ((i 0 (+ i 1)))
	((= i 100))
      (let ((val (random 1.0 rs)))
	(if (or (not (real? val))
		(negative? val)
		(> val 1.0))
	    (format #t ";(random 1.0 rs) -> ~A?~%" val)))))
  
  (if with-bignums
      (begin
	(num-test (random (bignum "0")) 0)
	(num-test (random (bignum "0.0")) 0.0)
	
	(let ((vr (v 1000 
		     (bignum "1.0")
		     (lambda (val)
		       (and (real? val)
			    (not (negative? val))
			    (<= val 1.0))))))
	  (if (or (< vr 40)
		  (> vr 400))
	      (format #t ";(big-random 1.0) not so random? ~A~%" vr)))
	
	(let ((vr (v 1000 
		     (bignum "100")
		     (lambda (val)
		       (and (integer? val)
			    (not (negative? val))
			    (<= val 100))))))
	  (if (or (< vr 40)
		  (> vr 400))
	      (format #t ";(big-random 100) not so random? ~A~%" vr)))
	
	(let ((vr (v 1000 
		     (bignum "1/2")
		     (lambda (val)
		       (and (rational? val)
			    (not (negative? val))
			    (<= val 1/2))))))
	  (if (or (< vr 40)
		  (> vr 400))
	      (format #t ";(big-random 1/2) not so random? ~A~%" vr)))
	
	(let ((vr (v 1000 
		     (bignum "-10.0")
		     (lambda (val)
		       (and (real? val)
			    (not (positive? val))
			    (>= val -10.0))))))
	  (if (or (< vr 40)
		  (> vr 400))
	      (format #t ";(big-random -10.0) not so random? ~A~%" vr)))
	
	(do ((i 0 (+ i 1)))
	    ((= i 100))
	  (let ((val (random (bignum "1.0+1.0i"))))
	    (if (or (not (complex? val))
		    (> (real-part val) 1.0)
		    (> (imag-part val) 1.0)
		    (< (real-part val) 0.0))
		(format #t ";(big-random 1.0+1.0i) -> ~A?~%" val))))
	
	(let ((rs (make-random-state (bignum "12345678"))))
	  (do ((i 0 (+ i 1)))
	      ((= i 100))
	    (let ((val (random (bignum "1.0") rs)))
	      (if (or (not (real? val))
		      (negative? val)
		      (> val 1.0))
		  (format #t ";(big-random 1.0 rs) -> ~A?~%" val)))
	    (let ((val (random 1.0 rs)))
	      (if (or (not (real? val))
		      (negative? val)
		      (> val 1.0))
		  (format #t ";(big-random small-1.0 rs) -> ~A?~%" val)))))
	
	(let ((rs (make-random-state 1234)))
	  (do ((i 0 (+ i 1)))
	      ((= i 100))
	    (let ((val (random (bignum "1.0") rs)))
	      (if (or (not (real? val))
		      (negative? val)
		      (> val 1.0))
		  (format #t ";(big-random 1.0 small-rs) -> ~A?~%" val)))
	    (let ((val (random 1.0 rs)))
	      (if (or (not (real? val))
		      (negative? val)
		      (> val 1.0))
		  (format #t ";(random small-1.0 rs) -> ~A?~%" val)))))
	))
  )

(test (random 0 #t) 'error)
(test (random 0.0 #(1 2)) 'error)
(test (nan? (random 1/0)) #t)
(test (zero? (random 1e-30)) #f)

(test ((object->string (make-random-state 1234)) 1) #\<)
(test (make-random-state 1.0) 'error)
(test (make-random-state 1+i) 'error)
(test (make-random-state 3/4) 'error)
(test (make-random-state 1/0) 'error)
(test (make-random-state (real-part (log 0))) 'error)
(test (random-state? (make-random-state 100)) #t)
(test (random-state?) 'error)
(test (random-state? (make-random-state 100) 100) 'error)

(let ((r1 (make-random-state 100))
      (r2 (make-random-state 100))
      (r3 (make-random-state 200)))
  (test (random-state? r3) #t)
  (test (equal? r1 r2) #t)
  (test (equal? r1 r3) #f)
  (random 1.0 r1)
  (test (equal? r1 r2) #f)
  (random 1.0 r2)
  (test (equal? r1 r2) #t)
  (test (equal? (copy r1) r1) #t)
  (test (random-state? r2) #t)
  (test (random-state? (copy r1)) #t))

(for-each
 (lambda (arg)
   (test (random arg) 'error)
   (test (random 1.0 arg) 'error)
   (test (make-random-state arg) 'error)
   (test (random-state->list arg) 'error)
   (test (random-state? arg) #f)
   )
 (list "hi" _ht_ '() '(1 2) #f (integer->char 65) 'a-symbol (make-vector 3) abs #\f (lambda (a) (+ a 1)) (if #f #f) :hi #<eof> #<undefined>))

(let ((r1 (make-random-state 1234))
      (r2 (make-random-state 1234)))
  (test (eq? r1 r2) #f)
  (test (equal? r1 r2) #t)
  (test (eq? r2 r2) #t)
  (test (equal? r1 r1) #t)
  (test ((object->string r1) 1) #\<)
  (let ((val1 (random 10000000 r1))
	(val2 (random 10000000 r2)))
    (test val1 val2)))

(let ((r1 (make-random-state 1234))
      (r2 (make-random-state 1234567)))
  (let ((val1 (random 10000000 r1))
	(val2 (random 10000000 r2)))
    (let ((val3 (random 10000000 r1))
	  (val4 (random 10000000 r2)))
      (let ((val5 (random 10000000 r1))
	    (val6 (random 10000000 r2)))
	(test (or (not (= val1 val2))
		  (not (= val3 val4))
		  (not (= val5 val6)))
	      #t)))))

(let ((r1 (make-vector 10)))
  (let* ((rs1 (make-random-state 12345))
	 (rs2 (copy rs1))
	 (rs3 (apply make-random-state (random-state->list rs1)))
	 (rs4 #f)
	 (rs5 #f))
    (do ((i 0 (+ i 1)))
	((= i 10))
      (set! (r1 i) (random 1.0 rs1))
      (if (= i 3) 
	  (set! rs4 (copy rs1)))
      (if (= i 5)
	  (set! rs5 (apply make-random-state (random-state->list rs1)))))
    (do ((i 0 (+ i 1)))
	((= i 10))
      (let ((v1 (random 1.0 rs2))
	    (v2 (random 1.0 rs3)))
	(if (not (= v1 v2 (r1 i)))
	    (format #t ";random v1: ~A, v2: ~A, r1[~A]: ~A~%" v1 v2 i (r1 i))))
      (if (> i 3)
	  (let ((v3 (random 1.0 rs4)))
	    (if (not (= v3 (r1 i)))
		(format #t ";random v3: ~A, r1[~A]: ~A~%" v3 i (r1 i)))))
      (if (> i 5)
	  (let ((v4 (random 1.0 rs5)))
	    (if (not (= v4 (r1 i)))
		(format #t ";random v4: ~A, r1[~A]: ~A~%" v4 i (r1 i))))))))

(do ((i 0 (+ i 1)))
    ((= i 20))              ; this was ((+ i 100)) !! -- surely a warning would be in order?
  (let ((val (random -1.0)))
    (test (and (real? val) (<= val 0.0) (>= val -1.0)) #t))
  (let ((val (random -100)))
    (test (and (integer? val) (<= val 0) (>= val -100)) #t))
  (let ((val (random most-negative-fixnum)))
    (test (and (integer? val) (<= val 0)) #t))
  (let ((val (random most-positive-fixnum)))
    (test (and (integer? val) (>= val 0)) #t))
  (let ((val (random pi)))
    (test (and (real? val) (>= val 0) (< val pi)) #t))
  (let ((val (random 3/4)))
    (test (and (rational? val) (>= val 0) (< val 3/4)) #t))
  (test (let ((x (random most-positive-fixnum))) (integer? x)) #t)
  (if with-bignums
      (begin
	(let ((val (random (expt 2 70))))
	  (test (and (integer? val) (>= val 0)) #t))
	(let ((val (random 1180591620717411303424.0)))
	  (test (and (real? val) (>= val 0.0)) #t)))))
  
(if with-bignums
    (begin
      (let ((r1 (make-random-state (expt 2 70))))
	(test (random-state? r1) #t)
	(test ((object->string r1) 1) #\<)
	(test (eq? r1 r1) #t)
	(test (equal? r1 r1) #t)
	(let ((val1 (random 10000000 r1))
	      (val2 (random 10000000 r1)))
	  (test (not (= val1 val2)) #t)))))
