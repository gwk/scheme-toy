(for-each
 (lambda (arg)
   (eval-string (format #f "(define (func) ~S)" arg))
   (let ((source (procedure-source func)))
     (let ((val (func)))
       (test val arg))))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) ':hi "hi"))

(for-each
 (lambda (arg)
   (test (procedure-source arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi :hi '#(()) (list 1 2 3) '(1 . 2) "hi"))

(test (let ((hi (lambda (x) (+ x 1)))) (procedure-source hi)) '(lambda (x) (+ x 1)))
(test (procedure-source) 'error)
(test (procedure-source abs abs) 'error)
(test (procedure-source quasiquote) 'error)
;(test (let () (define-macro (hi a) `(+ 1 ,a)) (cadr (caddr (procedure-source hi)))) '(lambda (a) ({list} '+ 1 a)))

(let ()
  (define (hi a) (+ a x))
  (test ((apply let '((x 32)) (list (procedure-source hi))) 12) 44))
;; i.e. make a closure from (let ((x 32)) <procedure-source hi>)

(let ()
  (define (arg-info f n) 
    ((procedure-source f) 1 n 1 0 2)) ; get the documentation string of f's n-th argument

  (define* (add-1 (arg ((lambda () "arg should be an integer" 0)))) 
    (+ arg 1))          ; the default value of arg is 0

  (test (add-1) 1)
  (test (add-1 1) 2)

  (test (arg-info add-1 0) "arg should be an integer"))
