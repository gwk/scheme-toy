(let ((f1 (lambda (a) (+ a 1)))
      (f2 (lambda* ((a 2)) (+ a 1))))
  (define (hi a) (+ a 1))
  (define* (ho (a 1)) (+ a 1))
  (test (environment? (procedure-environment hi)) #t)
  (test (null? (environment->list (procedure-environment hi))) #f)
  (test (environment? (procedure-environment ho)) #t)
  (test (environment? (procedure-environment f1)) #t)
  (test (environment? (procedure-environment f2)) #t)
  (test (environment? (procedure-environment abs)) #t)
  (test (length (procedure-environment ho)) 1)
  (test (> (length (procedure-environment abs)) 100) #t)
  (test (fill! (procedure-environment abs) 0) 'error)
  (test (reverse (procedure-environment abs)) 'error)
  (test (fill! (procedure-environment ho) 0) 'error)
  (test (reverse (procedure-environment ho)) 'error))

(test (procedure-environment quasiquote) (global-environment))
(test (procedure-environment lambda) 'error)
(test (procedure-environment abs) (global-environment))
(test (procedure-environment cond-expand) (global-environment))

(let ()
  (define func (let ((lst (list 1 2 3))) 
		 (lambda (a) 
		   (((procedure-environment func) 'lst) a))))
  (test (func 1) 2))

#|
;;; but: 
:(define func (let ((lst (list 1 2 3))) 
		 (lambda (a) 
		   ((procedure-environment func) 'lst a))))
func
:(func 1)
;environment as applicable object takes one argument: (lst 1)
;    'lst

which seems inconsistent

:(define func (let ((lst (list 1 2 3))) 
		 (lambda (a) 
		   ((list (procedure-environment func)) 0 'lst))))
func
:(func 1)
(1 2 3)
|#

(for-each
 (lambda (arg)
   (test (procedure-environment arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi '#(()) (list 1 2 3) '(1 . 2) "hi"))


(let ()
  (define (make-iterator obj)
    (let ((ctr 0))
      (lambda ()
	(and (< ctr (length obj))
	     (let ((val (obj ctr)))
	       (set! ctr (+ ctr 1))
	       val)))))

  (define-macro (with-iterator obj . body) 
    `(with-environment (procedure-environment ,obj) ,@body))
  
  (define iterator-ctr 
    (make-procedure-with-setter 
     (lambda (iter)
       (with-iterator iter ctr))
     (lambda (iter new-ctr)
       (with-environment 
	(augment-environment (procedure-environment iter) (cons 'new-ctr new-ctr))
	(set! ctr new-ctr)))))
  
  (define (iterator-obj iter)
    (with-iterator iter obj))
  
  (define (iterator-copy iter)
    (let ((new-iter (make-iterator (iterator-obj iter))))
      (set! (iterator-ctr new-iter) (iterator-ctr iter))
      new-iter))
  
  (define (iterator->string iterator)
    (let ((look-ahead (iterator-copy iterator)))
      (string-append "#<iterator ... " 
		     (object->string (look-ahead)) " "
		     (object->string (look-ahead)) " "
		     (object->string (look-ahead))
		     " ...>")))
  
  (let ((v1 (list 1 2 3 4)) 
	(v2 (vector 1.0 2.0))
	(v3 (string #\1 #\2 #\3)))
    (let ((obj1 (make-iterator v1))
	  (obj2 (make-iterator v2))
	  (obj3 (make-iterator v3))
	  (obj4 (make-iterator v3)))
      (test (morally-equal? obj1 obj3) #f)
      (test (morally-equal? obj4 obj3) #t)
      (test (list (obj1) (obj2) (obj3)) (list 1 1.0 #\1))
      (test (list (obj1) (obj2) (obj3)) (list 2 2.0 #\2))
      (test (list (obj1) (obj2) (obj3)) (list 3 #f #\3))
      (test (list (obj1) (obj2) (obj3)) (list 4 #f #f))
      (test (list (obj1) (obj2) (obj3)) (list #f #f #f))
      (test (morally-equal? obj4 obj3) #f)
      ))

  (let ((v (vector 0 1 2 3 4 5 6 7 8 9)))
    (let ((iterator (make-iterator v)))
      (let* ((vals (list (iterator) (iterator) (iterator)))
	     (description (iterator->string iterator))
	     (more-vals (list (iterator) (iterator))))
	(test (list vals description more-vals) '((0 1 2) "#<iterator ... 3 4 5 ...>" (3 4))))))
  )

(test (let ()
	(define (hi a)
	  (let ((func __func__))
	    (list (if (symbol? func) func (car func))
		  a)))
	(hi 1))
      (list 'hi 1))

(test (let ()
	(define hi (let ((a 32)) 
		     (lambda (b) 
		       (+ a b))))
	(define ho (with-environment 
		    (procedure-environment hi) 
		    (lambda (b) 
		      (+ a b))))
	(list (hi 1) (ho 1)))
      (list 33 33))

(test (let ()
	(define (hi a) (+ a 1))
	(with-environment (procedure-environment hi) 
			  ((eval (procedure-source hi)) 2)))
      3)

(let ()
  (define (where-is func)
    (let ((addr (with-environment (procedure-environment func) __func__)))
      (if (not (pair? addr))
	  ""
	  (list (format #f "~A[~D]" (cadr addr) (caddr addr))
		addr))))
  (let ((e (where-is ok?)))
    (test (and (pair? (cadr e))
	       (< ((cadr e) 2) 100)) ; this depends on where ok? is in this file
	  #t)
    (test (and (pair? (cadr e))
	       (string=? (symbol->string (car (cadr e))) "ok?"))
	  #t)
    (test (and (pair? (cadr e))
	       (let ((name (cadr (cadr e))))
		 (and (string? name)
		      (call-with-exit
		       (lambda (oops)
			 (let ((len (length name)))
			   (do ((i 0 (+ i 1)))
			       ((= i len) #t)
			     (if (and (not (char-alphabetic? (name i)))
				      (not (char=? (name i) #\/))
				      (not (char=? (name i) #\\))
				      (not (char=? (name i) #\.))
				      (not (char=? (name i) #\-))
				      (not (char-numeric? (name i))))
				 (begin
				   (format #t "ok? file name: ~S~%" name)
				   (oops #f))))))))))
	  #t)))

(let ()
  (define-macro (window func beg end . body)
    `(call-with-exit
      (lambda (quit)
	(do ((notes ',body (cdr notes)))
	    ((null? notes))
	  (let* ((note (car notes))
		 (note-beg (cadr note)))
	    (if (<= ,beg note-beg)
		(if (> note-beg (+ ,beg ,end))
		    (quit)
		    (,func note))))))))
  
  (test 
   (let ((n 0))
     (window (lambda (a-note) (set! n (+ n 1))) 0 1 
	     (fm-violin 0 1 440 .1) 
	     (fm-violin .5 1 550 .1) 
	     (fm-violin 3 1 330 .1))
     n)
   2)
  
  (test 
   (let ((notes 0)
	 (env #f))
     (set! env (current-environment))
     (window (with-environment env (lambda (n) (set! notes (+ notes 1)))) 0 1 
	     (fm-violin 0 1 440 .1) 
	     (fm-violin .5 1 550 .1) 
	     (fm-violin 3 1 330 .1))
     notes)
   2))

(test (let ()
	(define-macro (window func beg end . body)
	  `(let ((e (current-environment)))
	     (call-with-exit
	      (lambda (quit)
		(do ((notes ',body (cdr notes)))
		    ((null? notes))
		  (let* ((note (car notes))
			 (note-beg (cadr note)))
		    (if (<= ,beg note-beg)
			(if (> note-beg (+ ,beg ,end))
			    (quit)
			    ((with-environment e ,func) note)))))))))
	
	(let ((notes 0))
	  (window (lambda (n) (set! notes (+ notes 1))) 0 1 
		  (fm-violin 0 1 440 .1) 
		  (fm-violin .5 1 550 .1) 
		  (fm-violin 3 1 330 .1))
	  notes))
      2)

;;; this is version dependent
;;;(let ((a 32)) 
;;;  (define (hi x) (+ x a)) 
;;;  (test (defined? 'bbbbb (procedure-environment hi)) #f)
;;;  (let ((xdef (defined? 'x (procedure-environment hi))))
;;;    (test xdef #t))
;;;  (test (symbol->value 'a (procedure-environment hi)) 32))

(let ()
  (let ((x 32))
    (define (hi a) (+ a x))
    (let ((xx ((procedure-environment hi) 'x)))
      (test xx 32))
    (let ((s7-version 321))
      (test s7-version 321)
      (let ((xxx ((initial-environment) 'x)))
	(test xxx 32)
	(let ((str (with-environment (initial-environment) (s7-version))))
	  (test (string? str) #t))))))

;;; procedure-environment is a mess but it's hard to test mainly because it's different in different versions of s7
;;;    and the test macro affects it
;;; 
;;; (test (let () (define (func3 a b) (+ a b)) (environment->list (procedure-environment func3))) '((b) (a)))
;;; or is it ((__func__ . func3)) in context?
;;; 
;;; ;;; troubles:
;;; (let ((func1 (lambda (a b) (+ a b)))) (symbol->value '__func__ (procedure-environment func1))) -> #<undefined>
;;; (let ((func1 (lambda (a b) (+ a b)))) (eq? (procedure-environment func1) (global-environment))) -> #t
;;; 
;;; (letrec ((func1 (lambda (a b) (+ a b)))) (eq? (procedure-environment func1) (global-environment))) -> #f
;;; (letrec ((func1 (lambda (a b) (+ a b)))) (environment->list (procedure-environment func1))) -> ((func1 . #<closure>))
;;; 
;;; (let () (define* (func4 (a 1) b) (+ a b)) (environment->list (procedure-environment func4))) -> ((__func__ . func4))
;;; (let () (define-macro (func4 a b) `(+ ,a ,b)) (environment->list (procedure-environment func4))) -> ((func4 . #<macro>))
;;; 
;;; (let () (let ((func2 (lambda (a b) (+ a b)))) (environment->list (procedure-environment func2)))) -> ()
;;; 
;;; (procedure-environment #<continuation>) -> #<global-environment>
;;; (procedure-environment #<goto>) -> #<global-environment>
;;; and setter of pws is either global or ()
;;; 
;;; ;;; this returns #t because the fallback in g_procedure_environment is the global env
;;; (eq? (global-environment)
;;;      (let ((a 32))
;;;        (call-with-exit ; or call/cc
;;; 	(lambda (return)
;;; 	  (procedure-environment return)))))
;;; 
;;; (procedure-environment values) -> global env! (like catch/dynamic-wind it's a procedure)
;;; this is also true of (procedure-environment (lambda () 1)) 
;;; 
;;; :(procedure-environment (vct 1 2))
;;; #<environment>
;;; :(procedure-environment (vector 1 2))
;;; 					;procedure-environment argument, #(1 2), is a vector but should be a procedure or a macro
;;; 					;    (vector 1 2)
;;; 
;;; :(let ((a 1)) (define-macro (m1 b) `(+ ,a ,b)) (environment->list (procedure-environment m1)))
;;; ((a . 1) (m1 . #<macro>))
;;; :(let ((a 1)) (define (m1 b) (+ a b)) (environment->list (procedure-environment m1)))
;;; ((b))
;;; :(let ((a 1)) (define (m1 b) (+ a b)) (environment->list (outer-environment (procedure-environment m1))))
;;; ((__func__ . m1))
;;; 
;;; (procedure-documentation macroexpand) -> ""  ; also cond-expand

#|
;;; this checks existing procedures
(let ((st (symbol-table)) 
      (p (open-output-file "pinfo")))
  (do ((i 0 (+ i 1))) 
      ((= i (vector-length st)))
    (let ((lst (vector-ref st i)))
      (for-each 
       (lambda (sym)
	 (if (defined? sym)
	     (let ((val (symbol->value sym)))
	       (format p "---------------- ~A ----------------~%" sym)
	       (catch #t 
		      (lambda () 
			(let ((str (procedure-documentation val))
			      (sym-name (symbol->string sym)))
			  (if (procedure? val)
			      (if (= (length str) 0)
				  (format p "~A: [no doc]~%" sym)
				  (let ((pos (substring? sym-name str)))
				    (if (and (not pos)
					     (not (char-upper-case? (sym-name 0)))
					     (not (char=? (sym-name 0) #\.))
					     (not (char=? (sym-name 0) #\[)))
					(format p "~A documentation [no matched name]: ~A~%" sym str))))
			      (if (> (length str) 0)
				  (format p "~A (not a procedure) documentation: ~A~%" str)))))
		      (lambda args
			(if (procedure? val)
			    (format p "~A documentation: error: ~A~%" sym (apply format #f (cadr args))))))
	       (catch #t 
		      (lambda () 
			(let ((str (procedure-name val)))
			  (if (= (length str) 0)
			      (if (procedure? val)
				  (format p "~A: [no name]~%" sym))
			      (if (not (string=? str (symbol->string sym)))
				  (format p "~A name [unmatched]: ~A~%" sym str)))))
		      (lambda args
			(if (procedure? val)
			    (format p "~A name: error: ~A~%" sym (apply format #f (cadr args))))))
	       (catch #t 
		      (lambda () 
			(let ((lst (procedure-source val)))
			  (if (not lst)
			      (if (procedure? val)
				  (format p "~A: [no source]~%" sym))
			      (if (and (not (pair? lst))
				       (not (null? lst)))
				  (format p "~A source: ~A~%" sym lst)))))
		      (lambda args
			(if (procedure? val)
			    (format p "~A source: error: ~A~%" sym (apply format #f (cadr args))))))
	       (catch #t 
		      (lambda () 
			(let ((lst (procedure-arity val)))
			  (if (not lst)
			      (if (procedure? val)
				  (format p "~A: [no arity]~%" sym))
			      (if (not (pair? lst))
				  (format p "~A arity: ~A~%" sym lst)))))
		      (lambda args
			(if (procedure? val)
			    (format p "~A arity: error: ~A~%" sym (apply format #f (cadr args))))))
	       (catch #t 
		      (lambda () 
			(let ((pe (procedure-environment val)))
			  (if (not pe)
			      (if (procedure? val)
				  (format p "~A: [no environment]~%" sym))
			      (if (not (environment? pe))
				  (format p "~A environment:~%" sym pe)
				  (if (not (eq? (global-environment) pe))
				      (format p "~A env: ~A~%" sym (environment->list pe)))))))
		      (lambda args
			(if (procedure? val)
			    (format p "~A environment: error: ~A~%" sym (apply format #f (cadr args))))))
	       )))
       lst)))
  (close-output-port p))
|#


;;; object-environment
(for-each
 (lambda (arg)
   (test (object-environment arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi '#(()) (list 1 2 3) '(1 . 2) "hi" car macroexpand (lambda () 1) (lambda* (a) a)))
(test (object-environment) 'error)
(test (object-environment 1 2) 'error)
(test (object-environment (make-random-state 123)) ())
(test (set! (object-environment (make-random-state 123)) ()) 'error)
