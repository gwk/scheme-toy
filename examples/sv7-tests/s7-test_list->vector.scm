(test (vector->list '#(0)) (list 0))
(test (vector->list (vector)) '())
(test (vector->list '#(a b c)) '(a b c))
(test (vector->list '#(#(0) #(1))) '(#(0) #(1)))
(test (vector? (list-ref (let ((v (vector 1 2))) (vector-set! v 1 v) (vector->list v)) 1)) #t)

(test (list->vector '()) '#())
(test (list->vector '(a b c)) '#(a b c))
(test (list->vector (list (list 1 2) (list 3 4))) '#((1 2) (3 4)))
(test (list->vector ''foo) '#(quote foo))
(test (list->vector (list)) '#())
(test (list->vector (list 1)) '#(1))
(test (list->vector (list (list))) '#(()))
(test (list->vector (list 1 #\a "hi" 'hi)) '#(1 #\a "hi" hi))
(test (list->vector ''1) #(quote 1))
(test (list->vector '''1) #(quote '1))

(for-each
 (lambda (arg)
   (if (list? arg)
       (test (vector->list (list->vector arg)) arg)))
 lists)
(set! lists '())

(test (list->vector (vector->list (vector))) '#())
(test (list->vector (vector->list (vector 1))) '#(1))
(test (vector->list (list->vector (list))) '())
(test (vector->list (list->vector (list 1))) '(1))

(test (reinvert 12 vector->list list->vector #(1 2 3)) #(1 2 3))

(test (vector->list) 'error)
(test (list->vector) 'error)
(test (vector->list #(1) #(2)) 'error)
(test (list->vector '(1) '(2)) 'error)

(for-each
 (lambda (arg)
   (test (vector->list arg) 'error))
 (list #\a 1 () (list 1) '(1 . 2) #f 'a-symbol "hi" abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (let ((x (cons #\a #\b))) (set-cdr! x x) (list->vector x)) 'error)
(test (list->vector (cons 1 2)) 'error)
(test (list->vector '(1 2 . 3)) 'error)
(test (let ((lst (list #\a #\b))) (set! (cdr (cdr lst)) lst) (list->vector lst)) 'error)
(test (let ((lst (list #\a #\b))) (set! (cdr (cdr lst)) lst) (apply vector lst)) 'error)

(for-each
 (lambda (arg)
   (test (list->vector arg) 'error))
 (list "hi" #\a 1 '(1 . 2) (cons #\a #\b) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
