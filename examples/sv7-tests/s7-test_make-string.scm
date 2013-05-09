(test (make-string 0) "")
(test (make-string 3 #\a) "aaa")
(test (make-string 0 #\a) "")
(test (make-string 3 #\space) "   ")
(test (let ((hi (make-string 3 #\newline))) (string-length hi)) 3)

(test (make-string -1) 'error)
(test (make-string -0) "")
(test (make-string 2 #\a #\b) 'error)
(test (make-string) 'error)
(test (make-string most-positive-fixnum) 'error)
(test (make-string most-negative-fixnum) 'error)

(for-each
 (lambda (arg)
   (test (make-string 3 arg) 'error))
 (list "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (make-string arg #\a) 'error))
 (list #\a "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (make-string arg) 'error))
 (list #\a "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
