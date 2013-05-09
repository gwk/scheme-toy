; requires a control stack of depth 1000 to handle the build-up of additions surrounding the recursive call to sum,
(define (sum n)
  (if (zero? n)
    0
    (+ n (sum (sub1 n)))))
(sum 1000)


; computes the same result with a control stack of depth 1, because the result of a recursive call to sum2 produces the final result for the enclosing call to sum2.
; sum2 can keep an accumulated total, instead of waiting for all numbers before starting to add them, because addition is commutative.
(define (sum2 n r) (if (zero? n)
r
(sum2 (sub1 n) (+ r n)))) (sum2 1000 0)


(define (make-list n) (if (zero? n)
’()
(cons n (make-list (sub1 n))))) (make-list 1000)


(define (make-list2 n r) (if (zero? n)
r
(make-list2 (sub1 n) (cons n r)))) (make-list2 1000 ’())

(define (make-list3 n k) (if (zero? n)
(k ’())
(make-list3 (sub1 n) (lambda (l) (k (cons n l)))))) (make-list3 1000 (lambda (l) l))
