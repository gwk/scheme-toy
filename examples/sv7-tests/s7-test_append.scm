(test (append '(a b c) '()) '(a b c))
(test (append '() '(a b c)) '(a b c))
(test (append '(a b) '(c d)) '(a b c d))
(test (append '(a b) 'c) '(a b . c))
(test (equal? (append (list 'a 'b 'c) (list 'd 'e 'f) '() '(g)) '(a b c d e f g)) #t)
(test (append (list 'a 'b 'c) (list 'd 'e 'f) '() (list 'g)) '(a b c d e f g))
(test (append (list 'a 'b 'c) 'd) '(a b c . d))
(test (append '() '()) '())
(test (append '() (list 'a 'b 'c)) '(a b c))
(test (append) '())
(test (append '() 1) 1)
(test (append 'a) 'a)
(test (append '(x) '(y))  '(x y))
(test (append '(a) '(b c d)) '(a b c d))
(test (append '(a (b)) '((c)))  '(a (b) (c)))
(test (append '(a b) '(c . d))  '(a b c . d))
(test (append '() 'a)  'a)
(test (append '(a b) (append (append '(c)) '(e) 'f)) '(a b c e . f))
(test (append ''foo 'foo) '(quote foo . foo))
(test (append '() (cons 1 2)) '(1 . 2))
(test (append '() '() '()) '())
(test (append (cons 1 2)) '(1 . 2))

(test (append #f) #f)
(test (append '() #f) #f)
(test (append '(1 2) #f) '(1 2 . #f))
(test (append '() '() #f) #f)
(test (append '() '(1 2) #f) '(1 2 . #f))
(test (append '(1 2) '() #f) '(1 2 . #f))
(test (append '(1 2) '(3 4) #f) '(1 2 3 4 . #f))
(test (append '() '() '() #f) #f)
(test (append '(1 2) '(3 4) '(5 6) #f) '(1 2 3 4 5 6 . #f))
(test (append () () #()) #())
(test (append () ((lambda () #f))) #f)

(test (append (begin) do) do)
(test (append if) if)
(test (append quote) quote)
(test (append 0) 0) ; is this correct?
(test (append '() 0) 0)
(test (append '() '() 0) 0)
(test (let* ((x '(1 2 3)) (y (append x '()))) (eq? x y)) #f) ; check that append returns a new list
(test (let* ((x '(1 2 3)) (y (append x '()))) (equal? x y)) #t)
(test (let* ((x (list 1 2 3)) (y (append x (list)))) (eq? x y)) #f) 
(test (append '(1) 2) '(1 . 2))
(let ((x (list 1 2 3)))
  (let ((y (append x '())))
    (set-car! x 0)
    (test (= (car y) 1) #t)))
(let ((x (list 1 2 3)))
  (let ((y (append x '())))
    (set-cdr! x 0)
    (test (and (= (car y) 1)
	       (= (cadr y) 2)
	       (= (caddr y) 3))
	  #t)))

(test (let ((xx (list 1 2))) (recompose 12 (lambda (x) (append (list (car x)) (cdr x))) xx)) '(1 2))

(test (append 'a 'b) 'error)
(test (append 'a '()) 'error)
(test (append (cons 1 2) '()) 'error)
(test (append '(1) 2 '(3)) 'error)
(test (append '(1) 2 3) 'error)
(test (let ((lst (list 1 2 3))) (append lst lst)) '(1 2 3 1 2 3))
(test (append ''1 ''1) '(quote 1 quote 1))
(test (append '(1 2 . 3) '(4)) 'error)
(test (append '(1 2 . 3)) '(1 2 . 3))
(test (append '(4) '(1 2 . 3)) '(4 1 2 . 3))
(test (append '() 12 . ()) 12)
(test (append '(1) 12) '(1 . 12))
(test (append '(1) 12 . ()) '(1 . 12))
(test (append '() '() '(1) 12) '(1 . 12))
(test (append '(1) '(2) '(3) 12) '(1 2 3 . 12))
(test (append '(((1))) '(((2)))) '(((1)) ((2))))
(test (append '() . (2)) 2)
(test (append . (2)) 2)
(test (append ''() '()) ''())

(for-each
 (lambda (arg)
   (test (append arg) arg)
   (test (append '() arg) arg)
   (test (append '() '() '() arg) arg))
 (list "hi" #\a #f 'a-symbol _ht_ (make-vector 3) abs 1 3.14 3/4 1.0+1.0i #t #<unspecified> #<eof> '() #() (list 1 2) (cons 1 2) #(0) (lambda (a) (+ a 1))))
(test (append not) not)
