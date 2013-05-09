(test (let () (set! most-positive-fixnum 2)) 'error)
(test (let ((most-positive-fixnum 2)) most-positive-fixnum) 'error)
(test (let () (set! most-negative-fixnum 2)) 'error)
(test (let ((most-negative-fixnum 2)) most-negative-fixnum) 'error)
(test (let () (set! pi 2)) 'error)
(test (let ((pi 2)) pi) 'error)

(define-constant nan.0 (string->number "nan.0"))
(if (not (nan? nan.0)) (format #t ";(string->number \"nan.0\") returned ~A~%" nan.0))
(if (infinite? nan.0) (format #t ";nan.0 is infinite?~%"))

(define-constant +inf.0 (string->number "+inf.0"))
(if (not (infinite? +inf.0)) (format #t ";(string->number \"+inf.0\") returned ~A~%" +inf.0))
(if (nan? +inf.0) (format #t ";+inf.0 is NaN?~%"))

(define-constant -inf.0 (string->number "-inf.0"))
(if (not (infinite? -inf.0)) (format #t ";(string->number \"-inf.0\") returned ~A~%" -inf.0))
(if (nan? -inf.0) (format #t ";-inf.0 is NaN?~%"))

(define-constant inf.0 +inf.0)
(define-constant inf+infi (make-rectangular inf.0 inf.0))
(define-constant nan+nani (make-rectangular nan.0 nan.0))
(define-constant 0+infi (make-rectangular 0 inf.0))
(define-constant 0+nani (make-rectangular 0 nan.0))

(test (equal? +inf.0 inf.0) #t)
(test (equal? +inf.0 -inf.0) #f)
(test (equal? nan.0 inf.0) #f)
(test (= nan.0 nan.0) #f) 
(test (equal? inf.0 nan.0) #f)
; (test (equal? nan.0 nan.0) (eqv? nan.0 nan.0)) ; these are confusing: (equal? 0/0 0/0) is a different case
