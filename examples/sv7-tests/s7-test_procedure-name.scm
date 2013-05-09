(test (let () (define (hi a) a) (procedure-name hi)) "hi")
(test (let () (define (hi a) a) (procedure-name 'hi)) "hi")
(test (procedure-name abs) "abs")
(test (procedure-name 'abs) "abs")
(test (procedure-name quasiquote) "quasiquote")
(test (procedure-name -s7-symbol-table-locked?) "-s7-symbol-table-locked?")
(test (let ((a abs)) (procedure-name a)) "abs")
(test (let () (define hi (make-procedure-with-setter (lambda (a) a) (lambda (a b) a))) (procedure-name hi)) "hi")
(test (let () (define* (hi (a 1)) a) (let ((b #f)) (set! b hi) (procedure-name b))) "hi")
(for-each
 (lambda (arg)
   (test (procedure-name arg) 'error))
 (list -1 #\a #f _ht_ 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() #(()) (list 1 2 3) '(1 . 2) "hi"))

(if (defined? '1+) (test (procedure-name 1+) "1+"))
(if (defined? 'identity) (test (procedure-name identity) "identity"))
(test (procedure-name cddr-1) "cddr-1")
(test (cddr-1 '(1 2 3 4)) (cddr '(1 2 3 4)))
(test (procedure-name cddr) "cddr")
(test (let () (define-macro (hiho a) `(+ ,a 1)) (procedure-name hiho)) "")