(test (string? "abc") #t)
(test (string? ':+*/-) #f)
(test (string? "das ist einer der teststrings") #t)
(test (string? '(das ist natuerlich falsch)) #f)
(test (string? "aaaaaa") #t)
(test (string? #\a) #f)
(test (string? "\"\\\"") #t)
(test (string? lambda) #f)
(test (string? format) #f)

(for-each
 (lambda (arg)
   (test (string? arg) #f))
 (list #\a '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (string?) 'error)
(test (string? "hi" "ho") 'error)
(test (string? #\null) #f)
