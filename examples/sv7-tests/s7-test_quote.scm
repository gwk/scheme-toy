(test (quote a) 'a)
(test 'a (quote a))
(test '1 1)
(test '1/4 1/4)
(test '(+ 2 3) '(+ 2 3))
(test '"hi" "hi")
(test '#\a #\a)
(test '#f #f)
(test '#t #t)
(test '#b1 1)
(test (= 1/2 '#e#b1e-1) #t)
(test '() '())
(test '(1 . 2) (cons 1 2))
(test #(1 2) '#(1 2))
(test (+ '1 '2) 3)
(test (+ '1 '2) '3)
(test (+ ' 1 '   2) '    3)
(test (char? '#\a) #t)
(test (string? '"hi") #t)
(test (boolean? '#t) #t)
(test (if '#f 2 3) 3)
(test (if '#t 2 3) 2)
(test (vector? '#()) #t)
(test (char? (quote #\a)) #t)
(test (string? (quote "hi")) #t)
(test (boolean? (quote #t)) #t)
(test (if (quote #f) 2 3) 3)
(test (if (quote #t) 2 3) 2)
(test (vector? (quote #())) #t)
(test (+ (quote 1) (quote 2)) (quote 3))
(test (list? (quote ())) #t)
(test (pair? (quote (1 . 2))) #t)
(test (+ '1.0 '2.0) 3.0)
(test (+ '1/2 '3/2) 2)
(test (+ '1.0+1.0i '-2.0) -1.0+1.0i)
(test (let ((hi 2)) (equal? hi 'hi)) #f)
(test ''1 (quote (quote 1)))
(test ''a (quote (quote a)))
(test (symbol? '#f) #f)
(test (symbol? '.') #t)
(test ''quote (quote (quote quote)))
(test (+ (cadr ''3) (cadadr '''4) (cadr (cadr (cadr ''''5)))) 12)
(test (+ (cadr ' '   3) (cadadr '  
  '    ' 4)) 7)
(test (+ '#| a comment |#2 3) 5)
(test (+ ' #| a comment |# 2 3) 5)
(test (eq? lambda 'lambda) #f)
(test (equal? + '+) #f)
(test (eq? '() ()) #t) ; s7 specific

(test (quote) 'error)
(test (quote . -1) 'error)
(test (quote 1 1) 'error)
(test (quote . 1) 'error)
(test (quote . (1 2)) 'error)
(test (quote 1 . 2) 'error)
(test (symbol? '1'1) #t) 
(test (apply '+ (list 1 2)) 'error)
(test ((quote . #\h) (2 . #\i)) 'error)
(test ((quote "hi") 1) #\i)

(test (equal? '(1 2 '(3 4)) '(1 2 (3 4))) #f)
(test (equal? '(1 2 '(3 4)) (quote (list 1 2 (quote (list 3 4))))) #f)
(test (equal? (list-ref '(1 2 '(3 4)) 2) '(3 4)) #f)
(test (equal? '(1 2 '(3 4)) (list 1 2 (list 'quote (list 3 4)))) #t)
(test (equal? '(1 2 ''(3 4)) (list 1 2 (list 'quote (list 'quote (list 3 4))))) #t)
(test (equal? '('3 4) (list (list 'quote 3) 4)) #t)
(test (equal? '('3 4) (list 3 4)) #f)
(test (equal? '('() 4) (list (list 'quote '()) 4)) #t)
(test (equal? '('('4)) (list (list quote (list (list quote 4))))) #f)
(test (equal? '('('4)) (list (list 'quote (list (list 'quote 4))))) #t) 
(test (equal? '('('4)) '((quote ((quote 4))))) #t)
(test (equal? '1 ''1) #f)
(test (equal? ''1 ''1) #t)
(test (equal? '(1 '(1 . 2)) (list 1 (cons 1 2))) #f)
(test (equal? #(1 #(2 3)) '#(1 '#(2 3))) #f)
(test (equal? #(1) #('1)) #f)
(test (equal? #(()) #('())) #f)
(test (equal? cons 'cons) #f)

(test (eqv? #\a (quote #\a)) #t)
(test (eqv? 1 (quote 1)) #t)
(test (eqv? 0 (quote 0)) #t)
(test (equal? #(1 2 3) (quote #(1 2 3))) #t)
(test (eqv? 3.14 (quote 3.14)) #t)
(test (eqv? 3/4 (quote 3/4)) #t)
(test (eqv? 1+1i (quote 1+1i)) #t)
(test (eq? #f (quote #f)) #t)
(test (eq? #t (quote #t)) #t)
(test (eq? '() (quote ())) #t)
(test (equal? '(1 2 3) (quote (1 2 3))) #t)
(test (equal? '(1 . 2) (quote (1 . 2))) #t)
(test ('abs -1) 'error)
(test ('"hi" 0) #\h)

(test (''begin 1) 'begin)
(test (''let ((x 1)) ('set! x 3) x) 'error)
(test ('and #f) 'error)
(test ('and 1 #f) 'error)
(test ('begin 1) 'error)
(test ('cond ('define '#f)) 'error)
(test ('let ((x 1)) ('set! x 3) x) 'error)
(test ('let* () ('define x 3) x) 'error)
(test ('or #f) 'error)
(test ('quote 3) 'error)
(test ((copy quote) 1) 1)
(test ((copy quote) quote) 'quote)
(test ((lambda (q) (let ((x 1)) (q x))) quote) 'x) ; these two are strange -- not sure about them, but Guile 1.8 is the same
(test ((lambda (s c) (s c)) quote #f) 'c)
;;; ((lambda (lambda) (lambda (else))) quote) -> '(else)
(test ((quote and) #f) 'error)
(test ((values quote) 1) 1)

;; see also quasiquote
