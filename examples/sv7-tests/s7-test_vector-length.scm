(test (vector-length (vector)) 0)
(test (vector-length (vector 1)) 1)
(test (vector-length (make-vector 128)) 128)
(test (vector-length '#(a b c d e f)) 6)
(test (vector-length '#()) 0)
(test (vector-length (vector #\a (list 1 2) (vector 1 2))) 3)
(test (vector-length '#(#(#(hi)) #(#(hi)) #(#(hi)))) 3)
(test (vector-length (vector 1 2 3 4)) 4)
(test (vector-length (let ((v (vector 1 2))) (vector-set! v 1 v) v)) 2)
(test (vector-length (let ((v (vector 1 2))) (vector-set! v 1 v) (vector-ref v 1))) 2)

(test (vector-length) 'error)
(test (vector-length #(1) #(2)) 'error)

(for-each
 (lambda (arg)
   (test (vector-length arg) 'error))
 (list "hi" #\a 1 () '(1 . 2) (cons #\a #\b) #f 'a-symbol abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
