(test (vector-ref '#(1 1 2 3 5 8 13 21) 5) 8)
(test (vector-ref '#(1 1 2 3 5 8 13 21) (let ((i (round (* 2 (acos -1))))) (if (inexact? i) (inexact->exact i)  i))) 13)
(test (let ((v (make-vector 1 0))) (vector-ref v 0)) 0)
(test (let ((v (vector 1 (list 2) (make-vector 3 #\a)))) (vector-ref v 1)) (list 2))
(test (let ((v (vector 1 (list 2) (make-vector 3 #\a)))) (vector-ref v 2)) '#(#\a #\a #\a))
(test (let ((v (vector 1 (list 2) (make-vector 3 #\a)))) (vector-ref (vector-ref v 2) 1)) #\a)
(test (vector-ref '#(a b c) 1) 'b)
(test (vector-ref '#(()) 0) '())
(test (vector-ref '#(#()) 0) '#())
(test (vector-ref (vector-ref (vector-ref '#(1 (2) #(3 (4) #(5))) 2) 2) 0) 5)
(test (let ((v (vector 1 2))) (vector-set! v 1 v) (eq? (vector-ref v 1) v)) #t)

(test (vector-ref) 'error)
(test (vector-ref #(1)) 'error)
(test (vector-ref #(1) 0 0) 'error)
(test (vector-ref '() 0) 'error)

(test (let ((v (make-vector 1 0))) (vector-ref v 1)) 'error)
(test (let ((v (make-vector 1 0))) (vector-ref v -1)) 'error)
(test (let ((v (vector 1 (list 2) (make-vector 3 #\a)))) (vector-ref (vector-ref v 2) 3)) 'error)
(test (let ((v (vector 1 (list 2) (make-vector 3 #\a)))) (vector-ref (vector-ref v 3) 0)) 'error)
(test (vector-ref (vector) 0) 'error)
(test (vector-ref '#() 0) 'error)
(test (vector-ref '#() -1) 'error)
(test (vector-ref '#() 1) 'error)
(test (vector-ref #(1 2 3) (floor .1)) 1)
(test (vector-ref #(1 2 3) (floor 0+0i)) 1)
(test (vector-ref #10D((((((((((0 1)))))))))) 0 0 0 0 0 0 0 0 0 1) 1)

(test (#(1 2) 1) 2)
(test (#(1 2) 1 2) 'error)
(test ((#("hi" "ho") 0) 1) #\i)
(test (((vector (list 1 2) (cons 3 4)) 0) 1) 2)
(test ((#(#(1 2) #(3 4)) 0) 1) 2)
(test ((((vector (vector (vector 1 2) 0) 0) 0) 0) 0) 1)
(test ((((list (list (list 1 2) 0) 0) 0) 0) 0) 1)
(test ((((list (list (list 1 2) 0) 0) 0) 0) ((((vector (vector (vector 1 2) 0) 0) 0) 0) 0)) 2)
(test (#(1 2) -1) 'error)
(test (#()) 'error)
(test (#(1)) 'error)
(test (#2d((1 2) (3 4))) 'error)
(test (apply (make-vector '(1 2))) 'error)

(test (eval-string "#2/3d(1 2)") 'error)
(test (eval-string "#2.1d(1 2)") 'error)
(test (#(#(#(#t))) 0 0 0) #t)


(let ((v #(1 2 3)))
  (for-each
   (lambda (arg)
     ; (format *stderr* "~A~%" arg)
     (test (vector-ref arg 0) 'error)
     (test (v arg) 'error)
     (test (v arg 0) 'error)
     (test (vector-ref v arg) 'error)
     (test (vector-ref v arg 0) 'error)
     (test (vector-ref #2d((1 2) (3 4)) 0 arg) 'error))
   (list "hi" '() #() #\a -1 '(1 . 2) (cons #\a #\b) #f 'a-symbol abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	 3.14 3/4 1.0+1.0i #t (lambda (a) (+ a 1)) (make-hash-table))))


(test (vector-ref '#(#(1 2 3) #(4 5 6)) 1) '#(4 5 6))
(test (vector-ref '#(#(1 2 3) #(4 5 6)) 1 2) 6)
(test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1) '#(#(7 8 9) #(10 11 12)))
(test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0) '#(7 8 9))
(test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0 2) 9)
(test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0 3) 'error)
(test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0 2 0) 'error)

(test ('#(#(1 2 3) #(4 5 6)) 1) '#(4 5 6))
(test ('#(#(1 2 3) #(4 5 6)) 1 2) 6)
(test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1) '#(#(7 8 9) #(10 11 12)))
(test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0) '#(7 8 9))
(test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0 2) 9)
(test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0 3) 'error)
(test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) 1 0 2 0) 'error)

(test (let ((L '#(#(1 2 3) #(4 5 6)))) (L 1)) '#(4 5 6))
(test (let ((L '#(#(1 2 3) #(4 5 6)))) (L 1 2)) 6)
(test (let ((L '#(#(1 2 3) #(4 5 6)))) (L 1 2 3)) 'error)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L 1)) '#(#(7 8 9) #(10 11 12)))
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L 1 0)) '#(7 8 9))
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L 1 0 2)) 9)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L 1 0 2 3)) 'error)

(test (let ((L '#(#(1 2 3) #(4 5 6)))) ((L 1) 2)) 6)
(test (let ((L '#(#(1 2 3) #(4 5 6)))) (((L 1) 2) 3)) 'error)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((L 1) 0)) '#(7 8 9))
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (((L 1) 0) 2)) 9)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((L 1 0) 2)) 9)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((L 1) 0 2)) 9)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((((L 1) 0) 2) 3)) 'error)

(test (let ((L '#(#(1 2 3) #(4 5 6)))) (vector-ref (L 1) 2)) 6)
(test (let ((L '#(#(1 2 3) #(4 5 6)))) (vector-ref ((L 1) 2) 3)) 'error)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (vector-ref (L 1) 0)) '#(7 8 9))
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((vector-ref (L 1) 0) 2)) 9)
(test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (vector-ref (((L 1) 0) 2) 3)) 'error)


(let ((zero 0)
      (one 1)
      (two 2)
      (three 3)
      (thirty-two 32))
  (test (vector-ref '#(#(1 2 3) #(4 5 6)) one) '#(4 5 6))
  (test (vector-ref '#(#(1 2 3) #(4 5 6)) one two) 6)
  (test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) one) '#(#(7 8 9) #(10 11 12)))
  (test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) one zero) '#(7 8 9))
  (test (vector-ref '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) one zero two) 9)
  
  (test ('#(#(1 2 3) #(4 5 6)) one) '#(4 5 6))
  (test ('#(#(1 2 3) #(4 5 6)) one two) 6)
  (test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) one) '#(#(7 8 9) #(10 11 12)))
  (test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) one zero) '#(7 8 9))
  (test ('#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))) one zero two) 9)
  
  (test (let ((L '#(#(1 2 3) #(4 5 6)))) (L one)) '#(4 5 6))
  (test (let ((L '#(#(1 2 3) #(4 5 6)))) (L one two)) 6)
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L one)) '#(#(7 8 9) #(10 11 12)))
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L one zero)) '#(7 8 9))
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (L one zero two)) 9)
  
  (test (let ((L '#(#(1 2 3) #(4 5 6)))) ((L one) two)) 6)
  (test (let ((L '#(#(1 2 3) #(4 5 6)))) (((L one) two) 3)) 'error)
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((L one) zero)) '#(7 8 9))
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (((L one) zero) two)) 9)
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((L one zero) two)) 9)
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((L one) zero two)) 9)
  
  (test (let ((L '#(#(1 2 3) #(4 5 6)))) (vector-ref (L one) two)) 6)
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) (vector-ref (L one) zero)) '#(7 8 9))
  (test (let ((L '#(#(#(1 2 3) #(4 5 6)) #(#(7 8 9) #(10 11 12))))) ((vector-ref (L one) zero) two)) 9))

(test ((#(#(:hi) #\a (3)) (#("hi" 2) 1)) (#2d((#() ()) (0 #(0))) 1 ('(cons 0) 1))) 3)
(test (#(1 2 3) (#(1 2 3) 1)) 3)
(test ((#(#(1 2)) (#(1 0) 1)) (#(3 2 1 0) 2)) 2)
(test (apply min (#(1 #\a (3)) (#(1 2) 1))) 3) ; i.e vector ref here 2 levels -- (#(1 2) 1) is 2 and (#(1 #\a (3)) 2) is (3) 

(define global_vector (vector 1 2 3)) ; opt check
(let ()
  (define (hi i) (vector-ref global_vector i))
  (test (hi 1) 2))
(let ()
  (define (hi i) (vector-ref global_vector (vector-ref global_vector i)))
  (test (hi 0) 2))
