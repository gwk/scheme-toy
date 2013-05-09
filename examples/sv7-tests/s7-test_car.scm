(test (car (list 1 2 3)) 1)
(test (car (cons 1 2)) 1)
(test (car (list 1)) 1)
(test (car '(1 2 3)) 1)
(test (car '(1)) 1)
(test (car '(1 . 2)) 1)
(test (car '((1 2) 3)) '(1 2))
(test (car '(((1 . 2) . 3) 4)) '((1 . 2) . 3))
(test (car (list (list) (list 1 2))) '())
(test (car '(a b c)) 'a)
(test (car '((a) b c d)) '(a))
(test (car (reverse (list 1 2 3 4))) 4)
(test (car (list 'a 'b 'c 'd 'e 'f 'g)) 'a)
(test (car '(a b c d e f g)) 'a)
(test (car '(((((1 2 3) 4) 5) (6 7)) (((u v w) x) y) ((q w e) r) (a b c) e f g)) '((((1 2 3) 4) 5) (6 7)))
(test (car '(a)) 'a)
(test (car '(1 ^ 2)) 1)
(test (car '(1 .. 2)) 1)
(test (car ''foo) 'quote)
(test (car '(1 2 . 3)) 1)
(test (car (cons 1 '())) 1)
(test (car (if #f #f)) 'error)
(test (car '()) 'error)
(test (car #(1 2)) 'error)
(test (car '#(1 2)) 'error)

(for-each
 (lambda (arg)
   (if (not (equal? (car (cons arg '())) arg))
       (format #t ";(car '(~A)) returned ~A?~%" arg (car (cons arg '()))))
   (test (car arg) 'error))
 (list "hi" (integer->char 65) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand (log 0) 
       3.14 3/4 1.0+1.0i #\f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (reinvert 12 car (lambda (a) (cons a '())) '(1)) '(1))
