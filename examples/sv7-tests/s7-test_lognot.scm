(for-each
 (lambda (op)
   (for-each
    (lambda (arg)
      (let ((val (catch #t (lambda () (op arg)) (lambda args 'error))))
	(if (not (equal? val 'error))
	    (format #t ";(~A ~A) -> ~A?~%" op arg val))))
    (list "hi" _ht_ '() '(1 2) #f (integer->char 65) 'a-symbol (make-vector 3) 3.14 3/4 3.1+i abs #\f (lambda (a) (+ a 1)))))
 (list logior logand lognot logxor logbit? ash integer-length))

(for-each
 (lambda (op)
   (for-each
    (lambda (arg)
      (let ((val (catch #t (lambda () (op 1 arg)) (lambda args 'error))))
	(if (not (equal? val 'error))
	    (format #t ";(~A ~A) -> ~A?~%" op arg val))))
    (list "hi" _ht_ '() '(1 2) #f (integer->char 65) 'a-symbol (make-vector 3) 3.14 -1/2 1+i abs #\f (lambda (a) (+ a 1)))))
 (list logior logand logxor lognot logbit?))


(num-test (lognot 0) -1)
(num-test (lognot -1) 0)
(num-test (lognot 1) -2)
(num-test (lognot #b101) -6)
(num-test (lognot -6) #b101)
(num-test (lognot 12341234) -12341235)
(num-test (lognot #b-101) 4)
(num-test (lognot (+ 1 (lognot 1000))) 999)
(num-test (lognot #e10e011) -1000000000001)
(num-test (lognot -9223372036854775808) 9223372036854775807)
(num-test (lognot 9223372036854775807) -9223372036854775808)
(num-test (lognot most-positive-fixnum) most-negative-fixnum)

(if with-bignums
    (begin
      (test (lognot 9223372036854775808) -9223372036854775809)
      (test (lognot 618970019642690137449562111) (- (expt 2 89)))
      (num-test (lognot (+ (expt 2 48) (expt 2 46))) -351843720888321)
      (test (lognot 0+92233720368547758081.0i) 'error)
      (test (lognot 92233720368547758081.0) 'error)
      ))

(test (lognot) 'error)
(test (lognot 1.0) 'error)
(test (lognot 1+i) 'error)
(test (lognot 1/2) 'error)
(test (lognot #f) 'error)
(test (lognot 1/1) -2)
