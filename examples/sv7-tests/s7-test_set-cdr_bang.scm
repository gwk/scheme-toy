(test (let ((x (cons 1 2))) (set-cdr! x 3) x) (cons 1 3))
(test (let ((x (list 1 2))) (set-cdr! x 3) x) (cons 1 3))
(test (let ((x (list (list 1 2) 3))) (set-cdr! x 22) x) '((1 2) . 22))
(test (let ((x (cons 1 2))) (set-cdr! x '()) x) (list 1))
(test (let ((x (list 1 (list 2 3 4)))) (set-cdr! x (list 5 (list 6))) x) '(1 5 (6)))
(test (let ((x '(((1) 2) (3)))) (set-cdr! x '((2) 1)) x) '(((1) 2) (2) 1))
(test (let ((x ''foo)) (set-cdr! x "hi") x) (cons 'quote "hi"))
(test (let ((x '((1 . 2) . 3))) (set-cdr! x 4) x) '((1 . 2) . 4))
(test (let ((x '(1 . 2))) (set-cdr! x (cdr x)) x) '(1 . 2))
(test (let ((x '(1 . 2))) (set-cdr! x x) (list? x)) #f)
(test (let ((x (list 1))) (set-cdr! x '()) x) (list 1))
(test (let ((x '(1 . (2 . (3 (4 5)))))) (set-cdr! x 4) x) '(1 . 4))
(test (let ((lst (cons 1 (cons 2 3)))) (set-cdr! (cdr lst) 4) lst) (cons 1 (cons 2 4)))
(test (let ((x (cons (list 1 2) 3))) (set-cdr! (car x) (list 3 4)) x) '((1 3 4) . 3))
(test (let ((x (list 1 2))) (set-cdr! x (list 4 5)) x) '(1 4 5))
(test (let ((x (cons 1 2))) (set-cdr! x (list 4 5)) x) '(1 4 5)) ;!
(test (let ((x (cons 1 2))) (set-cdr! x (cons 4 5)) x) '(1 4 . 5))
(test (let ((lst (list 1 2 3))) (set! (cdr lst) 32) lst) (cons 1 32))

(test (set-cdr! '() 32) 'error)
(test (set-cdr! () 32) 'error)
(test (set-cdr! (list) 32) 'error)
(test (set-cdr! 'x 32) 'error)
(test (set-cdr! #f 32) 'error)
(test (set-cdr!) 'error)
(test (set-cdr! '(1 2) 1 2) 'error)
(test (let ((lst '(1 2))) (set-cdr! lst 32)) 32)
(test (let ((lst '(1 2))) (set! (cdr lst) 32)) 32)

(test (let ((c (cons 1 2))) (set-cdr! c #\a) (cdr c)) #\a)
(test (let ((c (cons 1 2))) (set-cdr! c #()) (cdr c)) #())
(test (let ((c (cons 1 2))) (set-cdr! c #f) (cdr c)) #f)
(test (let ((c (cons 1 2))) (set-cdr! c _ht_) (cdr c)) _ht_)
(test (let ((c (cons 1 2))) (set-cdr! c (list 3)) c) '(1 3))