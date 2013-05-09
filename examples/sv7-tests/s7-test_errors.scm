(let ()
  (for-each

   (lambda (op)
     (for-each

      (lambda (arg)
	(let ((val (catch #t (lambda () (op arg)) (lambda args 'error))))
	  (if (not (eq? val 'error))
	      (format #t "(~A ~A) -> ~A (expected 'error)~%" op arg val)))
	(let ((val (catch #t (lambda () (op 0 arg)) (lambda args 'error))))
	  (if (not (eq? val 'error))
	      (format #t "(~A 0 ~A) -> ~A (expected 'error)~%" op arg val)))
	(let ((val (catch #t (lambda () (op 0 1 arg)) (lambda args 'error))))
	  (if (not (eq? val 'error))
	      (format #t "(~A 0 1 ~A) -> ~A (expected 'error)~%" op arg val)))
	(if with-bignums
	    (let ((val (catch #t (lambda () (op (expt 2 60) arg)) (lambda args 'error))))
	      (if (not (eq? val 'error))
		  (format #t "(~A 2^60 ~A) -> ~A (expected 'error)~%" op arg val)))))

      (list "hi" '() #\a (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs #t _ht_ :hi (if #f #f) (lambda (a) (+ a 1)) #<undefined> #<unspecified> #<eof> :key)))

   (list exact? inexact? zero? positive? negative? even? odd? quotient remainder modulo truncate floor ceiling round
	 abs max min gcd lcm expt exact->inexact inexact->exact rationalize numerator denominator imag-part real-part
	 magnitude angle make-polar make-rectangular sqrt exp log sin cos tan asin acos atan number->string
	 + - * / < > <= >= =)))

(let ((d 3.14)
      (i 32)
      (r 2/3)
      (c 1.5+0.3i))
  (let ((check-vals (lambda (name)
		      (if (or (not (= d 3.14)) ; (> (abs (- d 3.14)) 1e-16) ; (- 3.14 (bignum "3.14")) is around 1e-17!
			      (not (= i 32))
			      (not (= r 2/3))
			      (not (= c 1.5+0.3i))) ; (> (magnitude (- c 1.5+0.3i)) 1e-16))
			  (begin 
			    (display name) (display " changed ")
			    (if (not (= i 32))
				(begin (display "stored integer to: ") (display i))
				(if (not (= r 2/3))
				    (begin (display "stored ratio to: ") (display r))
				    (if (not (= d 3.14))
					(begin (display "stored real to: ") (display d))
					(begin (display "stored complex to: ") (display c)))))
			    (display "?") (newline))))))
    (for-each
     (lambda (op)
       (let ((x (catch #t (lambda () (op i)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op r)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op d)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op c)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op i d)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op r d)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op d d)) (lambda args 'error))))
	 (check-vals op))
       (let ((x (catch #t (lambda () (op c d)) (lambda args 'error))))
	 (check-vals op)))
     (list
      number->string string->number make-rectangular magnitude abs exp make-polar angle
      sin cos tan sinh cosh tanh atan sqrt log asinh acosh atanh acos asin
      number? integer? real? complex? rational? even? odd? zero? positive? negative? real-part imag-part
      numerator denominator rationalize exact? inexact? exact->inexact inexact->exact floor ceiling truncate round
      logior logxor logand lognot logbit? ash integer-length
      + - * / quotient remainder
      expt = max min modulo < > <= >= lcm gcd 
      ))))

(if with-bignums
    (begin
      
      (test (bignum "1/3.0") 'error)

      (let ((d (bignum "3.14"))
	    (i (bignum "32"))
	    (r (bignum "2/3"))
	    (c (bignum "1.5+0.3i")))
	(let ((check-vals (lambda (name)
			    (if (or (not (= d (bignum "3.14"))) ; see above
				    (not (= i 32))
				    (not (= r 2/3))
				    (not (= c (bignum "1.5+0.3i"))))
				(begin 
				  (display name) (display " changed ")
				  (if (not (= i 32))
				      (begin (display "stored integer to: ") (display i))
				      (if (not (= r 2/3))
					  (begin (display "stored ratio to: ") (display r))
					  (if (not (= d 3.14))
					      (begin (display "stored real to: ") (display d))
					      (begin (display "stored complex to: ") (display c)))))
				  (display "?") (newline))))))
	  (for-each
	   (lambda (op)
	     (let ((x (catch #t (lambda () (op i)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op r)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op d)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op c)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op i d)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op r d)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op d d)) (lambda args 'error))))
	       (check-vals op))
	     (let ((x (catch #t (lambda () (op c d)) (lambda args 'error))))
	       (check-vals op)))
	   (list
	    number->string string->number make-rectangular magnitude abs exp make-polar angle
	    sin cos tan sinh cosh tanh atan sqrt log asinh acosh atanh acos asin
	    number? integer? real? complex? rational? even? odd? zero? positive? negative? real-part imag-part
	    numerator denominator rationalize exact? inexact? exact->inexact inexact->exact floor ceiling truncate round
	    logior logxor logand lognot logbit? ash integer-length
	    + - * / quotient remainder
	    expt = max min modulo < > <= >= lcm gcd 
	    ))))))

(for-each
 (lambda (arg)
   (test (bignum "1.0" arg) 'error))
 (list -1 0 #\a '#(1 2 3) 2/3 1.5+0.3i 1+i '() 'hi abs "hi" '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))



#|
(let ((funcs (list
	      make-polar make-rectangular magnitude angle real-part imag-part numerator denominator rationalize abs
	      exp log sin cos tan asin acos atan sinh cosh tanh asinh acosh atanh sqrt floor ceiling truncate
	      round lcm gcd + - * / max min quotient remainder modulo = < > <= >= even? odd? zero? positive? negative?
	      infinite? inexact->exact exact->inexact integer-length logior logxor logand lognot logbit?
	      ash integer-decode-float exact? inexact? number? integer? real? complex? rational? nan?; number->string expt
	      ))
      (func-names (list
		   'make-polar 'make-rectangular 'magnitude 'angle 'real-part 'imag-part 'numerator 'denominator 'rationalize 'abs
		   'exp 'log 'sin 'cos 'tan 'asin 'acos 'atan 'sinh 'cosh 'tanh 'asinh 'acosh 'atanh 'sqrt 'floor 'ceiling 'truncate
		   'round 'lcm 'gcd '+ '- '* '/ 'max 'min 'quotient 'remainder 'modulo '= '< '> '<= '>= 'even? 'odd? 'zero? 'positive? 'negative?
		   'infinite? 'inexact->exact 'exact->inexact 'integer-length 'logior 'logxor 'logand 'lognot 'logbit?
		   'ash 'integer-decode-float 'exact? 'inexact? 'number? 'integer? 'real? 'complex? 'rational? 'nan?; 'number->string 'expt
		   ))
      (args (list 0 1 -1)))
  (define (for-each-subset-permuted func name args)
    (let* ((arity (procedure-arity func))
	   (min-args (car arity))
	   (max-args (if (caddr arity)
			 1000
			 (+ min-args (cadr arity)))))
      (if (= min-args 0) (set! min-args 1))
      (for-each-subset
       (lambda s-args
	 (if (<= min-args (length s-args) max-args)
	     (for-each-permutation
	      (lambda p-args
		;(format *stderr* "(~A ~{~A~^ ~})~%" name p-args)
		(let ((val (catch #t (lambda () (apply func p-args)) (lambda e-args ''error))))
		  (format #t "(let ((new-val (catch-it (~A ~{~A~^ ~})))) " name p-args)
		  (if (nan? val)
		      (format #t "(if (not (nan? new-val)) (format #t \"(~A ~{~A~^ ~}) -> ~~A, not NaN?~~%\" new-val)))~%" name p-args)
		      (if (infinite? val)
			  (format #t "(if (not (infinite? new-val)) (format #t \"(~A ~{~A~^ ~}) -> ~~A, not inf?~~%\" new-val)))~%" name p-args)
			  (if (not (number? val))
			      (format #t "(if (not (equal? new-val ~A)) (format #t \"(~A ~{~A~^ ~}) -> ~~A, not ~A?~~%\" new-val)))~%" val name p-args val)
			      (format #t "(if (or (not (number? new-val)) (> (magnitude (- new-val ~A)) 1e-6)) (format #t \"(~A ~{~A~^ ~}) -> ~~A, not ~A?~~%\" new-val)))~%" 
				      val name p-args val))))))
	      s-args)))
       args)))
  
  (with-output-to-file "t248.data"
    (lambda ()
      (format #t "(define-macro (catch-it tst)~%  `(catch #t (lambda () ,tst) (lambda args 'error)))~%")

      (for-each
       (lambda (func name)
	 (for-each-subset-permuted func name args))
       funcs func-names))))
|#


;;; --------------------------------------------------------------------------------
;;;
;;; fft from s7.html (this could be turned into a good gc test)

(define* (cfft! data n (dir 1)) ; (complex data)
  (if (not n) (set! n (length data)))
  (do ((i 0 (+ i 1))
       (j 0))
      ((= i n))
    (if (> j i)
	(let ((temp (data j)))
	  (set! (data j) (data i))
	  (set! (data i) temp)))
    (let ((m (/ n 2)))
      (do () 
	  ((or (< m 2) (< j m)))
	(set! j (- j m))
	(set! m (/ m 2)))
      (set! j (+ j m))))
  (let ((ipow (floor (log n 2)))
	(prev 1))
    (do ((lg 0 (+ lg 1))
	 (mmax 2 (* mmax 2))
	 (pow (/ n 2) (/ pow 2))
	 (theta (make-rectangular 0.0 (* pi dir)) (* theta 0.5)))
	((= lg ipow))
      (let ((wpc (exp theta))
	    (wc 1.0))
	(do ((ii 0 (+ ii 1)))
	    ((= ii prev))
	  (do ((jj 0 (+ jj 1))
	       (i ii (+ i mmax))
	       (j (+ ii prev) (+ j mmax)))
	      ((>= jj pow))
	    (let ((tc (* wc (data j))))
	      (set! (data j) (- (data i) tc))
	      (set! (data i) (+ (data i) tc))))
	  (set! wc (* wc wpc)))
	(set! prev mmax))))
  data)

(test (morally-equal? (cfft! (list 0.0 1+i 0.0 0.0)) '(1+1i -1+1i -1-1i 1-1i)) #t)
(test (morally-equal? (cfft! (vector 0.0 1+i 0.0 0.0)) #(1+1i -1+1i -1-1i 1-1i)) #t)

(let ((size 32))
  (let ((v (make-vector size)))
    (do ((i 0 (+ i 1)))
	((= i size))
      (set! (v i) (random 1.0)))
    (let ((copy-v (copy v)))
      (cfft! v size)
      (cfft! v size -1)
      (do ((i 0 (+ i 1)))
	  ((= i size))
	(set! (v i) (/ (v i) size))
	(if (or (> (abs (imag-part (v i))) 1e-14)
		(> (magnitude (- (v i) (copy-v i))) 1e-14))
	    (format *stderr* ";cfft! reals: ~D: ~A ~A~%" i (v i) (copy-v i)))))))

(let ((size 32))
  (let ((v (make-vector size)))
    (do ((i 0 (+ i 1)))
	((= i size))
      (set! (v i) (random 100)))
    (let ((copy-v (copy v)))
      (cfft! v size)
      (cfft! v size -1)
      (do ((i 0 (+ i 1)))
	  ((= i size))
	(set! (v i) (/ (v i) size))
	(if (or (> (abs (imag-part (v i))) 1e-12)
		(> (magnitude (- (v i) (copy-v i))) 1e-12))
	    (format *stderr* ";cfft! ints: ~D: ~A ~A~%" i (v i) (copy-v i)))))))

(let ((size 32))
  (let ((v (make-vector size)))
    (do ((i 0 (+ i 1)))
	((= i size))
      (set! (v i) (random 1+i)))
    (let ((copy-v (copy v)))
      (cfft! v size)
      (cfft! v size -1)
      (do ((i 0 (+ i 1)))
	  ((= i size))
	(set! (v i) (/ (v i) size))
	(if (> (magnitude (- (v i) (copy-v i))) 1e-12)
	    (format *stderr* ";cfft! complex: ~D: ~A ~A~%" i (v i) (copy-v i)))))))
#|
;;; 1048576 forces us to 4608000, 32568 512000
(let ((size 65536))
  (let ((v (make-vector size)))
    (do ((i 0 (+ i 1)))
	((= i size))
      (set! (v i) (random 1+i)))
    (let ((copy-v (copy v)))
      (cfft! v size)
      (cfft! v size -1)
      (do ((i 0 (+ i 1)))
	  ((= i size))
	(set! (v i) (/ (v i) size))
	(if (> (magnitude (- (v i) (copy-v i))) 1e-10)
	    (format *stderr* "~D: ~A (~A ~A)~%" (magnitude (- (v i) (copy-v i))) i (v i) (copy-v i)))))))
|#




;;; --------------------------------------------------------------------------------
;;;
;;; cload define-c-function tests

(if (provided? 'snd)
    (begin
      (load "cload.scm")
      
      (define-c-function '((double j0 (double)) 
			   (double j1 (double)) 
			   (double erf (double)) 
			   (double erfc (double))
			   (double lgamma (double)))
	"m" "math.h")
      (num-test (m:j0 1.0) 0.76519768655797)
      (num-test (m:j1 1.0) 0.44005058574493)
      (num-test (m:j0 1/2) 0.93846980724081)
      (num-test (m:erf 1.0) 0.84270079294971)
      (num-test (m:erf 2) 0.99532226501895)
      (num-test (m:erfc 1.0) 0.15729920705029)
      (num-test (m:lgamma 2/3) 0.30315027514752)
      
      (let ()
	(define-c-function '(char* getenv (char*)))
	(define-c-function '(int setenv (char* char* int)))
	(test (string? (getenv "HOST")) #t))
      
      (test (defined? 'setenv) #f)
      
      (let ()
	(define local-file-exists? (let () ; define F_OK and access only within this let
				     (define-c-function '((int F_OK) (int access (char* int))) "" "unistd.h") 
				     (lambda (arg) (= (access arg F_OK) 0))))
	
	(define delete-file (let () 
			      (define-c-function '(int unlink (char*)) "" "unistd.h") 
			      (lambda (file) (= (unlink file) 0)))) ; 0=success
	
	(test (local-file-exists? "s7test.scm") #t))

      (define-c-function 
	'((in-C "static struct timeval overall_start_time;  \n\
           static bool time_set_up = false;           \n\
           static double get_internal_real_time(void) \n\
           {                                          \n\
            struct timezone z0;                       \n\
            struct timeval t0;                        \n\
            double secs;                              \n\
            if (!time_set_up) {gettimeofday(&overall_start_time, &z0); time_set_up = true;} \n\
            gettimeofday(&t0, &z0);                   \n\
            secs = difftime(t0.tv_sec, overall_start_time.tv_sec);\n\
            return(secs + 0.000001 * (t0.tv_usec - overall_start_time.tv_usec)); \n\
           }")
	  (double get_internal_real_time (void)))
	"" '("time.h" "sys/time.h"))

      (define-macro (new-time func) 
	`(let ((start (get_internal_real_time)))
	   ,func
	   (- (get_internal_real_time) start)))

      (test (real? (new-time (do ((i 0 (+ i 1))) ((= i 30) i)))) #t)
      ))




;;; --------------------------------------------------------------------------------


;;; these can slow us down if included in their normal place

(test (let ((equal? #f)) (member 3 '(1 2 3))) '(3))
(test (let ((eqv? #f)) (case 1 ((1) 1))) 1) ; scheme wg
(test (let ((eqv? equal?)) (case "asd" (("asd") 1) (else 2))) 2)
(test (let ((eq? #f)) (memq 'a '(a b c))) '(a b c))

;(test (define 'quote 'quote) 'error)
(test (define (and a) a) 'error)
(test (define-constant and 1) 'error)
;(test (define-macro (quote a) quote) 'error)
;(test (define 'hi 1) 'error)
(test (let ((if #t)) (or if)) #t)
(test (let ((if +)) (if 1 2 3)) 6)
(test (if (let ((if 3)) (> 2 if)) 4 5) 5)
(test (let ('1 ) quote) 1)
(test (let ((quote 1)) (+ quote 1)) 2)
(test (let ((quote -)) '32) -32)
(test (do ((do 1)) (#t do)) 1)
(test (do ((do 1 (+ do do))) ((> do 3) do)) 4)
(test (do ((do 1 do) (j do do)) (do do)) 1)
(test (do ((do do do)) (do do)) do)
(test (do ((do do do)) (do do do)) do) ; ok ok!
(test (or (let ((or #t)) or)) #t)
(test (and (let ((and #t)) and)) #t)
(test (let ((=> 3) (cond 4)) (+ => cond)) 7)
(test (case 1 ((1 2) (let ((case 3)) (+ case 1))) ((3 4) 0)) 4)
(test (let ((lambda 4)) (+ lambda 1)) 5)

(test (let () (define (hi a) (let ((pair? +)) (pair? a 1))) (hi 2)) 3)
(test ((lambda (let) (let* ((letrec 1)) (+ letrec let))) 123) 124)

(test (let ((begin 3)) (+ begin 1)) 4)
(test ((lambda (let*) (let ((letrec 1)) (+ letrec let*))) 123) 124)
(test ((lambda (quote) (+ quote 1)) 2) 3)
(test ((lambda (quote . args) (list quote args)) 1 2 3) '(1 (2 3)))
(test (let ((do 1) (map 2) (for-each 3) (quote 4)) (+ do map for-each quote)) 10)
(test ((lambda lambda lambda) 'x) '(x))
(test ((lambda (begin) (begin 1 2 3)) (lambda lambda lambda)) '(1 2 3))
(test (let* ((let 3) (x let)) (+ x let)) 6)
(test (((lambda case lcm))) 1)
(test (((lambda let* *))) 1)
(test (do ((i 0 1) '(list)) (#t quote)) '())
(test ((lambda (let) (+)) 0) 0)
(test (let () (define (hi cond) (+ cond 1)) (hi 2)) 3)
(test (let () (define* (hi (cond 1)) (+ cond 1)) (hi 2)) 3)
(test (let () (define* (hi (cond 1)) (+ cond 1)) (hi)) 2)
(test (let () ((lambda (cond) (+ cond 1)) 2)) 3)
(test (let () ((lambda* (cond) (+ cond 1)) 2)) 3)
(test (let () (define-macro (hi cond) `(+ 1 ,cond)) (hi 2)) 3)
(test (let () (define-macro* (hi (cond 1)) `(+ 1 ,cond)) (hi)) 2)
(test (let () (define (hi abs) (+ abs 1)) (hi 2)) 3)
(test (let () (define (hi if) (+ if 1)) (hi 2)) 3)

(test (let () (define* (hi (lambda 1)) (+ lambda 1)) (hi)) 2)
(test (do ((i 0 0) '(+ 0 1)) ((= i 0) i)) 0) ; guile also! (do ((i 0 0) (quote list (+ 0 1))) ((= i 0) i))?
(test (let () (define (cond a) a) (cond 1)) 1)
(test (let ((cond 1)) (+ cond 3)) 4)
(test (let () (define (tst cond) (if cond 0 1)) (tst #f)) 1)
(test (let () (define (tst fnc) (fnc ((> 0 1) 2) (#t 3))) (tst cond)) 3)
(test (let () (define (tst fnc) (fnc ((> 0 1) 2) (#t 3))) (define (val) cond) (tst (val))) 3)
(test (let () (define (cond a) a) (procedure-arity cond)) '(1 0 #f))
(test (let () (define-macro (hi a) `(let ((lambda +)) (lambda ,a 1))) (hi 2)) 3)
(test ((let ((do or)) do) 1 2) 1)

(test (let () (define (hi) (let ((oscil *)) (if (< 3 2) (+ 1 2) (oscil 4 2)))) (hi) (hi)) 8)
(test (let () (define (hi) (let ((oscil *)) (if (< 3 2) (+ 1 2) (oscil 4 2)))) (hi) (hi) (hi) (hi)) 8)
(test (let ((x 12)) (define (hi env) (set! x (env 0)) x) (hi '(1 2 3)) (hi '(1 2 3))) 1)
(test (let ((x 12)) (define (hi env) (set! x (+ x (env 0))) x) (hi '(1 2 3)) (hi '(1 2 3))) 14)
(test (let ((x 12)) (define (hi env) (set! x (+ (env 0) x)) x) (hi '(1 2 3)) (hi '(1 2 3))) 14)
(test (let ((x 12)) (define (hi env) (set! x (+ x (env 0))) x) (hi '(1 2 3)) (hi '(1 2 3)) (hi '(1 2 3))) 15)
(test (let ((x 12)) (define (hi env) (set! x (+ (env 0) x)) x) (hi '(1 2 3)) (hi '(1 2 3)) (hi '(1 2 3))) 15)

(test (let ((env +) (x 0)) (define (hi) (do ((i 0 (+ i (env 1 2)))) ((> i (env 4 5)) (env 1 2 3)) (+ x (env 1)))) (hi) (hi)) 6)
(test (let ((env +) (x 0)) (define (hi) (do ((i 0 (+ i 3))) ((> i (env 4 5)) (env 1 2 3)) (+ x (env 1)))) (hi) (hi)) 6)
(test (let ((env +) (x 0)) (define (hi) (do ((i 0 (+ i 3))) ((> i (env 4 5)) (env 1 2 3)) (+ x 1))) (hi) (hi)) 6)
(test (let ((env +) (x 0)) (define (hi) (do ((i 0 (+ i 3))) ((> i 9) (env 1 2 3)) (+ x 1))) (hi) (hi)) 6)
(test (let ((env +) (x 0)) (define (hi) (do ((i 0 (+ i 3))) ((> i 9) (+ 1 2 3)) (+ x 1))) (hi) (hi)) 6)
(test (let * ((i 0)) (if (< i 1) (* (+ i 1))) i) 0)
(test (let ((car if)) (car #t 0 1)) 0)
(test (call-with-exit (lambda (abs) (abs -1))) -1)

(test (let ((sqrt (lambda (a) (* a a)))) `(+ ,@(map sqrt '(1 4 9)) 2)) '(+ 1 16 81 2))
(test (let ((sqrt (lambda (a) (* a a)))) `(+ ,(sqrt 9) 4)) '(+ 81 4))
(test `(+ ,(let ((sqrt (lambda (a) (* a a)))) (sqrt 9)) 4) '(+ 81 4))
(test `(+ (let ((sqrt (lambda (a) (* a a)))) ,(sqrt 9)) 4) '(+ (let ((sqrt (lambda (a) (* a a)))) 3) 4))
(test (let ((sqrt (lambda (a) (* a a)))) `(+ ,(apply values (map sqrt '(1 4 9))) 2)) '(+ 1 16 81 2))
(if (not (provided? 'immutable-unquote)) (test (let ((sqrt (lambda (a) (* a a)))) `(+ (unquote (apply values (map sqrt '(1 4 9)))) 2)) '(+ 1 16 81 2)))

(test ((((eval lambda) lcm gcd))) 0)
(test ((((lambda - -) -) 0) 1) -1)

(test (let () (define (hi) (let ((oscil >)) (or (< 3 2) (oscil 4 2)))) (hi) (hi)) #t)
(test (let () (define (hi) (let ((oscil >)) (and (< 2 3) (oscil 4 2)))) (hi) (hi)) #t)

(test ((lambda* ((- 0)) -) :- 1) 1)
  (let ()
    (define-macro (i_ arg)
      `(with-environment (initial-environment) ,arg))

    (define-bacro* (mac b)
      `((i_ let) ((a 12)) 
	((i_ +) a ,(symbol->value b)))) 
    ;; this assumes the 'b' value is a symbol
    ;; (let ((a 1)) (mac (* a 2))) is an error
    ;; use eval, not symbol->value to generalize it

    (test (let ((a 32) 
		(+ -)) 
	    (mac a))
	  44))

;(define (hi) (do ((i 0 (+ i 1))) ((= i 200000) i) (abs i)))
;(test (hi) 200000)

(test (let ()
	(define-immaculo (hi a) `(let ((b 23)) (+ b ,a)))
	(let ((+ *)
	      (b 12))
	  (hi b)))
      35)

(test (let ()
	(define-clean-macro (hi a) `(+ ,a 1))
	(let ((+ *)
	      (a 12))
	  (hi a)))
      13)

(test (let ()
	(define-immaculo (hi a) `(+ ,a 1))
	(let ((+ *)
	      (a 12))
	  (hi a)))
      13)

(test (let ()
	(define-clean-macro (mac a . body)
	  `(+ ,a ,@body))
	(let ((a 2)
	      (+ *))
	  (mac a (- 5 a) (* a 2))))
      9)

(test (let () 
	(define-macro (mac b) 
	  `(let ((a 12)) 
	     (,+ a ,b)))
	(let ((a 1) 
	      (+ *))
	  (mac a)))
      24)

(test (let () 
	(define-macro (mac b) 
	  `(let ((a 12)) 
	     (+ a ,b)))
	(let ((a 1) 
	      (+ *))
	  (mac a)))
      144)

(test (let ()
	(define-immaculo (mac c d) `(let ((a 12) (b 3)) (+ a b ,c ,d)))
	(let ((a 21) (b 10) (+ *)) (mac a b)))
      46)

(let ()
  (define-macro (pure-let bindings . body)
    `(with-environment (initial-environment)
       (let ,bindings ,@body)))
  (test (let ((+ *) (lambda abs)) (pure-let ((x 2)) ((lambda (y) (+ x y)) 3))) 5))

(test (let ((name '+))
	(let ((+ *))	
	  (eval (list name 2 3))))
      6)
(test (let ((name +))
	(let ((+ *))	
	  (eval (list name 2 3))))
      5)
;; why is this considered confusing?  It has nothing to do with eval!

(test (let ((call/cc (lambda (x)
		       (let ((c (call/cc x))) c))))
	(call/cc (lambda (r) (r 1))))
      1)

(test (with-environment (augment-environment (current-environment) (cons '+ (lambda args (apply * args)))) (+ 1 2 3 4)) 24)

(let ()
  (define-constant [begin] begin)
  (define-constant [if] if)
  (define-macro (when expr . body)
    `([if] ,expr ([begin] ,@body)))
  (let ((if 32) (begin +)) 
    (test (when (> 2 1) 1 2 3) 3)
    (test (when (> 1 2) 3 4 5) #<unspecified>))
  (test (when (> 2 1) 3) 3))

(test (let ((car 1) (cdr 2) (list '(1 2 3))) (+ car cdr (cadr list))) 5)
(test (letrec ((null? (lambda (car cdr) (+ car cdr)))) (null? 1 2)) 3)
(test (letrec ((append (lambda (car list) (car list)))) (append cadr '(1 2 3))) 2)
(test (let () (define (hi) (let ((car 1) (cdr 2) (list '(1 2 3))) (+ car cdr (cadr list)))) (hi)) 5)
(test (let () (define (hi) (letrec ((null? (lambda (car cdr) (+ car cdr)))) (null? 1 2))) (hi)) 3)
(test (let () (define (hi) (letrec ((append (lambda (car list) (car list)))) (append cadr '(1 2 3)))) (hi)) 2)

(let ()
  (test ((lambda 'a (eval-string "1")) (current-environment) 1) 1)
  (test ((lambda 'a (eval-string "a")) (current-environment) 1) 1))

;;; check optimizer 
(let ((lst (list 1 2 3)) 
      (old-lambda lambda)
      (ho #f)
      (val #f))
  (let* ((lambda 1))
    (define (hi) 
      (for-each (lambda (a) (display a)) lst))
    (set! val (+ lambda 2))
    (set! ho hi))
  (test val 3)
  (test (ho) 'error))

(let ()
  (define mac (let ((var (gensym))) 
		(define-macro (mac-inner b) 
		  `(#_let ((,var 12)) (#_+ ,var ,b))) 
		mac-inner))
  (test (let ((a 1) (+ *) (let /)) (mac a)) 13)
  (test (let ((a 1) (+ *) (let /)) (mac (mac a))) 25))

(test (let ((begin +)) (with-environment (initial-environment) (begin 1 2))) 2)
(test (let () (define (f x) (let > (begin (vector-dimensions 22)))) (f 0)) 'error)
(test (let () (define (f x) (let asd ())) (f 1)) 'error)
(test (let () (define (f x) (hook *)) (f #f)) 'error)
(test (let ((e (augment-environment () '(a . 1)))) (define (f x) (e *)) (f 1)) 'error)
(test (let () (define (f) (eval (lambda 2.(hash-table-ref 1-)))) (f)) 'error)
(test (let () (eval (lambda 2.(hash-table-ref 1-)))) 'error)
(test (let () (define (f) (eval (lambda 2 #f))) (f)) 'error)
(test (let () (define (f) (eval (lambda #f))) (f)) 'error)
(test (let () (define (f) (eval (lambda))) (f)) 'error)
(test (let () ((lambda () (eval (lambda 2 #f))))) 'error)
(test (let () (define (f x) (help (lambda  `(x 1) 12))) (f (string #\a))) 'error)
(test (let () (define (func x) (* +(quote (vector? )))) (func '((x 1) (y) . 2))) 'error)
(test (let () (define (func x) (* +(quote i))) (func cond))  'error)
(test (let ((i 1)) (define (func x) (begin i(let -))) (func macroexpand))  'error)
(test (let ((i 1)) (define (func x) (if (* i '((x 1) (y) . 2) ) (atan (procedure? 2(sin ))))) (func '(values #\c 3 1.2))) 'error)
(test (let ((i 1)) (define (func x) (* 1- '(values #\c 3 1.2) )) (func set!))  'error)

(test (let ()
	(define (gset-test)
	  (let ((old-gcd gcd)
		(sum 0)
		(x 12)
		(y 4))
	    (do ((i 0 (+ i 1)))
		((= i 3))
	      (set! sum (+ sum (gcd x y)))
	      (set! gcd +))
	    (set! gcd old-gcd)
	    sum))
	(define (gset-test-1) (gset-test))
	(gset-test-1))
      36)


;;; for some reason these confuse the optimizer

(define-class quaternion () 
  '((r 0) (i 0) (j 0) (k 0))
  (list (list 'real-part (lambda (obj) (obj 'r)))
	(list 'imag-part (lambda (obj) (vector (obj 'i) (obj 'j) (obj 'k))))

	(list 'number? (lambda (obj) #t))
	(list 'complex? (lambda (obj) #f))
	(list 'real? (lambda (obj) #f))
	(list 'integer? (lambda (obj) #f))
	(list 'rational? (lambda (obj) #f))

	(list '+ (lambda orig-args
		   (let add ((r ()) (i ()) (j ()) (k ()) (args orig-args))
		     (if (null? args)
			 (make-quaternion (apply + r) (apply + i) (apply + j) (apply + k)) 
			 (let ((n (car args)))
			   (cond
			    ((real? n) (add (cons n r) i j k (cdr args)))
			    ((complex? n) (add (cons (real-part n) r) (cons (imag-part n) i) j k (cdr args)))
			    ((quaternion? n) (add (cons (n 'r) r) (cons (n 'i) i) (cons (n 'j) j) (cons (n 'k) k) (cdr args)))
			    ((open-environment? n)
			     (if (eq? n (car orig-args))
				 (error 'missing-method "+ can't handle these arguments: ~A" args)
				 (apply (n '+) (make-quaternion (apply + r) (apply + i) (apply + j) (apply + k)) (cdr args))))

			    ;; this code is trying to make sure we don't start bouncing:
			    ;; if (+ q1 o1) goes to (o1 '+) which also can't handle this
			    ;; combination, don't bounce back here!
			    ;; In the current case, it would be (+ o1 q1) bouncing us here.
			    ;; we're assuming (+ a b c) = (+ (+ a b) c), and that any other
			    ;; + method will behave that way.  I think the optimizer also
			    ;; assumes that (+ a b) = (+ b a).

			    (else (error 'wrong-type-arg "+ argument ~A is not a number" n))))))))

	(list '- (lambda args
		   (let ((first (car args)))
		     (if (null? (cdr args)) ; (- q) is not the same as (- q 0)
			 (make-quaternion (- (first 'r)) (- (first 'i)) (- (first 'j)) (- (first 'k)))
			 (let ((q (cond ((real? first) (make-quaternion first 0 0 0))
					((complex? first) (make-quaternion (real-part first) (imag-part first) 0 0))
					(else (copy first))))
			       (n (apply + (cdr args))))
			   (cond ((real? n) (set! (q 'r) (- (q 'r) n)) q)
				 ((complex? n) (make-quaternion (- (q 'r) (real-part n)) (- (q 'i) (imag-part n)) (q 'j) (q 'k)))
				 ((quaternion? n) (make-quaternion (- (q 'r) (n 'r)) (- (q 'i) (n 'i)) (- (q 'j) (n 'j)) (- (q 'k) (n 'k))))
				 (else (apply (n '-) (list q n)))))))))
	))

(let ((old-make-quaternion make-quaternion))
  (augment-environment! (outer-environment (current-environment))
    (cons 'make-quaternion (lambda args
			     (let ((q (apply old-make-quaternion args)))
			       (if (or (not (real? (q 'r)))
				       (not (real? (q 'i)))
				       (not (real? (q 'j)))
				       (not (real? (q 'k))))
				   (error 'wrong-type-arg "quaternion fields should all be real: ~A" q)
				   q))))))


(define-class float ()
  '((x 0.0))
  (list (list '+ (lambda orig-args
		   (let add ((x ()) (args orig-args))
		     (if (null? args)
			 (make-float (apply + x))
			 (let ((n (car args)))
			   (cond
			    ((float? n) (add (cons (n 'x) x) (cdr args)))
			    ((real? n) (add (cons n x) (cdr args)))
			    ((complex? n) (add (cons (real-part n) x) (cdr args)))
			    ((open-environment? n)
			     (if (eq? n (car orig-args))
				 (error 'missing-method "+ can't handle these arguments: ~A" args)
				 (apply (n '+) (make-float (apply + x)) (cdr args))))
			    (else (error 'wrong-type-arg "+ argument ~A is not a number" n))))))))))


(let ((q1 (make-quaternion 1.0 1.0 0.0 0.0)))
  (test (complex? q1) #f)
  (test (number? q1) #t)
  (test (quaternion? q1) #t)
  (test (quaternion? 1) #f)
  (test (quaternion? 1+i) #f)
  (test (integer? q1) #f)
  (test (real? q1) #f)
  (test (rational? q1) #f)

  (test (real-part q1) 1.0)
  (test (imag-part q1) #(1.0 0.0 0.0))

  (test (eq? q1 q1) #t)
  (test (eqv? q1 q1) #t)
  (test (equal? q1 q1) #t)

  (let ((q2 (make-quaternion 1.0 1.0 0.0 0.0)))
    (test (eq? q1 q2) #f)
    (test (eqv? q1 q2) #f)
    (test (equal? q1 q2) #t)
    (set! (q2 'r) 2.0)
    (test (equal? q1 q2) #f)
    
    (test (+ q1) q1)
    (test (+ 1 q1) q2)
    (test (+ q1 1) q2)
    (test (+ 1/2 q1 1/2) q2)
    (test (+ .5 1/2 q1) q2)
    (test (+ 1+i q1 0-i) q2)
    (test (+ 1.0 q1) q2)
    (test (+ q1 1+i 0-i) q2)
    (test (+ 0+i q1 1 0-i) q2)

    (test (- q1) (make-quaternion -1.0 -1.0 0.0 0.0))
    (test (- q1 1) (make-quaternion 0.0 1.0 0.0 0.0))
    (test (- q1 1 0.0+i) (make-quaternion 0.0 0.0 0.0 0.0))
    (test (- 1 q1) (make-quaternion 0.0 -1.0 0.0 0.0))

    (test (+ (make-float 1.0) 1.0) (make-float 2.0))
    (test (+ (make-quaternion 1 0 0 0) (make-float 1.0)) 'error)
    (test (+ (make-float 1.0) 2 (make-quaternion 1 1 1 1)) 'error)
    (test (+ 1 (make-float 1.0) 2 (make-quaternion 1 1 1 1)) 'error)

    (test (make-quaternion 1 2+i 0 0) 'error)
    (test (make-quaternion 1 2 3 "hi") 'error)

    (let () (define (a1 q) (+ q 1)) (test (a1 q1) (make-quaternion 2.0 1.0 0.0 0.0)))
    (let () (define (a1 q) (+ 1 q)) (test (a1 q1) (make-quaternion 2.0 1.0 0.0 0.0)))
    (let () (define (a1 q) (+ q q)) (test (a1 q1) (make-quaternion 2.0 2.0 0.0 0.0)))
    (let () (define (a1 q) (- q 1)) (test (a1 q1) (make-quaternion 0.0 1.0 0.0 0.0)))
    ))

(let ()
  (define-class test-all-methods ()
    '()
    (list (list '* (lambda args '*))
	  (list '+ (lambda args '+))
	  (list '- (lambda args '-))
	  (list '/ (lambda args '/))
	  (list '< (lambda args '<))
	  (list '= (lambda args '=))
	  (list '> (lambda args '>))
	  (list 'call-with-output-file (lambda args 'call-with-output-file))
	  (list 'round (lambda args 'round))
	  (list 'keyword? (lambda args 'keyword?))
	  (list '<= (lambda args '<=))
	  (list '>= (lambda args '>=))
	  (list 'cdaaar (lambda args 'cdaaar))
	  (list 'cdaadr (lambda args 'cdaadr))
	  (list 'cdadar (lambda args 'cdadar))
	  (list 'cdaddr (lambda args 'cdaddr))
	  (list 'cddaar (lambda args 'cddaar))
	  (list 'cddadr (lambda args 'cddadr))
	  (list 'cdddar (lambda args 'cdddar))
	  (list 'cddddr (lambda args 'cddddr))
	  (list 'make-rectangular (lambda args 'make-rectangular))
	  (list 'truncate (lambda args 'truncate))
	  (list 'string->number (lambda args 'string->number))
	  (list 'remainder (lambda args 'remainder))
	  (list 'char-downcase (lambda args 'char-downcase))
	  (list 'char->integer (lambda args 'char->integer))
	  (list 'zero? (lambda args 'zero?))
	  (list 'char<? (lambda args 'char<?))
	  (list 'char=? (lambda args 'char=?))
	  (list 'char>? (lambda args 'char>?))
	  (list 'char-ci<? (lambda args 'char-ci<?))
	  (list 'char-ci=? (lambda args 'char-ci=?))
	  (list 'char-ci>? (lambda args 'char-ci>?))
	  (list 'close-input-port (lambda args 'close-input-port))
	  (list 'infinite? (lambda args 'infinite?))
	  (list 'magnitude (lambda args 'magnitude))
	  (list 'open-input-file (lambda args 'open-input-file))
	  (list 'string->list (lambda args 'string->list))
	  (list 'write-char (lambda args 'write-char))
	  (list 'abs (lambda args 'abs))
	  (list 'car (lambda args 'car))
	  (list 'procedure? (lambda args 'procedure?))
	  (list 'cdr (lambda args 'cdr))
	  (list 'ash (lambda args 'ash))
	  (list 'cos (lambda args 'cos))
	  (list 'gcd (lambda args 'gcd))
	  (list 'list->vector (lambda args 'list->vector))
	  (list 'exp (lambda args 'exp))
	  (list 'symbol->keyword (lambda args 'symbol->keyword))
	  (list 'lcm (lambda args 'lcm))
	  (list 'max (lambda args 'max))
	  (list 'write-byte (lambda args 'write-byte))
	  (list 'inexact? (lambda args 'inexact?))
	  (list 'min (lambda args 'min))
	  (list 'log (lambda args 'log))
	  (list 'tan (lambda args 'tan))
	  (list 'sin (lambda args 'sin))
	  (list 'list-ref (lambda args 'list-ref))
	  (list 'directory->list (lambda args 'directory->list))
	  (list 'string (lambda args 'string))
	  (list 'integer-decode-float (lambda args 'integer-decode-float))
	  (list 'list->string (lambda args 'list->string))
	  (list 'symbol (lambda args 'symbol))
	  (list 'directory? (lambda args 'directory?))
	  (list 'vector->list (lambda args 'vector->list))
	  (list 'imag-part (lambda args 'imag-part))
	  (list 'vector-length (lambda args 'vector-length))
	  (list 'char-ready? (lambda args 'char-ready?))
	  (list 'system (lambda args 'system))
	  (list 'random-state->list (lambda args 'random-state->list))
	  (list 'with-output-to-file (lambda args 'with-output-to-file))
	  (list 'char-alphabetic? (lambda args 'char-alphabetic?))
	  (list 'char-numeric? (lambda args 'char-numeric?))
	  (list 'integer-length (lambda args 'integer-length))
	  (list 'peek-char (lambda args 'peek-char))
	  (list 'keyword->symbol (lambda args 'keyword->symbol))
	  (list 'vector? (lambda args 'vector?))
	  (list 'ceiling (lambda args 'ceiling))
	  (list 'real-part (lambda args 'real-part))
	  (list 'gensym (lambda args 'gensym))
	  (list 'make-hash-table (lambda args 'make-hash-table))
	  (list 'negative? (lambda args 'negative?))
	  (list 'getenv (lambda args 'getenv))
	  (list 'char<=? (lambda args 'char<=?))
	  (list 'char>=? (lambda args 'char>=?))
	  (list 'char-ci<=? (lambda args 'char-ci<=?))
	  (list 'char-ci>=? (lambda args 'char-ci>=?))
	  (list 'string-append (lambda args 'string-append))
	  (list 'port-line-number (lambda args 'port-line-number))
	  (list 'numerator (lambda args 'numerator))
	  (list 'make-hash-table-iterator (lambda args 'make-hash-table-iterator))
	  (list 'string->symbol (lambda args 'string->symbol))
	  (list 'make-random-state (lambda args 'make-random-state))
	  (list 'string-ci<? (lambda args 'string-ci<?))
	  (list 'string-ci=? (lambda args 'string-ci=?))
	  (list 'string-ci>? (lambda args 'string-ci>?))
	  (list 'make-keyword (lambda args 'make-keyword))
	  (list 'integer->char (lambda args 'integer->char))
	  (list 'exact? (lambda args 'exact?))
	  (list 'string-copy (lambda args 'string-copy))
	  (list 'string<? (lambda args 'string<?))
	  (list 'string=? (lambda args 'string=?))
	  (list 'string>? (lambda args 'string>?))
	  (list 'vector-ref (lambda args 'vector-ref))
	  (list 'acos (lambda args 'acos))
	  (list 'caar (lambda args 'caar))
	  (list 'with-input-from-file (lambda args 'with-input-from-file))
	  (list 'cadr (lambda args 'cadr))
	  (list 'cdar (lambda args 'cdar))
	  (list 'cddr (lambda args 'cddr))
	  (list 'string-set! (lambda args 'string-set!))
	  (list 'rationalize (lambda args 'rationalize))
	  (list 'atan (lambda args 'atan))
	  (list 'asin (lambda args 'asin))
	  (list 'assq (lambda args 'assq))
	  (list 'assv (lambda args 'assv))
	  (list 'cosh (lambda args 'cosh))
	  (list 'expt (lambda args 'expt))
	  (list 'continuation? (lambda args 'continuation?))
	  (list 'nan? (lambda args 'nan?))
	  (list 'memq (lambda args 'memq))
	  (list 'memv (lambda args 'memv))
	  (list 'odd? (lambda args 'odd?))
	  (list 'load (lambda args 'load))
	  (list 'hash-table-iterator? (lambda args 'hash-table-iterator?))
	  (list 'read (lambda args 'read))
	  (list 'tanh (lambda args 'tanh))
	  (list 'sinh (lambda args 'sinh))
	  (list 'number? (lambda args 'number?))
	  (list 'sqrt (lambda args 'sqrt))
	  (list 'set-car! (lambda args 'set-car!))
	  (list 'set-cdr! (lambda args 'set-cdr!))
	  (list 'pair-line-number (lambda args 'pair-line-number))
	  (list 'string-ci<=? (lambda args 'string-ci<=?))
	  (list 'char-upcase (lambda args 'char-upcase))
	  (list 'string-ci>=? (lambda args 'string-ci>=?))
	  (list 'macro? (lambda args 'macro?))
	  (list 'list-set! (lambda args 'list-set!))
	  (list 'list-tail (lambda args 'list-tail))
	  (list 'reverse! (lambda args 'reverse!))
	  (list 'symbol->value (lambda args 'symbol->value))
	  (list 'complex? (lambda args 'complex?))
	  (list 'file-exists? (lambda args 'file-exists?))
	  (list 'symbol->string (lambda args 'symbol->string))
	  (list 'make-vector (lambda args 'make-vector))
	  (list 'positive? (lambda args 'positive?))
	  (list 'string? (lambda args 'string?))
	  (list 'make-polar (lambda args 'make-polar))
	  (list 'member (lambda args 'member))
	  (list 'string-fill! (lambda args 'string-fill!))
	  (list 'number->string (lambda args 'number->string))
	  (list 'make-list (lambda args 'make-list))
	  (list 'reverse (lambda args 'reverse))
	  (list 'rational? (lambda args 'rational?))
	  (list 'open-input-string (lambda args 'open-input-string))
	  (list 'hash-table-set! (lambda args 'hash-table-set!))
	  (list 'hash-table-ref (lambda args 'hash-table-ref))
	  (list 'logand (lambda args 'logand))
	  (list 'hash-table-size (lambda args 'hash-table-size))
	  (list 'logior (lambda args 'logior))
	  (list 'lognot (lambda args 'lognot))
	  (list 'logbit? (lambda args 'logbit?))
	  (list 'integer? (lambda args 'integer?))
	  (list 'make-string (lambda args 'make-string))
	  (list 'exact->inexact (lambda args 'exact->inexact))
	  (list 'logxor (lambda args 'logxor))
	  (list 'string<=? (lambda args 'string<=?))
	  (list 'string>=? (lambda args 'string>=?))
	  (list 'vector-set! (lambda args 'vector-set!))
	  (list 'modulo (lambda args 'modulo))
	  (list 'vector-fill! (lambda args 'vector-fill!))
	  (list 'acosh (lambda args 'acosh))
	  (list 'call-with-output-string (lambda args 'call-with-output-string))
	  (list 'get-output-string (lambda args 'get-output-string))
	  (list 'caaar (lambda args 'caaar))
	  (list 'caadr (lambda args 'caadr))
	  (list 'cadar (lambda args 'cadar))
	  (list 'caddr (lambda args 'caddr))
	  (list 'cdaar (lambda args 'cdaar))
	  (list 'cdadr (lambda args 'cdadr))
	  (list 'cddar (lambda args 'cddar))
	  (list 'boolean? (lambda args 'boolean?))
	  (list 'cdddr (lambda args 'cdddr))
	  (list 'char-upper-case? (lambda args 'char-upper-case?))
	  (list 'angle (lambda args 'angle))
	  (list 'char? (lambda args 'char?))
	  (list 'inexact->exact (lambda args 'inexact->exact))
	  (list 'string-length (lambda args 'string-length))
	  (list 'atanh (lambda args 'atanh))
	  (list 'symbol? (lambda args 'symbol?))
	  (list 'denominator (lambda args 'denominator))
	  (list 'asinh (lambda args 'asinh))
	  (list 'with-output-to-string (lambda args 'with-output-to-string))
	  (list 'assoc (lambda args 'assoc))
	  (list 'input-port? (lambda args 'input-port?))
	  (list 'call-with-input-file (lambda args 'call-with-input-file))
	  (list 'fill! (lambda args 'fill!))
	  (list 'port-closed? (lambda args 'port-closed?))
	  (list 'newline (lambda args 'newline))
	  (list 'provided? (lambda args 'provided?))
	  (list 'char-whitespace? (lambda args 'char-whitespace?))
	  (list 'random (lambda args 'random))
	  (list 'floor (lambda args 'floor))
	  (list 'read-char (lambda args 'read-char))
	  (list 'vector-dimensions (lambda args 'vector-dimensions))
	  (list 'even? (lambda args 'even?))
	  (list 'defined? (lambda args 'defined?))
	  (list 'read-byte (lambda args 'read-byte))
	  (list 'output-port? (lambda args 'output-port?))
	  (list 'substring (lambda args 'substring))
	  (list 'string-ref (lambda args 'string-ref))
	  (list 'provide (lambda args 'provide))
	  (list 'read-line (lambda args 'read-line))
	  (list 'eval-string (lambda args 'eval-string))
	  (list 'port-filename (lambda args 'port-filename))
	  (list 'delete-file (lambda args 'delete-file))
	  (list 'list? (lambda args 'list?))
	  (list 'open-output-file (lambda args 'open-output-file))
	  (list 'quotient (lambda args 'quotient))
	  (list 'pair? (lambda args 'pair?))
	  (list 'call-with-input-string (lambda args 'call-with-input-string))
	  (list 'random-state? (lambda args 'random-state?))
	  (list 'with-input-from-string (lambda args 'with-input-from-string))
	  (list 'real? (lambda args 'real?))
	  (list 'char-lower-case? (lambda args 'char-lower-case?))
	  (list 'null? (lambda args 'null?))
	  (list 'eof-object? (lambda args 'eof-object?))
	  (list 'hash-table? (lambda args 'hash-table?))
	  (list 'caaaar (lambda args 'caaaar))
	  (list 'caaadr (lambda args 'caaadr))
	  (list 'caadar (lambda args 'caadar))
	  (list 'caaddr (lambda args 'caaddr))
	  (list 'cadaar (lambda args 'cadaar))
	  (list 'cadadr (lambda args 'cadadr))
	  (list 'caddar (lambda args 'caddar))
	  (list 'cadddr (lambda args 'cadddr))
	  (list 'close-output-port (lambda args 'close-output-port))
	  ))
  
  (let ((procs (make-test-all-methods)))
    (for-each
     (lambda (p) 
       (let* ((fnc (procs p))
	      (val (and (not (eq? fnc #<undefined>))
			(fnc procs))))
	 (if (not (eq? val p))
	     (format #t "~A ~A -> ~A?~%" p fnc val))
	 (let ((function (symbol->value p)))
	   (let ((val (catch #t
			(lambda () ;(format #t "(~A ~A)~%" p (arity function))
			  (apply function (make-list (max 1 (car (arity function))) procs)))
			(lambda args (apply format #f (cadr args))))))
	     (if (not (eq? val p))
		 (format #t ";test-all-methods: (~A~A~A (~D)procs) -> ~A~%" bold-text p unbold-text (max 1 (car (arity function))) val))))))
     (list 
      '* '+ '- '/ '< '= '> 'call-with-output-file 'round 'keyword? '<= '>= 'cdaaar 'cdaadr 'cdadar 'cdaddr 'cddaar 'cddadr 'cdddar 'cddddr 'make-rectangular 'truncate 'string->number 'remainder 'char-downcase 'char->integer 'zero? 'char<? 'char=? 'char>? 'char-ci<? 'char-ci=? 'char-ci>? 'close-input-port 'infinite? 'magnitude 'open-input-file 'string->list 'write-char 'abs 'car 'procedure? 'cdr 'ash 'cos 'gcd 'list->vector 'exp 'symbol->keyword 'lcm 'max 'write-byte 'inexact? 'min 'log 'tan 'sin 'list-ref 'string 'integer-decode-float 'list->string 'symbol 'vector->list 'imag-part 'vector-length 'char-ready? 'random-state->list 'with-output-to-file 'char-alphabetic? 'char-numeric? 'integer-length 'peek-char 'keyword->symbol 'vector? 'ceiling 'real-part 'gensym 'make-hash-table 'negative? 'char<=? 'char>=? 'char-ci<=? 'char-ci>=? 'string-append 'port-line-number 'numerator 'make-hash-table-iterator 'string->symbol 'make-random-state 'string-ci<? 'string-ci=? 'string-ci>? 'make-keyword 'integer->char 'exact? 'string-copy 'string<? 'string=? 'string>? 'vector-ref 'acos 'caar 'with-input-from-file 'cadr 'cdar 'cddr 'string-set! 'rationalize 'atan 'asin 'assq 'assv 'cosh 'expt 'continuation? 'nan? 'memq 'memv 'odd? 'load 'hash-table-iterator? 'read 'tanh 'sinh 'number? 'sqrt 'set-car! 'set-cdr! 'pair-line-number 'string-ci<=? 'char-upcase 'string-ci>=? 'macro? 'list-set! 'list-tail 'reverse! 'symbol->value 'complex? 'symbol->string 'make-vector 'positive? 'string? 'make-polar 'member 'string-fill! 'number->string 'make-list 'reverse 'rational? 'open-input-string 'hash-table-set! 'hash-table-ref 'logand 'hash-table-size 'logior 'lognot 'logbit? 'integer? 'make-string 'exact->inexact 'logxor 'string<=? 'string>=? 'vector-set! 'modulo 'vector-fill! 'acosh 'call-with-output-string 'get-output-string 'caaar 'caadr 'cadar 'caddr 'cdaar 'cdadr 'cddar 'boolean? 'cdddr 'char-upper-case? 'angle 'char? 'inexact->exact 'string-length 'atanh 'symbol? 'denominator 'asinh 'with-output-to-string 'assoc 'input-port? 'call-with-input-file 'fill! 'port-closed? 'newline 'provided? 'char-whitespace? 'random 'floor 'read-char 'vector-dimensions 'even? 'defined? 'read-byte 'output-port? 'substring 'string-ref 'provide 'read-line 'eval-string 'port-filename 'list? 'open-output-file 'quotient 'pair? 'call-with-input-string 'random-state? 'with-input-from-string 'real? 'char-lower-case? 'null? 'eof-object? 'hash-table? 'caaaar 'caaadr 'caadar 'caaddr 'cadaar 'cadadr 'caddar 'cadddr 'close-output-port)))
  )


(test (let ((x (abs -1)) (sba abs)) (set! abs odd?) (let ((y (abs 1))) (set! abs sba) (list x y abs))) (list 1 #t abs))
(test (let () (define (hi z) (abs z)) (let ((x (hi -1)) (sba abs)) (set! abs odd?) (let ((y (hi 1))) (set! abs sba) (list x y)))) (list 1 #t))
(test (let () (define (hi z) (abs z)) (let ((x (hi -1)) (sba abs)) (set! abs (lambda (a b) (+ a b))) (let ((y (hi 1))) (set! abs sba) (list x y)))) 'error)
(test (let () (define (hi) (let ((cond 3)) (set! cond 4) cond)) (hi)) 4)
(test (let ((old+ +) (j 0)) (do ((i 0 (+ i 1))) ((or (< i -3) (> i 3))) (set! + -) (set! j (old+ j i))) (set! + old+) j) -6)

#|
(let ((old+ +))
  (let ((vals 
	 (list (let ()
		 (define a 32)
		 (define p +)
		 (define (f b) (+ a b))
		 (set! a 1)
		 (let ((t1 (f 2)))
		   (set! + -)
		   (let ((t2 (f 2)))
		     (let ((t3 (equal? p +)))
		       (list t1 t2 t3)))))
	       
	       ;; s7: (3 -1 #f) ; this is now (3 3 #f) which strikes me as correct
	       ;; guile: (3 3 #f)
	       
	       (let ()
		 (define a 32)
		 (define p old+)
		 (define (f b) (p a b))
		 (set! a 1)
		 (let ((t1 (f 2)))
		   (set! p -)
		   (let ((t2 (f 2)))
		     (let ((t3 (equal? p old+)))
		       (list t1 t2 t3)))))
	       
	       ;; s7 (3 -1 #t)
	       ;; guile (3 -1 #t)
	       )))
    (set! + old+)
    (test (car vals) (cadr vals))))
|#

(let ((old+ +))
  (define (f x) (with-environment (initial-environment) (+ x 1)))
  (set! + -)
  (test (+ 1 1) 0)
  (test (f 1) 2)
  (set! + old+))

(let ((old+ +))
  (let ((f #f))
    (let ((+ -))
      (set! f (lambda (a) (+ 1 a))))
    (test (f 2) -1)
    (set! + *)
    (test (f 2) -1)
    (set! + old+)))


(if (provided? 'debugging)
    (format #t "~%;all done! (debugging flag is on)~%")
    (format #t "~%;all done!~%"))



#|
;;; why the sign change? or lack thereof?
  :1+0/0i
  1-nani
  :1-0/0i
  1nani


(define (mu) ; infinite loop if bignums
  (let* ((x 1)
	 (xp (+ x 1)))
    (do ()
	((<= xp 1) (list (* 2 x) (* 2.0 x)))
      (set! x (/ x 2))
      (set! xp (+ x 1)))))

; (1/1152921504606846976 8.673617379884e-19)

smallest positive normalized fp	2-1022 = 2.225 10-308
largest normalized fp  2+1023 (2 - 2-52) 2+1024 - 2+971 = 1.798 10+308
smallest positive denormal  2-1023 2-52	 2-1075 = 2.470 10-324
largest denormal  2-1023 (1 - 2-52)	 2-1023 - 2-1075 = 1.113 10-308
largest fp integer	 2+1024 - 2+971 = 1.798 10+308
gap from largest fp integer to previous fp integer	2+971 = 1.996 10+292
largest fp integer with a predecessor	2+53 - 1 = 9,007,199,254,740,991


#x7ff0000000000000 +inf
#xfff0000000000000 -inf
#x7ff8000000000000 nan
#xfff8000000000000 -nan

but how to build these in scheme? (set! flt (integer-encode-float 0 #x7ff 0)) ? (would need check for invalid args)
in C:
	    s7_pointer p;
	    unsigned long long int NAN_1, NAN_0;
	    s7_Double f_NAN_0, f_NAN_1;
	    p = s7_make_real(sc, NAN);
	    f_NAN_0 = real(p);
	    NAN_0 = integer(p);
	    NAN_1 = integer(p) | 1;
	    f_NAN_1 = (* ((s7_Double*)(&NAN_1)));
	    fprintf(stderr, "%llx %f %d, %llx %f %d\n", NAN_0, f_NAN_0, is_NaN(f_NAN_0), NAN_1, f_NAN_1, is_NaN(f_NAN_1));

7ff8000000000000 nan 1, 7ff8000000000001 nan 1

so we can use these low order bits to mark where the NaN was created
but I think we get NaN's implicitly and s7_make_real does not check

in non-gmp, 
  (+ most-negative-fixnum -1 most-positive-fixnum) is the same as 
  (+ most-positive-fixnum most-positive-fixnum) -> -2!

|#


#|
;;; here's an expanded version of the autotester mentioned in s7.html:

(let ((constants (list #f #t () 1.5 (/ 1 most-positive-fixnum) (/ -1 most-positive-fixnum) 1.5+i
		  "hi" :hi 'hi (list 1) (list 1 2) (cons 1 2) '() (list (list 1 2)) (list (list 1)) (list ()) #() 
		  1/0+i 0+0/0i 0+1/0i 1+0/0i 0/0+0i 0/0+0/0i 1+1/0i 0/0+i cons ''2 
		  1+i 1+1e10i 1e15+1e15i 0+1e18i 1e18 (integer->char 255) (string (integer->char 255)) 1e308 
		  most-positive-fixnum most-negative-fixnum (- most-positive-fixnum 1) (+ most-negative-fixnum 1)
		  -1 0 0.0 1 1.5 1.0+1.0i 3/4 63 -63 (make-hash-table) ;(hash-table '(a . 2) '(b .3))
		  '((1 2) (3 4)) '((1 (2)) (((3) 4))) '(()) "" (list #(1) "1") '(1 2 . 3)
		  #(1 2) (vector 1 '(3)) (let ((x 3)) (lambda (y) (+ x y))) abs (lambda args args) (lambda* ((a 3) (b 2)) (+ a b))
		  (augment-environment '() (cons 'a 1)) (current-environment) (global-environment)
		  *load-hook*  *error-hook* (make-random-state 123) *vector-print-length* *gc-stats*
		  quasiquote macroexpand cond-expand
		  (string #\a #\null #\b) #2d((1 2) (3 4))
		  #<undefined> #<eof> #<unspecified>
		  )))

  (define (autotest func args args-now args-left)
    (set! (-s7-symbol-table-locked?) #t)
    (if (aritable? func args-now)
	(let ((val (catch #t 
		     (lambda () 
		       ;(format *stderr* "(~S ~S)~%" func args) 
		       (apply func args))
		     (lambda any 'error))))
	  (if (and val (not (eq? val 'error)))
	      (format *stderr* "(apply ~S ~{~S~^ ~}) -> ~S~%" func args val))))
    (set! (-s7-symbol-table-locked?) #f)
    (if (> args-left 0)
	(for-each
	 (lambda (c)
	   (autotest func (cons c args) (+ args-now 1) (- args-left 1)))
	 constants)))

  (let ((st (symbol-table)))
    (do ((i 0 (+ i 1))) 
	((= i (length st)) 
	 (format *stderr* "~%all done~%"))
      (let ((lst (st i)))
	(for-each 
	 (lambda (sym)
	   (if (defined? sym)
	       (let ((val (symbol->value sym)))
		 (if (or (aritable? val 0)
			 (aritable? val 1)
			 (aritable? val 2)
			 (aritable? val 3))
		     (if (procedure? val)
			 (let ((strname (symbol->string sym)))
			   (if (or (member (strname 0) '(#\{ #\[ #\())
				   (member strname '("exit" "abort" "unoptimize" "autotest" "delete-file" "system" "set-cdr!"
						     "augment-environment!" "make-procedure-with-setter" "open-environment")))
			       (format *stderr* ";skip ~A for now~%" sym) ; no time! no time!
			       (begin
				 (format *stderr* ";whack on ~A...~%" sym)
				 (autotest val '() 0 3))))
			 (begin
			   (if (or #t (member (symbol->string sym) 
					      '("do" "begin" "set!" "constants" "st" "i" "lst"
						"define" "define*" "define-expansion" "symbol-table"
						"define-macro" "define-bacro" "define-macro*" "define-bacro*"
						"defmacro" "defmacro*" "define-constant")))
			       (format *stderr* ";skip ~A for now~%" sym)
			       (begin
				 (format *stderr* ";whack on ~A...~%" sym)
				 (autotest val '() 0 3)))))))))
	 lst)))))
|#

;;; (aritable? '2 8) -> #t
;;; (gensym "a\x00b") -> {a}-10 for unreadable gensym??


;;; write/display hash-table stdin lambda? macro/bacro cont/goto func/closure etc, all the pair types, circular etc

#|
(let ((lst ()))
   (do ((i 0 (+ i 1)))
       ((= i 1000) (reverse lst)) 
     (set! lst (cons i lst))))
;;; ok (tested) up to 10000000 
|#
