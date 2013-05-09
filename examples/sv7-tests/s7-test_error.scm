(test (catch #t (lambda () (error 'oops 1)) (let () (lambda args (caadr args)))) 1)
(test (catch #t (lambda () (error 'oops 1)) (let ((x 3)) (lambda args (+ x (caadr args))))) 4)
(test (catch #t (let () (lambda () (error 'oops 1))) (let ((x 3)) (lambda args (+ x (caadr args))))) 4)
(test (catch #t (let ((x 2)) (lambda () (error 'oops x))) (let ((x 3)) (lambda args (+ x (caadr args))))) 5)
(test (catch #t (let ((x 2)) ((lambda () (lambda () (error 'oops x))))) (let ((x 3)) (lambda args (+ x (caadr args))))) 5)

(test (let ((pws (make-procedure-with-setter (lambda () (+ 1 2)) (lambda (a) (+ a 2)))))
	(catch #t pws (lambda (tag type) tag)))
      3)
(test (let ((pws (make-procedure-with-setter (lambda () (error 'pws 3) 4) (lambda (a) (+ a 2)))))
	(catch #t pws (lambda (tag type) tag)))
      'pws)
(test (let ((pws (make-procedure-with-setter (lambda (a b) a) (lambda (a b) (+ a 2)))))
	(catch #t (lambda () (error 'pws-error 3)) pws))
      'pws-error)

(for-each
 (lambda (tag)
   (let ((val (catch tag (lambda () (error tag "an error") 123) (lambda args (car args)))))
     (if (not (equal? tag val))
	 (format #t ";catch ~A -> ~A~%" tag val))))
 (list :hi '() #() #<eof> #f #t #<unspecified> car #\a 32 9/2))

(for-each
 (lambda (tag)
   (let ((val (catch #t (lambda () (error tag "an error") 123) (lambda args (car args)))))
     (if (not (equal? tag val))
	 (format #t ";catch #t (~A) -> ~A~%" tag val))))
 (list :hi '() #<eof> #f #t #<unspecified> car #\a 32 9/2 '(1 2 3) '(1 . 2) #(1 2 3) #()))

(for-each
 (lambda (tag)
   (test (catch #t tag (lambda args (car args))) 'error)
   (test (catch #t (lambda () #f) tag) 'error))
 (list :hi '() #<eof> #f #t #<unspecified> #\a 32 9/2 '(1 2 3) '(1 . 2) #(1 2 3) #()))

;; (error <string>...) throws 'no-catch which makes it harder to check
(let ((val (catch #t (lambda () (error "hi") 123) (lambda args (car args)))))
  (if (not (eq? val 'no-catch))
      (format #t ";catch #t, tag is string -> ~A~%" val)))

(for-each
 (lambda (tag)
   (let ((val (catch tag (lambda () (error #t "an error") 123) (lambda args (car args)))))
     (if (not (equal? #t val))
	 (format #t ";catch ~A -> ~A (#t)~%" tag val))))
 (list :hi '() #<eof> #f #t #<unspecified> car #\a 32 9/2))

(let ((tag 'tag)) (test (catch (let () tag) (lambda () (set! tag 123) (error 'tag "tag") tag) (lambda args (car args))) 'tag))

(let ()
  (define (check-reerror x)
    (catch #t
      (lambda ()
	(define (our-func x)
	  (case x
	    ((0) (error 'zero))
	    ((1) (error 'one))
	    (else (error 'else))))
	(catch #t 
  	  (lambda () 
	    (our-func x))
	  (lambda args
	    (if (eq? (car args) 'one)
		(our-func (+ x 1))
		(apply error args)))))
      (lambda args
	(let ((type (car args)))
	  (case type
	    ((zero) 0)
	    ((one) 1)
	    (else 2))))))
  (test (check-reerror 0) 0)
  (test (check-reerror 1) 2)
  (test (check-reerror 2) 2))

(test (catch 'hiho
	     (lambda ()
	       (define (f1 a)
		 (error 'hiho a))
	       (* 2 (catch 'hiho
			   (lambda ()
			     (f1 3))
			   (lambda args (caadr args)))))
	     (lambda args (caadr args)))
      6)

(test (let ()
	(define (f1 a)
	  (error 'hiho a))
	(catch 'hiho
	       (lambda ()
		 (* 2 (catch 'hiho
			     (lambda ()
			       (f1 3))
			     (lambda args (caadr args)))))
	       (lambda args (caadr args))))
      6)

(test (catch 'hiho
	     (lambda ()
	       (let ((f1 (catch 'hiho
				(lambda ()
				  (lambda (a) (error 'hiho 3)))
				(lambda args args))))
		 (f1 3)))
	     (lambda args (caadr args)))
      3)


(test (error) 'error)
(test (let ((x 1))
	(let ((val (catch #\a
			  (lambda ()
			    (set! x 0)
			    (error #\a "an error")
			    (set! x 2))
			  (lambda args
			    (if (equal? (car args) #\a)
				(set! x (+ x 3)))
			    x))))
	  (= x val 3)))
      #t)
(test (let ((x 1))
	(let ((val (catch 32
			   (lambda ()
			     (catch #\a
				    (lambda ()
				      (set! x 0)
				      (error #\a "an error: ~A" (error 32 "another error!"))
				      (set! x 2))
				    (lambda args
				      (if (equal? (car args) #\a)
					  (set! x (+ x 3)))
				      x)))
			   (lambda args 
			     (if (equal? (car args) 32)
				 (set! x (+ x 30)))))))
	  (= x val 30)))
      #t)





;;; --------------------------------------------------------------------------------

(define (last-pair l) ; needed also by loop below
  (if (pair? (cdr l)) 
      (last-pair (cdr l)) l))
  

(let ()
  ;; from guile-user I think
  ;; (block LABEL FORMS...)
  ;;
  ;; Execute FORMS.  Within FORMS, a lexical binding named LABEL is
  ;; visible that contains an escape function for the block.  Calling
  ;; the function in LABEL with a single argument will immediatly stop
  ;; the execution of FORMS and return the argument as the value of the
  ;; block.  If the function in LABEL is not invoked, the value of the
  ;; block is the value of the last form in FORMS.
  
  (define-macro (block label . forms)
    `(let ((body (lambda (,label) ,@forms))
	   (tag (gensym "return-")))
       (catch tag
	      (lambda () (body (lambda (val) (error tag val))))
	      (lambda (tag val) val))))
  
  ;; (with-return FORMS...)
  ;;
  ;; Equivalent to (block return FORMS...)
  
  (define-macro (with-return . forms)
    `(block return ,@forms))
  
  ;; (tagbody TAGS-AND-FORMS...)
  ;;
  ;; TAGS-AND-FORMS is a list of either tags or forms.  A TAG is a
  ;; symbol while a FORM is everything else.  Normally, the FORMS are
  ;; executed sequentially.  However, control can be transferred to the
  ;; forms following a TAG by invoking the tag as a function.  That is,
  ;; within the FORMS, there is a lexical binding for each TAG with the
  ;; symbol that is the tag as its name.  The bindings carry functions
  ;; that will execute the FORMS following the respective TAG.
  ;;
  ;; The value of a tagbody is always `#f'.
  
  (define (transform-tagbody forms)
    (let ((start-tag (gensym "start-"))
	  (block-tag (gensym "block-")))
      (let loop ((cur-tag start-tag)
		 (cur-code '())
		 (tags-and-code '())
		 (forms forms))
	(cond
	 ((null? forms)
	  `(block ,block-tag
		  (letrec ,(reverse! (cons (list cur-tag `(lambda () ,@(reverse! (cons `(,block-tag #f) cur-code)))) tags-and-code))
		    (,start-tag))))
	 ((symbol? (car forms))
	  (loop (car forms)
		'()
		(cons (list cur-tag `(lambda () ,@(reverse! (cons `(,(car forms)) cur-code)))) tags-and-code)
		(cdr forms)))
	 (else
	  (loop cur-tag
		(cons (car forms) cur-code)
		tags-and-code
		(cdr forms)))))))
  
  (define-macro (tagbody . forms)
    (transform-tagbody forms))
  
  (define (first_even l)
    (with-return
     (tagbody
      continue
      (if (not (not (null? l)))
	  (break))
      (let ((e (car l)))
	(if (not (number? e))
	    (break))
	(if (even? e)
	    (return e))
	(set! l (cdr l)))
      (continue)
      break)
     (return #f)))
  
  (let ((val (first_even '(1 3 5 6 7 8 9))))
    (if (not (equal? val (list 6)))
	(format #t "first_even (tagbody, gensym, reverse!) (6): '~A~%" val)))
  )
