(test (eval-string "(list #b)") 'error)
(test (eval-string "(char? #\\spaces)") 'error)
(test (eval-string "(car '( . 1))") 'error)
(test (eval-string "(car '(. ))") 'error)
(test (eval-string "(car '( . ))") 'error)
(test (eval-string "(car '(. . . ))") 'error)
(test (eval-string "'#( . 1)") 'error)
(test (eval-string "'(1 2 . )") 'error)
(test (eval-string "'#(1 2 . )") 'error)
(test (eval-string "#'(1 2)") 'error)
(test (eval-string "#`(1 2)") 'error)
(test (eval-string "#,(1 2)") 'error)
(test (eval-string "#`,(1 2)") 'error)
(test (eval-string "#1(2)") 'error)
(test (eval-string "(+ 1 . . )") 'error)
(test (eval-string "(car '(1 . ))") 'error)
(test (eval-string "(car '(1 . . 2))") 'error)
(test (eval-string "'#( . )") 'error)
(test (eval-string "'#(1 . )") 'error)
(test (eval-string "'#(. . . )") 'error)
(test (eval-string "'#(1 . . 2)") 'error)
(test (eval-string "'(. 1)") 'error)
(test (eval-string "'#(. 1)") 'error)
(test (eval-string "'(. )") 'error)
(test (eval-string "'#(. )") 'error)
(test (eval-string "(list 1 . 2)") 'error)
(test (eval-string "(+ 1 . 2)") 'error)
(test (eval-string "(car '@#`')") 'error)
(test (eval-string "(list . )") 'error)
(test (eval-string "'#( .)") 'error)
(test (eval-string "(car '( .))") 'error)
(test (eval-string "(let ((. 3)) .)") 'error)
(test (eval-string "#0d()") 'error)
(test (eval-string "`#0d()") 'error)
(test (eval-string "'#t:") 'error) ; guile interprets this as #t : and complains unbound variable :
(test (eval-string "#t1") 'error)  ;   similarly this is #t 1 in guile
(test (eval-string "'#(1 . 2)") 'error)
(test (eval-string "#(1 2 . 3)") 'error)
(test (eval-string "'#'") 'error)
(test (eval-string "#b") 'error)

(test (eval-string "(+ 1 2)") 3)
(test (eval '(+ 1 2)) 3)
(test (eval `(+ 1 (eval `(* 2 3)))) 7)
(test (eval `(+ 1 (eval-string "(* 2 3)"))) 7)
(test (eval-string "(+ 1 (eval-string \"(* 2 3)\"))") 7)
(test (eval `(+ 1 2 . 3)) 'error)
(test (eval-string) 'error)
(test (eval) 'error)
(test (eval-string "") #f)
(test (eval ()) ())
(test (eval '()) '())
(test (eval-string "1" () ()) 'error)
(test (eval () () ()) 'error)
(test (eval "1") "1")
(test (eval-string #t) 'error)
(test (eval #(+ 1 2)) #(+ 1 2))

(let () (define e1 (let ((a 10)) (current-environment))) (test (eval 'a e1) 10)) ; from andy wingo
(let () (define e1 (let ((a 10)) (current-environment))) (eval '(set! a 32) e1) (test (eval 'a e1) 32))

(test (eval '(begin (define __eval_var__ 1) __eval_var__) (global-environment)) 1)
(test (let () __eval_var__) 1)
(test (eval-string "(begin (define __eval_var1__ 12) __eval_var1__)" (global-environment)) 12)
(test (let () __eval_var1__) 12)
(test (let () (eval '(begin (define __eval_var2__ 123) __eval_var__) (current-environment)) __eval_var2__) 123)
(test (let () __eval_var2__) 'error)

;; from scheme wg
(let ((x (list 'cons 1 2))
      (y (list (list 'quote 'cons) 1 2)))
  (set-car! x cons) 
  (set-car! (cdar y) cons)
  (test (eval x) (eval y)))
(test (eval (list 'cons 1 2)) (eval (list cons 1 2)))
(let ((f (lambda (a) (+ a 1))))
  (test (eval (list 'f 2)) (eval (list f 2))))

(test (apply "hi" 1 ()) #\i)
(test (eval ("hi" 1)) #\i)
(test (apply + 1 1 (cons 1 (quote ()))) 3)
(test (eq? (eval (quote (quote ()))) ()) #t)
(test (apply (cons (quote cons) (cons 1 (quote ((quote ()))))) 1 ()) 1) ; essentially ((list 'cons 1 ...) 1) => 1
(test (eval ((cons (quote cons) (cons 1 (quote ((quote ()))))) 1)) 1)
(test (eval (eval (list '+ 1 2))) 3)

(test (eval if) if)
(test (eval quote) quote)
(test (eval (eval (list define* #(1)))) 'error)
(test (eval (eval (list lambda* ()))) 'error)
(test (eval (eval (list letrec "hi"))) 'error)
(test (eval (eval (cons defmacro 1))) 'error)
(test (eval (eval (cons quote "hi"))) 'error)
(test (eval (eval (list and "hi"))) "hi")

(test (apply + (+ 1) ()) 1)
(test (apply #(1) (+) ()) 1)
(test (apply + (+) ()) 0)
(test (eval #()) #())
(test (apply (lambda () #f)) #f)
(test (eval '(if #f #f)) (if #f #f))
(test (let ((ho 32)) (symbol? (eval (eval (eval (eval '''''ho)))))) #t)
(test (eval '(case 0 ((1) 2) ((0) 1))) 1)
(test (eval '(cond ((= 1 2) 3) (#t 4))) 4)

(test (eval-string (string-append "(list 1 2 3)" (string #\newline) (string #\newline))) (list 1 2 3))
(eval-string (string-append "(define evalstr_1 32)" (string #\newline) "(define evalstr_2 2)"))
(test (eval-string "(+ evalstr_1 evalstr_2)") 34)
(eval-string (string-append "(set! evalstr_1 3)" "(set! evalstr_2 12)"))
(test (eval-string "(+ evalstr_1 evalstr_2)") 15)

(test (+ (eval `(values 1 2 3)) 4) 10)
(test (+ (eval-string "(values 1 2 3)") 4) 10)
(test (+ 1 (eval-string "(+ 2 3)") 4) 10)
(test ((eval-string "(lambda (a) (+ a 1))") 2) 3)
(test (eval ((eval-string "(lambda (a) (list '+ a 1))") 2)) 3)
(test (eval-string "(+ 1 (eval (list '+ 1 2)))") 4)

(for-each
 (lambda (arg)
   (test (eval-string arg) 'error))
 (list -1 0 1 512 #\a '#(1 2 3) 3.14 2/3 1.5+0.3i 1+i '() 'hi :hi abs '#(()) (list 1 2 3) '(1 . 2) (lambda () 1)))
(for-each
 (lambda (arg)
   (test (eval-string "(+ 1 2)" arg) 'error))
 (list -1 0 1 512 #\a '#(1 2 3) 3.14 2/3 1.5+0.3i 1+i 'hi abs "hi" :hi '#(()) (lambda () 1)))


(test (let () (defmacro hiho (a) `(+ ,a 1)) (hiho 3)) 4)
(test (let () (defmacro hiho () `(+ 3 1)) (hiho)) 4)
(test (let () (defmacro hiho () `(+ 3 1)) (hiho 1)) 'error)
(test (let () (defmacro hi (a) `(+ ,@a)) (hi (1 2 3))) 6)
(test (let () (defmacro hi (a) `(+ ,a 1) #f) (hi 2)) #f)

(test (let () (define-macro (hiho a) `(+ ,a 1)) (hiho 3)) 4)
(test (let () (define-macro (hiho) `(+ 3 1)) (hiho)) 4)
(test (let () (define-macro (hiho) `(+ 3 1)) (hiho 1)) 'error)
(test (let () (define-macro (hi a) `(+ ,@a)) (hi (1 2 3))) 6)
(test (let () (define-macro (hi a) `(+ ,a 1) #f) (hi 2)) #f)
(test (let () (define-macro (mac1 a) `',a) (equal? (mac1 (+ 1 2)) '(+ 1 2))) #t)
(test (let () (define-macro (hi . a) `,@a) (hi 1)) 1)

(test (let () (defmacro hi (a) `(+ , a 1)) (hi 1)) 2)
(test (let () (defmacro hi (a) `(eval `(+ ,,a 1))) (hi 1)) 2)
(test (let () (defmacro hi (a) `(eval (let ((a 12)) `(+ ,,a 1)))) (hi 1)) 2)
(test (let () (defmacro hi (a) `(eval (let ((a 12)) `(+ ,a 1)))) (hi 1)) 13)
(test (let () (defmacro hi (a) `(eval (let ((a 12)) `(let ((a 100)) (+ ,a 1))))) (hi 1)) 13)
(test (let () (defmacro hi (a) `(eval (let ((a 12)) `(let ((a 100)) (+ a 1))))) (hi 1)) 101)

(test (let () (defmacro hi (q) ``(,,q)) (hi (* 2 3))) '(6))
(test (let () (defmacro hi (q) `(let ((q 32)) `(,,q))) (hi (* 2 3))) '(6))
(test (let () (defmacro hi (q) `(let ((q 32)) `(,q))) (hi (* 2 3))) '(32))
(test (let () (defmacro hi (q) `(let () ,@(list q))) (hi (* 2 3))) 6)

(test (let () (define-macro (tst a) ``(+ 1 ,,a)) (tst 2)) '(+ 1 2))
(test (let () (define-macro (tst a) ```(+ 1 ,,,a)) (eval (tst 2))) '(+ 1 2))
(test (let () (define-macro (tst a) ``(+ 1 ,,a)) (tst (+ 2 3))) '(+ 1 5))
(test (let () (define-macro (tst a) ``(+ 1 ,@,a)) (tst '(2 3))) '(+ 1 2 3))
(test (let () (define-macro (tst a) ``(+ 1 ,,@a)) (tst (2 3))) '(+ 1 2 3))
(test (let () (define-macro (tst a) ```(+ 1 ,,,@a)) (eval (tst (2 3)))) '(+ 1 2 3))
(test (let () (define-macro (tst a) ```(+ 1 ,,@,@a)) (eval (tst ('(2 3))))) '(+ 1 2 3))
(test (let () (define-macro (tst a) ````(+ 1 ,,,,@a)) (eval (eval (eval (tst (2 3)))))) 6)
(test (let () (define-macro (tst a) ``(+ 1 ,@,@a)) (tst ('(2 3)))) '(+ 1 2 3))
(test (let () (define-macro (tst a b) `(+ 1 ,a (apply * `(2 ,,@b)))) (tst 3 (4 5))) 44)
(test (let () (define-macro (tst . a) `(+ 1 ,@a)) (tst 2 3)) 6)
(test (let () (define-macro (tst . a) `(+ 1 ,@a (apply * `(2 ,,@a)))) (tst 2 3)) 18)
(test (let () (define-macro (tst a) ```(+ 1 ,@,@,@a)) (eval (tst ('('(2 3)))))) '(+ 1 2 3))

(test (let () (define-macro (hi a) `(+ ,a 1)) (procedure? hi)) #f)
(test (let () (define-macro (hi a) `(let ((@ 32)) (+ @ ,a))) (hi @)) 64)
(test (let () (define-macro (hi @) `(+ 1 ,@@)) (hi (2 3))) 6) ; ,@ is ambiguous
(test (let () (define-macro (tst a) `(+ 1 (if (> ,a 0) (tst (- ,a 1)) 0))) (tst 3)) 4)
(test (let () (define-macro (hi a) (if (list? a) `(+ 1 ,@a) `(+ 1 ,a))) (* (hi 1) (hi (2 3)))) 12)

(test (let ((x 1)) (eval `(+ 3 ,x))) 4)
(test (let ((x 1)) (eval (eval `(let ((x 2)) `(+ 3 ,x ,,x))))) 6)
(test (let ((x 1)) (eval (eval (eval `(let ((x 2)) `(let ((x 3)) `(+ 10 ,x ,,x ,,,x))))))) 16)
(test (let ((x 1)) (eval (eval (eval (eval `(let ((x 2)) `(let ((x 3)) `(let ((x 30)) `(+ 100 ,x ,,x ,,,x ,,,,x))))))))) 136)

(test (let () (define-bacro (hiho a) `(+ ,a 1)) (hiho 3)) 4)
(test (let () (define-bacro (hiho) `(+ 3 1)) (hiho)) 4)
(test (let () (define-bacro (hiho) `(+ 3 1)) (hiho 1)) 'error)
(test (let () (define-bacro (hi a) `(+ ,@a)) (hi (1 2 3))) 6)
(test (let () (define-bacro (hi a) `(+ ,a 1) #f) (hi 2)) #f)
(test (let () (define-bacro (mac1 a) `',a) (equal? (mac1 (+ 1 2)) '(+ 1 2))) #t)
(test (let () (define-bacro (tst a) ``(+ 1 ,,a)) (tst 2)) '(+ 1 2))
(test (let () (define-bacro (tst a) ```(+ 1 ,,,a)) (eval (tst 2))) '(+ 1 2))
(test (let () (define-bacro (tst a) ``(+ 1 ,,a)) (tst (+ 2 3))) '(+ 1 5))
(test (let () (define-bacro (tst a) ``(+ 1 ,@,a)) (tst '(2 3))) '(+ 1 2 3))
(test (let () (define-bacro (tst a) ``(+ 1 ,,@a)) (tst (2 3))) '(+ 1 2 3))
(test (let () (define-bacro (tst a) ```(+ 1 ,,,@a)) (eval (tst (2 3)))) '(+ 1 2 3))
(test (let () (define-bacro (tst a) ```(+ 1 ,,@,@a)) (eval (tst ('(2 3))))) '(+ 1 2 3))
(test (let () (define-bacro (tst a) ````(+ 1 ,,,,@a)) (eval (eval (eval (tst (2 3)))))) 6)
(test (let () (define-bacro (tst a) ``(+ 1 ,@,@a)) (tst ('(2 3)))) '(+ 1 2 3))
(test (let () (define-bacro (tst a b) `(+ 1 ,a (apply * `(2 ,,@b)))) (tst 3 (4 5))) 44)
(test (let () (define-bacro (tst . a) `(+ 1 ,@a)) (tst 2 3)) 6)
(test (let () (define-bacro (tst . a) `(+ 1 ,@a (apply * `(2 ,,@a)))) (tst 2 3)) 18)
(test (let () (define-bacro (tst a) ```(+ 1 ,@,@,@a)) (eval (tst ('('(2 3)))))) '(+ 1 2 3))
(test (let () (define-bacro (hi a) `(+ ,a 1)) (procedure? hi)) #f)
(test (let () (define-bacro (hi a) `(let ((@ 32)) (+ @ ,a))) (hi @)) 64)
(test (let () (define-bacro (hi @) `(+ 1 ,@@)) (hi (2 3))) 6) ; ,@ is ambiguous
(test (let () (define-bacro (tst a) `(+ 1 (if (> ,a 0) (tst (- ,a 1)) 0))) (tst 3)) 4)
(test (let () (define-bacro (hi a) (if (list? a) `(+ 1 ,@a) `(+ 1 ,a))) (* (hi 1) (hi (2 3)))) 12)

(test (let () (define-bacro (hiho a) `(+ ,a 1)) (macro? hiho)) #t)
(test (let () (define-bacro* (hiho (a 1)) `(+ ,a 1)) (macro? hiho)) #t)
(test (let () (define-macro (hiho a) `(+ ,a 1)) (macro? hiho)) #t)
(test (let () (define-macro* (hiho (a 1)) `(+ ,a 1)) (macro? hiho)) #t)

#|
(define-macro (when test . body)
  `((apply lambda (list '(test) '(if test (let () ,@body)))) ,test))

(define-macro (when test . body)
  `(if ,test (let () ,@body)))

(define-macro (when test . body)
  `((lambda (test) (if test (let () ,@body))) ,test))

(define-macro (when test . body)
  `(let ((func (apply lambda `(() ,,@body))))
     (if ,test (func))))
|#

(test (defmacro) 'error)
(test (define-macro) 'error)
(test (defmacro 1 2 3) 'error)
(test (define-macro (1 2) 3) 'error)
(test (defmacro a) 'error)
(test (define-macro (a)) 'error)
(test (defmacro a (1) 2) 'error)
(test (define-macro (a 1) 2) 'error)
(test (defmacro . a) 'error)
(test (define-macro . a) 'error)
(test (define :hi 1) 'error)
(test (define hi: 1) 'error)
(test (define-macro (:hi a) `(+ ,a 1)) 'error)
(test (defmacro :hi (a) `(+ ,a 1)) 'error)
(test (defmacro hi (1 . 2) 1) 'error)
(test (defmacro hi 1 . 2) 'error)
(test (defmacro : "" . #(1)) 'error)
(test (defmacro : #(1) . :) 'error)
(test (defmacro hi ()) 'error)
(test (define-macro (mac . 1) 1) 'error)
(test (define-macro (mac 1) 1) 'error)
(test (define-macro (a #()) 1) 'error)
(test (define-macro (i 1) => (j 2)) 'error)
(test (define hi 1 . 2) 'error)
(test (defmacro hi hi . hi) 'error)
(test (define-macro (hi hi) . hi) 'error)
(test (((lambda () (define-macro (hi a) `(+ 1 ,a)) hi)) 3) 4)

(test (let () (define-macro (hi a b) `(list ,@a . ,@b)) (hi (1 2) ((2 3)))) '(1 2 2 3))
(test (let () (define-macro (hi a b) `(list ,@a . ,b)) (hi (1 2) (2 3))) '(1 2 2 3))
(test (let () (define-macro (hi a b) `(list ,@a ,@b)) (hi (1 2) (2 3))) '(1 2 2 3))


(let ((vals #(0 0)))
  
#|
  (let ()
      (define (hi a) (+ 1 a))
      (define (use-hi b) (hi b))
      (set! (vals 0) (use-hi 1))
      (define (hi a) (+ 2 a))
      (set! (vals 1) (use-hi 1))
      (test vals #(2 3))) ; hmmm, or possibly #(2 2)... see comment above (line 13494 or thereabouts)
|#

  (let ()
    (defmacro hi (a) `(+ 1 ,a))
    (define (use-hi b) (hi b))
    (set! (vals 0) (use-hi 1))
    (defmacro hi (a) `(+ 2 ,a))
    (set! (vals 1) (use-hi 1))
    (test vals #(2 3)))
  (let ()
    (define (use-hi b) (hhi b))
    (defmacro hhi (a) `(+ 1 ,a))
    (set! (vals 0) (use-hi 1))
    (defmacro hhi (a) `(+ 2 ,a))
    (set! (vals 1) (use-hi 1))
    (test vals #(2 3))))

(test (let ()
	(define-macro (hanger name-and-args)
	  `(define ,(car name-and-args)
	     (+ ,@(map (lambda (arg) arg) (cdr name-and-args)))))
	(hanger (hi 1 2 3))
	hi)
      6)
(test (let ()
	(define-macro (hanger name-and-args)
	  `(define-macro (,(car name-and-args))
	     `(+ ,@(map (lambda (arg) arg) (cdr ',name-and-args)))))
	(hanger (hi 1 2 3))
	(hi))
      6)

(let ()
  ;; inspired by Doug Hoyte, "Let Over Lambda"
  (define (mcxr path lst)
    (define (cxr-1 path lst)
      (if (null? path)
	  lst
	  (if (char=? (car path) #\a)
	      (cxr-1 (cdr path) (car lst))
	      (cxr-1 (cdr path) (cdr lst)))))
    (let ((p (string->list (symbol->string path))))
      (if (char=? (car p) #\c)
	  (set! p (cdr p)))
      (let ((p (reverse p)))
	(if (char=? (car p) #\r)
	    (set! p (cdr p)))
	(cxr-1 p lst))))
  
  (test (mcxr 'cr '(1 2 3)) '(1 2 3))
  (test (mcxr 'cadddddddr '(1 2 3 4 5 6 7 8)) 8)
  (test (mcxr 'caadadadadadadadr '(1 (2 (3 (4 (5 (6 (7 (8))))))))) 8)
  
  (define-macro (cxr path lst)
    (let ((p (string->list (symbol->string path))))
      (if (char=? (car p) #\c)
	  (set! p (cdr p)))
      (let ((p (reverse p)))
	(if (char=? (car p) #\r)
	    (set! p (cdr p)))
	(let ((func 'arg))
	  (for-each
	   (lambda (f)
	     (set! func (list (if (char=? f #\a) 'car 'cdr) func)))
	   p)
	  `((lambda (arg) ,func) ,lst)))))
  
  (test (cxr car '(1 2 3)) 1)
  (test (cxr cadddddddr '(1 2 3 4 5 6 7 8)) 8)
  (test (cxr caadadadadadadadr '(1 (2 (3 (4 (5 (6 (7 (8))))))))) 8)
  )

;; this is the best of them!
(let ()
  (define-macro (c?r path)
    ;; here "path" is a list and "X" marks the spot in it that we are trying to access
    ;; (a (b ((c X)))) -- anything after the X is ignored, other symbols are just placeholders
    ;; c?r returns a function that gets X
    
    ;; maybe ... for cdr? (c?r (a ...);  right now it's using dot: (c?r (a . X)) -> cdr
    
    ;; (c?r (a b X)) -> caddr, 
    ;; (c?r (a (b X))) -> cadadr
    ;; ((c?r (a a a X)) '(1 2 3 4 5 6)) -> 4
    ;; ((c?r (a (b c X))) '(1 (2 3 4))) -> 4
    ;; ((c?r (((((a (b (c (d (e X)))))))))) '(((((1 (2 (3 (4 (5 6)))))))))) -> 6
    ;; ((c?r (((((a (b (c (X (e f)))))))))) '(((((1 (2 (3 (4 (5 6)))))))))) -> 4
    ;; (procedure-source (c?r (((((a (b (c (X (e f))))))))))) -> (lambda (lst) (car (car (cdr (car (cdr (car (cdr (car (car (car (car lst))))))))))))
    
    (define (X-marks-the-spot accessor tree)
      (if (pair? tree)
	  (or (X-marks-the-spot (cons 'car accessor) (car tree))
	      (X-marks-the-spot (cons 'cdr accessor) (cdr tree)))
	  (if (eq? tree 'X)
	      accessor
	      #f)))
    
    (let ((accessor (X-marks-the-spot '() path)))
      (if (not accessor)
	  (error "can't find the spot! ~A" path)
	  (let ((len (length accessor)))
	    (if (< len 5)                   ; it's a built-in function
		(let ((name (make-string (+ len 2))))
		  (set! (name 0) #\c)
		  (set! (name (+ len 1)) #\r)
		  (do ((i 0 (+ i 1))
		       (a accessor (cdr a)))
		      ((= i len))
		    (set! (name (+ i 1)) (if (eq? (car a) 'car) #\a #\d)))
		  (string->symbol name))
		(let ((body 'lst))          ; make a new function to find the spot
		  (for-each
		   (lambda (f)
		     (set! body (list f body)))
		   (reverse accessor))
		  `(lambda (lst) ,body)))))))
  
  (test ((c?r (a b X)) (list 1 2 3 4)) 3)
  (test ((c?r (a (b X))) '(1 (2 3) ((4)))) 3)
  (test ((c?r (a a a X)) '(1 2 3 4 5 6)) 4)
  (test ((c?r (a (b c X))) '(1 (2 3 4))) 4)
  (test ((c?r (((((a (b (c (d (e X)))))))))) '(((((1 (2 (3 (4 (5 6)))))))))) 6)
  (test ((c?r (((((a (b (c (X (e f)))))))))) '(((((1 (2 (3 (4 (5 6)))))))))) 4))

(let ()
  (define-macro (nested-for-each args func . lsts)
    (let ((body `(,func ,@args)))
      (for-each
       (lambda (arg lst)
	 (set! body `(for-each
		      (lambda (,arg)
			,body)
		      ,lst)))
       args lsts)
      body))
  
  ;;(nested-for-each (a b) + '(1 2) '(3 4)) ->
  ;;  (for-each (lambda (b) (for-each (lambda (a) (+ a b)) '(1 2))) '(3 4))
  
  (define-macro (nested-map args func . lsts)
    (let ((body `(,func ,@args)))
      (for-each
       (lambda (arg lst)
	 (set! body `(map
		      (lambda (,arg)
			,body)
		      ,lst)))
       args lsts)
      body))
  
  ;;(nested-map (a b) + '(1 2) '(3 4))
  ;;   ((4 5) (5 6))
  ;;(nested-map (a b) / '(1 2) '(3 4))
  ;;   ((1/3 2/3) (1/4 1/2))
  
  (test (nested-map (a b) + '(1 2) '(3 4)) '((4 5) (5 6)))
  (test (nested-map (a b) / '(1 2) '(3 4)) '((1/3 2/3) (1/4 1/2)))
  )

(let ()
  (define-macro (define-curried name-and-args . body)	
    `(define ,@(let ((newlst `(begin ,@body)))
		 (define (rewrap lst)
		   (if (pair? (car lst))
		       (begin
			 (set! newlst (cons 'lambda (cons (cdr lst) (list newlst))))
			 (rewrap (car lst)))
		       (list (car lst) (list 'lambda (cdr lst) newlst))))
		 (rewrap name-and-args))))
  
  (define-curried (((((f a) b) c) d) e) (* a b c d e))
  (test (((((f 1) 2) 3) 4) 5) 120)
  (define-curried (((((f a b) c) d e) f) g) (* a b c d e f g))
  (test (((((f 1 2) 3) 4 5) 6) 7) 5040)
  (define-curried (((foo)) x) (+ x 34))
  (test (((foo)) 300) 334)
  (define-curried ((foo-1) x) (+ x 34))
  (test ((foo-1) 200) 234)
  )



(define-macro (eval-case key . clauses)
  ;; case with evaluated key-lists
  `(cond ,@(map (lambda (lst)
		  (if (pair? (car lst))
		      (cons `(member ,key (list ,@(car lst)))
			    (cdr lst))
		      lst))
		clauses)))

(test (let ((a 1) (b 2)) (eval-case 1 ((a) 123) ((b) 321) (else 0))) 123)
(test (let ((a 1) (b 2) (c 3)) (eval-case 3 ((a c) 123) ((b) 321) (else 0))) 123)
(test (let ((a 1) (b 2)) (eval-case 3 ((a) 123) ((b) 321) (((+ a b)) -1) (else 0))) -1)
(test (let ((a 1) (b 2)) (eval-case 6 ((a (* (+ a 2) b)) 123) ((b) 321) (((+ a b)) -1) (else 0))) 123)

(test (let ()
	(define (set-cadr! a b)
	  (set-car! (cdr a) b)
	  b)
	(let ((lst (list 1 2 3)))
	  (set-cadr! lst 32)
	  lst))
      '(1 32 3))

  ;;; macro?
(test (macro? eval-case) #t)
(test (macro? pi) #f)
(test (macro? quasiquote) #t) ; s7_define_macro in s7.c
(test (let ((m quasiquote)) (macro? m)) #t)
(test (macro? macroexpand) #t)
(test (macro? cond) #f)
(test (macro? letrec) #f)

;; not ideal: (let () (define (hi a) (+ a 1)) (macroexpand (hi 2))) ->
;;              ;+ argument 1, (hi 2), is pair but should be a number
;;              ;    (+ a 1)

(for-each
 (lambda (arg)
   (test (macro? arg) #f))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() car abs (lambda () 1) #2d((1 2) (3 4)) _ht_ #f 'hi '#(()) (list 1 2 3) '(1 . 2) "hi"))
(test (macro?) 'error)

(define-macro (fully-expand form)
  (define (expand form)
    ;; walk form looking for macros, expand any that are found
    (if (pair? form)
	(if (macro? (car form))
	    (expand ((eval (procedure-source (car form))) form))
	    (cons (expand (car form))
		  (expand (cdr form))))
	form))
  (expand form))

(define fe1-called #f)
(define-macro (fe1 a) (set! fe1-called #t) `(+ ,a 1))
(define fe2-called #f)
(define-macro (fe2 b) (set! fe2-called #f) `(+ (fe1 ,b) 2))
(fully-expand (define (fe3 c) (+ (fe2 c) (fe1 (+ c 1)))))
(set! fe1-called #f)
(set! fe2-called #f)
(let ((val (fe3 3)))
  (if (or (not (= val 11))
	  fe1-called
	  fe2-called)
      (format #t "fully-expand: ~A ~A ~A ~A~%" val (procedure-source fe3) fe1-called fe2-called)))

(test (let ()
	(define-macro (pop sym)
	  (let ((v (gensym "v")))
	    `(let ((,v (car ,sym)))
	       (set! ,sym (cdr ,sym))
	       ,v)))
	(let ((lst (list 1 2 3)))
	  (let ((val (pop lst)))
	    (and (= val 1)
		 (equal? lst (list 2 3))))))
      #t)

(define-macro (destructuring-bind lst expr . body)
  `(let ((ex ,expr))
     
     (define (flatten lst)
       (cond ((null? lst) '())
	     ((pair? lst)
	      (if (pair? (car lst))
		  (append (flatten (car lst)) (flatten (cdr lst)))
		  (cons (car lst) (flatten (cdr lst)))))
	     (#t lst)))
     
     (define (structures-equal? l1 l2)
       (if (pair? l1)
	   (and (pair? l2)
		(structures-equal? (car l1) (car l2))
		(structures-equal? (cdr l1) (cdr l2)))
	   (not (pair? l2))))
     
     (if (not (structures-equal? ',lst ex))
	 (error "~A and ~A do not match" ',lst ex))
     
     (let ((names (flatten ',lst))
	   (vals (flatten ex)))
       (apply (eval (list 'lambda names ',@body)) vals))))

(test (destructuring-bind (a b) (list 1 2) (+ a b)) 3)
(test (destructuring-bind ((a) b) (list (list 1) 2) (+ a b)) 3)
(test (destructuring-bind (a (b c)) (list 1 (list 2 3)) (+ a b c)) 6)
(test (let ((x 1)) (destructuring-bind (a b) (list x 2) (+ a b))) 3)

(defmacro once-only (names . body)
  (let ((gensyms (map (lambda (n) (gensym)) names)))
    `(let (,@(map (lambda (g) `(,g (gensym))) gensyms))
       `(let (,,@(map (lambda (g n) ``(,,g ,,n)) gensyms names))
	  ,(let (,@(map (lambda (n g) `(,n ,g)) names gensyms))
	     ,@body)))))

(let ()
  (defmacro hiho (start end) 
    (once-only (start end) 
	       `(list ,start ,end (+ 2 ,start) (+ ,end 2))))
  
  (test (let ((ctr 0)) 
	  (let ((lst (hiho (let () (set! ctr (+ ctr 1)) ctr) 
			   (let () (set! ctr (+ ctr 1)) ctr))))
	    (list ctr lst)))
	'(2 (1 2 3 4))))

(defmacro once-only-2 (names . body)
  (let ((gensyms (map (lambda (n) (gensym)) names)))
    `(let (,@(map (lambda (g) (list g '(gensym))) gensyms))
       `(let (,,@(map (lambda (g n) (list list g n)) gensyms names))
          ,(let (,@(map (lambda (n g) (list n g)) names gensyms))
             ,@body)))))

(let ()
  (defmacro hiho (start end) 
    (once-only-2 (start end) 
	       `(list ,start ,end (+ 2 ,start) (+ ,end 2))))
  
  (test (let ((ctr 0)) 
	  (let ((lst (hiho (let () (set! ctr (+ ctr 1)) ctr) 
			   (let () (set! ctr (+ ctr 1)) ctr))))
	    (list ctr lst)))
	'(2 (1 2 3 4))))

;;; (define-bacro (once-only-1 names . body)
;;;   `(let (,@(map (lambda (name) `(,name ,(eval name))) names))
;;;     ,@body))
;;; can't be right: (let ((names 1)) (once-only (names) (+ names 1)))
;;; if define-macro used here: syntax-error ("~A: unbound variable" start) in the example below

(define once-only-1
  (let ((names (gensym))
	(body (gensym)))
    (apply define-bacro 
	 `((once ,names . ,body)
	   `(let (,@(map (lambda (name) `(,name ,(eval name))) ,names))
	      ,@,body)))
    once))

(let ()
  (define-bacro (hiho start end) ; note the bacro!  not a macro here
    (once-only-1 (start end) 
		 `(list ,start ,end (+ 2 ,start) (+ ,end 2))))
  
  (test (let ((ctr 0)) 
	  (let ((lst (hiho (let () (set! ctr (+ ctr 1)) ctr) 
			   (let () (set! ctr (+ ctr 1)) ctr))))
	    (list ctr lst)))
	'(2 (1 2 3 4)))

  (test (let ((names 1)) (once-only-1 (names) (+ names 1))) 2)
  (test (let ((body 1)) (once-only-1 (body) (+ body 1))) 2) ; so body above also has to be gensym'd
  )


(define once-only-3
  (let ((names (gensym))
	(body (gensym)))
    (symbol->value (apply define-bacro `((,(gensym) ,names . ,body)
      `(let (,@(map (lambda (name) `(,name ,(eval name))) ,names))
	 ,@,body))))))

(let ()
  (define-bacro (hiho start end) ; note the bacro!  not a macro here
    (once-only-3 (start end) 
		 `(list ,start ,end (+ 2 ,start) (+ ,end 2))))
  
  (test (let ((ctr 0)) 
	  (let ((lst (hiho (let () (set! ctr (+ ctr 1)) ctr) 
			   (let () (set! ctr (+ ctr 1)) ctr))))
	    (list ctr lst)))
	'(2 (1 2 3 4)))

  (test (let ((names 1)) (once-only-3 (names) (+ names 1))) 2)
  (test (let ((body 1)) (once-only-3 (body) (+ body 1))) 2) ; so body above also has to be gensym'd
  )
  

(let ()
  (define setf
    (let ((args (gensym)))
      (apply define-bacro 
	     `((setf-1 . ,args)        
	       (if (not (null? ,args))
		   (begin
		     (apply set! (car ,args) (cadr ,args) ())
		     (apply setf (cddr ,args)))))) ; not setf-1 -- it's not defined except during the definition 
      setf-1))
  
  (define-macro (psetf . args)
    (let ((bindings ())
	  (settings ()))
      (do ((arglist args (cddr arglist)))
	  ((null? arglist))
	(let* ((g (gensym)))
	  (set! bindings (cons (list g (cadr arglist)) bindings))
	  (set! settings (cons `(set! ,(car arglist) ,g) settings))))
      `(let ,bindings ,@settings)))
  
  (test (let ((a 1) (b 2)) (setf a b b 3) (list a b)) '(2 3))
  (test (let ((a 1) (b 2)) (setf a b b (+ a 3)) (list a b)) '(2 5))
  (test (let ((a #(1)) (b 2)) (setf (a 0) b b (+ (a 0) 3)) (list a b)) '(#(2) 5))
  (test (let ((a 1) (b 2)) (setf a b b a) (list a b)) '(2 2))
  (test (let ((a 1) (b 2)) (setf a '(+ 1 2) b a) (list a b)) '((+ 1 2) (+ 1 2)))
  (test (let ((args 1) (arg 1)) (setf args 2 arg 3) (list args arg)) '(2 3))
  (test (let ((args 1) (arg 1)) (setf args (+ 2 3) arg args) (list args arg)) '(5 5))
  (test (let ((args 1) (arg 1)) (setf args '(+ 2 3) arg (car args)) (list args arg)) '((+ 2 3) +))
  
  (test (let ((a 1) (b 2)) (psetf a b b a) (list a b)) '(2 1))
  (test (let ((a #(1)) (b 2)) (psetf (a 0) b b (+ (a 0) 3)) (list a b)) '(#(2) 4))
  (test (let ((a 1) (b 2)) (psetf a '(+ 1 2) b a) (list a b)) '((+ 1 2) 1))
  (test (let ((new-args 1)) (psetf new-args (+ new-args 1)) new-args) 2)
  (test (let ((args 1) (arg 1)) (psetf args 2 arg 3) (list args arg)) '(2 3))
  (test (let ((args 1) (arg 1)) (psetf args (+ 2 3) arg args) (list args arg)) '(5 1))
  (test (let ((args 1) (arg 1)) (psetf args '(+ 2 3) arg (car args)) (list args arg)) 'error)
  (test (let ((args '(1 2)) (arg 1)) (psetf args '(+ 2 3) arg (car args)) (list args arg)) '((+ 2 3) 1))
  )

(defmacro with-gensyms (names . body)
  `(let ,(map (lambda (n) `(,n (gensym))) names)
     ,@body))

(define-macro (define-clean-macro name-and-args . body)
  ;; the new backquote implementation breaks this slightly -- it's currently confused about unquoted nil in the original
  (let ((syms ()))
    
    (define (walk func lst)
      (if (and (func lst)
	       (pair? lst))
	  (begin
	    (walk func (car lst))
	    (walk func (cdr lst)))))
    
    (define (car-member sym lst)
      (if (null? lst)
	  #f
	  (if (eq? sym (caar lst))
	      (cdar lst)
	      (car-member sym (cdr lst)))))
    
    (define (walker val)
      (if (pair? val)
	  (if (eq? (car val) 'quote)
	      (or (car-member (cadr val) syms)
		  (and (pair? (cadr val))
		       (or (and (eq? (caadr val) 'quote) ; 'sym -> (quote (quote sym))
				val)
			   (append (list 'list) 
				   (walker (cadr val)))))
		  (cadr val))
	      (cons (walker (car val))
		    (walker (cdr val))))
	  (or (car-member val syms)
	      val)))
    
    (walk (lambda (val)
	    (if (and (pair? val)
		     (eq? (car val) 'quote)
		     (symbol? (cadr val))
		     (not (car-member (cadr val) syms)))
		(set! syms (cons 
			    (cons (cadr val) 
				  (gensym (symbol->string (cadr val))))
			    syms)))
	    (or (not (pair? val))
		(not (eq? (car val) 'quote))
		(not (pair? (cadr val)))
		(not (eq? (caadr val) 'quote))))
	  body)
    
    (let* ((new-body (walker body))
	   (new-syms (map (lambda (slot)
			    (list (cdr slot) '(gensym)))
			  syms))
	   (new-globals 
	    (let ((result '()))
	      (for-each
	       (lambda (slot)
		 (if (defined? (car slot))
		     (set! result (cons
				   (list 'set! (cdr slot) (car slot))
				   result))))
	       syms)
	      result)))
      
      `(define-macro ,name-and-args 
	 (let ,new-syms
	   ,@new-globals
	   `(begin ,,@new-body))))))


(define-macro (define-immaculo name-and-args . body)
  (let* ((gensyms (map (lambda (g) (gensym)) (cdr name-and-args)))
	 (args (cdr (copy name-and-args)))
	 (name (car name-and-args))
	 (set-args (map (lambda (a g) `(list ',g ,a)) args gensyms))
	 (get-args (map (lambda (a g) `(quote (cons ',a ,g))) args gensyms))
	 (blocked-args (map (lambda (a) `(,a ',a)) args))
	 (new-body (list (apply let blocked-args body))))
    `(define-macro ,name-and-args
       `(let ,(list ,@set-args)
	  ,(list 'with-environment 
		 (append (list 'augment-environment) 
			 (list (list 'procedure-environment ,name)) 
			 (list ,@get-args))
		 ',@new-body)))))

;;; this is not perfect: if unquote is on expr involving an arg, it's going to be unhappy,
;;;   but we can always move the unquote in, so it's purely stylistic.  Another way would
;;;   be to remove one level of unquotes throughout -- then the blocked-args and new-body
;;;   would be unneeded.

(test (let ()
	(define-clean-macro (hi a) `(+ ,a 1))
	(hi 1))	  
      2)

(test (let ()
	(define-immaculo (hi a) `(+ ,a 1))
	(hi 1))	  
      2)


;; define-clean-macro is making no-longer-correct assumptions about quasiquote -- I think I'll just put these aside
					;  (test (let ()
					;	  (define-clean-macro (hi a) `(let ((b 23)) (+ b ,a)))
					;	  (hi 2))
					;	25)

(test (let ()
	(define-immaculo (hi a) `(let ((b 23)) (+ b ,a)))
	(hi 2))
      25)


					;  (test (let ()
					;	  (define-clean-macro (mac a b) `(let ((c (+ ,a ,b))) (let ((d 12)) (* ,a ,b c d))))
					;	  (mac 2 3))
					;	360)

(test (let ()
	(define-immaculo (mac a b) `(let ((c (+ ,a ,b))) (let ((d 12)) (* ,a ,b c d))))
	(mac 2 3))
      360)

					;  (test (let ()
					;	  (define-clean-macro (mac a b) `(let ((c (+ ,a ,b))) (let ((d 12)) (* ,a ,b c d))))
					;	  (let ((c 2)
					;		(d 3))
					;	    (mac c d)))
					;	360)

(test (let ()
	(define-immaculo (mac a b) `(let ((c (+ ,a ,b))) (let ((d 12)) (* ,a ,b c d))))
	(let ((c 2)
	      (d 3))
	  (mac c d)))
      360)

(test (let ()
	(define-clean-macro (mac a . body)
	  `(+ ,a ,@body))
	(mac 2 3 4))
      9)

(test (let ()
	(define-clean-macro (mac) (let ((a 1)) `(+ ,a 1)))
	(mac))
      2)

(test (let ()
	(define-immaculo (mac) (let ((a 1)) `(+ ,a 1)))
	(mac))
      2)

(test (let ()
	(define-immaculo (hi a) `(list 'a ,a))
	(hi 1))
      (list 'a 1))

					;  (test (let ((values 32)) (define-macro (hi a) `(+ 1 ,@a)) (hi (2 3))) 6)
					;  (test (let ((list 32)) (define-macro (hi a) `(+ 1 ,@a)) (hi (2 3))) 6)
					;  (test (let () (define-macro (hi a) `(let ((apply 32)) (+ apply ,@a))) (hi (2 3))))
(test (let () (define-macro (hi a) `(+ 1 (if ,(= a 0) 0 (hi ,(- a 1))))) (hi 3)) 4)
(test (let () (define-macro (hi a) `(+ 1 ,a)) ((if #t hi abs) -3)) -2)
(test (let () (apply define-macro '((m a) `(+ 1 ,a))) (m 2)) 3)
(test (let () (apply (eval (apply define-macro '((m a) `(+ 1 ,a)))) '(3))) 4)
(test (let () (apply (eval (apply define '((hi a) (+ a 1)))) '(2))) 3)
(test (let () ((eval (apply define '((hi a) (+ a 1)))) 3)) 4)
(test (let () ((eval (apply define-macro '((m a) `(+ 1 ,a)))) 3)) 4)
(test (let () ((symbol->value (apply define '((hi a) (+ a 1)))) 3)) 4)
(test (let () ((symbol->value (apply define-macro '((m a) `(+ 1 ,a)))) 3)) 4)
(test (let () 
	(define-macro (mu args . body)
	  (let ((m (gensym)))
	    `(symbol->value (apply define-macro '((,m ,@args) ,@body)))))
	((mu (a) `(+ 1 ,a)) 3))
      4)
(test (let () (define-macro (hi a) `(+ 1 ,a)) (map hi '(1 2 3))) '(2 3 4))
(test (let () (define-macro (hi a) `(+ ,a 1)) (apply hi '(4))) 5)
(test (let () 
	(define-macro (hi a) `(+ ,a 1))
	(define (fmac mac) (apply mac '(4)))
	(fmac hi))
      5)
(test (let () 
	(define (make-mac)
	  (define-macro (hi a) `(+ ,a 1))
	  hi)
	(let ((x (make-mac)))
	  (x 2)))
      3)

(define-macro* (_mac1_) `(+ 1 2))
(test (_mac1_) 3)
(define-macro* (_mac2_ a) `(+ ,a 2))
(test (_mac2_ 1) 3)
(test (_mac2_ :a 2) 4)
(define-macro* (_mac3_ (a 1)) `(+ ,a 2))
(test (_mac3_) 3)
(test (_mac3_ 3) 5)
(test (_mac3_ :a 0) 2)
(define-macro* (_mac4_ (a 1) (b 2)) `(+ ,a ,b))
(test (_mac4_) 3)
(test (_mac4_ :b 3) 4)
(test (_mac4_ 2 :b 3) 5)
(test (_mac4_ :b 10 :a 12) 22)
(test (_mac4_ :a 4) 6)

(define-bacro* (_mac21_) `(+ 1 2))
(test (_mac21_) 3)
(define-bacro* (_mac22_ a) `(+ ,a 2))
(test (_mac22_ 1) 3)
(test (_mac22_ :a 2) 4)
(define-bacro* (_mac23_ (a 1)) `(+ ,a 2))
(test (_mac23_) 3)
(test (_mac23_ 3) 5)
(test (_mac23_ :a 0) 2)
(define-bacro* (_mac24_ (a 1) (b 2)) `(+ ,a ,b))
(test (_mac24_) 3)
(test (_mac24_ :b 3) 4)
(test (_mac24_ 2 :b 3) 5)
(test (_mac24_ :b 10 :a 12) 22)
(test (_mac24_ :a 4) 6)  

(defmacro* _mac11_ () `(+ 1 2))
(test (_mac11_) 3)
(defmacro* _mac12_ (a) `(+ ,a 2))
(test (_mac12_ 1) 3)
(test (_mac12_ :a 2) 4)
(defmacro* _mac13_ ((a 1)) `(+ ,a 2))
(test (_mac13_) 3)
(test (_mac13_ 3) 5)
(test (_mac13_ :a 0) 2)
(defmacro* _mac14_ ((a 1) (b 2)) `(+ ,a ,b))
(test (_mac14_) 3)
(test (_mac14_ :b 3) 4)
(test (_mac14_ 2 :b 3) 5)
(test (_mac14_ :b 10 :a 12) 22)
(test (_mac14_ :a 4) 6)

(define-bacro (symbol-set! var val) `(set! ,(symbol->value var) ,val))
(test (let ((x 32) (y 'x)) (symbol-set! y 123) (list x y)) '(123 x))

(define-bacro (symbol-eset! var val) `(set! ,(eval var) ,val))
(test (let ((x '(1 2 3)) (y `(x 1))) (symbol-eset! y 123) (list x y)) '((1 123 3) (x 1)))
(test (let ((x #(1 2 3)) (y `(x 1))) (symbol-eset! y 123) (list x y)) '(#(1 123 3) (x 1)))

(let ()
  (define-macro (hi a) `````(+ ,,,,,a 1))
  (test (eval (eval (eval (eval (hi 2))))) 3)
  
  (define-macro (hi a) `(+ ,@@a))
  (test (hi (1 2 3)) 'error)
  
  (define-macro (hi @a) `(+ ,@@a))
  (test (hi (1 2 3)) 6))


;;; --------------------------------------------------------------------------------
;;; # readers 
;;; *#readers*
;;;
;;; #\; reader: 

(let ((old-readers *#readers*))
  
  ;; testing *#readers* is slightly tricky because the reader runs before we evaluate the test expression
  ;;    so in these cases, the new reader use is always in a string 
  
  (set! *#readers* (list (cons #\s (lambda (str) 123))))
  (let ((val (eval-string "(+ 1 #s1)"))) ; force this into the current reader
    (test val 124))
  (set! *#readers* '())
  
  (set! *#readers* 
	(cons (cons #\t (lambda (str) 
			  (string->number (substring str 1) 12)))
	      *#readers*))
  (num-test (string->number "#tb") 11)
  (num-test (string->number "#t11.3") 13.25)
  (num-test (string->number "#e#t11.3") 53/4)
  (num-test (string->number "#t#e1.5") 17/12)
  (num-test (string->number "#i#t1a") 22.0)
  (num-test (string->number "#t#i1a") 22.0) ; ??? this is analogous to #x#i1a = 26.0
  (num-test (string->number "#t#t1a") 22.0)
  (num-test (string->number "#t#t#t1a") 22.0)
  (test (eval-string "#t") #t)
  (test (eval-string "#T1") 'error)
  
  (set! *#readers*
	(cons (cons #\. (lambda (str)
			  (if (string=? str ".") (eval (read)) #f)))
	      *#readers*))
  
  (test (eval-string "'(1 2 #.(* 3 4) 5)") '(1 2 12 5))
  (num-test (string->number "#t1a") 22)
  (test (eval-string "'(1 #t(2))") '(1 #t (2)))
  (test (string->number "#t1r") #f)
  
  (set! *#readers* (list (cons #\t (lambda (str) 
				     ;; in the duplicated case: "t#t..."
				     (if (< (length str) 3)
					 (string->number (substring str 1) 12)
					 (and (not (char=? (str 1) #\#)) 
					      (not (char=? (str 2) #\t)) 
					      (string->number (substring str 1) 12)))))))
  (test (string->number "#t#t1a") #f)
  
  (set! *#readers* (cons (cons #\x (lambda (str) 
				     (or (if (< (length str) 3)
					     (string->number (substring str 1) 7)
					     (and (not (char=? (str 1) #\#)) 
						  (not (char=? (str 2) #\x)) 
						  (string->number (substring str 1) 7)))
					 'error)))
			 *#readers*))
  
  (num-test (string->number "#x12") 9)
  (num-test (string->number "#x-142.1e-1") -11.30612244898)
  (num-test (string->number "#e#x-142.1e-1") -554/49)
  (num-test (string->number "#t460.88") 648.72222222222)
  (num-test (string->number "#e#ta.a") 65/6)
  (num-test (string->number "#x1") 1)
  (test (string->number "#te") #f)
  (num-test (string->number "#x10") 7)
  (test (string->number "#x17") #f)
  (num-test (string->number "#x106") 55)
  (test (string->number "#x#t1") #f)
  
  (let ()
    (define (read-in-radix str radix)
      ;; no error checking, only integers
      (define (char->digit c)
	(cond ((char-numeric? c)
	       (- (char->integer c) (char->integer #\0)))
	      ((char-lower-case? c)
	       (+ 10 (- (char->integer c) (char->integer #\a))))
	      (#t
	       (+ 10 (- (char->integer c) (char->integer #\A))))))
      (let* ((negative (char=? (str 0) #\-))
	     (len (length str))
	     (j (if (or negative (char=? (str 0) #\+)) 2 1))) ; 1st char is "z"
	(do ((sum (char->digit (str j))
		  (+ (* sum radix) (char->digit (str j)))))
	    ((= j (- len 1)) sum)
	  (set! j (+ j 1)))))
    
    (set! *#readers* (list (cons #\z (lambda (str) (read-in-radix str 32)))))
    (num-test (string->number "#z1p") 57)
    )
  
  (let ((p1 (make-procedure-with-setter (lambda (str) (string->number (substring str 1) 12)) (lambda (a) a))))
    (set! *#readers* (list (cons #\t p1)))
    (num-test (string->number "#ta") 10)
    (num-test (string->number "#t11.6") 13.5)
    (num-test (string->number "#e#t11.6") 27/2))
  
  (set! *#readers* old-readers)
  
  (num-test (string->number "#x106") 262)
  (num-test (string->number "#x17") 23)
  )

(let ((old-readers *#readers*)
      (reader-file "tmp1.r5rs"))
  ;; to test readers in a file, we need to write the file and load it, so here we go...
  (set! *#readers* '())

  (define circular-list-reader
    (let ((known-vals #f)
	  (top-n -1))
      (lambda (str)
	
	(define (replace-syms lst)
	  ;; walk through the new list, replacing our special keywords 
	  ;;   with the associated locations
	  
	  (define (replace-sym tree getter)
	    (if (keyword? (getter tree))
		(let ((n (string->number (symbol->string (keyword->symbol (getter tree))))))
		  (if (integer? n)
		      (let ((lst (assoc n known-vals)))
			(if lst
			    (set! (getter tree) (cdr lst))
			    (format *stderr* "#~D# is not defined~%" n)))))))
	  
	  (define (walk-tree tree)
	    (if (pair? tree)
		(begin
		  (if (pair? (car tree)) (walk-tree (car tree)) (replace-sym tree car))
		  (if (pair? (cdr tree)) (walk-tree (cdr tree)) (replace-sym tree cdr))))
	    tree)
	  
	  (walk-tree (cdr lst)))
	
	;; str is whatever followed the #, first char is a digit
	(let* ((len (length str))
	       (last-char (str (- len 1))))
	  (if (memq last-char '(#\= #\#))             ; is it #n= or #n#?
	      (let ((n (string->number (substring str 0 (- len 1)))))
		(if (integer? n)
		    (begin
		      (if (not known-vals)
			  (begin
			    (set! known-vals ())
			    (set! top-n n))) 
		      
		      (if (char=? last-char #\=)      ; #n=
			  (if (char=? (peek-char) #\()
			      (let ((cur-val (assoc n known-vals)))
				;; associate the number and the list it points to
				;;    if cur-val, perhaps complain? (#n# redefined)
				(let ((lst (catch #t 
					     (lambda () 
					       (read))
					     (lambda args             ; a read error
					       (set! known-vals #f)   ;   so clear our state
					       (apply throw args))))) ;   and pass the error on up
				  (if (not cur-val)
				      (set! known-vals 
					    (cons (set! cur-val (cons n lst)) known-vals))
				      (set! (cdr cur-val) lst)))
				
				(if (= n top-n)       ; replace our special keywords
				    (let ((result (replace-syms cur-val)))
				      (set! known-vals #f)
				      result)
				    (cdr cur-val)))
			      #f)                     ; #n=<not a list>?
			  
			  ;; else it's #n# -- set a marker for now since we may not 
			  ;;   have its associated value yet.  We use a symbol name that 
			  ;;   string->number accepts.
			  (symbol->keyword 
			   (symbol (string-append (number->string n) (string #\null) " ")))))
		    #f))                             ; #n<not an integer>?
	      #f)))))                                ; #n<something else>?
  
  (define (sharp-plus str)
    ;; str here is "+", we assume either a symbol or a expression involving symbols follows
    (let* ((e (if (string=? str "+")
		  (read)                                ; must be #+(...)
		  (string->symbol (substring str 1))))  ; #+feature
	   (expr (read)))
      (if (symbol? e)
	  (if (provided? e)
	      expr
	      (values))
	  (if (pair? e)
	      (begin
		(define (traverse tree)
		  (if (pair? tree)                                             
		      (cons (traverse (car tree))                             
			    (if (null? (cdr tree)) () (traverse (cdr tree))))
		      (if (memq tree '(and or not)) 
			  tree                 
			  (and (symbol? tree) 
			       (provided? tree)))))
		(if (eval (traverse e))
		    expr
		    (values)))
	      (error "strange #+ chooser: ~S~%" e)))))
  
  (set! *#readers* 
	(cons (cons #\+ sharp-plus)
	      (cons (cons #\. (lambda (str) (if (string=? str ".") (eval (read)) #f)))
		    (cons (cons #\; (lambda (str) (if (string=? str ";") (read)) (values)))
			  *#readers*))))
  (do ((i 0 (+ i 1)))
      ((= i 10))
    (set! *#readers* 
	  (cons (cons (integer->char (+ i (char->integer #\0))) circular-list-reader)
		*#readers*)))

  (call-with-output-file reader-file
    (lambda (port)
      (format port "(define x #.(+ 1 2 3))~%")
      (format port "(define xlst '(1 2 3 #.(* 2 2)))~%")

      (format port "(define y '#1=(2 . #1#))~%")
      (format port "(define y1 '#1=(2 #2=(3 #3=(#1#) . #3#) . #2#))~%")
      (format port "(define y2 #2D((1 2) (3 4)))~%")

      (format port "#+s7 (define z 32)~%#+asdf (define z 123)~%")
      (format port "#+(and complex-numbers (or snd s7)) (define z1 1)~%#+(and (not complex-numbers) asdf) (define z1 123)~%")

      (format port "(define x2 (+ 1 #;(* 2 3) 4))~%")
      (format port "(define x3 (+ #;32 1 2))~%") 
      (format port "(define x4 (+ #; 32 1 2))~%")

      (format port "(define y3 (+ 1 (car '#1=(2 . #1#))))~%")
      (format port "(define y4 #.(+ 1 (car '#1=(2 . #1#))))~%")
      (format port "(define y5 (+ 1 #.(* 2 3) #.(* 4 #.(+ 5 6))))~%")

      (format port "(define r1 '(1 #. #;(+ 2 3) 4))~%")
      (format port "(define r2 '(1 #. #;(+ 2 3) (* 2 4)))~%")
      (format port "(define r3 '(1 #; #.(+ 2 3) (* 2 4)))~%")
      (format port "(define r4 '(1 #. #1=(+ 2 3) (* 2 4)))~%")
      (format port "(define r5 '(1 #. #1=(+ 2 #. 3) (* 2 4)))~%")
      ;; but #.3 is ambiguous: '(1 #. #1=(+ 2 #.3) (* 2 4))
      (format port "(define r6 '(1 #. #1=(+ 2 #+pi 3) (* 2 4)))~%")
      (format port "(define r7 '(1 #. #1=(+ 2 #+pi #1#) (* 2 4)))~%")
      (format port "(define r8 '(1 #+s7 #1=(1 2) 3))~%")
      (format port "(define r9 '(1 #+asdf #1=(1 2) 3))~%")
      (format port "(define r10 #. #1#)~%")
      (format port "(define r13 #+s7 #e0.0)~%")
      (format port "(define r14 #. #o1)~%")
      (format port "(define r15 #. #_-)~%")
      (format port "(define r16 (#+s7 #_- #d0))~%")
      (format port "(define r17 (#. #_- #o1))~%")
      (format port "(define r18 (#. #.  #_+))~%")
      (format port "(define r19 (#. #+s7  #_+))~%")
      (format port "(define r20 (#+s7 #+s7 #_+))~%")
      (format port "(define r21 (#_-(#_+ 1 2)3))~%")
      (format port "(define r22 (#(#_+ 1 2)#o1))~%")
      (format port "(define r23 (+ #;#1.##+asdf ))~%")
      (format port "(define r24 (+ #. #;(#_+ 1 2)))~%")
      (format port "(define r25 (+ #;#1=#2=))~%")
      (format port "(define r26 (+ #;#2#(#_+ 1 2)))~%")
      (format port "(define r27 (+ #;#1=.))~%")
      (format port "(define r28 (+ #; #; #; ()))~%")
      (format port "(define r29 (+ 3(#_+ 1 2)#;#. ))~%")
      (format port "(define r30 (+ #;#2=#+asdf#+s7))~%")
      (format port "(define r31 (+ #;#f#=#\\))~%")
      (format port "(define r32 (#. + (#_-(#_+ 1 2))))~%")
      (format port "(define r33 (+ 1 #+asdf #\\a 2))~%")
      (format port "(define r34 (+ #++(#. #\\a)))~%")
      (format port "(define r35 (+ #+s7 #; (33)))~%")

      (format port "(define r36 (cos #. #. #. `(string->symbol \"pi\")))~%")
      ))

  (let ()
    (load reader-file (current-environment))
    (if (not (= x 6)) (format #t ";#.(+ 1 2 3) -> ~A~%" x))
    (if (not (equal? xlst '(1 2 3 4))) (format #t ";#.(* 2 2) -> ~A~%" xlst))
    (if (not (equal? (object->string y) "#1=(2 . #1#)")) (format #t ";'#1=(2 . #1#) -> ~S~%" (object->string y)))
    (if (not (equal? (object->string y1) "#1=(2 #3=(3 #2=(#1#) . #2#) . #3#)"))
	(format #t ";'#1=(2 #2=(3 #3=(#1#) . #3#) . #2#) -> ~S~%" (object->string y1)))
    (if (not (equal? y2 #2d((1 2) (3 4)))) (format #t ";#2d((1 2) (3 4)) -> ~A~%" y2))
    (if (not (= z 32)) (format #t ";#+asdf? -> ~A~%" z))
    (if (not (= z1 1)) (format #t ";#(or ... +asdf)? -> ~A~%" z1))
    (if (not (= x2 5)) (format #t ";(+ 1 #;(* 2 3) 4) -> ~A~%" x2))
    (if (not (= x3 3)) (format #t ";(+ #;32 1 2) -> ~A~%" x3))
    (if (not (= x4 3)) (format #t ";(+ #; 32 1 2) -> ~A~%" x4))
    (if (not (= y3 3)) (format #t ";(+ 1 (car '#1=(2 . #1#))) -> ~A~%" y3))
    (if (not (= y4 3)) (format #t ";#.(+ 1 (car '#1=(2 . #1#))) -> ~A~%" y4))
    (if (not (= y5 51)) (format #t ";(+ 1 #.(* 2 3) #.(* 4 #.(+ 5 6))) -> ~A~%" y5))

    (if (not (equal? r1 '(1 4))) (format #t ";'(1 #. #;(+ 2 3) 4) -> ~A~%" r1))
    (if (not (equal? r2 '(1 (* 2 4)))) (format #t ";'(1 #. #;(+ 2 3) (* 2 4)) -> ~A~%" r2))
    (if (not (equal? r3 '(1 (* 2 4)))) (format #t ";'(1 #; #.(+ 2 3) (* 2 4)) -> ~A~%" r3))
    (if (not (equal? r4 '(1 5 (* 2 4)))) (format #t ";'(1 #. #1=(+ 2 3) (* 2 4)) -> ~A~%" r4))
    (if (not (equal? r5 '(1 5 (* 2 4)))) (format #t ";'(1 #. #1=(+ 2 #. 3) (* 2 4)) -> ~A~%" r5))
    (if (not (equal? r6 '(1 2 (* 2 4)))) (format #t ";'(1 #. #1=(+ 2 #+pi 3) (* 2 4)) -> ~A~%" r6))
    (if (not (equal? r7 '(1 2 (* 2 4)))) (format #t ";'(1 #. #1=(+ 2 #+pi #1#) (* 2 4)) -> ~A~%" r7))
    (if (not (equal? r8 '(1 (1 2) 3))) (format #t ";'(1 #+s7 #1=(1 2) 3) -> ~A~%" r8))
    (if (not (equal? r9 '(1 3))) (format #t ";'(1 #+asdf #1=(1 2) 3)) -> ~A~%" r9))
    (if (not (equal? r10 ':1)) (format #t ";#. #1# -> ~A~%" r10)) 
    (if (not (equal? r13 0)) (format #t ";#+s7 #e0.0 -> ~A~%" r13))
    (if (not (equal? r14 1)) (format #t ";#. #o1 -> ~A~%" r14))
    (if (not (equal? r15 -)) (format #t ";#. #_- -> ~A~%" r15))
    (if (not (equal? r16 0)) (format #t ";(#+s7 #_- #d0) -> ~A~%" r16))
    (if (not (equal? r17 -1)) (format #t ";(#. #_- #o1) -> ~A~%" r17))
    (if (not (equal? r18 0)) (format #t ";(#. #.  #_+) -> ~A~%" r18))
    (if (not (equal? r19 0)) (format #t ";(#. #+s7  #_+) -> ~A~%" r19))
    (if (not (equal? r20 0)) (format #t ";(#+s7 #+s7 #_+) -> ~A~%" r20))
    (if (not (equal? r21 0)) (format #t ";(#_-(#_+ 1 2)3) -> ~A~%" r21))
    (if (not (equal? r22 1)) (format #t ";(#(#_+ 1 2)#o1) -> ~A~%" r22))
    (if (not (equal? r23 0)) (format #t ";(+ #;#1.##+asdf ) -> ~A~%" r23))
    (if (not (equal? r24 0)) (format #t ";(+ #. #;(#_+ 1 2)) -> ~A~%" r24))
    (if (not (equal? r25 0)) (format #t ";(+ #;#1=#2=) -> ~A~%" r25))
    (if (not (equal? r26 3)) (format #t ";(+ #;#2#(#_+ 1 2)) -> ~A~%" r26))
    (if (not (equal? r27 0)) (format #t ";(+ #;#1=.) -> ~A~%" r27))
    (if (not (equal? r28 0)) (format #t ";(+ #; #; #; ()) -> ~A~%" r28))
    (if (not (equal? r29 6)) (format #t ";(+ 3(#_+ 1 2)#;#. ) -> ~A~%" r29))
    (if (not (equal? r30 0)) (format #t ";(+ #;#2=#+asdf#+s7) -> ~A~%" r30))
    (if (not (equal? r31 0)) (format #t ";(+ #;#f#=#\\) -> ~A~%" r31))
    (if (not (equal? r32 -3)) (format #t ";(#. + (#_-(#_+ 1 2))) -> ~A~%" r32))
    (if (not (equal? r33 3)) (format #t ";(+ 1 #+asdf #\\a 2) -> ~A~%" r33))
    (if (not (equal? r34 0)) (format #t ";(+ #++(#. #\\a)) -> ~A~%" r34))
    (if (not (equal? r35 0)) (format #t ";(+ #+s7 #; (33)) -> ~A~%" r35))

    (if (not (morally-equal? r36 -1.0)) (format #t ";(cos #. #. #. `(string->symbol \"pi\")) -> ~A~%" r36))
    )

  (set! *#readers* old-readers)
  )



;;; --------------------------------------------------------------------------------

(begin
  (define-macro (hi a) `(+ ,a 1))
  (test (hi 2) 3)
  (let ()
    (define (ho b) (+ 1 (hi b)))
    (test (ho 1) 3))
  (let ((hi 32))
    (test (+ hi 1) 33))
  (letrec ((hi (lambda (a) (if (= a 0) 0 (+ 2 (hi (- a 1)))))))
    (test (hi 3) 6))
  (letrec* ((hi (lambda (a) (if (= a 0) 0 (+ 2 (hi (- a 1)))))))
	   (test (hi 3) 6))
  (test (equal? '(hi 1) (quote (hi 1))) #t)
  (test (list? '(hi 1)) #t)
  (test (list? '(((hi 1)))) #t)
  (test (equal? (vector (hi 1)) '#(2)) #t)
  (test (symbol? (vector-ref '#(hi) 0)) #t))

(define-macro (define-with-goto name-and-args . body)
  ;; run through the body collecting label accessors, (label name)
  ;; run through getting goto positions, (goto name)
  ;; tie all the goto's to their respective labels (via set-cdr! essentially)
  
  (define (find-accessor type)
    (let ((labels '()))
      (define (gather-labels accessor tree)
	(if (pair? tree)
	    (if (equal? (car tree) type)
		(begin
		  (set! labels (cons (cons (cadr tree) 
					   (let ((body 'lst))
					     (for-each
					      (lambda (f)
						(set! body (list f body)))
					      (reverse (cdr accessor)))
					     (make-procedure-with-setter
					      (apply lambda '(lst) (list body))
					      (apply lambda '(lst val) `((set! ,body val))))))
				     labels))
		  (gather-labels (cons 'cdr accessor) (cdr tree)))
		(begin
		  (gather-labels (cons 'car accessor) (car tree))
		  (gather-labels (cons 'cdr accessor) (cdr tree))))))
      (gather-labels '() body)
      labels))
  (let ((labels (find-accessor 'label))
	(gotos (find-accessor 'goto)))
    (if (not (null? gotos))
	(for-each
	 (lambda (goto)
	   (let* ((name (car goto))
		  (goto-accessor (cdr goto))
		  (label (assoc name labels))
		  (label-accessor (and label (cdr label))))
	     (if label-accessor
		 (set! (goto-accessor body) (label-accessor body))
		 (error 'bad-goto "can't find label: ~S" name))))
	 gotos))
    `(define ,name-and-args
       (let ((label (lambda (name) #f))
	     (goto (lambda (name) #f)))
	 ,@body))))

(let ()
  (define-with-goto (g1 a)
    (let ((x 1))
      (if a
	  (begin
	    (set! x 2)
	    (goto 'the-end)
	    (set! x 3))
	  (set! x 4))
      (label 'the-end)
      x))
  
  (define-with-goto (g2 a)
    (let ((x a))
      (label 'start)
      (if (< x 4)
	  (begin
	    (set! x (+ x 1))
	    (goto 'start)))
      x))
  
  (test (g1 #f) 4)
  (test (g1 #t) 2)
  (test (g2 1) 4)
  (test (g2 32) 32))


;;; symbol-access
  
(define (notify-if-set var notifier)
  (set! (symbol-access var) (list #f notifier #f)))
  
(define constant-access 
  (list #f
	(lambda (symbol new-value) 
	  (error "can't change constant ~A's value to ~A" symbol new-value))
	(lambda (symbol new-value) 
	  (error "can't bind constant ~A to a new value, ~A" symbol new-value))))

(define-macro (define-global-constant symbol value)
  `(begin
     (define ,symbol ,value)
     (set! (symbol-access ',symbol) constant-access)
     ',symbol))

(define-macro (let-constant vars . body)
  (let ((varlist (map car vars)))
    `(let ,vars
       ,@(map (lambda (var)
		`(set! (symbol-access ',var) constant-access))
	      varlist)
       ,@body)))

(define-macro (define-integer var value)
  `(begin
     (define ,var ,value)
     (set! (symbol-access ',var) 
	   (list #f
		 (lambda (symbol new-value)
		   (if (real? new-value)
		       (floor new-value)
		       (error "~A can only take an integer value, not ~S" symbol new-value)))
		 #f))
     ',var))

(define (trace-var var)
  (let* ((cur-access (symbol-access var))
	 (cur-set (and cur-access (cadr cur-access))))
    (set! (symbol-access var)
	  (list (and cur-access (car cur-access))
		(lambda (symbol new-value) 
		  (format #t "~A set to ~A~%" symbol new-value) 
		  (if cur-set 
		      (cur-set symbol new-value)
		      new-value))
		(and cur-access (caddr cur-access))
		cur-access))))

(define (untrace-var var)
  (if (and (symbol-access var)
	   (cdddr (symbol-access var)))
      (set! (symbol-access var) (cadddr (symbol-access var)))))

(define-integer _int_ 32)
(test _int_ 32)
(set! _int_ 1.5)
(test _int_ 1)

(for-each
 (lambda (arg)
   (test (symbol-access arg) 'error)
   (test (set! (symbol-access _int_) arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() '#(()) (list 1 2 3) '(1 . 2) "hi"))

(test (symbol-access) 'error)
(test (symbol-access '_int_ 2) 'error)
;(test (symbol-access 'abs) #f)
(test (symbol-access 'xyzzy) #f)
(test (set! (symbol-access _int_) '()) 'error)
(test (set! (symbol-access _int_) '(#f)) 'error)
(test (set! (symbol-access _int_) '(#f #f)) 'error)
(test (set! (symbol-access _int_) '(#f #f #f #f)) 'error)

(let ((_x1_ #f))
  (set! (symbol-access '_x1_) (list #f 
				    (lambda (x y) 'error)
				    (lambda (x y) 'error)))
  (test (set! _x1_ 32) 'error)
  (test (let ((_x1_ 32)) 2) 'error))
(set! (symbol-access '_x1_) #f)
(let ((_x1_ 0))
  (set! (symbol-access '_x1_) (list #f 
				    (lambda (x y) 'error)
				    #f))
  (test (set! _x1_ 32) 'error)
  (test (let ((_x1_ 32)) _x1_) 32))
(set! (symbol-access '_x1_) #f)
(let ((_x1_ 0))
  (set! (symbol-access '_x1_) (list #f 
				    (lambda (x y) 0)
				    (lambda (x y) (* y 2))))
  (test (begin (set! _x1_ 32) _x1_) 0)
  (test (let ((_x1_ 32)) _x1_) 64))
(set! (symbol-access '_x1_) #f)
(let ((_x1_ 0))
  (set! (symbol-access '_x1_) (list #f 
				    (lambda (x y) (symbol->value x))
				    (lambda (x y) (+ 2 (symbol->value x)))))
  (test (begin (set! _x1_ 32) _x1_) 0)
  (test (let ((_x1_ 32)) _x1_) 2))

(let ((_acc_var1_ 0)
      (_acc_var2_ 1))
  (set! (symbol-access '_acc_var1_)
	(list #f
	      (lambda (symbol new-value)
		(set! _acc_var2_ _acc_var1_)
		new-value)
	      #f))
  (set! (symbol-access '_acc_var2_)
	(list #f
	      (lambda (symbol new-value)
		new-value)
	      #f))
  (test (list _acc_var1_ _acc_var2_) '(0 1))
  (set! _acc_var1_ 32)
  (test (list _acc_var1_ _acc_var2_) '(32 0)))

(define _x3_ 3)
(set! (symbol-access '_x3_) (list #f (lambda (a b) b) (lambda (a b) b)))
(test (let ((_x3_ 32)) _x3_) 32)
(test (let ((_x3_ 32)) (set! _x3_ 1) _x3_) 1)
(test (let ((_x3_ 32)) (letrec ((_x3_ 1)) _x3_)) 1)
  
(let ()
  (define-macro (define-integer var value)
    `(begin
       (define ,var ,value)
       (set! (symbol-access ',var) 
	     (list #f
		   (lambda (symbol new-value)
		     (if (real? new-value)
			 (floor new-value)
			 (error "~A can only take an integer value, not ~S" symbol new-value)))
		   (lambda (symbol new-value)
		     (if (real? new-value)
			 (floor new-value)
			 (error "~A can only take an integer value, not ~S" symbol new-value)))))
       ',var))
  
  (define-integer _just_int_ 32)
  (set! _just_int_ 123.123)
  (test _just_int_ 123)
  (let ((tag (catch #t 
		    (lambda ()
		      (set! _just_int_ "123"))
		    (lambda args 'error))))
    (test tag 'error))
  
  (let ((tag (catch #t 
		    (lambda ()
		      (define _just_int_ "123"))
		    (lambda args 'error))))
    (test tag 'error))
  
  (let ((tag (catch #t 
		    (lambda ()
		      (define (_just_int_ a) "123"))
		    (lambda args 'error))))
    (test tag 'error))
  
  (let ((tag (catch #t 
		    (lambda ()
		      (define* (_just_int_ a) "123"))
		    (lambda args 'error))))
    (test tag 'error))
  
  (let ((tag (catch #t 
		    (lambda ()
		      (define-macro (_just_int_ a) "123"))
		    (lambda args 'error))))
    (test tag 'error))
  
  (let ((tag (catch #t 
		    (lambda ()
		      (defmacro _just_int_ (a) "123"))
		    (lambda args 'error))))
    (test tag 'error))
  
  (test (letrec ((_just_int_ 12.41)) _just_int_) 12)
  (test (let ((_just_int_ 12.41)) _just_int_) 12)
  (test (let* ((_just_int_ 12.41)) _just_int_) 12)
  
  (test (do ((_just_int_ 1.5 (+ _just_int_ 2))) ((>= _just_int_ 10) _just_int_)) 11)
  ;;  (format #t "do: ~A~%" (do ((_just_int_ 1.5 (+ _just_int_ 2.3))) ((>= _just_int_ 10) _just_int_))) ; 10.2 (no step check)
  )

(let ()
  ;; CL property lists
  (define get (make-procedure-with-setter
	       (lambda (sym property)
		 (let ((val (assoc property (symbol-plist sym))))
		   (and val (cdr val))))
	       (lambda (sym property value)
		 (let* ((access (symbol-access sym))
			(plist (and (pair? access) (car access)))
			(prop (and (pair? plist) (assoc property plist))))
		   (if (pair? prop)
		       (set-cdr! prop value)
		       (if (pair? access)
			   (if (pair? plist)
			       (set-car! access (cons (cons property value) plist))
			       (set-car! access (list (cons property value))))
			   (set! (symbol-access sym) (list (list (cons property value)) #f #f))))
		   value))))
  
  (define (symbol-plist sym)
    (let ((access (symbol-access sym)))
      (if (pair? access)
	  (or (car access) ())
	  ())))

  ;; using s7-version here is bad -- all safe funcs share the same immutable accessor
  (test (symbol-plist 's7-version) ())
  (test (get 's7-version 'hiho) #f)
  (test (set! (get 's7-version 'hiho) 123) 123)
  (test (symbol-plist 's7-version) '((hiho . 123)))
;  (test (symbol-access 's7-version) '(((hiho . 123)) #f #f))
  (test (get 's7-version 'hiho) 123)
  (test (set! (get 's7-version 'hiho) 321) 321)
  (test (get 's7-version 'hiho) 321)
  (test (set! (get 's7-version 'newp) 321123) 321123)
  (test (symbol-plist 's7-version) '((newp . 321123) (hiho . 321)))
  (test (get 's7-version 'newp) 321123)
  (test (get 's7-version 'hiho) 321)
)




#|
;;; these tests are problematic -- they might not fail as hoped, or they might generate unwanted troubles
(let ((bad-ideas "
                      (define (bad-idea)
                        (let ((lst '(1 2 3)))
                          (let ((result (list-ref lst 1)))
                            (list-set! lst 1 (* 2.0 16.6))
                            (gc)
                            result)))

                      (define (bad-idea-1)
                        (let ((lst #(1 2 3)))
                          (let ((result (vector-ref lst 1)))
                            (vector-set! lst 1 (* 2.0 16.6))
                            (gc)
                             result)))
                      "))
  (with-output-to-file "tmp1.r5rs" (lambda () (display bad-ideas)))
  (load "tmp1.r5rs"))

(num-test (bad-idea) 2)
(let ((val (bad-idea)))
  (if (equal? val 33.2)
      (set! val (bad-idea)))
  (if (equal? val 33.2)
      (format #t ";bad-idea 3rd time: ~A~%" val)))
(num-test (bad-idea-1) 2)
(let ((val (bad-idea-1)))
  (if (equal? val 33.2)
      (set! val (bad-idea-1)))
  (if (equal? val 33.2)
      (format #t ";bad-idea-1 3rd time: ~A~%" val)))
(set! *safety* 1)
(load "tmp1.r5rs")
(num-test (bad-idea) 2)
(num-test (bad-idea) 33.2)
(num-test (bad-idea) 33.2)
(num-test (bad-idea-1) 2)
(num-test (bad-idea-1) 33.2)
(num-test (bad-idea-1) 33.2)
(set! *safety* 0)
|#

;(test (quit 0) 'error)

;;; macroexpand
(let () 
  (define-macro (hi a) `(+ ,a 1))
  (test (macroexpand (hi 2)) '(+ 2 1))
  (test (macroexpand (hi (abs 2))) '(+ (abs 2) 1))
  (define-macro (ho a) `(+ ,@a 1))
  (test (macroexpand (ho (2 3 4))) '(+ 2 3 4 1))
  (define-macro* (hi1 a (b 2)) `(+ ,a ,b))
  (test (macroexpand (hi1 3)) '(+ 3 2))
  )



;;; define-expansion
(define-expansion (_expansion_ a) `(+ ,a 1))
(test (_expansion_ 3) 4)
(test (macroexpand (_expansion_ 3)) `(+ 3 1))
(test '(_expansion_ 3) (quote (_expansion_ 3)))
(test (_expansion_ (+ (_expansion_ 1) 2)) 5)


;;; define-constant
(test (let () (define-constant __c1__ 32) __c1__) 32)
(test (let () __c1__) 'error)
(test (let ((__c1__ 3)) __c1__) 'error)
(test (let* ((__c1__ 3)) __c1__) 'error)
(test (letrec ((__c1__ 3)) __c1__) 'error)
(test (let () (define (__c1__ a) a) (__c1__ 3)) 'error)
(test (let () (set! __c1__ 3)) 'error)
