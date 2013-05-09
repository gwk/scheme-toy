(test (make-list 0) '())
(test (make-list 0 123) '())
(test (make-list 1) '(#f))
(test (make-list 1 123) '(123))
(test (make-list 1 '()) '(()))
(test (make-list 2) '(#f #f))
(test (make-list 2 1) '(1 1))
(test (make-list 2/1 1) '(1 1))
(test (make-list 2 (make-list 1 1)) '((1) (1)))
(test (make-list -1) 'error)
(test (make-list -0) '())
(test (make-list most-negative-fixnum) 'error)
(test (make-list most-positive-fixnum) 'error)
(test (make-list 0 #\a) ())
(test (make-list 1 #\a) '(#\a))

(for-each
 (lambda (arg)
   (test (make-list arg) 'error))
 (list #\a '#(1 2 3) 3.14 3/4 1.0+1.0i 0.0 1.0 '() #t 'hi '#(()) (list 1 2 3) '(1 . 2) "hi" (- (real-part (log 0.0)))))

(for-each
 (lambda (arg)
   (test ((make-list 1 arg) 0) arg))
 (list #\a '#(1 2 3) 3.14 3/4 1.0+1.0i '() #f 'hi '#(()) (list 1 2 3) '(1 . 2) "hi"))

(test (make-list) 'error)
(test (make-list 1 2 3) 'error)
(test (let ((lst (make-list 2 (make-list 1 0)))) (eq? (lst 0) (lst 1))) #t)
