;;; (define (infinite? x) (and (number? x) (or (= x inf.0) (= x -inf.0)))) but this misses complex cases
;;;
;;; a number can be both NaN and infinite...:
(test (nan? (make-rectangular 0/0 (real-part (log 0)))) #t)
(test (infinite? (make-rectangular 0/0 (real-part (log 0)))) #t)
;;; maybe we should restrict nan? and infinite? to reals?

(test (infinite? 0) #f)
(test (infinite? 1.0) #f)
(test (infinite? 1/2) #f)
(test (infinite? 1+i) #f)
(test (infinite? most-positive-fixnum) #f)
(test (infinite? +inf.0) #t)
(test (infinite? -inf.0) #t)
(test (infinite? nan.0) #f)
(test (infinite? pi) #f)
(test (infinite? (imag-part (sinh (log 0.0)))) #t)
(test (infinite? (make-rectangular -inf.0 inf.0)) #t)
(test (infinite? (+ (make-rectangular 1 inf.0))) #t)
(test (infinite? most-negative-fixnum) #f)
(test (infinite? -1.797693134862315699999999999999999999998E308) #f)
(test (infinite? -2.225073858507201399999999999999999999996E-308) #f)
(test (infinite? (real-part inf+infi)) #t)
(test (infinite? (real-part 0+infi)) #f)
(test (infinite? (imag-part inf+infi)) #t)
(test (infinite? (imag-part 0+infi)) #t)

(test (infinite? (imag-part (make-rectangular 0.0 (real-part (log 0))))) #t)
(test (infinite? (real-part (make-rectangular 0.0 (real-part (log 0))))) #f)
(test (infinite? (make-rectangular 0.0 (real-part (log 0)))) #t)
(test (infinite? (real-part (make-rectangular (real-part (log 0)) 1.0))) #t)
(test (infinite? (imag-part (make-rectangular (real-part (log 0)) 1.0))) #f)
(test (infinite? (make-rectangular (real-part (log 0)) 1.0)) #t)
(test (infinite? (imag-part (make-rectangular (real-part (log 0)) (real-part (log 0))))) #t)
(test (infinite? (real-part (make-rectangular (real-part (log 0)) (real-part (log 0))))) #t)
(test (infinite? (make-rectangular (real-part (log 0)) (real-part (log 0)))) #t)

;; if mpc version > 0.8.2
;; (test (infinite? (sin 1+1e10i)) #t)
;; this hangs in earlier versions

(if with-bignums
    (begin
      (test (infinite? (log (bignum "0.0"))) #t)
      (test (infinite? 1e310) #f)
      (test (infinite? 1e400) #f)
      (test (infinite? 1.695681258519314941339000000000000000003E707) #f)
      (test (infinite? 7151305879464824441563197685/828567267217721441067369971) #f)
      ))

(test (infinite?) 'error)
(test (infinite? 1 2) 'error)
