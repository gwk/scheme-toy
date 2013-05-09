(test (string-fill! "hiho" #\c) #\c)
(test (string-fill! "" #\a) #\a)
(test (string-fill! "hiho" #\a) #\a)
(test (let ((g (lambda () "***"))) (string-fill! (g) #\?)) #\?)
(test (string-fill!) 'error)
(test (string-fill! "hiho" #\a #\b) 'error)

(test (let ((hi (string-copy "hi"))) (string-fill! hi #\s) hi) "ss")
(test (let ((hi (string-copy ""))) (string-fill! hi #\x) hi) "")
(test (let ((str (make-string 0))) (string-fill! str #\a) str) "")
(test (let ((hi (make-string 8 (integer->char 0)))) (string-fill! hi #\a) hi) "aaaaaaaa") ; is this result widely accepted?
(test (recompose 12 string-copy "xax") "xax")
(test (let ((hi (make-string 3 #\x))) (recompose 12 (lambda (a) (string-fill! a #\a) a) hi)) "aaa")
(test (let ((hi (make-string 3 #\x))) (recompose 12 (lambda (a) (string-fill! hi a)) #\a) hi) "aaa")
(test (let ((str (string #\null #\null))) (fill! str #\x) str) "xx")

(for-each
 (lambda (arg)
   (test (let ((hiho "hiho")) (string-fill! hiho arg) hiho) 'error))
 (list 1 "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (string-fill! arg #\a) 'error))
 (list #\a 1 () (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
