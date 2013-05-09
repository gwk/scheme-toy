(let ((str (string #\1 #\2 #\3)))
  (fill! str #\x)
  (test str "xxx"))
(let ((v (vector 1 2 3)))
  (fill! v 0.0)
  (test v (vector 0.0 0.0 0.0)))
(let ((lst (list 1 2 (list (list 3) 4))))
  (fill! lst 100)
  (test lst '(100 100 100)))
(let ((cn (cons 1 2)))
  (fill! cn 100)
  (test cn (cons 100 100)))
(test (fill! 1 0) 'error)
(test (fill! 'hi 0) 'error)
(test (let ((x (cons 1 2))) (fill! x 3) x) '(3 . 3))
(test (let ((x "")) (fill! x #\c) x) "") 
(test (let ((x ())) (fill! x #\c) x) ()) 
(test (let ((x #())) (fill! x #\c) x) #()) 
(test (let ((x #(0 1))) (fill! x -1) (set! (x 0) -2) x) #(-2 -1))
(test (let ((x #(0 0))) (fill! x #(1)) (object->string x)) "#(#1=#(1) #1#)")
(test (let ((lst (list "hi" "hi" "hi"))) (fill! lst "hi") (equal? lst '("hi" "hi" "hi"))) #t)
(test (let ((lst (list "hi" "hi"))) (fill! lst "hi") (equal? lst '("hi" "hi"))) #t)
(test (let ((lst (list 1 2 3 4))) (fill! lst "hi") (equal? lst '("hi" "hi" "hi" "hi"))) #t)
(test (let ((lst (list 1 2 3))) (fill! lst lst) (object->string lst)) "#1=(#1# #1# #1#)")
(test (let ((lst (vector 1 2 3))) (fill! lst lst) (object->string lst)) "#1=#(#1# #1# #1#)")
(test (let ((lst #2d((1) (1)))) (fill! lst lst) (object->string lst)) "#1=#2D((#1#) (#1#))")
(test (let ((lst '(1 2 3))) (fill! lst (cons 1 2)) (set! (car (car lst)) 3) (caadr lst)) 3)

(test (let ((lst (list))) (fill! lst 0) lst) '())
(test (let ((lst (list 1))) (fill! lst 0) lst) '(0))
(test (let ((lst (list 1 2))) (fill! lst 0) lst) '(0 0))
(test (let ((lst (list 1 (list 2 3)))) (fill! lst 0) lst) '(0 0))
(test (let ((lst (cons 1 2))) (fill! lst 0) lst) '(0 . 0))
(test (let ((lst (cons 1 (cons 2 3)))) (fill! lst 0) lst) '(0 0 . 0))
(let ((lst (make-list 3)))
  (fill! lst lst)
  (test lst (lst 0))
  (set! (lst 1) 32)
  (test ((lst 0) 1) 32))

(test (fill!) 'error)
(test (fill! '"hi") 'error)
(test (fill! (begin) if) if)
(test (fill! (global-environment) 3) 'error)
(test (fill! (current-environment) 3) 'error)
(test (fill! "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #f) 'error)

(for-each
 (lambda (arg)
   (test (fill! arg 1) 'error))
 (list (integer->char 65) #f 'a-symbol abs _ht_ quasiquote macroexpand 1/0 (log 0) #<eof> #<unspecified> #<undefined> (lambda (a) (+ a 1))
       3.14 3/4 1.0+1.0i #\f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (let ((str (string #\a #\b)))
     (test (fill! str arg) 'error)))
 (list "hi" '(1 2 3) #() #f 'a-symbol abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))





;; generic for-each/map
(test (let ((sum 0)) (for-each (lambda (n) (set! sum (+ sum n))) (vector 1 2 3)) sum) 6)      
(test (map (lambda (n) (+ n 1)) (vector 1 2 3)) '(2 3 4))
(test (map (lambda (a b) (/ a b)) (list 1 2 3) (list 4 5 6)) '(1/4 2/5 1/2))

;; try some applicable stuff
(test (let ((lst (list 1 2 3)))
	(set! (lst 1) 32)
	(list (lst 0) (lst 1)))
      (list 1 32))

(test (let ((hash (make-hash-table)))
	(set! (hash 'hi) 32)
	(hash 'hi))
      32)

(test (let ((str (string #\1 #\2 #\3)))
	(set! (str 1) #\a)
	(str 1))
      #\a)

(test (let ((v (vector 1 2 3)))
	(set! (v 1) 0)
	(v 1))
      0)

(let ()
  (define (hiho a) __func__)
  (test (or (equal? (hiho 1) 'hiho)
	    (equal? (car (hiho 1)) 'hiho))
	#t))


;;; gc
(for-each
 (lambda (arg)
   (test (gc arg) 'error))
 (list "hi" '(1 2 3) #() 'a-symbol abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i 1 '() "" :hi (if #f #f) (lambda (a) (+ a 1))))

(test (gc #f #t) 'error)
