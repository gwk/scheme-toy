(test (string-length "abc") 3)
(test (string-length "") 0)
(test (string-length (string)) 0)
(test (string-length "\"\\\"") 3)
(test (string-length (string #\newline)) 1)
(test (string-length "hi there") 8)
(test (string-length "\"") 1)
(test (string-length "\\") 1)
(test (string-length "\n") 1)
(test (string-length (make-string 100 #\a)) 100)
(test (string-length "1\\2") 3)
(test (string-length "1\\") 2)
(test (string-length "hi\\") 3)
(test (string-length "\\\\\\\"") 4)
(test (string-length "A ; comment") 11)
(test (string-length "#| comment |#") 13)
(test (string-length "'123") 4)
(test (string-length '"'123") 4)
(test (let ((str (string #\# #\\ #\t))) (string-length str)) 3)

(test (string-length "#\\(") 3)
(test (string-length ")()") 3)
(test (string-length "(()") 3)
(test (string-length "(string #\\( #\\+ #\\space #\\1 #\\space #\\3 #\\))") 44)
(test (string-length) 'error)
(test (string-length "hi" "ho") 'error)
(test (string-length (string #\null)) 1) ; ??
(test (string-length (string #\null #\null)) 2) ; ??
(test (string-length (string #\null #\newline)) 2) ; ??
(test (string-length ``"hi") 2) ; ?? and in s7 ,"hi" is "hi" as with numbers

(test (string-length ";~S ~S") 6)
(test (string-length "\n;~S ~S") 7)
(test (string-length "\n\t") 2)
(test (string-length "#\newline") 8)
(test (string-length "#\tab") 4)
(test (string-length "a\x00b") 3)

(for-each
 (lambda (arg)
   (test (string-length arg) 'error))
 (list #\a '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
