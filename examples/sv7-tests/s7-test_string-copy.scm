(test (let ((hi (string-copy "hi"))) (string-set! hi 0 #\H) hi) "Hi")
(test (let ((hi (string-copy "hi"))) (string-set! hi 1 #\H) hi) "hH")
(test (let ((hi (string-copy "\"\\\""))) (string-set! hi 0 #\a) hi) "a\\\"")
(test (let ((hi (string-copy "\"\\\""))) (string-set! hi 1 #\a) hi) "\"a\"")
(test (let ((hi (string #\a #\newline #\b))) (string-set! hi 1 #\c) hi) "acb")
(test (string-copy "ab") "ab")
(test (string-copy "") "")
(test (string-copy "\"\\\"") "\"\\\"")
(test (let ((hi "abc")) (eq? hi (string-copy hi))) #f)
(test (let ((hi (string-copy (make-string 8 (integer->char 0))))) (string-fill! hi #\a) hi) "aaaaaaaa") ; is this result widely accepted?
(test (string-copy (string-copy (string-copy "a"))) "a")
(test (string-copy (string-copy (string-copy ""))) "")
(test (string-copy "a\x00b") "a\x00b") ; prints normally as "a" however
(test (string-copy (string #\1 #\null #\2)) (string #\1 #\null #\2))
(test (string-copy) 'error)
(test (string-copy "hi" "ho") 'error)

(for-each
 (lambda (arg)
   (test (string-copy arg) 'error))
 (list #\a 1 () (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (length (string-copy (string #\null))) 1)
