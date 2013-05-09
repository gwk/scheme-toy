(let ((e '((a 1) (b 2) (c 3))))
  (test (assq 'a e) '(a 1))
  (test (assq 'b e) '(b 2))
  (test (assq 'd e) #f))
(test (assq (list 'a) '(((a)) ((b)) ((c))))  #f)

(let ((xcons (cons 1 2))
      (xvect (vector 1 2))
      (xlambda (lambda () 1))
      (xstr "abs"))
  (let ((e (list (list #t 1) (list #f 2) (list 'a 3) (list xcons 4) (list xvect 5) (list xlambda 6) (list xstr 7) (list car 8))))
    (test (assq #t e) (list #t 1))
    (test (assq #f e) (list #f 2))
    (test (assq 'a e) (list 'a 3))
    (test (assq xcons e) (list xcons 4))
    (test (assq xvect e) (list xvect 5))
    (test (assq xlambda e) (list xlambda 6))
    (test (assq xstr e) (list xstr 7))
    (test (assq car e) (list car 8))))

(let ((e '((1+i 1) (3.0 2) (5/3 3))))
  (test (assq 1+i e) #f)
  (test (assq 3.0 e) #f)
  (test (assq 5/3 e) #f))

(test (assq 'x (cdr (assq 'a '((b . 32) (a . ((a . 12) (b . 32) (x . 1))) (c . 1))))) '(x . 1))

(test (assq #f '(#f 2 . 3)) #f)
(test (assq #f '((#f 2) . 3)) '(#f 2))
(test (assq '() '((() 1) (#f 2))) '(() 1))
(test (assq '() '((1) (#f 2))) #f)
(test (assq #() '((#f 1) (() 2) (#() 3))) #f)  ; (eq? #() #()) -> #f

(test (assq 'b '((a . 1) (b . 2) () (c . 3) #f)) '(b . 2))
(test (assq 'c '((a . 1) (b . 2) () (c . 3) #f)) '(c . 3))
(test (assq 'b '((a . 1) (b . 2) () (c . 3) . 4)) '(b . 2))
(test (assq 'c '((a . 1) (b . 2) () (c . 3) . 4)) '(c . 3))
(test (assq 'b (list '(a . 1) '(b . 2) '() '(c . 3) #f)) '(b . 2))
(test (assq 'asdf (list '(a . 1) '(b . 2) '() '(c . 3) #f)) #f)
(test (assq "" (list '("a" . 1) '("" . 2) '(#() . 3))) #f) ; since (eq? "" "") is #f
(test (assq 'a '((a . 1) (a . 2) (a . 3))) '(a . 1)) ; is this specified?
(test (assq 'a '((b . 1) (a . 2) (a . 3))) '(a . 2))

;; check the even/odd cases
(let ((odd '((3 . 1) (a . 2) (3.0 . 3) (b . 4) (3/4 . 5) (c . 6) (#(1) . 7) (d . 8)))
      (even '((e . 1) (3 . 2) (a . 3) (3.0 . 4) (b . 5) (3/4 . 6) (c . 7) (#(1) . 8) (d . 9))))
  (test (assq 'a odd) '(a . 2))
  (test (assq 'a even) '(a . 3))
  (test (assq 3/4 odd) #f)
  (test (assq 3/4 even) #f)
  (test (assq 3.0 odd) #f)
  (test (assq 3.0 even) #f)
  (test (assq #(1) odd) #f)
  (test (assq #(1) even) #f))
