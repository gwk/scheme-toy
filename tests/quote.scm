(test '1 1)
(test '"hi" "hi")
(test '#f #f)
(test '#t #t)
(test '() '())
(test '(1 . 2) (cons 1 2))
(test (+ '1 '2) 3)
(test (+ '1 '2) '3)
(test (if '#f 2 3) 3)
(test (if '#t 2 3) 2)
