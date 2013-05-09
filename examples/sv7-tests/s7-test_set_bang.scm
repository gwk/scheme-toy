(test (let ((a 1)) (set! a 2) a) 2)
(for-each
 (lambda (arg)
   (test (let ((a 0)) (set! a arg) a) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t (list 1 2 3) '(1 . 2)))

(test (let ((a 1)) (call/cc (lambda (r) (set! a (let () (if (= a 1) (r 123)) 321)))) a) 1)
(test (let ((a (lambda (b) (+ b 1)))) (set! a (lambda (b) (+ b 2))) (a 3)) 5)
(test (let ((a (lambda (x) (set! x 3) x))) (a 1)) 3)

(test (let ((x (vector 1 2 3))) (set! (x 1) 32) x) #(1 32 3))
(test (let* ((x (vector 1 2 3))
	     (y (lambda () x)))
	(set! ((y) 1) 32)
	x)
      #(1 32 3))
(test (let* ((x (vector 1 2 3))
	     (y (lambda () x))
	     (z (lambda () y)))
	(set! (((z)) 1) 32)
	x)
      #(1 32 3))

(test (let ((a 1)) (set! a)) 'error)
(test (let ((a 1)) (set! a 2 3)) 'error)
(test (let ((a 1)) (set! a . 2)) 'error)
(test (let ((a 1)) (set! a 1 . 2)) 'error)
(test (let ((a 1)) (set! a a) a) 1)
(test (set! "hi" 1) 'error)
(test (set! 'a 1) 'error)
(test (set! 1 1) 'error)
(test (set! (list 1 2) 1) 'error)
(test (set! (let () 'a) 1) 'error)
(test (set!) 'error)
(test (set! #t #f) 'error)
(test (set! '() #f) 'error)
(test (set! #(1 2 3) 1) 'error)
(test (set! (call/cc (lambda (a) a)) #f) 'error)
(test (set! 3 1) 'error)
(test (set! 3/4 1) 'error)
(test (set! 3.14 1) 'error)
(test (set! #\a 12) 'error)
(test (set! (1 2) #t) 'error)
(test (set! _not_a_var_ 1) 'error)
(test (set! (_not_a_pws_) 1) 'error)
(test (let ((x 1)) (set! ((lambda () 'x)) 3) x) 'error)
(test (let ((x '(1 2 3))) (set! (((lambda () 'x)) 0) 3) x) '(3 2 3))
(test (let ((x '(1 2 3))) (set! (((lambda () x)) 0) 3) x) '(3 2 3)) ; ?? 
(test (let ((x '(1 2 3))) (set! ('x 0) 3) x) '(3 2 3)) ; ???  I suppose that's similar to
(test (let ((x '((1 2 3)))) (set! ((car x) 0) 3) x) '((3 2 3)))
(test (let ((x '((1 2 3)))) (set! ('(1 2 3) 0) 32) x) '((1 2 3))) ; this still looks wrong... (expands to (list-set! '(1 2 3) 0 3) I guess)

(test (let ((a (lambda (x) (set! a 3) x))) (list (a 1) a)) 'error)
(test (let ((a (let ((b 1)) (set! a 3) b))) a) 'error)            
(test (let ((a (lambda () "hi"))) (set! (a) "ho")) 'error)
(test (let ((a (let ((b 1)) (set! a 3) b))) a) 'error) 

(test (set! . -1) 'error)
(test (set!) 'error)
(test (let ((x 1)) (set! x x x)) 'error)
(test (let ((x 1)) (set! x x) x) 1)
(test (set! set! 123) 'error)
(test (set! (cons 1 2) 3) 'error)
(test (let ((var 1) (val 2)) (set! var set!) (var val 3) val) 3)
(test (let ((var 1) (val 2)) (set! var +) (var val 3)) 5)
(test (let ((sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 1)
	    (sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456780 3))
	(set! sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 2)
	sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789)
      2)

(test (let ((x '(1)) (y '(2))) (set! ((if #t x y) 0) 32) x) '(32))
(test (let ((hi 0)) (set! hi 32)) 32)
(test (let ((hi 0)) ((set! hi ('((1 2) (3 4)) 0)) 0)) 1)

(test (set! #<undefined> 1) 'error)
(test (set! #<eof> 1) 'error)
(test (set! #<unspecified> 1) 'error)
(test (let ((x 0)) (define-macro (hi) 'x) (set! (hi) 3) x) 'error)

(test (set! ("hi" . 1) #\a) 'error)
(test (set! (#(1 2) . 1) 0) 'error)
(test (set! ((1 . 2)) 3) 'error)
(test (let ((lst (list 1 2))) (set! (lst . 0) 3) lst) 'error)
(test (let ((lst (list 1 2))) (set! (list-ref lst . 1) 2)) 'error)
(test (let ((v #2d((1 2) (3 4)))) (set! (v 0 . 0) 2) v) 'error)
(test (set! ('(1 2) . 0) 1) 'error)
(test (set! ('(1 2) 0) 3) 3)
(test (set! (''(1 . 2)) 3) 'error)
(test (set! (''(1 2)) 3) 'error)
(test (set! ('(1 . 2)) 3) 'error)
(test (set! ('(1 2)) 3) 'error)
(test (set! (''(1 2) 0 0) 3) 'error)
(test (set! (#(1 2) 0 0) 3) 'error)
(test (let ((x 1)) (set! (quasiquote . x) 2) x) 'error)
(test (let ((x 1)) (set! (quasiquote x) 2) x) 'error)
(test (set! `,(1) 3) 'error)
(test (set! (1) 3) 'error)
(test (set! `,@(1) 3) 'error)
(test (let ((x 0)) (set! x 1 . 2)) 'error)
(test (let ((x 0)) (apply set! x '(3))) 'error) ; ;set!: can't alter immutable object: 0
(test (let ((x 0)) (apply set! 'x '(3)) x) 3)
(test (set! (#(a 0 (3)) 1) 0) 0)
(test (set! ('(a 0) 1) 0) 0)
(test (apply set! (apply list (list ''(1 2 3) 1)) '(32)) 32)

(let ()
  (define-macro (symbol-set! var val) `(apply set! ,var (list ,val))) ; but this evals twice
  (test (let ((x 32) (y 'x)) (symbol-set! y 123) (list x y)) '(123 x)))
(let ()
  (define-macro (symbol-set! var val) ; like CL's set
    `(apply set! ,var ',val ()))
  (test (let ((var '(+ 1 2)) (val 'var)) (symbol-set! val 3) (list var val)) '(3 var))
  (test (let ((var '(+ 1 2)) (val 'var)) (symbol-set! val '(+ 1 3)) (list var val)) '((+ 1 3) var)))

(test (set! ('(1 2) 1 . 2) 1) 'error)
(test (set! ('((1 2) 1) () . 1) 1) 'error)
(test (set! ('(1 1) () . 1) 1) 'error)

(test (let () (define (hi) (let ((x 1000)) (set! x (+ x 1)) x)) (hi) (hi)) 1001)
(test (let () (define (hi) (let ((x 1000.5)) (set! x (+ x 1)) x)) (hi) (hi)) 1001.5)
(test (let () (define (hi) (let ((x 3/2)) (set! x (+ x 1)) x)) (hi) (hi)) 5/2)
(test (let () (define (hi) (let ((x 3/2)) (set! x (- x 1)) x)) (hi) (hi)) 1/2)
(test (let () (define (hi) (let ((x 3/2)) (set! x (- x 2)) x)) (hi) (hi)) -1/2)
(test (let () (define (hi) (let ((x "asdf")) (set! x (+ x 1)) x)) (hi) (hi)) 'error)
