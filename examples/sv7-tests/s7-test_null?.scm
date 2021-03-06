(test (null? 'a) '#f)
(test (null? '()) #t)
(test (null? ()) #t)
(test (null? '(a b c)) #f)
(test (null? (cons 1 2)) #f)
(test (null? ''()) #f)
(test (null? #f) #f)
(test (null? (make-vector 6)) #f)
(test (null? #t) #f)
(test (null? '(a . b)) #f)
(test (null? '#(a b))  #f)
(test (null? (list 1 2)) #f)
(test (null? (list)) #t)
(test (null? ''foo) #f)
(test (null? (list 'a 'b 'c 'd 'e 'f)) #f)
(test (null? '(this-that)) #f)
(test (null? '(this - that)) #f)
(let ((x (list 1 2)))
  (set-cdr! x x)
  (test (null? x) #f))
(test (null? (list 1 (cons 1 2))) #f)
(test (null? (list 1 (cons 1 '()))) #f)
(test (null? (cons 1 '())) #f)
(test (null? (cons '() '())) #f)
(test (null? (cons '() 1)) #f)
(test (null? (list (list))) #f)
(test (null? '(())) #f)
(test (null? '#()) #f)
(test (null? (make-vector '(2 0 3))) #f)
(test (null? "") #f)
(test (null? lambda) #f)
(test (null? cons) #f)
(test (null? (begin)) #t)
(test (null? (cdr (list 1))) #t)
(test (null? (cdr (cons '() '(())))) #f)

(test (null? () '()) 'error)
(test (null?) 'error)

(for-each
 (lambda (arg)
   (if (null? arg)
       (format #t ";(null? ~A) -> #t?~%" arg)))
 (list "hi" (integer->char 65) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #\f #t (if #f #f) :hi #<eof> #<undefined> (values) (lambda (a) (+ a 1))))
