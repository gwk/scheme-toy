(test (assv 1 '(1 2 . 3)) #f)
(test (assv 1 '((1 2) . 3)) '(1 2))

(let ((e '((a 1) (b 2) (c 3))))
  (test (assv 'a e) '(a 1))
  (test (assv 'b e) '(b 2))
  (test (assv 'd e) #f))
(test (assv (list 'a) '(((a)) ((b)) ((c))))  #f)

(let ((xcons (cons 1 2))
      (xvect (vector 1 2))
      (xlambda (lambda () 1))
      (xstr "abs"))
  (let ((e (list (list #t 1) (list #f 2) (list 'a 3) (list xcons 4) (list xvect 5) (list xlambda 6) (list xstr 7) (list car 8))))
    (test (assv #t e) (list #t 1))
    (test (assv #f e) (list #f 2))
    (test (assv 'a e) (list 'a 3))
    (test (assv xcons e) (list xcons 4))
    (test (assv xvect e) (list xvect 5))
    (test (assv xlambda e) (list xlambda 6))
    (test (assv xstr e) (list xstr 7))
    (test (assv car e) (list car 8))))

(let ((e '((1+i 1) (3.0 2) (5/3 3) (#\a 4) ("hiho" 5))))
  (test (assv 1+i e) '(1+i 1))
  (test (assv 3.0 e) '(3.0 2))
  (test (assv 5/3 e) '(5/3 3))
  (test (assv #\a e) '(#\a 4))
  (test (assv "hiho" e) #f))

(let ((e '(((a) 1) (#(a) 2) ("c" 3))))
  (test (assv '(a) e) #f)
  (test (assv '#(a) e) #f)
  (test (assv (string #\c) e) #f))

(let ((lst '((2 . a) (3 . b))))
  (set-cdr! (assv 3 lst) 'c)
  (test lst '((2 . a) (3 . c))))

(test (assv '() '((() 1) (#f 2))) '(() 1))
(test (assv '() '((1) (#f 2))) #f)
(test (assv #() '((#f 1) (() 2) (#() 3))) #f)  ; (eqv? #() #()) -> #f ??

(test (assv 'b '((a . 1) (b . 2) () (c . 3) #f)) '(b . 2))
(test (assv 'c '((a . 1) (b . 2) () (c . 3) #f)) '(c . 3))
(test (assv 'b '((a . 1) (b . 2) () (c . 3) . 4)) '(b . 2))
(test (assv 'c '((a . 1) (b . 2) () (c . 3) . 4)) '(c . 3))
(test (assv 'asdf '((a . 1) (b . 2) () (c . 3) . 4)) #f)
(test (assv 'd '((a . 1) (b . 2) () (c . 3) (d . 5))) '(d . 5))
(test (assv 'a '((a . 1) (a . 2) (a . 3))) '(a . 1)) ; is this specified?
(test (assv 'a '((b . 1) (a . 2) (a . 3))) '(a . 2))

(let ((odd '((3 . 1) (a . 2) (3.0 . 3) (b . 4) (3/4 . 5) (c . 6) (#(1) . 7) (d . 8)))
      (even '((e . 1) (3 . 2) (a . 3) (3.0 . 4) (b . 5) (3/4 . 6) (c . 7) (#(1) . 8) (d . 9))))
  (test (assv 'a odd) '(a . 2))
  (test (assv 'a even) '(a . 3))
  (test (assv 3 odd) '(3 . 1))
  (test (assv 3 even) '(3 . 2))
  (test (assv 3/4 odd) '(3/4 . 5))
  (test (assv 3/4 even) '(3/4 . 6))
  (test (assv 3.0 odd) '(3.0 . 3))
  (test (assv 3.0 even) '(3.0 . 4))
  (test (assv #(1) odd) #f)
  (test (assv #(1) even) #f))

(test (assv 1/0 '((1/0 . 1) (1.0 . 3))) #f)
(test (pair? (assv (real-part (log 0)) (list (cons 1/0 1) (cons (real-part (log 0)) 2) (cons -1 3)))) #t)
(test (pair? (assv (- (real-part (log 0))) (list (cons 1/0 1) (cons (real-part (log 0)) 2) (cons -1 3)))) #f)