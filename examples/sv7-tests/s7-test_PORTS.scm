(define start-input-port (current-input-port))
(define start-output-port (current-output-port))

(test (input-port? (current-input-port)) #t)
(test (input-port? *stdin*) #t)
(test (input-port? (current-output-port)) #f)
(test (input-port? *stdout*) #f)
(test (input-port? (current-error-port)) #f)
(test (input-port? *stderr*) #f)

(for-each
 (lambda (arg)
   (if (input-port? arg)
       (format #t ";(input-port? ~A) -> #t?~%" arg)))
 (list "hi" #f (integer->char 65) 1 (list 1 2) '#t '3 (make-vector 3) 3.14 3/4 1.0+1.0i #\f :hi #<eof> #<undefined> #<unspecified>))

(test (call-with-input-file "s7test.scm" input-port?) #t)
(if (not (eq? start-input-port (current-input-port)))
    (format #t "call-with-input-file did not restore current-input-port? ~A from ~A~%" start-input-port (current-input-port)))

(test (let ((this-file (open-input-file "s7test.scm"))) (let ((res (input-port? this-file))) (close-input-port this-file) res)) #t)
(if (not (eq? start-input-port (current-input-port)))
    (format #t "open-input-file clobbered current-input-port? ~A from ~A~%" start-input-port (current-input-port)))

(test (call-with-input-string "(+ 1 2)" input-port?) #t)
(test (let ((this-file (open-input-string "(+ 1 2)"))) (let ((res (input-port? this-file))) (close-input-port this-file) res)) #t)

;;; read
;;; write
(test (+ 100 (call-with-input-string "123" (lambda (p) (values (read p) 1)))) 224)


(test (call-with-input-string
       "1234567890"
       (lambda (p)
	 (call-with-input-string
	  "0987654321"
	  (lambda (q)
            (+ (read p) (read q))))))
      2222222211)

(test (call-with-input-string
       "12345 67890"
       (lambda (p)
	 (call-with-input-string
	  "09876 54321"
	  (lambda (q)
            (- (+ (read p) (read q)) (read p) (read q))))))
      -99990)

(call-with-output-file "empty-file" (lambda (p) #f))
(test (call-with-input-file "empty-file" (lambda (p) (eof-object? (read-char p)))) #t)
(test (call-with-input-file "empty-file" (lambda (p) (eof-object? (read p)))) #t)
(test (call-with-input-file "empty-file" (lambda (p) (eof-object? (read-byte p)))) #t)
(test (call-with-input-file "empty-file" (lambda (p) (eof-object? (read-line p)))) #t)
(test (load "empty-file") #<unspecified>)
(test (call-with-input-file "empty-file" (lambda (p) (port-closed? p))) #f)
(test (eof-object? (call-with-input-string "" (lambda (p) (read p)))) #t)
(test (eof-object? #<eof>) #t)
(test (let () (define (hi a) (eof-object? a)) (hi #<eof>)) #t)

(let ()
  (define (io-func) (lambda (p) (eof-object? (read-line p))))
  (test (call-with-input-file (let () "empty-file") (io-func)) #t))

(let ((p1 #f))
  (call-with-output-file "empty-file" (lambda (p) (set! p1 p) (write-char #\a p)))
  (test (port-closed? p1) #t))
(test (call-with-input-file "empty-file" (lambda (p) (and (char=? (read-char p) #\a) (eof-object? (read-char p))))) #t)
(test (call-with-input-file "empty-file" (lambda (p) (and (string=? (symbol->string (read p)) "a") (eof-object? (read p))))) #t) ; Guile also returns a symbol here
(test (call-with-input-file "empty-file" (lambda (p) (and (char=? (integer->char (read-byte p)) #\a) (eof-object? (read-byte p))))) #t)
(test (call-with-input-file "empty-file" (lambda (p) (and (string=? (read-line p) "a") (eof-object? (read-line p))))) #t)

(test (call-with-input-string "(lambda (a) (+ a 1))" (lambda (p) (let ((f (eval (read p)))) (f 123)))) 124)
(test (call-with-input-string "(let ((x 21)) (+ x 1))" (lambda (p) (eval (read p)))) 22)
(test (call-with-input-string "(1 2 3) (4 5 6)" (lambda (p) (list (read p) (read p)))) '((1 2 3) (4 5 6)))

(test (let ()
	(call-with-output-file "empty-file" (lambda (p) (write '(lambda (a) (+ a 1)) p)))
	(call-with-input-file "empty-file" (lambda (p) (let ((f (eval (read p)))) (f 123)))))
      124)
(test (let ()
	(call-with-output-file "empty-file" (lambda (p) (write '(let ((x 21)) (+ x 1)) p)))
	(call-with-input-file "empty-file" (lambda (p) (eval (read p)))))
      22)
(test (let ()
	(call-with-output-file "empty-file" (lambda (p) (write '(1 2 3) p) (write '(4 5 6) p)))
	(call-with-input-file "empty-file" (lambda (p) (list (read p) (read p)))))
      '((1 2 3) (4 5 6)))

(call-with-output-file "empty-file" (lambda (p) (for-each (lambda (c) (write-char c p)) "#b11")))
(test (call-with-input-file "empty-file" (lambda (p) 
					   (and (char=? (read-char p) #\#) 
						(char=? (read-char p) #\b) 
						(char=? (read-char p) #\1) 
						(char=? (read-char p) #\1) 
						(eof-object? (read-char p))))) 
      #t)
(test (call-with-input-file "empty-file" (lambda (p) 
					   (and (= (read p) 3) 
						(eof-object? (read p))))) 
      #t)
(test (call-with-input-file "empty-file" (lambda (p) 
					   (and (= (read-byte p) (char->integer #\#))
						(= (read-byte p) (char->integer #\b))
						(= (read-byte p) (char->integer #\1))
						(= (read-byte p) (char->integer #\1))
						(eof-object? (read-byte p))))) 
      #t)
(test (call-with-input-file "empty-file" (lambda (p) 
					   (and (string=? (read-line p) "#b11") 
						(eof-object? (read-line p))))) 
      #t)
(test (load "empty-file") 3)
(let ((p1 (make-procedure-with-setter (lambda (p) (and (= (read p) 3) (eof-object? (read p)))) (lambda (p) #f))))
  (test (call-with-input-file "empty-file" p1) #t))


;;; load
(for-each
 (lambda (arg)
   (test (load arg) 'error)
   (test (load "empty-file" arg) 'error))
 (list '() (list 1) '(1 . 2) #f #\a 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))
(test (load) 'error)
(test (load "empty-file" (current-environment) 1) 'error)
(test (load "not a file") 'error)
(test (load "") 'error)
(test (load "/home/bil/cl") 'error)

(call-with-output-file "empty-file" (lambda (p) (write '(+ 1 2 3) p)))
(let ((x 4))
  (test (+ x (load "empty-file")) 10))

(call-with-output-file "empty-file" (lambda (p) (write '(list 1 2 3) p)))
(let ((x 4))
  (test (cons x (load "empty-file")) '(4 1 2 3)))

(call-with-output-file "empty-file" (lambda (p) (write '(values 1 2 3) p)))
(let ((x 4))
  (test (+ x (load "empty-file")) 10))
(test (+ 4 (eval (call-with-input-file "empty-file" (lambda (p) (read p))))) 10)

(call-with-output-file "empty-file" (lambda (p) (write '(+ x 1) p)))
(let ((x 2))
  (test (load "empty-file" (current-environment)) 3))

(call-with-output-file "empty-file" (lambda (p) (write '(set! x 1) p)))
(let ((x 2))
  (load "empty-file" (current-environment))
  (test x 1))

(call-with-output-file "empty-file" (lambda (p) (write '(define (hi a) (values a 2)) p) (write '(hi x) p)))
(let ((x 4))
  (test (+ x (load "empty-file" (current-environment))) 10))

(let ((x 1)
      (e #f))
  (set! e (current-environment))
  (let ((x 4))
    (test (+ x (load "empty-file" e)) 7)))

(let ()
  (let ()
    (call-with-output-file "empty-file" (lambda (p) (write '(define (load_hi a) (+ a 1)) p)))
    (load "empty-file" (current-environment))
    (test (load_hi 2) 3))
  (test (defined? 'load_hi) #f))

(let ()
  (apply load '("empty-file"))
  (test (load_hi 2) 3))

(call-with-output-file "empty-file" (lambda (p) (display "\"empty-file\"" p)))
(test (load (load "empty-file")) "empty-file")

#|
(let ((c #f)
      (i 0)
      (e #f))
  (set! e (current-environment))
  (call-with-output-file "empty-file" (lambda (p) (write '(call/cc (lambda (c1) (set! c c1) (set! i (+ i 1)))) p)))
  (load "empty-file" e)
  (test (c) 'error)) ; ;read-error ("our input port got clobbered!")
|#


(test (reverse *stdin*) 'error)
(test (fill! (current-output-port)) 'error)
(test (length *stderr*) 'error)

(test (output-port? (current-input-port)) #f)
(test (output-port? *stdin*) #f)
(test (output-port? (current-output-port)) #t)
(test (output-port? *stdout*) #t)
(test (output-port? (current-error-port)) #t)
(test (output-port? *stderr*) #t)

;(write-char #\space (current-output-port))
;(write " " (current-output-port))
(newline (current-output-port))


(for-each
 (lambda (arg)
   (if (output-port? arg)
       (format #t ";(output-port? ~A) -> #t?~%" arg)))
 (list "hi" #f '() 'hi (integer->char 65) 1 (list 1 2) _ht_ '#t '3 (make-vector 3) 3.14 3/4 1.0+1.0i #\f))

(for-each
 (lambda (arg)
   (test (read-line '() arg) 'error)
   (test (read-line arg) 'error))
 (list "hi" (integer->char 65) 1 #f _ht_ (list) (cons 1 2) (list 1 2) (make-vector 3) 3.14 3/4 1.0+1.0i #\f))

(test (call-with-output-file "tmp1.r5rs" output-port?) #t)
(if (not (eq? start-output-port (current-output-port)))
    (format #t "call-with-output-file did not restore current-output-port? ~A from ~A~%" start-output-port (current-output-port)))

(test (let ((this-file (open-output-file "tmp1.r5rs"))) (let ((res (output-port? this-file))) (close-output-port this-file) res)) #t)
(if (not (eq? start-output-port (current-output-port)))
    (format #t "open-output-file clobbered current-output-port? ~A from ~A~%" start-output-port (current-output-port)))

(test (let ((val #f)) (call-with-output-string (lambda (p) (set! val (output-port? p)))) val) #t)
(test (let ((res #f)) (let ((this-file (open-output-string))) (set! res (output-port? this-file)) (close-output-port this-file) res)) #t)

(for-each
 (lambda (arg)
   (if (eof-object? arg)
       (format #t ";(eof-object? ~A) -> #t?~%" arg)))
 (list "hi" '() '(1 2) -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #f #t (if #f #f) #<undefined> (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (let ((val (catch #t
		     (lambda () (port-closed? arg))
		     (lambda args 'error))))
     (if (not (eq? val 'error))
	 (format #t ";(port-closed? ~A) -> ~S?~%" arg val))))
 (list "hi" '(1 2) -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #f #t (if #f #f) #<undefined> #<eof> (lambda (a) (+ a 1))))

(test (port-closed?) 'error)
(test (port-closed? (current-input-port) (current-output-port)) 'error)

(call-with-output-file "tmp1.r5rs" (lambda (p) (display "3.14" p)))
(test (call-with-input-file "tmp1.r5rs" (lambda (p) (read p) (let ((val (read p))) (eof-object? val)))) #t)

(test (call-with-input-file "tmp1.r5rs" (lambda (p) (read-char p))) #\3)
(test (call-with-input-file "tmp1.r5rs" (lambda (p) (peek-char p))) #\3)
(test (call-with-input-file "tmp1.r5rs" (lambda (p) (peek-char p) (read-char p))) #\3)
(test (call-with-input-file "tmp1.r5rs" (lambda (p) (list->string (list (read-char p) (read-char p) (read-char p) (read-char p))))) "3.14")
(test (call-with-input-file "tmp1.r5rs" (lambda (p) (list->string (list (read-char p) (peek-char p) (read-char p) (read-char p) (peek-char p) (read-char p))))) "3..144")

(for-each
 (lambda (arg)
   (call-with-output-file "tmp1.r5rs" (lambda (p) (write arg p)))
   (test (call-with-input-file "tmp1.r5rs" (lambda (p) (read p))) arg))
 (list "hi" -1 #\a 1 'a-symbol (make-vector 3 0) 3.14 3/4 .6 1.0+1.0i #f #t (list 1 2 3) (cons 1 2)
       '(1 2 . 3) '() '((1 2) (3 . 4)) '(()) (list (list 'a "hi") #\b 3/4) ''a
       (string #\a #\null #\b) "" "\"hi\""
       (integer->char 128) (integer->char 127) (integer->char 255) #\space #\null #\newline #\tab
       #() #2d((1 2) (3 4)) #3d()
       :hi #<eof> #<undefined> #<unspecified>
       most-negative-fixnum
       (if with-bignums 1239223372036854775808 123)
       (if with-bignums 144580536300674537151081081515762353325831/229154728370723013560448485454219755525522 11/10)
       (if with-bignums 221529797579218180403518826416685087012.0 1000.1)
       (if with-bignums 1239223372036854775808+1239223372036854775808i 1000.1-1234i)

       ))

(for-each
 (lambda (arg)
   (call-with-output-file "tmp1.r5rs" (lambda (p) (write arg p)))
   (test (call-with-input-file "tmp1.r5rs" (lambda (p) (eval (read p)))) arg)) ; so read -> symbol?
 (list *stdout* *stdin* *stderr*
       abs + quasiquote
  
;       (hash-table '(a . 1) '(b . 2)) (hash-table)
;       0/0 (real-part (log 0))
;;; for these we need nan? and infinite? since equal? might be #f
;       (lambda (a) (+ a 1))
; pws?
;       (current-output-port)
;       (make-random-state 1234)
;       (symbol ":\"")
; (let () (define-macro (hi1 a) `(+ ,a 1)) hi1)
;;; and how could a continuation work in general?        
       ))

;;; (call-with-input-file "tmp1.r5rs" (lambda (p) (read p))) got (symbol ":\"") but expected (symbol ":\"")


;;; r4rstest
(let* ((write-test-obj '(#t #f a () 9739 -3 . #((test) "te \" \" st" "" test #() b c)))
       (load-test-obj (list 'define 'foo (list 'quote write-test-obj))))
  
  (define (check-test-file name)
    (let ((val (call-with-input-file
		   name
		 (lambda (test-file)
		   (test (read test-file) load-test-obj)
		   (test (eof-object? (peek-char test-file)) #t)
		   (test (eof-object? (read-char test-file)) #t)
		   (input-port? test-file)))))
      (if (not (eq? val #t))
	  (format #t "input-port? in call-with-input-file? returned ~A from ~A~%" val name))))
  
  (test (call-with-output-file
	    "tmp1.r5rs"
	  (lambda (test-file)
	    (write-char #\; test-file)
	    (display #\; test-file)
	    (display ";" test-file)
	    (write write-test-obj test-file)
	    (newline test-file)
	    (write load-test-obj test-file)
	    (output-port? test-file))) #t)
  (check-test-file "tmp1.r5rs")
  
  (let ((test-file (open-output-file "tmp2.r5rs")))
    (test (port-closed? test-file) #f)
    (write-char #\; test-file)
    (display #\; test-file)
    (display ";" test-file)
    (write write-test-obj test-file)
    (newline test-file)
    (write load-test-obj test-file)
    (test (output-port? test-file) #t)
    (close-output-port test-file)
    (check-test-file "tmp2.r5rs")))


(call-with-output-file "tmp1.r5rs" (lambda (p) (display "3.14" p)))
(test (with-input-from-file "tmp1.r5rs" (lambda () (read))) 3.14)
(if (not (eq? start-input-port (current-input-port)))
    (format #t "with-input-from-file did not restore current-input-port? ~A from ~A~%" start-input-port (current-input-port)))

(test (with-input-from-file "tmp1.r5rs" (lambda () (eq? (current-input-port) start-input-port))) #f)

(test (with-output-to-file "tmp1.r5rs" (lambda () (eq? (current-output-port) start-output-port))) #f)
(if (not (eq? start-output-port (current-output-port)))
    (format #t "with-output-to-file did not restore current-output-port? ~A from ~A~%" start-output-port (current-output-port)))


(let ((newly-found-sonnet-probably-by-shakespeare 
       "This is the story, a sad tale but true \
        Of a programmer who had far too little to do.\
        One day as he sat in his hut swilling stew, \
        He cried \"CLM takes forever, it's stuck in a slough!,\
        Its C code is slow, too slow by a few.\
        Why, with just a small effort, say one line or two,\
        It could outpace a no-op, you could scarcely say 'boo'\"!\
        So he sat in his kitchen and worked like a dog.\
        He typed and he typed 'til his mind was a fog. \
        Now 6000 lines later, what wonders we see!  \
        CLM is much faster, and faster still it will be!\
        In fact, for most cases, C beats the DSP!  \
        But bummed is our coder; he grumbles at night.  \
        That DSP code took him a year to write.  \
        He was paid many dollars, and spent them with glee,\
        But his employer might mutter, this result were he to see."))
  
  (call-with-output-file "tmp1.r5rs"
    (lambda (p)
      (write newly-found-sonnet-probably-by-shakespeare p)))
  
  (let ((sonnet (with-input-from-file "tmp1.r5rs"
		  (lambda ()
		    (read)))))
    (if (or (not (string? sonnet))
	    (not (string=? sonnet newly-found-sonnet-probably-by-shakespeare)))
	(format #t "write/read long string returned: ~A~%" sonnet)))
  
  (let ((file (open-output-file "tmp1.r5rs")))
    (let ((len (string-length newly-found-sonnet-probably-by-shakespeare)))
      (write-char #\" file)
      (do ((i 0 (+ i 1)))
	  ((= i len))
	(let ((chr (string-ref newly-found-sonnet-probably-by-shakespeare i)))
	  (if (char=? chr #\")
	      (write-char #\\ file))
	  (write-char chr file)))
      (write-char #\" file)
      (close-output-port file)))
  
  (let ((file (open-input-file "tmp1.r5rs")))
    (let ((sonnet (read file)))
      (close-input-port file)
      (if (or (not (string? sonnet))
	      (not (string=? sonnet newly-found-sonnet-probably-by-shakespeare)))
	  (format #t "write-char/read long string returned: ~A~%" sonnet)))))

(let ((file (open-output-file "tmp1.r5rs")))
  (for-each
   (lambda (arg)
     (write arg file)
     (write-char #\space file))
   (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t (list 1 2 3) '(1 . 2)))
  (close-output-port file))

(let ((file (open-input-file "tmp1.r5rs")))
  (for-each
   (lambda (arg)
     (let ((val (read file)))
       (if (not (equal? val arg))
	   (format #t "read/write ~A returned ~A~%" arg val))))
   (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t (list 1 2 3) '(1 . 2)))
  (close-input-port file))

(with-output-to-file "tmp1.r5rs"
  (lambda ()
    (write lists)))

(let ((val (with-input-from-file "tmp1.r5rs"
	     (lambda ()
	       (read)))))
  (if (not (equal? val lists))
      (format #t "read/write lists returned ~A~%" val)))

(if (not (string=? "" (with-output-to-string (lambda () (display "")))))
    (format #t "with-output-to-string null string?"))

(let ((str (with-output-to-string
	     (lambda ()
	       (with-input-from-string "hiho123"
		 (lambda ()
		   (do ((c (read-char) (read-char)))
		       ((eof-object? c))
		     (display c))))))))
  (if (not (string=? str "hiho123"))
      (format #t "with string ports: ~S?~%" str)))


(if (not (eof-object? (with-input-from-string "" (lambda () (read-char)))))
    (format #t ";input from null string not #<eof>?~%")
    (let ((EOF (with-input-from-string "" (lambda () (read-char)))))
      (if (not (eq? (with-input-from-string "" (lambda () (read-char)))
		    (with-input-from-string "" (lambda () (read-char)))))
	  (format #t "#<eof> is not eq? to itself?~%"))
      (if (char? EOF)
	  (do ((c 0 (+ c 1)))
	      ((= c 256))
	    (if (char=? EOF (integer->char c))
		(format #t "#<eof> is char=? to ~C~%" (integer->char c)))))))

(test (+ 100 (call-with-output-file "tmp.r5rs" (lambda (p) (write "1" p) (values 1 2)))) 103)
(test (+ 100 (with-output-to-file "tmp.r5rs" (lambda () (write "2") (values 1 2)))) 103)

(let ((str (with-output-to-string
	     (lambda ()
	       (with-input-from-string "hiho123"
		 (lambda ()
		   (do ((c (read-char) (read-char)))
		       ((or (not (char-ready?))
			    (eof-object? c)))
		     (display c))))))))
  (if (not (string=? str "hiho123"))
      (format #t "with string ports: ~S?~%" str)))

(let ((str (with-output-to-string
	     (lambda ()
	       (with-input-from-string ""
		 (lambda ()
		   (do ((c (read-char) (read-char)))
		       ((eof-object? c))
		     (display c))))))))
  (if (not (string=? str ""))
      (format #t "with string ports and null string: ~S?~%" str)))

(let ((str (with-output-to-string ; this is from the guile-user mailing list, I think -- don't know who wrote it
	     (lambda ()
	       (with-input-from-string "A2B5E3426FG0ZYW3210PQ89R."
		 (lambda ()
		   (call/cc
		    (lambda (hlt)
		      (define (nextchar)
			(let ((c (read-char)))
			  (if (and (char? c) 
				   (char=? c #\space))
			      (nextchar) 
			      c)))
		      
		      (define inx
			(lambda()
			  (let in1 ()
			    (let ((c (nextchar)))
			      (if (char-numeric? c)
				  (let ((r (nextchar)))
				    (let out*n ((n (- (char->integer c) (char->integer #\0))))
				      (out r)
				      (if (not (zero? n))
					  (out*n (- n 1)))))
				  (out c))
			      (in1)))))
		      
		      (define (move-char c)
			(write-char c)
			(if (char=? c #\.)
			    (begin (hlt))))
		      
		      (define outx
			(lambda()
			  (let out1 ()
			    (let h1 ((n 16))
			      (move-char (in))
			      (move-char (in))
			      (move-char (in))
			      (if (= n 1)
				  (begin (out1))
				  (begin (write-char #\space) (h1 (- n 1))) )))))
		      
		      (define (in)
			(call/cc (lambda(return)
				   (set! outx return)
				   (inx))))
		      
		      (define (out c)
			(call/cc (lambda(return) 
				   (set! inx return)
				   (outx c))))
		      (outx)))))))))
  (if (not (string=? str "ABB BEE EEE E44 446 66F GZY W22 220 0PQ 999 999 999 R."))
      (format #t "call/cc with-input-from-string str: ~A~%" str)))

(let ((badfile "tmp1.r5rs"))
  (let ((p (open-output-file badfile)))
    (close-output-port p))
  (load badfile))

(for-each
 (lambda (str)
   ;;(test (eval-string str) 'error)
   ;; eval-string is confused somehow
   (test (with-input-from-string str (lambda () (read))) 'error))
 (list "\"\\x" "\"\\x0" "`(+ ," "`(+ ,@" "#2d(" "#\\"))

(let ((loadit "tmp1.r5rs"))
  (let ((p1 (open-output-file loadit)))
    (display "(define s7test-var 314) (define (s7test-func) 314) (define-macro (s7test-mac a) `(+ ,a 2))" p1)
    (newline p1)
    (close-output-port p1)
    (load loadit)
    (test (= s7test-var 314) #t)
    (test (s7test-func) 314)
    (test (s7test-mac 1) 3)
    (let ((p2 (open-output-file loadit))) ; hopefully this starts a new file
      (display "(define s7test-var 3) (define (s7test-func) 3) (define-macro (s7test-mac a) `(+ ,a 1))" p2)
      (newline p2)
      (close-output-port p2)
      (load loadit)
      (test (= s7test-var 3) #t)
      (test (s7test-func) 3)
      (test (s7test-mac 1) 2)
      (test (morally-equal? p1 p2) #t))))

(test (+ 100 (with-input-from-string "123" (lambda () (values (read) 1)))) 224)

(for-each
 (lambda (op)
   (for-each
    (lambda (arg) ;(format #t ";(~A ~A)~%" op arg)
      (test (op arg) 'error))
    (list (integer->char 65) 1 0 -1 (list 1) (cons 1 2) #f 'a-symbol (make-vector 3) abs lambda with-environment
	  _ht_ quasiquote macroexpand 1/0 (log 0) 
	  3.14 3/4 1.0+1.0i #\f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list char-ready? set-current-output-port set-current-input-port set-current-error-port
       close-input-port close-output-port open-input-file open-output-file
       read-char peek-char read 
       (lambda (arg) (write-char #\a arg))
       (lambda (arg) (write "hi" arg))
       (lambda (arg) (display "hi" arg))
       call-with-input-file with-input-from-file call-with-output-file with-output-to-file))

(with-output-to-file "tmp1.r5rs"
  (lambda ()
    (display "this is a test")
    (newline)))
    
(test (call-with-input-file "tmp1.r5rs" (lambda (p) (integer->char (read-byte p)))) #\t)
(test (with-input-from-string "123" (lambda () (read-byte))) 49)
;(test (with-input-from-string "1/0" (lambda () (read))) 'error) ; this is a reader error in CL
;;; this test causes trouble when s7test is called from snd-test -- I can't see why

(let ((bytes (vector #o000 #o000 #o000 #o034 #o000 #o001 #o215 #o030 #o000 #o000 #o000 #o022 #o000 
		     #o000 #o126 #o042 #o000 #o000 #o000 #o001 #o000 #o000 #o000 #o000 #o000 #o001)))
  (with-output-to-file "tmp1.r5rs"
    (lambda ()
      (for-each
       (lambda (b)
	 (write-byte b))
       bytes)))
  
  (let ((ctr 0))
    (call-with-input-file "tmp1.r5rs"
      (lambda (p)	
	(if (not (string=? (port-filename p) "tmp1.r5rs")) (display (port-filename p)))	
	(let loop ((val (read-byte p)))
	  (if (eof-object? val)
	      (if (not (= ctr 26))
		  (format #t "read-byte done at ~A~%" ctr))
	      (begin
		(if (not (= (bytes ctr) val))
		    (format #t "read-byte bytes[~D]: ~A ~A~%" ctr (bytes ctr) val))
		(set! ctr (+ 1 ctr))
		(loop (read-byte p))))))))
  
  (let ((ctr 0))
    (call-with-input-file "tmp1.r5rs"
      (lambda (p)
	(let loop ((val (read-char p)))
	  (if (eof-object? val)
	      (if (not (= ctr 26))
		  (format #t "read-char done at ~A~%" ctr))
	      (begin
		(if (not (= (bytes ctr) (char->integer val)))
		    (format #t "read-char bytes[~D]: ~A ~A~%" ctr (bytes ctr) (char->integer val)))
		(set! ctr (+ 1 ctr))
		(loop (read-char p))))))))
  )

(with-output-to-file "tmp1.r5rs"
  (lambda ()
    (if (not (string=? (port-filename (current-output-port)) "tmp1.r5rs")) (display (port-filename (current-output-port))))
    (display "(+ 1 2) 32")
    (newline)
    (display "#\\a  -1")))

(with-input-from-file "tmp1.r5rs"
  (lambda ()
    (if (not (string=? (port-filename (current-input-port)) "tmp1.r5rs")) (display (port-filename (current-input-port))))
    (let ((val (read)))
      (if (not (equal? val (list '+ 1 2)))
	  (format #t "read: ~A~%" val)))
    (let ((val (read)))
      (if (not (equal? val 32))
	  (format #t "read: ~A~%" val)))
    (let ((val (read)))
      (if (not (equal? val #\a))
	  (format #t "read: ~A~%" val)))
    (let ((val (read)))
      (if (not (equal? val -1))
	  (format #t "read: ~A~%" val)))
    (let ((val (read)))
      (if (not (eof-object? val))
	  (format #t "read: ~A~%" val)))
    (let ((val (read)))
      (if (not (eof-object? val))
	  (format #t "read again: ~A~%" val)))))

(let ((port #f))
  (call-with-exit
   (lambda (go)
     (call-with-input-string "0123456789"
       (lambda (p)
	 (set! port p)
	 (if (not (char=? (peek-char p) #\0))
	     (format #t ";peek-char input-string: ~A~%" (peek-char p)))
	 (go)))))
  (if (not (input-port? port))
      (format #t ";c/e-> c/is -> port? ~A~%" port)
      (if (not (port-closed? port))
	  (begin
	    (format #t ";c/e -> c/is -> closed? ~A~%" port)
	    (close-input-port port)))))

(call-with-output-file "tmp1.r5rs" (lambda (p) (display "0123456789" p)))

(let ((port #f))
  (call-with-exit
   (lambda (go)
     (call-with-input-file "tmp1.r5rs"
       (lambda (p)
	 (set! port p)
	 (if (not (char=? (peek-char p) #\0))
	     (format #t ";peek-char input-file: ~A~%" (peek-char p)))
	 (go)))))
  (if (not (input-port? port))
      (format #t ";c/e -> c/if -> port? ~A~%" port)
      (if (not (port-closed? port))
	  (begin
	    (format #t ";c/e -> c/if -> closed? ~A~%" port)
	    (close-input-port port)))))

(let ((port #f))
  (call-with-exit
   (lambda (go)
     (dynamic-wind
	 (lambda () #f)
	 (lambda ()
	   (call-with-input-string "0123456789"
             (lambda (p)
	       (set! port p)
	       (if (not (char=? (peek-char p) #\0))
		   (format #t ";peek-char input-string 1: ~A~%" (peek-char p)))
	       (go))))
	 (lambda ()
	   (close-input-port port)))))
  (if (not (input-port? port))
      (format #t ";c/e -> dw -> c/is -> port? ~A~%" port)
      (if (not (port-closed? port))
	  (begin
	    (format #t ";c/e -> dw -> c/is -> closed? ~A~%" port)
	    (close-input-port port)))))

(let ((port #f))
  (call-with-exit
   (lambda (go)
     (dynamic-wind
	 (lambda () #f)
	 (lambda ()
	   (call-with-input-file "tmp1.r5rs"
            (lambda (p)
	      (set! port p)
	      (if (not (char=? (peek-char p) #\0))
		  (format #t ";peek-char input-file: ~A~%" (peek-char p)))
	      (go))))
	 (lambda ()
	   (close-input-port port)))))
  (if (not (input-port? port))
      (format #t ";c/e -> dw -> c/if -> port? ~A~%" port)
      (if (not (port-closed? port))
	  (begin
	    (format #t ";c/e -> dw -> c/if -> closed? ~A~%" port)
	    (close-input-port port)))))

(let ((port #f))
  (catch #t
    (lambda ()
     (call-with-input-string "0123456789"
       (lambda (p)
	 (set! port p)
	 (if (not (char=? (peek-char p) #\0))
	     (format #t ";peek-char input-string: ~A~%" (peek-char p)))
	 (error 'oops))))
    (lambda args #f))
  (if (not (input-port? port))
      (format #t ";catch -> c/is -> error -> port? ~A~%" port)
      (if (not (port-closed? port))
	  (begin
	    (format #t ";catch -> c/is -> error -> closed? ~A~%" port)
	    (close-input-port port)))))

(let ((port #f))
  (catch #t
    (lambda ()
     (call-with-input-file "tmp1.r5rs"
       (lambda (p)
	 (set! port p)
	 (if (not (char=? (peek-char p) #\0))
	     (format #t ";peek-char input-file: ~A~%" (peek-char p)))
	 (error 'oops))))
    (lambda args #f))
  (if (not (input-port? port))
      (format #t ";catch -> c/if -> error -> port? ~A~%" port)
      (if (not (port-closed? port))
	  (begin
	    (format #t ";catch -> c/if -> error -> closed? ~A~%" port)
	    (close-input-port port)))))

(test (with-output-to-string (lambda () (write (string (integer->char 4) (integer->char 8) (integer->char 20) (integer->char 30))))) "\"\\x04\\x08\\x14\\x1e\"")
(test (string-length "\x04\x08\x14\x1e") 4)
(test (char->integer (string-ref "\x0" 0)) 0)
(test (char->integer (string-ref "\x0e" 0)) 14)
(test (char->integer (string-ref "\x1e" 0)) 30)
(test (char->integer (string-ref "\xff" 0)) 255)
(test (string=?
        "\"\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\x09x\\x0b\\x0c\\x0d\\x0e\\x0f\\x10\\x11\\x12\\x13\\x14\\x15\\x16\\x17\\x18\\x19\\x1a\\x1b\\x1c\\x1d\\x1e\\x1f !\\\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\\x7f\\x80\\x81\\x82\\x83\\x84\\x85\\x86\\x87\\x88\\x89\\x8a\\x8b\\x8c\\x8d\\x8e\\x8f\\x90\\x91\\x92\\x93\\x94\\x95\\x96\\x97\\x98\\x99\\x9a\\x9b\\x9c\\x9d\\x9e\\x9f\\xa0¡¢£¤¥¦§¨©ª«¬\\xad®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ\""             "\"\\x01\\x02\\x03\\x04\\x05\\x06\\x07\\x08\\x09x\\x0b\\x0c\\x0d\\x0e\\x0f\\x10\\x11\\x12\\x13\\x14\\x15\\x16\\x17\\x18\\x19\\x1a\\x1b\\x1c\\x1d\\x1e\\x1f !\\\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\\x7f\\x80\\x81\\x82\\x83\\x84\\x85\\x86\\x87\\x88\\x89\\x8a\\x8b\\x8c\\x8d\\x8e\\x8f\\x90\\x91\\x92\\x93\\x94\\x95\\x96\\x97\\x98\\x99\\x9a\\x9b\\x9c\\x9d\\x9e\\x9f\\xa0¡¢£¤¥¦§¨©ª«¬\\xad®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ\"") 
      #t)
(test (string=? "\x61\x42\x63" "aBc") #t)


(if (provided? 'system-extras)
    (begin

      ;;; directory?
      (test (directory? "tmp1.r5rs") #f)
      (test (directory? ".") #t)
      (test (directory?) 'error)
      (test (directory? "." 0) 'error)
      (for-each
       (lambda (arg)
	 (test (directory? arg) 'error))
       (list -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	     3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

      ;;; file-exists?
      (test (file-exists? "tmp1.r5rs") #t)
      (test (file-exists? "not-a-file-I-hope") #f)
      (test (file-exists?) 'error)
      (test (file-exists? "tmp1.r5rs" 0) 'error)
      (for-each
       (lambda (arg)
	 (test (file-exists? arg) 'error))
       (list -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	     3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

      ;;; delete-file
      (test (delete-file "tmp1.r5rs") 0)
      (test (file-exists? "tmp1.r5rs") #f)
      (test (delete-file "not-a-file-I-hope") -1)
      (test (delete-file) 'error)
      (test (delete-file "tmp1.r5rs" 0) 'error)
      (for-each
       (lambda (arg)
	 (test (delete-file arg) 'error))
       (list -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	     3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

      ;;; getenv
      (test (getenv "HOME") "/home/bil")
      (test (getenv "NO-ENV") "")
      (test (getenv) 'error)
      (test (getenv "HOME" #t) 'error)
      (for-each
       (lambda (arg)
	 (test (getenv arg) 'error))
       (list -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	     3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

      ;;; directory->list
      (test (directory->list) 'error)
      (test (directory->list "." 0) 'error)
      (for-each
       (lambda (arg)
	 (test (directory->list arg) 'error))
       (list -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	     3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

      ;;; system
      (test (system "test -f s7test.scm") 0)
      (test (system) 'error)
      (test (system "ls" 0) 'error)
      (for-each
       (lambda (arg)
	 (test (system arg) 'error))
       (list -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
	     3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))
      
      ))
      
(let ()
  (define (args2)
    (with-output-to-file "test.data"
      (lambda ()
	(write-byte 1)
	(write-byte 2)
	(write-byte 1)
	(write-byte 2)))
    
    (let ((v (with-input-from-file "test.data"
	       (lambda ()
		 (vector (+ (read-byte) (ash (read-byte) 8))
			 (+ 1 (ash 2 8))
			 (+ (ash (read-byte) 8) (read-byte))
			 (+ (ash 1 8) 2))))))
      (if (not (equal? v #(513 513 258 258)))
	  (format *stderr* ";2 arg order check: ~A~%" v))))
  
  
  (args2)
  
  (define (args3)
    (with-output-to-file "test.data"
      (lambda ()
	(do ((i 0 (+ i 1)))
	    ((= i 8))
	  (write-byte 1)
	  (write-byte 2)
	  (write-byte 3))))
    
    (let ((v (with-input-from-file "test.data"
	       (lambda ()
		 (vector (+ (read-byte) (ash (read-byte) 8) (ash (read-byte) 16))
			 (+ 1 (ash 2 8) (ash 3 16))
			 (+ (read-byte) (read-byte) (ash (read-byte) 8))
			 (+ 1 2 (ash 3 8))
			 (+ (read-byte) (ash (read-byte) 8) (read-byte))
			 (+ 1 (ash 2 8) 3)
			 (+ (ash (read-byte) 8) (read-byte) (read-byte))
			 (+ (ash 1 8) 2 3)
			 (+ (ash (read-byte) 8) (ash (read-byte) 16) (read-byte))
			 (+ (ash 1 8) (ash 2 16) 3)
			 (+ (ash (read-byte) 8) (read-byte) (ash (read-byte) 16))
			 (+ (ash 1 8) 2 (ash 3 16)))))))
      (if (not (equal? v #(197121 197121 771 771 516 516 261 261 131331 131331 196866 196866)))
	  (format *stderr* ";3 arg order check: ~A~%" v))))
  
  (args3))


(for-each
 (lambda (arg)
   (test (char-ready? arg) 'error))
 (list "hi" -1 #\a 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1))))


;;; -------- format --------
;;; format

(test (format #f "hiho") "hiho")
(test (format #f "") "")
(test (format #f "" 1) 'error)
(test (format #f "a") "a")
;(test (format #f "a\x00b") "a")

(test (format #f "~~") "~") ; guile returns this, but clisp thinks it's an error
(test (format #f "~~~~") "~~")
(test (format #f "a~~") "a~")
(test (format #f "~~a") "~a")
(test (format #f "~A" "") "")
(test (format #f "~{~^~A~}" '()) "")
(test (format #f "~{~^~{~^~A~}~}" '(())) "")
(test (format #f "~P" 1) "")
(test (format #f "~P" #\a) 'error)
(test (format #f "~0T") "")
(test (format #f "") "")
(test (format #f "~*~*" 1 2) "")
(test (format #f "~20,'~D" 3) "~~~~~~~~~~~~~~~~~~~3")
(test (format #f "~0D" 123) "123")
(test (format #f "~-1D" 123) 'error)
(test (format #f "~+1D" 123) 'error)
(test (format #f "~1.D" 123) 'error)
(test (format #f "~1+iD" 123) 'error)
(test (format #f "~1/2D" 123) 'error)
(test (format #f "~1/1D" 123) 'error)
(test (format #f "~20,'-1D" 123) 'error)

(for-each
 (lambda (directive)
   (for-each 
    (lambda (arg)
      (test (format #f directive arg) 'error)
      (test (format #f directive) 'error))
    (list "hi" #\a 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand
	  #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list "~D" "~F" "~G" "~X" "~B" "~O" "~E" "~P"))

(test (format #f "~,1" 123) 'error)
;format "~,1" 123: numeric argument, but no directive!
;    (format #f "~,1" 123)

(test (format #f "~,123456789123456789123456789d" 1) 'error)
;format "~,123456789123456789123456789d" 1: numeric argument too large
;    (format #t "~,123456789123456789123456789d" 1)

(test (format #f "~D" 1 2) 'error)
;format: "~D" 1 2
;           ^: too many arguments
;    (format #f "~D" 1 2)

(test (format #f "~D~" 1) 'error)
;format: "~D~" 1
;           ^: control string ends in tilde
;    (format #f "~D~" 1)

(test (format #f "~@D" 1) 'error)
;format "~@D" 1: unknown '@' directive
;    (format #f "~@D" 1)

(test (format #f "~@p" #\a) 'error)
;format "~@p" #\a: '@P' directive argument is not an integer
;    (format #f "~@p" #\a)

(test (format #f "~P" 1+i) 'error)
;format "~P" 1+1i: 'P' directive argument is not a real number
;    (format #f "~P" 1+1i)

(test (format #f "~P" (real-part (log 0))) "s")

(test (format #f "~@p" 0+i) 'error)
;format "~@p" 0+1i: '@P' directive argument is not a real number
;    (format #f "~@p" 0+1i)

(test (format #f "~{~}") 'error)
;format "~{~}": missing argument
;    (format #f "~{~}")

(test (format #f "~{~a" '(1 2 3)) 'error)
;format "~{~a" (1 2 3): '{' directive, but no matching '}'
;    (format #f "~{~a" '(1 2 3))

(test (format #f "~{~a~}" '(1 . 2)) 'error)
;format "~{~a~}" (1 . 2): '{' directive argument should be a proper list or something we can turn into a list
;    (format #f "~{~a~}" '(1 . 2))

(test (let ((lst (cons 1 2))) (set-cdr! lst lst) (format #f "~{~A~}" lst)) 'error)
;format "~{~A~}" #1=(1 . #1#): '{' directive argument should be a proper list or something we can turn into a list
;    (format #f "~{~A~}" lst)

(test (format #f "~{~a~}" 'asdf) 'error)
;format "~{~a~}" asdf: '{' directive argument should be a proper list or something we can turn into a list
;    (format #f "~{~a~}" 'asdf)

(test (format #f "~{~a~}" '()) "")
(test (format #f "~{asd~}" '(1 2 3)) 'error)
;format: "~{asd~}" (1 2 3)
;             ^: '{...}' doesn't consume any arguments!
;    (format #f "~{asd~}" '(1 2 3))

(test (format #f "~}" '(1 2 3)) 'error)
;format "~}" (1 2 3): unmatched '}'
;    (format #f "~}" '(1 2 3))

(test (format #f "~C") 'error)
;format "~C": ~C: missing argument
;    (format #f "~C")

(test (format #f "~A ~C" #\a) 'error)
;format: "~A ~C" #\a
;            ^: ~C: missing argument
;    (format #f "~A ~C" #\a)

(test (format #f "~C" 1) 'error)
;format "~C" 1: 'C' directive requires a character argument
;    (format #f "~C" 1)

(test (format #f "~C" #<eof>) 'error)
;format "~C" #<eof>: 'C' directive requires a character argument
;    (format #f "~C" #<eof>)

(test (format #f "~1,9223372036854775807f" 1) 'error)
;format "~1,9223372036854775807f" 1: numeric argument too large
;    (format #f "~1,9223372036854775807f" 1)

(test (format #f "~1,2A" 1) 'error)
;format "~1,2A" 1: extra numeric argument
;    (format #f "~1,2A" 1)

(test (format #f "~F" #\a) 'error)
;format "~F" #\a: ~F: numeric argument required
;    (format #f "~F" #\a)

(test (format #f "~1,") 'error)
;format "~1,": format directive does not take a numeric argument
;    (format #f "~1,")

(test (format #f "~-1,") 'error)
;format "~-1,": unimplemented format directive
;    (format #f "~-1,")

(test (format #f "~L" 1) 'error)
;format "~L" 1: unimplemented format directive
;    (format #f "~L" 1)

(test (format #f "~A" 1 2) 'error)
;format: "~A" 1 2
;           ^: too many arguments
;    (format #f "~A" 1 2)

(test (format #f "hiho~%ha") (string-append "hiho" (string #\newline) "ha"))
(test (format #f "~%") (string #\newline))
(test (format #f "~%ha") (string-append (string #\newline) "ha"))
(test (format #f "hiho~%") (string-append "hiho" (string #\newline)))

(for-each
 (lambda (arg res)
   (let ((val (catch #t (lambda () (format #f "~A" arg)) (lambda args 'error))))
     (if (or (not (string? val))
	     (not (string=? val res)))
	 (begin (display "(format #f \"~A\" ") (display arg) 
		(display " returned \"") (display val) 
		(display "\" but expected \"") (display res) (display "\"") 
		(newline)))))
 (list "hiho"  -1  #\a  1   #f   #t  '#(1 2 3)   3.14   3/4  1.5+1.5i '()  '#(())  (list 1 2 3) '(1 . 2) 'hi)
 (list "hiho" "-1" "a" "1" "#f" "#t" "#(1 2 3)" "3.14" "3/4" "1.5+1.5i"   "()" "#(())" "(1 2 3)"    "(1 . 2)" "hi"))

(test (format #f "hi ~A ho" 1) "hi 1 ho")
(test (format #f "hi ~a ho" 1) "hi 1 ho")
(test (format #f "~a~A~a" 1 2 3) "123")
(test (format #f "~a~~~a" 1 3) "1~3")
(test (format #f "~a~%~a" 1 3) (string-append "1" (string #\newline) "3"))

(for-each
 (lambda (arg res)
   (let ((val (catch #t (lambda () (format #f "~S" arg)) (lambda args 'error))))
     (if (or (not (string? val))
	     (not (string=? val res)))
	 (begin (display "(format #f \"~S\" ") (display arg) 
		(display " returned \"") (display val) 
		(display "\" but expected \"") (display res) (display "\"") 
		(newline)))))
 (list "hiho"  -1  #\a  1   #f   #t  '#(1 2 3)   3.14   3/4  1.5+1.5i '()  '#(())  (list 1 2 3) '(1 . 2) 'hi)
 (list "\"hiho\"" "-1" "#\\a" "1" "#f" "#t" "#(1 2 3)" "3.14" "3/4" "1.5+1.5i"   "()" "#(())" "(1 2 3)"    "(1 . 2)" "hi"))

(test (format #f "hi ~S ho" 1) "hi 1 ho")
(test (format #f "hi ~S ho" "abc") "hi \"abc\" ho")
(test (format #f "~s~a" #\a #\b) "#\\ab")
(test (format #f "~C~c~C" #\a #\b #\c) "abc")
;(test (format #f "1 2~C 3 4" #\null) "1 2") ; ?? everyone does something different here
;; s7 used to return "1 2 3 4" because it treated ~C as a string (empty in this case)
(test  (format #f "1 2~C 3 4" #\null) "1 2\x00 3 4") ; this is also what Guile returns

(test (format #f "~{~A~}" '(1 2 3)) "123")
(test (format #f "asb~{~A ~}asb" '(1 2 3 4)) "asb1 2 3 4 asb")
(test (format #f "asb~{~A ~A.~}asb" '(1 2 3 4)) "asb1 2.3 4.asb")
(test (format #f ".~{~A~}." '()) "..")

(test (format #f "~{~A ~A ~}" '(1 "hi" 2 "ho")) "1 hi 2 ho ")
(test (format #f "~{.~{+~A+~}.~}" (list (list 1 2 3) (list 4 5 6))) ".+1++2++3+..+4++5++6+.")
(test (format #f "~{~s ~}" '(fred jerry jill)) "fred jerry jill ")
(test (format #f "~{~s~^ ~}" '(fred jerry jill)) "fred jerry jill")
(test (format #f "~{~s~^~^ ~}" '(fred jerry jill)) "fred jerry jill")
(test (format #f "~{.~{~A~}+~{~A~}~}" '((1 2) (3 4 5) (6 7 8) (9))) ".12+345.678+9")
(test (format #f "~{.~{+~{-~A~}~}~}" '(((1 2) (3 4 5)))) ".+-1-2+-3-4-5")
(test (format #f "~{.~{+~{-~A~}~}~}" '(((1 2) (3 4 5)) ((6) (7 8 9)))) ".+-1-2+-3-4-5.+-6+-7-8-9")

(test (format #f "~A ~* ~A" 1 2 3) "1  3")
(test (format #f "~*" 1) "")
(test (format #f "~{~* ~}" '(1 2 3)) "   ")
(test (format #f "~A" catch) "catch")
(test (format #f "this is a ~
             sentence") "this is a sentence")
(test (format #f "~{~C~}" "hi") "hi")
(test (format #f "~{~C~}" #(#\h #\i)) "hi")

(test (format #f "~{.~{~C+~}~}" '((#\h #\i) (#\h #\o))) ".h+i+.h+o+")
(test (format #f "~{.~{~C+~}~}" '("hi" "ho")) ".h+i+.h+o+")
(test (format #f "~{.~{~C+~}~}" #("hi" "ho")) ".h+i+.h+o+")
(test (format #f "~{.~{~C+~}~}" #(#(#\h #\i) #(#\h #\o))) ".h+i+.h+o+")

; (format #f "~{.~{~C~+~}~}" #2d((#\h #\i) (#\h #\o))) error?? -- this is documented...
(test (format #f "~{~A~}" #2D((1 2) (3 4))) "1234") ; this seems inconsistent with:
(test (format #f "~{~A~}" '((1 2) (3 4))) "(1 2)(3 4)")
(test (format #f "~{~A ~}" #2d((1 2) (3 4))) "1 2 3 4 ")
(test (format #f "1~\
a2" 3) "132")

(test (format #f "~{~{~C~^ ~}~^...~}" (list "hiho" "test")) "h i h o...t e s t")

;; ~nT handling is a mess -- what are the defaults?  which is column 1? do we space up to or up to and including?

(test (format #f "~A:~8T~A" 100 'a)   "100:   a")
(test (format #f "~A:~8T~A" 0 'a)     "0:     a")
(test (format #f "~A:~8T~A" 10000 'a) "10000: a")
(test (format #f "~8T~A" 'a)      "       a")
(test (format #f "1212:~8T~A" 'a) "1212:  a")
(test (format #f "~D:~8T~A" 100 'a)   "100:   a")
(test (format #f "~D:~8T~A" 0 'a)     "0:     a")
(test (format #f "~D:~8T~A" 10000 'a) "10000: a")
(test (format #f "~a~10,7Tb" 1)     "1               b")
(test (format #f "~a~10,7Tb" 10000) "10000           b")
(test (format #f "~a~10,12Tb" 1)     "1                    b")
(test (format #f "~a~10,12Tb" 10000) "10000                b")

(test (format #f "asdh~20Thiho") "asdh               hiho")
(test (format #f "asdh~2Thiho") "asdhhiho")
(test (format #f "a~Tb") "ab")
(test (format #f "0123456~4,8Tb") "0123456    b")
(test (format #f "0123456~0,8Tb") "0123456b")
(test (format #f "0123456~10,8Tb") "0123456          b")
(test (format #f "0123456~1,0Tb") "0123456b")
(test (format #f "0123456~1,Tb") "0123456b")
(test (format #f "0123456~1,Tb") "0123456b")
(test (format #f "0123456~,Tb") "0123456b")
(test (format #f "0123456~7,10Tb") "0123456         b")
(test (format #f "0123456~8,10tb") "0123456          b")
(test (format #f "0123456~3,12tb") "0123456       b")
(test (format #f "~40TX") "                                       X")
(test (format #f "X~,8TX~,8TX") "X      X       X")
(test (format #f "X~8,TX~8,TX") "X      XX")
(test (format #f "X~8,10TX~8,10TX") "X                X         X")
(test (format #f "X~8,0TX~8,0TX") "X      XX")
(test (format #f "X~0,8TX~0,8TX") "X      X       X")
(test (format #f "X~1,8TX~1,8TX") "X       X       X")
(test (format #f "X~,8TX~,8TX") "X      X       X") ; ??
(test (format #f "X~TX~TX") "XXX") ; clisp and sbcl say "X X X" here and similar differences elsewhere -- is it colnum or colinc as default if no comma?
(test (format #f "X~2TX~4TX") "XX X")
(test (format #f "X~0,0TX~0,0TX") "XXX")
(test (format #f "X~0,TX~0,TX") "XXX")
(test (format #f "X~,0TX~,0TX") "XXX")

(test (format #f "~0D" 123) "123")
(test (format #f "~0F" 123.123) "123.123000")
(test (format #f "~,0D" 123) "123")
(test (format #f "~,0F" 123.123) "123.0")
(test (format #f "~,D" 123) "123")
(test (format #f "~,F" 123.123) "123.123000")
(test (format #f "~0,D" 123) "123")
(test (format #f "~0,F" 123.123) "123.123000")
(test (format #f "~0,0D" 123) "123")
(test (format #f "~0,0F" 123.123) "123.0")
(test (format #f "~0,0,D" 123) 'error)
(test (format #f "~0,0,F" 123.123) 'error)

(test (format #f "~000000000000000000000000000000000000000000003F" 123.123456789) "123.123457")
(test (format #f "~922337203685477580F" 123.123) 'error)   ; numeric argument too large
(test (format #f "~,922337203685477580F" 123.123) 'error)  
(test (format #f "~1,922337203685477580F" 123.123) 'error) 
(test (format #f "~1 ,2F" 123.456789) 'error)
(test (format #f "~1, 2F" 123.456789) 'error)
(test (format #f "~1, F" 123.456789) 'error)

(test (= (length (substring (format #f "~%~10T.") 1)) (length (format #f "~10T."))) #t)
(test (= (length (substring (format #f "~%-~10T.~%") 1)) (length (format #f "-~10T.~%"))) #t)
(test (string=? (format #f "~%|0 1 2|~21T|5  8  3  2|~%~
                              |1 2 3| |0 1 2 3|~21T|8 14  8  6|~%~
                              |2 3 0| |1 2 3 0| = ~21T|3  8 13  6|~%~
                              |3 0 1| |2 3 0 1|~21T|2  6  6 10|~%")
		"
|0 1 2|             |5  8  3  2|
|1 2 3| |0 1 2 3|   |8 14  8  6|
|2 3 0| |1 2 3 0| = |3  8 13  6|
|3 0 1| |2 3 0 1|   |2  6  6 10|
") #t)


(test (format #f "~S" '(+ 1/0 1/0)) "(+ nan.0 nan.0)") ; !?
(test (format #f "~S" '(+ '1/0 1/0)) "(+ 'nan.0 nan.0)") ; !? 
(test (format #f "~S" '(+ 1/0 1.0/0.0)) (format #f "~S" (list '+ '1/0 '1.0/0.0)))
(test (format #f "~S" (quote (+ '1 1))) "(+ '1 1)")


(test (format #f "~12,''D" 1) "'''''''''''1")
(test (let ((str "~12,'xD")) (set! (str 5) #\space) (format #f str 1)) "           1")
(test (format #f "~12,' D" 1) "           1")
(test (format #f "~12,'\\D" 1) "\\\\\\\\\\\\\\\\\\\\\\1")
(test (format #f "~12,'\"D" 1) "\"\"\"\"\"\"\"\"\"\"\"1")
(test (format #f "~12,'~D" 1) "~~~~~~~~~~~1")
(test (format #f "~12,',d" 1) ",,,,,,,,,,,1")
(test (format #f "~12,',,d" 1) 'error)
(test (format #f "~12,,d" 1) 'error)

(test (string=? (format #f "~%~&" ) (string #\newline)) #t)
(test (string=? (format #f "~%a~&" ) (string #\newline #\a #\newline)) #t)
(test (string=? (format #f "~%~%") (string #\newline #\newline)) #t)
(test (string=? (format #f "~10T~%~&~10T.") (format #f "~10T~&~&~10T.")) #t)
(test (string=? (format #f "~10T~&~10T.") (format #f "~10T~%~&~&~&~&~10T.")) #t)

(test (format #f "~2,1F" 0.5) "0.5")
(test (format #f "~:2T") 'error)
(test (format #f "~2,1,3F" 0.5) 'error)
(test (format #f "~<~W~>" 'foo) 'error)
(test (format #f "~{12") 'error)
(test (format #f "~{}") 'error)
(test (format #f "~{}" '(1 2)) 'error)
(test (format #f "{~}" '(1 2)) 'error)
(test (format #f "~{~{~}}" '(1 2)) 'error)
(test (format #f "~}" ) 'error)
(test (format #f "#|~|#|") 'error)
(test (format #f "~1.5F" 1.5) 'error)
(test (format #f "~1+iF" 1.5) 'error)
(test (format #f "~1,1iF" 1.5) 'error)
(test (format #f "~0" 1) 'error)
(test (format #f "~1") 'error)
(test (format #f "~^" 1) 'error)
(test (format #f "~.0F" 1.0) 'error)
(test (format #f "~1.0F" 1.0) 'error)
(test (format #f "~-1F" 1.0) 'error)
(test (format #f "~^") "")
(test (format #f "~D~" 9) 'error)
(test (format #f "~&" 9) 'error)
(test (format #f "~D~100T~D" 1 1) "1                                                                                                  1")
(test (format #f ".~P." 1) "..")
(test (format #f ".~P." 1.0) "..")
(test (format #f ".~P." 1.2) ".s.")
(test (format #f ".~P." 2/3) ".s.")
(test (format #f ".~P." 2) ".s.")
(test (format #f ".~p." 1) "..")
(test (format #f ".~p." 1.0) "..")
(test (format #f ".~p." 1.2) ".s.")
(test (format #f ".~p." 2) ".s.")
(test (format #f ".~@P." 1) ".y.")
(test (format #f ".~@P." 1.0) ".y.")
(test (format #f ".~@P." 1.2) ".ies.")
(test (format #f ".~@P." 2) ".ies.")
(test (format #f ".~@p." 1) ".y.")
(test (format #f ".~@p." 1.0) ".y.")
(test (format #f ".~@p." 1.2) ".ies.")
(test (format #f ".~@p." 2) ".ies.")
(test (format #f ".~P." 1.0+i) 'error)
(test (format #f ".~P." 1/0) ".s.")
(test (format #f ".~P." (real-part (log 0))) ".s.")

(test (format #f (string #\~ #\a) 1) "1")
(test (format #f (format #f "~~a") 1) "1")
(test (format #f (format #f "~~a") (format #f "~D" 1)) "1")
(test (format #f "~A" (quasiquote quote)) "quote")

(test (format #f "~f" (/ 1 3)) "1/3") ; hmmm -- should it call exact->inexact?
(test (format #f "~f" 1) "1")
(test (format #f "~F" most-positive-fixnum) "9223372036854775807")

(if (not with-bignums) 
    (begin
      (test (format #f "~,20F" 1e-20) "0.00000000000000000001")
      (test (format #f "~,40F" 1e-40) "0.0000000000000000000000000000000000000001")))
;; if with bignums, these needs more bits

;;; the usual troubles here with big floats:
;;; (format #f "~F" 922337203685477580.9) -> "922337203685477632.000000"
;;; (format #f "~F" 9223372036854775.9) -> "9223372036854776.000000"
;;; (format #f "~F" 1e25) -> "10000000000000000905969664.000000"
;;; or small:
;;; (format #f "~,30F" 1e-1) -> "0.100000000000000005551115123126"

(if with-bignums
    (begin
      (test (format #f "~A" -7043009959286724629649270926654940933664689003233793014518979272497911394287216967075767325693021717277238746020477538876750544587281879084559996466844417586093291189295867052594478662802691926547232838591510540917276694295393715934079679531035912244103731582711556740654671309980075069010778644542022/670550434139267031632063192770201289106737062379324644110801846820471752716238484923370056920388400273070254958650831435834503195629325418985020030706879602898158806736813101434594805676212779217311897830937606064579213895527844045511878668289820732425014254579493444623868748969110751636786165152601) "-7043009959286724629649270926654940933664689003233793014518979272497911394287216967075767325693021717277238746020477538876750544587281879084559996466844417586093291189295867052594478662802691926547232838591510540917276694295393715934079679531035912244103731582711556740654671309980075069010778644542022/670550434139267031632063192770201289106737062379324644110801846820471752716238484923370056920388400273070254958650831435834503195629325418985020030706879602898158806736813101434594805676212779217311897830937606064579213895527844045511878668289820732425014254579493444623868748969110751636786165152601")
      (test (format #f "~D" -7043009959286724629649270926654940933664689003233793014518979272497911394287216967075767325693021717277238746020477538876750544587281879084559996466844417586093291189295867052594478662802691926547232838591510540917276694295393715934079679531035912244103731582711556740654671309980075069010778644542022/670550434139267031632063192770201289106737062379324644110801846820471752716238484923370056920388400273070254958650831435834503195629325418985020030706879602898158806736813101434594805676212779217311897830937606064579213895527844045511878668289820732425014254579493444623868748969110751636786165152601) "-7043009959286724629649270926654940933664689003233793014518979272497911394287216967075767325693021717277238746020477538876750544587281879084559996466844417586093291189295867052594478662802691926547232838591510540917276694295393715934079679531035912244103731582711556740654671309980075069010778644542022/670550434139267031632063192770201289106737062379324644110801846820471752716238484923370056920388400273070254958650831435834503195629325418985020030706879602898158806736813101434594805676212779217311897830937606064579213895527844045511878668289820732425014254579493444623868748969110751636786165152601")
    ))
(test (format #f "~@F" 1.23) 'error)
(test (format #f "~{testing ~D ~C ~}" (list 0 #\( 1 #\) 2 #\* 3 #\+ 4 #\, 5 #\- 6 #\. 7 #\/ 8 #\0 9 #\1 10 #\2 11 #\3 12 #\4 13 #\5 14 #\6 15 #\7 16 #\8 17 #\9 18 #\: 19 #\; 20 #\< 21 #\= 22 #\> 23 #\? 24 #\@ 25 #\A 26 #\B 27 #\C 28 #\D 29 #\E 30 #\F 31 #\G 32 #\H 33 #\I 34 #\J 35 #\K 36 #\L 37 #\M 38 #\N 39 #\O 40 #\P 41 #\Q 42 #\R 43 #\S 44 #\T 45 #\U 46 #\V 47 #\W 48 #\X 49 #\Y 50 #\( 51 #\) 52 #\* 53 #\+ 54 #\, 55 #\- 56 #\. 57 #\/ 58 #\0 59 #\1 60 #\2 61 #\3 62 #\4 63 #\5 64 #\6 65 #\7 66 #\8 67 #\9 68 #\: 69 #\; 70 #\< 71 #\= 72 #\> 73 #\? 74 #\@ 75 #\A 76 #\B 77 #\C 78 #\D 79 #\E 80 #\F 81 #\G 82 #\H 83 #\I 84 #\J 85 #\K 86 #\L 87 #\M 88 #\N 89 #\O 90 #\P 91 #\Q 92 #\R 93 #\S 94 #\T 95 #\U 96 #\V 97 #\W 98 #\X 99 #\Y))
      "testing 0 ( testing 1 ) testing 2 * testing 3 + testing 4 , testing 5 - testing 6 . testing 7 / testing 8 0 testing 9 1 testing 10 2 testing 11 3 testing 12 4 testing 13 5 testing 14 6 testing 15 7 testing 16 8 testing 17 9 testing 18 : testing 19 ; testing 20 < testing 21 = testing 22 > testing 23 ? testing 24 @ testing 25 A testing 26 B testing 27 C testing 28 D testing 29 E testing 30 F testing 31 G testing 32 H testing 33 I testing 34 J testing 35 K testing 36 L testing 37 M testing 38 N testing 39 O testing 40 P testing 41 Q testing 42 R testing 43 S testing 44 T testing 45 U testing 46 V testing 47 W testing 48 X testing 49 Y testing 50 ( testing 51 ) testing 52 * testing 53 + testing 54 , testing 55 - testing 56 . testing 57 / testing 58 0 testing 59 1 testing 60 2 testing 61 3 testing 62 4 testing 63 5 testing 64 6 testing 65 7 testing 66 8 testing 67 9 testing 68 : testing 69 ; testing 70 < testing 71 = testing 72 > testing 73 ? testing 74 @ testing 75 A testing 76 B testing 77 C testing 78 D testing 79 E testing 80 F testing 81 G testing 82 H testing 83 I testing 84 J testing 85 K testing 86 L testing 87 M testing 88 N testing 89 O testing 90 P testing 91 Q testing 92 R testing 93 S testing 94 T testing 95 U testing 96 V testing 97 W testing 98 X testing 99 Y ")

(let ((old-len *vector-print-length*))
  (let ((vect1 #3D(((1 2 3) (3 4 5)) ((5 6 1) (7 8 2))))
	(vect2 #2d((1 2 3 4 5 6) (7 8 9 10 11 12)))
	(vect3 #(1 2 3 4 5 6 7 8 9 10 11 12 13 14))
	(vect4 #3D(((1 2) (3 4) (5 6)) ((7 8) (9 10) (11 12)))))
    (do ((i 0 (+ i 2)))
	((>= i 10))
      (set! *vector-print-length* i)
      (test (object->string vect1) (format #f "~A" vect1))
      (test (object->string vect2) (format #f "~A" vect2))
      (test (object->string vect3) (format #f "~A" vect3))
      (test (object->string vect4) (format #f "~A" vect4))))
  (set! *vector-print-length* 0)
  (test (format #f "~A" #()) "#()")
  (set! *vector-print-length* old-len))

(test (format #f "~D" 123) "123")
(test (format #f "~X" 123) "7b")
(test (format #f "~B" 123) "1111011")
(test (format #f "~O" 123) "173")

(test (format #f "~10D" 123) "       123")
(test (format #f "~10X" 123) "        7b")
(test (format #f "~10B" 123) "   1111011")
(test (format #f "~10O" 123) "       173")

(test (format #f "~D" -123) "-123")
(test (format #f "~X" -123) "-7b")
(test (format #f "~B" -123) "-1111011")
(test (format #f "~O" -123) "-173")

(test (format #f "~10D" -123) "      -123")
(test (format #f "~10X" -123) "       -7b")
(test (format #f "~10B" -123) "  -1111011")
(test (format #f "~10O" -123) "      -173")

(test (format #f "~d" 123) "123")
(test (format #f "~x" 123) "7b")
(test (format #f "~b" 123) "1111011")
(test (format #f "~o" 123) "173")

(test (format #f "~10d" 123) "       123")
(test (format #f "~10x" 123) "        7b")
(test (format #f "~10b" 123) "   1111011")
(test (format #f "~10o" 123) "       173")

(test (format #f "~d" -123) "-123")
(test (format #f "~x" -123) "-7b")
(test (format #f "~b" -123) "-1111011")
(test (format #f "~o" -123) "-173")

(test (format #f "~10d" -123) "      -123")
(test (format #f "~10x" -123) "       -7b")
(test (format #f "~10b" -123) "  -1111011")
(test (format #f "~10o" -123) "      -173")

(test (format #f "~D" most-positive-fixnum) "9223372036854775807")
(test (format #f "~D" (+ 1 most-negative-fixnum)) "-9223372036854775807")
      
(test (format #f "~X" most-positive-fixnum) "7fffffffffffffff")
(test (format #f "~X" (+ 1 most-negative-fixnum)) "-7fffffffffffffff")
      
(test (format #f "~O" most-positive-fixnum) "777777777777777777777")
(test (format #f "~O" (+ 1 most-negative-fixnum)) "-777777777777777777777")
      
(test (format #f "~B" most-positive-fixnum) "111111111111111111111111111111111111111111111111111111111111111")
(test (format #f "~B" (+ 1 most-negative-fixnum)) "-111111111111111111111111111111111111111111111111111111111111111")
      
(num-test (inexact->exact most-positive-fixnum) most-positive-fixnum)

(test (format #f "~0D" 123) "123")
(test (format #f "~0X" 123) "7b")
(test (format #f "~0B" 123) "1111011")
(test (format #f "~0O" 123) "173")

(test (format #f "" 1) 'error)
(test (format #f "hiho" 1) 'error)
(test (format #f "a~%" 1) 'error) ; some just ignore extra args

(for-each
 (lambda (arg)
   (let ((result (catch #t (lambda () (format arg "hiho")) (lambda args 'error))))
     (if (not (eq? result 'error))
	 (begin (display "(format ") (display arg) (display " \"hiho\")")
		(display " returned ") (display result) 
		(display " but expected 'error")
		(newline)))))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i 'hi :hi #<eof> abs (lambda () 1) '#(()) (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (let ((result (catch #t (lambda () (format #f arg)) (lambda args 'error))))
     (if (not (eq? result 'error))
	 (begin (display "(format #f ") (display arg) (display ")")
		(display " returned ") (display result) 
		(display " but expected 'error")
		(newline)))))
 (list -1 #\a 1 #f #t '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi abs (lambda () 1) '#(()) (list 1 2 3) '(1 . 2)))

(test (format #f "hi ~A ho" 1 2) 'error)
(test (format #f "hi ~A ho") 'error)
(test (format #f "hi ~S ho") 'error)
(test (format #f "hi ~S ho" 1 2) 'error)
(test (format #f "~C" 1) 'error)
(test (format #f "123 ~R 321" 1) 'error)
(test (format #f "123 ~,3R 321" 1) 'error)
(test (format #f "~,2,3,4D" 123) 'error)

(test (format #f "hi ~Z ho") 'error)
(test (format #f "hi ~+ ho") 'error)
(test (format #f "hi ~# ho") 'error)
(test (format #f "hi ~, ho") 'error)

(test (format #f "hi ~} ho") 'error)
(test (format #f "hi {ho~}") 'error)

(test (format #f "asb~{~A asd" '(1 2 3)) 'error)
(test (format #f "~{~A~}" 1 2 3) 'error)
(test (format #f "asb~{~}asd" '(1 2 3)) 'error)
(test (format #f "asb~{ ~}asd" '(1 2 3)) 'error)
(test (format #f "asb~{ . ~}asd" '(1 2 3)) 'error)
(test (format #f "asb~{ hiho~~~}asd" '(1 2 3)) 'error)

(test (format #f "~12C" #\a) 'error)
(test (format #f "~12P" #\a) 'error)
(test (format #f "~12*" #\a) 'error)
(test (format #f "~12%" #\a) 'error)
(test (format #f "~12^" #\a) 'error)
(test (format #f "~12{" #\a) 'error)
(test (format #f "~12,2A" #\a) 'error)

(test (format #f "~12,A" #\a) 'error) ; s7 misses padding errors such as (format #f "~12,' A" #\a)


;;; I removed this feature 21-Jun-12
;(test (format #f "~12A" "012345678901234567890") "012345678...")
;(test (format #f "~1A" "012345678901234567890") "0")
;(test (format #f "~40A" "012345678901234567890") "012345678901234567890")
;(test (format #f "~12s" "012345678901234567890") "\"0123456...\"")
;
;(let ((old-len *vector-print-length*))
;  (set! *vector-print-length* 32)
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~A" v)) "#(1 2 3 4 5 6 7 8 9 10)")
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~10A" v)) "#(1 2 3...")
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~20A" v)) "#(1 2 3 4 5 6 7 8...")
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~30A" v)) "#(1 2 3 4 5 6 7 8 9 10)")
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~-10A" v)) 'error)
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~10.0A" v)) 'error)
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~10,0A" v)) 'error)
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~10,A" v)) "#(1 2 3...")
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~10,,A" v)) 'error)
;  (test (let ((v (vector 1 2 3 4 5 6 7 8 9 10))) (format #f "~,10A" v)) 'error)
;  (set! *vector-print-length* old-len))
;
;(test (let ((v (hash-table '(a . 1) '(b . 2) '(c . 3) '(d . 4)))) (format #f "~20A" v)) "#<hash-table (a ....")
;(test (let ((v (hash-table '(a . 1) '(b . 2) '(c . 3) '(d . 4)))) (format #f "~40A" v)) "#<hash-table (a . 1) (b . 2) (c . 3)...")
;
;(test (let ((v (list 1 2 3 4 5 6 7 8 9 10))) (format #f "~20A" v)) "(1 2 3 4 5 6 7 8...")


#|
(let ((v (vector 1 2 3 4 5 6 7 8 9 10)))
  (do ((i 0 (+ i 1)))
      ((= i 30))
    (let ((str (string-append "~" (number->string i) "A")))
      (let ((nstr (format #f str v)))
	(format *stderr* "~D: ~A: ~D~%" i nstr (length nstr))))))

(let ((v (hash-table '(a . 1) '(b . 2) '(c . 3) '(d . 4))))
  (do ((i 0 (+ i 1)))
      ((= i 50))
    (let ((str (string-append "~" (number->string i) "A")))
      (let ((nstr (format #f str v)))
	(format *stderr* "~D: ~A: ~D~%" i nstr (length nstr))))))

(let ((v (list 1 2 3 4 5 6 7 8 9 10)))
  (do ((i 0 (+ i 1)))
      ((= i 24))
    (let ((str (string-append "~" (number->string i) "A")))
      (let ((nstr (format #f str v)))
	(format *stderr* "~D: ~A: ~D~%" i nstr (length nstr))))))

(do ((i 0 (+ i 1))) ((= i 256)) 
  (let ((chr (integer->char i)))
    (format #t "~D: ~A ~A ~D~%" i (format #f "~S" (string chr)) (string chr) (length (format #f "~S" (string chr))))))
|#

(for-each
 (lambda (arg)
   (test (format #f "~F" arg) 'error))
 (list "hi" #\a 'a-symbol (make-vector 3) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (format #f "~D" arg) 'error))
 (list "hi" #\a 'a-symbol (make-vector 3) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (format #f "~P" arg) 'error))
 (list "hi" #\a 'a-symbol (make-vector 3) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (format #f "~X" arg) 'error))
 (list "hi" #\a 'a-symbol (make-vector 3) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (format #f "~C" arg) 'error))
 (list "hi" 1 1.0 1+i 2/3 'a-symbol (make-vector 3) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (format #f arg 123) 'error))
 (list 1 1.0 1+i 2/3 'a-symbol (make-vector 3) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (format #f "~{~A ~A ~}" '(1 "hi" 2)) 'error)
(for-each
 (lambda (arg)
   (let ((result (catch #t (lambda () (format #f "~F" arg)) (lambda args 'error))))
     (if (not (eq? result 'error))
	 (begin (display "(format #f \"~F\" ") (display arg)
		(display ") returned ") (display result) 
		(display " but expected 'error")
		(newline)))))
 (list #\a '#(1 2 3) "hi" '() 'hi abs (lambda () 1) '#(()) (list 1 2 3) '(1 . 2)))

(test (format #f "~D") 'error)
(test (format () "hi") 'error)
(test (format #f "~F" "hi") 'error)
(test (format #f "~D" #\x) 'error)
(test (format #f "~C" (list 1 2 3)) 'error)
(test (format #f "~1/4F" 1.4) 'error)
(test (format #f "~1.4F" 1.4) 'error)
(test (format #f "~F" (real-part (log 0.0))) "-inf.0")
(test (let ((val (format #f "~F" (/ (real-part (log 0.0)) (real-part (log 0.0)))))) (or (string=? val "nan.0") (string=? val "-nan.0"))) #t)
(test (format #f "~1/4T~A" 1) 'error)
(test (format #f "~T") "")
(test (format #f "~@P~S" 1 '(1)) "y(1)")
(test (format #f ".~A~*" 1 '(1)) ".1")
(test (format #f "~*~*~T" 1 '(1)) "")

(test (format #f "~A" 'AB\c) "(symbol \"AB\\\\c\")")
(test (format #f "~S" 'AB\c) "(symbol \"AB\\\\c\")")
(test (format #f "~A" '(AB\c () xyz)) "((symbol \"AB\\\\c\") () xyz)")
(test (format #f "~,2f" 1234567.1234) "1234567.12")
(test (format #f "~5D" 3) "    3")
(test (format #f "~5,'0D" 3) "00003")
(test (format #f "++~{-=~s=-~}++" (quote (1 2 3))) "++-=1=--=2=--=3=-++")

(test (format) 'error)
(for-each
 (lambda (arg)
   (test (format arg) 'error))
 (list 1 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))
(test (format "hi") "hi") ; !?
(test (format "~A ~D" 1/3 2) "1/3 2")
(test (format "") "")

;; from slib/formatst.scm
(test (string=? (format #f "abc") "abc") #t)
(test (string=? (format #f "~a" 10) "10") #t)
(test (string=? (format #f "~a" -1.2) "-1.2") #t)
(test (string=? (format #f "~a" 'a) "a") #t)
(test (string=? (format #f "~a" #t) "#t") #t)
(test (string=? (format #f "~a" #f) "#f") #t)
(test (string=? (format #f "~a" "abc") "abc") #t)
(test (string=? (format #f "~a" '#(1 2 3)) "#(1 2 3)") #t)
(test (string=? (format #f "~a" '()) "()") #t)
(test (string=? (format #f "~a" '(a)) "(a)") #t)
(test (string=? (format #f "~a" '(a b)) "(a b)") #t)
(test (string=? (format #f "~a" '(a (b c) d)) "(a (b c) d)") #t)
(test (string=? (format #f "~a" '(a . b)) "(a . b)") #t)
(test (string=? (format #f "~a ~a" 10 20) "10 20") #t)
(test (string=? (format #f "~a abc ~a def" 10 20) "10 abc 20 def") #t)
(test (string=? (format #f "~d" 100) "100") #t)
(test (string=? (format #f "~x" 100) "64") #t)
(test (string=? (format #f "~o" 100) "144") #t)
(test (string=? (format #f "~b" 100) "1100100") #t)
(test (string=? (format #f "~10d" 100) "       100") #t)
(test (string=? (format #f "~10,'*d" 100) "*******100") #t)
(test (string=? (format #f "~c" #\a) "a") #t)
(test (string=? (format #f "~c" #\space) " ") #t)
(test (string=? (format #f "~C" #\x91) "\x91") #t)
(test (string=? (format #f "~C" #\x9) "\x09") #t)
(test (string=? (format #f "~C" #\~) "~") #t)
(test (string=? (format #f "~A" #\x91) "\x91") #t)
(test (string=? (format #f "~S" #\x91) "#\\x91") #t)
(test (string=? (format #f "~A" (string->symbol "hi")) "hi") #t)
(test (string=? (format #f "~S" (string->symbol "hi")) "hi") #t)
(test (string=? (format #f "~A" (string->symbol ";\\\";")) "(symbol \";\\\\\\\";\")") #t)
(test (string=? (format #f "~S" (string->symbol ";\\\";")) "(symbol \";\\\\\\\";\")") #t)
(test (string=? (format #f "~A" (string->symbol (string #\, #\. #\# #\; #\" #\\ #\' #\`))) "(symbol \",.#;\\\"\\\\'`\")") #t)

(test (string=? (format #f "~~~~") "~~") #t)
(test (string=? (format #f "~s" "abc") "\"abc\"") #t)
(test (string=? (format #f "~s" "abc \\ abc") "\"abc \\\\ abc\"") #t)
(test (string=? (format #f "~a" "abc \\ abc") "abc \\ abc") #t)
(test (string=? (format #f "~s" "abc \" abc") "\"abc \\\" abc\"") #t)
(test (string=? (format #f "~a" "abc \" abc") "abc \" abc") #t)
(test (string=? (format #f "~s" #\space) "#\\space") #t)
(test (string=? (format #f "~s" #\newline) "#\\newline") #t)
(test (string=? (format #f "~s" #\a) "#\\a") #t)
(test (string=? (format #f "~a" '(a "b" c)) "(a \"b\" c)") #t)
(test (string=? (format #f "abc~
         123") "abc123") #t)
(test (string=? (format #f "abc~
123") "abc123") #t)
(test (string=? (format #f "abc~
") "abc") #t)
(test (string=? (format #f "~{ ~a ~}" '(a b c)) " a  b  c ") #t)
(test (string=? (format #f "~{ ~a ~}" '()) "") #t)
(test (string=? (format #f "~{ ~a ~}" "") "") #t)
(test (string=? (format #f "~{ ~a ~}" #()) "") #t)
(test (string=? (format #f "~{ ~a,~a ~}" '(a 1 b 2 c 3)) " a,1  b,2  c,3 ") #t)
(test (string=? (format #f "abc ~^ xyz") "abc ") #t)
(test (format (values #f "~A ~D" 1 2)) "1 2")
(test (format #f "~A~^" 1) "1") ; clisp agrees here
(test (format #f "~A~*~* ~A" (values 1 2 3 4)) "1 4")
(test (format #f "~^~A~^~*~*~^ ~^~A~^" (values 1 2 3 4)) "1 4")

(test (string=? (format #f "~B" 123) "1111011") #t)
(test (string=? (format #f "~B" 123/25) "1111011/11001") #t)
(test (string=? (format #f "~B" 123.25) "1111011.01") #t)
(test (string=? (format #f "~B" 123+i) "1111011.0+1.0i") #t)

(test (string=? (format #f "~D" 123) "123") #t)
(test (string=? (format #f "~D" 123/25) "123/25") #t)

(test (string=? (format #f "~O" 123) "173") #t)
(test (string=? (format #f "~O" 123/25) "173/31") #t)
(test (string=? (format #f "~O" 123.25) "173.2") #t)
(test (string=? (format #f "~O" 123+i) "173.0+1.0i") #t)

(test (string=? (format #f "~X" 123) "7b") #t)
(test (string=? (format #f "~X" 123/25) "7b/19") #t)
(test (string=? (format #f "~X" 123.25) "7b.4") #t)
(test (string=? (format #f "~X" 123+i) "7b.0+1.0i") #t)

(test (string=? (format #f "~A" "hi") (format #f "~S" "hi")) #f)
(test (string=? (format #f "~A" #\a) (format #f "~S" #\a)) #f)
(for-each
 (lambda (arg)
   (test (string=? (format #f "~A" arg) (format #f "~S" arg)) #t))
 (list 1 1.0 #(1 2 3) '(1 2 3) '(1 . 2) '() #f #t abs #<eof> #<unspecified> 'hi '\a))
(test (length (format #f "~S" (string #\\))) 4)                  ; "\"\\\\\""
(test (length (format #f "~S" (string #\a))) 3)                  ; "\"a\""
(test (length (format #f "~S" (string #\null))) 6)               ; "\"\\x00\""
(test (length (format #f "~S" (string (integer->char #xf0)))) 3) ; "\"ð\""
(test (length (format #f "~S" (string #\"))) 4)                  ; "\""

(test (format #f "~F" 3.0) "3.000000")
(test (format #f "~G" 3.0) "3.0")
(test (format #f "~E" 3.0) "3.000000e+00")
(test (format #f "~F" 3.14159) "3.141590")
(test (format #f "~G" 3.14159) "3.14159")
(test (format #f "~E" 3.14159) "3.141590e+00")
(test (format #f "~,2F" 3.14159) "3.14")
(test (format #f "~,2G" 3.14159) "3.1")
(test (format #f "~,2E" 3.14159) "3.14e+00")
(test (format #f "~12F" 3.14159) "    3.141590")
(test (format #f "~12G" 3.14159) "     3.14159")
(test (format #f "~12E" 3.14159) "3.141590e+00")
(test (format #f "~12,3F" 3.14159) "       3.142")
(test (format #f "~12,3G" 3.14159) "        3.14")
(test (format #f "~12,3E" 3.14159) "   3.142e+00")
(test (format #f "~12,'xD" 1) "xxxxxxxxxxx1")
(test (format #f "~12,'xF" 3.14159) "xxxx3.141590")
(test (format #f "~12,'xG" 3.14159) "xxxxx3.14159")
(test (format #f "~12,'xE" 3.14159) "3.141590e+00")
(test (format #f "~12,'\\F" 3.14159) "\\\\\\\\3.141590")
(test (format #f "~20,20G" 3.0) "                   3.0")
(test (format #f "~20,20F" 3.0) "3.00000000000000000000")
(test (format #f "~20,20E" 3.0) "3.00000000000000000000e+00")

(test (format #f "~,3B" 0.99999) "0.111")
(test (format #f "~,3O" 0.99999) "0.777")
(test (format #f "~,3F" 0.99999) "1.000")
(test (format #f "~,3X" 0.99999) "0.fff")

(test (format #f "~-2F" 0.0) 'error)
(test (format #f "~,-2F" 0.0) 'error)
(test (format #f "~2/3F" 0.0) 'error)
(test (format #f "~2.3F" 0.0) 'error)
(test (format #f "~2,1,3,4F" 0.0) 'error)
(test (format #f "~'xF" 0.0) 'error)
(test (format #f "~3,3" pi) 'error)
(test (format #f "~3," pi) 'error)
(test (format #f "~3" pi) 'error)
(test (format #f "~," pi) 'error)
(test (format #f "~'," pi) 'error)
(test (format #f "~'" pi) 'error)

(test (format #f "~*" 1.0) "")
(test (format #f "~D" 1.0) "1.000000e+00")
(test (format #f "~O" 1.0) "1.0")
(test (format #f "~P" 1.0) "")
(test (format #f "~P" '(1 2 3)) 'error)
(test (format #f "~\x00T") 'error)
(test (format #f "~9,'(T") "((((((((")
(test (format #f "~0F" 1+1i) "1.000000+1.000000i")
(test (format #f "~9F" 1) "        1")
(test (format #f "~,0F" 3.14) "3.0")
(test (format #f "~,0F" 1+1i) "1+1i")
(test (format #f "~,0X" 1+1i) "1.0+1.0i")
(test (format #f "~,9g" 1+1i) "1+1i")
(test (format #f "~,1e" 3.14) "3.1e+00")
(test (format #f "~9,0F" 3.14) "        3.0")
(test (format #f "~9,1F" 3.14) "      3.1")
(test (format #f "~9,2F" 3.14) "     3.14")
(test (format #f "~9,3F" 3.14) "    3.140")
(test (format #f "~9,4F" 3.14) "   3.1400")
(test (format #f "~9,5F" 3.14) "  3.14000")
(test (format #f "~9,6F" 3.14) " 3.140000")
(test (format #f "~9,7F" 3.14) "3.1400000")
(test (format #f "~9,8F" 3.14) "3.14000000")
(test (format #f "~9,9F" 3.14) "3.140000000")
(test (format #f "~9,9G" 1+1i) "     1+1i")
(test (format #f "~9,0e" 1+1i) "1e+00+1e+00i")
(test (format #f "~9,1e" 1+1i) "1.0e+00+1.0e+00i")
(test (format #f "~9,2e" 1+1i) "1.00e+00+1.00e+00i")
(test (format #f "~9,3e" 1+1i) "1.000e+00+1.000e+00i")
(test (format #f "~9,4e" 1+1i) "1.0000e+00+1.0000e+00i")
(test (format #f "~9,5e" 1+1i) "1.00000e+00+1.00000e+00i")
(test (format #f "~9,6e" 1+1i) "1.000000e+00+1.000000e+00i")
(test (format #f "~9,7e" 1+1i) "1.0000000e+00+1.0000000e+00i")
(test (format #f "~9,8e" 1+1i) "1.00000000e+00+1.00000000e+00i")
(test (format #f "~9,9e" 1+1i) "1.000000000e+00+1.000000000e+00i")
(test (format #f "~9,0x" 3.14) "      3.0")
(test (format #f "~9,1x" 3.14) "      3.2")
(test (format #f "~9,2x" 3.14) "     3.23")
(test (format #f "~9,3x" 3.14) "    3.23d")
(test (format #f "~9,4x" 3.14) "   3.23d7")
(test (format #f "~9,5x" 3.14) "   3.23d7")
(test (format #f "~9,6x" 3.14) " 3.23d70a")
(test (format #f "~9,7x" 3.14) "3.23d70a3")
(test (format #f "~9,8x" 3.14) "3.23d70a3d")
(test (format #f "~9,9x" 3.14) "3.23d70a3d7")
(test (format #f "~9,0b" 3.14) "     11.0")
(test (format #f "~9,1b" 3.14) "     11.0")
(test (format #f "~9,2b" 3.14) "     11.0")
(test (format #f "~9,3b" 3.14) "   11.001")
(test (format #f "~9,4b" 3.14) "   11.001")
(test (format #f "~9,5b" 3.14) "   11.001")
(test (format #f "~9,6b" 3.14) "   11.001")
(test (format #f "~9,7b" 3.14) "11.0010001")
(test (format #f "~9,8b" 3.14) "11.00100011")
(test (format #f "~9,9b" 3.14) "11.001000111")
(test (format #f "~0,'xf" 1) "1")
(test (format #f "~1,'xf" 1) "1")
(test (format #f "~2,'xf" 1) "x1")
(test (format #f "~3,'xf" 1) "xx1")
(test (format #f "~4,'xf" 1) "xxx1")
(test (format #f "~5,'xf" 1) "xxxx1")
(test (format #f "~6,'xf" 1) "xxxxx1")
(test (format #f "~7,'xf" 1) "xxxxxx1")
(test (format #f "~8,'xf" 1) "xxxxxxx1")
(test (format #f "~9,'xf" 1) "xxxxxxxx1")
(test (format #f "~11,'xf" 3.14) "xxx3.140000")
(test (format #f "~12,'xf" 3.14) "xxxx3.140000")
(test (format #f "~13,'xf" 3.14) "xxxxx3.140000")
(test (format #f "~14,'xf" 3.14) "xxxxxx3.140000")
(test (format #f "~15,'xf" 3.14) "xxxxxxx3.140000")
(test (format #f "~16,'xf" 3.14) "xxxxxxxx3.140000")
(test (format #f "~17,'xf" 3.14) "xxxxxxxxx3.140000")
(test (format #f "~18,'xf" 3.14) "xxxxxxxxxx3.140000")
(test (format #f "~19,'xf" 3.14) "xxxxxxxxxxx3.140000")
(test (format #f "~,f" 1.0) "1.000000")
(test (format #f "~,,f" 1.0) 'error)
(test (format #f "~p" '(1 2 3)) 'error) ; these are not errors in CL
(test (format #f "~p" #(())) 'error)
(test (format #f "~p" 'hi) 'error)
(test (format #f "~p" abs) 'error)
(test (format #f "~p" 1+i) 'error)
(test (format #f "~@p" '(1 2 3)) 'error)
(test (format #f "~@p" #(())) 'error)
(test (format #f "~@p" 'hi) 'error)
(test (format #f "~@p" abs) 'error)
(test (format #f "~{~{~A~^~} ~}" '((hi 1))) "hi1 ")
(test (format #f "~{~{~A~^~} ~}" '((1 2) (3 4))) "12 34 ")
(test (format #f "~{~{~A~} ~}" '((1 2) (3 4))) "12 34 ")
(test (format #f "~{~{~A~} ~}" '(())) " ")
(test (format #f "~{~{~A~} ~}" '((()))) "() ")
(test (format #f "~{~{~F~} ~}" '(())) " ")
(test (format #f "~{~{~C~} ~}" '(())) " ")
(test (format #f "~{~C ~}" '()) "")
(test (format #f "~C ~^" #\a) "a ") ; CL ignores pointless ~^
(test (format #f "~^~A" #f) "#f")
(test (format #f "~^~^~A" #f) "#f")
(test (format #f "~*~*~A~*" 1 2 3 4) "3")
(test (format #f "~{~*~A~}" '(1 2 3 4)) "24")
(test (let ((lst (list 1 2 3))) (set! (cdr (cddr lst)) lst) (format #f "~A" lst)) "#1=(1 2 3 . #1#)")
(test (let ((lst (list 1 2 3))) (set! (cdr (cddr lst)) lst) (format #f "~{~A~}" lst)) 'error)
(test (format #f "~{~A~}" (cons 1 2)) 'error)
(test (format #f "~{~A~}" '(1 2 3 . 4)) 'error)
(test (format #f "~20,vF" 3.14) 'error)
(test (format #f "~{~C~^ ~}" "hiho") "h i h o")
(test (format #f "~{~{~C~^ ~}~}" (list "hiho")) "h i h o")
(test (format #f "~{~A ~}" #(1 2 3 4)) "1 2 3 4 ")
(test (let ((v (vector 1))) (set! (v 0) v) (format #f "~A" v)) "#1=#(#1#)")
(test (let ((v (vector 1))) (set! (v 0) v) (format #f "~{~A~}" v)) "#1=#(#1#)")
(test (format #f "~{~{~{~A~^ ~}~^ ~}~}" '(((1 2) (3 4)))) "1 2 3 4")
(test (format #f "~{~{~{~A~^ ~}~^ ~}~}" '((#(1 2) #(3 4)))) "1 2 3 4")
(test (format #f "~{~{~{~A~^ ~}~^ ~}~}" #(((1 2) (3 4)))) "1 2 3 4")
(test (format #f "~{~{~{~A~^ ~}~^ ~}~}" #(#((1 2) (3 4)))) "1 2 3 4")
(test (format #f "~{~{~{~A~^ ~}~^ ~}~}" #(#(#(1 2) (3 4)))) "1 2 3 4")
(test (format #f "~{~{~{~A~^ ~}~^ ~}~}" #(#(#(1 2) #(3 4)))) "1 2 3 4")
(test (format #f "~{~{~C~^ ~}~^ ~}" (list "hiho" "xxx")) "h i h o x x x")
(test (format #f "~{~{~A~}~}" '((1 . 2) (3 . 4))) 'error)
(test (format #f "~{~A~^ ~}" '((1 . 2) (3 . 4))) "(1 . 2) (3 . 4)") 
(test (format #f "~{~A ~}" (hash-table '(a . 1) '(b . 2))) "(b . 2) (a . 1) ")
(test (format #f "~{~A ~}" (hash-table)) "")

(test (format #f "~10,'-T") "---------")
(test (format #f "~10,'\\T") "\\\\\\\\\\\\\\\\\\")
(test (format #f "~10,'\"T") "\"\"\"\"\"\"\"\"\"")
(test (format #f "~10,'-T12345~20,'-T") "---------12345-----")
(test (format #f "~10,')T") ")))))))))")

(test (format #f "~,0F" 1.4) "1.0")
(test (format #f "~,0F" 1.5) "2.0")
(test (format #f "~,0F" 1.6) "2.0")
(test (format #f "~,0F" 0.4) "0.0")
(test (format #f "~,0F" 0.5) "0.0")
(test (format #f "~,0F" 0.6) "1.0")
(test (format #f "~,-0F" 1.4) 'error)
(test (format #f "~, 0F" 1.4) 'error)
(test (format #f "~*1~*" 1) 'error)
(test (format #f "~*1~A" 1) 'error)

(test (reverse (format #f "~{~A~}" '((1 2) (3 4)))) ")4 3()2 1(")
(test (string->symbol (format #f "~A" '(1 2))) (symbol "(1 2)"))

(test (string->number (format #f "~A" -1)) -1)
(test (string->number (format #f "~S" -1)) -1)
(test (string->number (format #f "~F" -1)) -1)
(test (string->number (format #f "~D" -1)) -1)
(test (string->number (format #f "~G" -1)) -1)
(test (string->number (format #f "~E" -1)) -1)
(test (string->number (format #f "~B" -1)) -1)
(test (string->number (format #f "~X" -1)) -1)
(test (string->number (format #f "~O" -1)) -1)
(num-test (string->number (format #f "~A" 1.5)) 1.5)
(num-test (string->number (format #f "~S" 1.5)) 1.5)
(num-test (string->number (format #f "~F" 1.5)) 1.5)
(num-test (string->number (format #f "~D" 1.5)) 1.5)
(num-test (string->number (format #f "~G" 1.5)) 1.5)
(num-test (string->number (format #f "~E" 1.5)) 1.5)
(num-test (string->number (format #f "~B" 1.5)) 1.1)
(num-test (string->number (format #f "~X" 1.5)) 1.8)
(num-test (string->number (format #f "~O" 1.5)) 1.4)
(num-test (string->number (format #f "~A" 1+1i)) 1+1i)
(num-test (string->number (format #f "~S" 1+1i)) 1+1i)
(num-test (string->number (format #f "~F" 1+1i)) 1+1i)
(num-test (string->number (format #f "~D" 1+1i)) 1+1i)
(num-test (string->number (format #f "~G" 1+1i)) 1+1i)
(num-test (string->number (format #f "~E" 1+1i)) 1+1i)
(num-test (string->number (format #f "~B" 1+1i)) 1+1i)
(num-test (string->number (format #f "~X" 1+1i)) 1+1i)
(num-test (string->number (format #f "~O" 1+1i)) 1+1i)
(test (string->number (format #f "~A" 3/4)) 3/4)
(test (string->number (format #f "~S" 3/4)) 3/4)
(test (string->number (format #f "~F" 3/4)) 3/4)
(test (string->number (format #f "~D" 3/4)) 3/4)
(test (string->number (format #f "~G" 3/4)) 3/4)
(test (string->number (format #f "~E" 3/4)) 3/4)
(test (string->number (format #f "~B" 3/4)) 11/100)
(test (string->number (format #f "~X" 3/4)) 3/4)
(test (string->number (format #f "~O" 3/4)) 3/4)
(num-test (string->number (format #f "~A" 0+1i)) 0+1i)
(num-test (string->number (format #f "~S" 0+1i)) 0+1i)
(num-test (string->number (format #f "~F" 0+1i)) 0+1i)
(num-test (string->number (format #f "~D" 0+1i)) 0+1i)
(num-test (string->number (format #f "~G" 0+1i)) 0+1i)
(num-test (string->number (format #f "~E" 0+1i)) 0+1i)
(num-test (string->number (format #f "~B" 0+1i)) 0+1i)
(num-test (string->number (format #f "~X" 0+1i)) 0+1i)
(num-test (string->number (format #f "~O" 0+1i)) 0+1i)

(test (format "~G" 1e10) "1e+10")
(test (format "~F" 1e10) "10000000000.000000")
(test (format "~E" 1e10) "1.000000e+10")
(test (format "~A" 1e10) "10000000000.0")
(test (format "~D" 1e10) "1.000000e+10")

(test (format #f "~P{T}'" 1) "{T}'")
(test (format #f "~") 'error)
(test (format #f "~B&B~X" 1.5 1.5) "1.1&B1.8")
(test (format #f ",~~~A~*1" 1 1) ",~11")
(test (format #f "~D~20B" 0 0) "0                   0")
(test (format #f "~D~20B" 1 1) "1                   1")
(test (format #f "~10B" 1) "         1")
(test (format #f "~10B" 0) "         0")
(test (format #f "~100B" 1) "                                                                                                   1")
(test (length (format #f "~1000B" 1)) 1000)
(test (format #f "~D~20D" 3/4 3/4) "3/4                 3/4")
(test (length (format #f "~20D" 3/4)) 20)
(test (format #f "~20B" 3/4) "              11/100")
(test (length (format #f "~20B" 3/4)) 20)
(test (format #f "~D~20B" 3/4 3/4) "3/4              11/100")
(test (format #f "~X~20X" 21/33 21/33) "7/b                 7/b")
(test (format #f "~D~20,'.B" 3/4 3/4) "3/4..............11/100")
(test (format #f "~20g" 1+i) "                1+1i")
(test (length (format #f "~20g" 1+i)) 20)
(test (format #f "~20f" 1+i) "  1.000000+1.000000i")
(test (length (format #f "~20f" 1+i)) 20)
(test (format #f "~20x" 17+23i) "          11.0+17.0i")
(test (length (format #f "~20x" 17+23i)) 20)

(test (format #f "~{~{~A~^~} ~}" (hash-table '((a . 1) (b . 2)))) "(a . 1)(b . 2) ")
(test (format #f "~{~{~A~^~}~^~}" (hash-table '((a . 1) (b . 2)))) "(a . 1)(b . 2)")
(test (format #f "~{~{~A~^ ~}~^~}" (hash-table '((a . 1) (b . 2)))) "(a . 1) (b . 2)")
(test (format #f "~{~{~{~A~^~} ~}~}" #(())) "")
(test (format #f "~{~{~{~P~^~} ~}~}" '((()))) " ")
(test (format #f "~{~{~{~P~^~}~}~}" '(((2 3 4)))) "sss")
(test (apply format #f "~T~~{~{~{~*~~0~1~*~}~@~}" '(())) "~{")
(test (format #f "~{~S}%~}" '(a b c)) "a}%b}%c}%")
(test (format #f "~&~^%~F." 0) "%0.")
(test (format #f "1~^2") "1")
(test (apply format #f "~P~d~B~~" '(1 2 3)) "211~")
(test (format #f "~T1~~^~P" 0) "1~^s")
(test (format #f "~S~^~{~^" '(+ x 1)) "(+ x 1)")
(test (format #f "1~^~{2") "1")
(test (format #f "~A~{~0~g~@~B~}" '() '()) "()")
(test (format #f "1~^~^~^2") "1")
(test (format #f "~{~{~~}~~,~}~*" '(()) '(())) "~,")
(test (format #f "~~S~S~T~~C~g~~" 0 0) "~S0~C0~")
(test (format #f "~{~~e~}~~{~*~~" "" "") "~{~")

(let ()
  (define* (clean-string e (precision 3))
    (format #f (format #f "(~~{~~,~DF~~^ ~~})" precision) e))
  (test (clean-string '(1.123123 -2.31231323 3.141592653589 4/3) 1) "(1.1 -2.3 3.1 4/3)")
  (test (clean-string '(1.123123 -2.31231323 3.141592653589 4/3)) "(1.123 -2.312 3.142 4/3)")
  (test (clean-string '(1.123123 -2.31231323 3.141592653589 4/3) 6) "(1.123123 -2.312313 3.141593 4/3)"))

(if with-bignums
    (begin
      (test (format #f "~P" (bignum "1")) "")
      (test (format #f "~P" (bignum "1.0")) "")
      (test (format #f "~P" (bignum "2")) "s")
      (test (format #f "~P" (bignum "2.0")) "s")
      (test (format #f "~10,' D" (bignum "1")) "         1")
      (test (format #f "~10,' D" (bignum "3/4")) "       3/4")
      (test (format #f "~10,'.D" (bignum "3/4")) ".......3/4")
      (test (format #f "~10D" (bignum "3/4")) "       3/4")
      (test (length (format #f "~100D" (bignum "34"))) 100)
      (test (format #f "~50F" (bignum "12345678.7654321")) "                                1.23456787654321E7")
      ))


(call-with-output-file "tmp1.r5rs" (lambda (p) (format p "this ~A ~C test ~D" "is" #\a 3)))
(let ((res (call-with-input-file "tmp1.r5rs" (lambda (p) (read-line p)))))
  (if (not (string=? res "this is a test 3"))
      (begin 
	(display "call-with-input-file + format to \"tmp1.r5rs\" ... expected \"this is a test 3\", but got \"")
	(display res) (display "\"?") (newline))))

(let ((val (format #f "line 1~%line 2~%line 3")))
  (with-input-from-string val
    (lambda ()
      (let ((line1 (read-line)))
	(test (string=? line1 "line 1") #t))
      (let ((line2 (read-line)))
	(test (string=? line2 "line 2") #t))
      (let ((line3 (read-line)))
	(test (string=? line3 "line 3") #t))
      (let ((eof (read-line)))
	(test (eof-object? eof) #t))
      (let ((eof (read-line)))
	(test (eof-object? eof) #t)))))


(let ((val (format #f "line 1~%line 2~%line 3")))
  (call-with-input-string val
			  (lambda (p)
			    (let ((line1 (read-line p #t)))
			      (test (string=? line1 (string-append "line 1" (string #\newline))) #t))
			    (let ((line2 (read-line p #t)))
			      (test (string=? line2 (string-append "line 2" (string #\newline))) #t))
			    (let ((line3 (read-line p #t)))
			      (test (string=? line3 "line 3") #t))
			    (let ((eof (read-line p #t)))
			      (test (eof-object? eof) #t))
			    (let ((eof (read-line p #t)))
			      (test (eof-object? eof) #t)))))

(let ((res #f)) 
  (let ((this-file (open-output-string))) 
    (format this-file "this ~A ~C test ~D" "is" #\a 3)
    (set! res (get-output-string this-file))
    (close-output-port this-file))
  (if (not (string=? res "this is a test 3"))
      (begin 
	(display "open-output-string + format ... expected \"this is a test 3\", but got \"")
	(display res) (display "\"?") (newline))))

(let ((res1 #f)
      (res2 #f)
      (res3 #f))
  (let ((p1 (open-output-string)))
    (format p1 "~D" 0)
    (let ((p2 (open-output-string)))
      (format p2 "~D" 1)
      (let ((p3 (open-output-string)))
	(if (not (string=? (get-output-string p1) "0"))
	    (format #t ";format to nested ports, p1: ~S~%" (get-output-string p1)))	
	(if (not (string=? (get-output-string p2) "1"))
	    (format #t ";format to nested ports, p2: ~S~%" (get-output-string p2)))	
	(format p3 "~D" 2)
	(format p2 "~D" 3)
	(format p1 "~D" 4)
	(format p3 "~D" 5)
	(set! res3 (get-output-string p3))
	(close-output-port p3)
	(if (not (string=? (get-output-string p1) "04"))
	    (format #t ";format to nested ports after close, p1: ~S~%" (get-output-string p1)))	
	(if (not (string=? (get-output-string p2) "13"))
	    (format #t ";format to nested ports after close, p2: ~S~%" (get-output-string p2))))
      (format (or p1 p3) "~D" 6)
      (format (and p1 p2) "~D" 7)
      (set! res1 (get-output-string p1))
      (close-output-port p1)
      (if (not (string=? (get-output-string p2) "137"))
	  (format #t ";format to nested ports after 2nd close, p2: ~S~%" (get-output-string p2)))
      (format p2 "~D" 8)
      (set! res2 (get-output-string p2))
      (test (get-output-string p1) 'error)
      (close-output-port p2)))
  (if (not (string=? res1 "046"))
      (format #t ";format to nested ports, res1: ~S~%" res1))
  (if (not (string=? res2 "1378"))
      (format #t ";format to nested ports, res2: ~S~%" res2))
  (if (not (string=? res3 "25"))
      (format #t ";format to nested ports, res3: ~S~%" res3)))

(test (call/cc (lambda (return) 
		 (let ((val (format #f "line 1~%line 2~%line 3")))
		   (call-with-input-string val
					   (lambda (p) (return "oops"))))))
      "oops")

;(format #t "format #t: ~D" 1)
;(format (current-output-port) " output-port: ~D! (this is testing output ports)~%" 2)

(call-with-output-file "tmp1.r5rs"
  (lambda (p)
    (display 1 p)
    (write 2 p)
    (write-char #\3 p)
    (format p "~D" 4)
    (write-byte (char->integer #\5) p)
    (call-with-output-file "tmp2.r5rs"
      (lambda (p)
	(display 6 p)
	(write 7 p)
	(write-char #\8 p)
	(format p "~D" 9)
	(write-byte (char->integer #\0) p)
	(newline p)))
    (call-with-input-file "tmp2.r5rs"
      (lambda (pin)
	(display (read-line pin) p)))
    (newline p)))

(test (call-with-input-file "tmp1.r5rs"
	(lambda (p)
	  (read-line p)))
      "1234567890")

(call-with-output-file "tmp1.r5rs"
  (lambda (p)
    (format p "12345~%")
    (format p "67890~%")))

(call-with-input-file "tmp1.r5rs"
  (lambda (p)
    (test (read-char p) #\1)
    (test (read-byte p) (char->integer #\2))
    (test (peek-char p) #\3)
    (test (char-ready? p) #t)
    (test (read-line p) "345")
    (test (read-line p) "67890")))

(test (write 1 (current-input-port)) 'error)
(test (write-char #\a (current-input-port)) 'error)
(test (write-byte 0 (current-input-port)) 'error)
(test (read (current-output-port)) 'error)
(test (read-char (current-output-port)) 'error)
(test (read-byte (current-output-port)) 'error)
(test (read-line (current-output-port)) 'error)

(let ((op1 (set-current-output-port (open-output-file "tmp1.r5rs"))))
  (display 1)
  (write 2)
  (write-char #\3)
  (format #t "~D" 4) ; #t -> output port
  (write-byte (char->integer #\5))
  (let ((op2 (set-current-output-port (open-output-file "tmp2.r5rs"))))
    (display 6)
    (write 7)
    (write-char #\8)
    (format #t "~D" 9)
    (write-byte (char->integer #\0))
    (newline)
    (close-output-port (current-output-port))
    (set-current-output-port op2)
    (let ((ip1 (set-current-input-port (open-input-file "tmp2.r5rs"))))
      (display (read-line))
      (close-input-port (current-input-port))
      (set-current-input-port ip1))
    (newline)
    (close-output-port (current-output-port))
    (set-current-output-port op1)))

(let ((old-op1 (current-output-port))
      (op1 (open-output-file "tmp1.r5rs")))
  (set! (current-output-port) op1)
  (display 1)
  (write 2)
  (write-char #\3)
  (format #t "~D" 4) ; #t -> output port
  (write-byte (char->integer #\5))
  (let ((old-op2 (current-output-port))
	(op2 (open-output-file "tmp2.r5rs")))
    (set! (current-output-port) op2)
    (display 6)
    (write 7)
    (write-char #\8)
    (format #t "~D" 9)
    (write-byte (char->integer #\0))
    (newline)
    (close-output-port (current-output-port))
    (set! (current-output-port) old-op2)
    (let ((old-ip1 (current-input-port))
	  (ip1 (open-input-file "tmp2.r5rs")))
      (set! (current-input-port) ip1)
      (display (read-line))
      (close-input-port (current-input-port))
      (set! (current-input-port) old-ip1))
    (newline)
    (close-output-port (current-output-port))
    (set! (current-output-port) old-op1)))

(test (call-with-input-file "tmp1.r5rs"
	(lambda (p)
	  (read-line p)))
      "1234567890")

(for-each 
 (lambda (op)
   (for-each
    (lambda (arg)
      (test (op arg display) 'error))
    (list 1 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list call-with-output-file call-with-input-file
       call-with-output-string call-with-input-string
       with-input-from-string with-input-from-file
       with-output-to-file))

(for-each 
 (lambda (op)
   (for-each
    (lambda (arg)
      (test (op arg) 'error))
    (list 1 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list open-output-file open-input-file 
       open-input-string))

(for-each
 (lambda (op)
   (for-each 
    (lambda (arg)
      (test (op "hi" arg) 'error))
    (list "hi" 1 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list write display write-byte newline write-char 
       read read-char read-byte peek-char char-ready? read-line))

(for-each 
 (lambda (arg)
   (test (write-char arg) 'error)
   (test (write-byte arg) 'error)
   (test (read-char arg) 'error)
   (test (read-byte arg) 'error)
   (test (peek-char arg) 'error))
 (list "hi" 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs #f #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (op)
   (for-each
    (lambda (arg)
      (test (op arg) 'error))
    (list "hi" 1 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list set-current-input-port set-current-error-port set-current-output-port close-input-port close-output-port))

(let ((hi (open-output-string)))
  (test (get-output-string hi) "")
  (close-output-port hi)
  (test (get-output-string hi) 'error))

(test (open-output-string "hiho") 'error)
(test (with-output-to-string "hi") 'error)
(test (call-with-output-string "hi") 'error)

(test (get-output-string 1 2) 'error)
(test (get-output-string) 'error)
(for-each 
 (lambda (arg)
   (test (get-output-string arg) 'error))
 (list "hi" 1 1.0 1+i 2/3 'a-symbol (make-vector 3) '(1 2) (cons 1 2) abs :hi (if #f #f) (lambda (a) (+ a 1))))

;; since read of closed port will generate garbage, it needs to be an error,
;;   so I guess write of closed port should also be an error

(let ((hi (open-output-string)))
  (close-output-port hi)
  (for-each
   (lambda (op)
     (test-e (op hi) (object->string op) 'closed-port))
   (list (lambda (p) (display 1 p))
	 (lambda (p) (write 1 p))
	 (lambda (p) (write-char #\a p))
	 (lambda (p) (write-byte 0 p))
	 (lambda (p) (format p "hiho"))
	 set-current-output-port
	 set-current-input-port
	 set-current-error-port
	 newline)))

(let ((hi (open-input-string "hiho")))
  (test (get-output-string hi) 'error)
  (close-input-port hi)
  (for-each
   (lambda (op)
     (test-e (op hi) (object->string op) 'closed-port))
   (list read read-char read-byte peek-char char-ready? read-line 
	 port-filename port-line-number
	 set-current-output-port
	 set-current-input-port
	 set-current-error-port
	 )))
  
(test (close-output-port (open-input-string "hiho")) 'error)
(test (close-input-port (open-output-string)) 'error)
(test (set! (port-filename) "hiho") 'error)
(test (set! (port-closed (current-output-port)) "hiho") 'error)

(let* ((new-error-port (open-output-string))
       (old-error-port (set-current-error-port new-error-port)))
  (catch #t
	 (lambda ()
	   (format #f "~R" 123))
	 (lambda args
	   (format (current-error-port) "oops")))
  (let ((str (get-output-string new-error-port)))
    (set-current-error-port old-error-port)
    (test str "oops")))


(let ((hi (open-input-string "hiho")))
  (for-each
   (lambda (op)
     (test-e (op hi) (object->string op) 'input-port))
   (list (lambda (p) (display 1 p))
	 (lambda (p) (write 1 p))
	 (lambda (p) (write-char #\a p))
	 (lambda (p) (write-byte 0 p))
	 (lambda (p) (format p "hiho"))
	 newline))
  (close-input-port hi))

(let ((hi (open-output-file "tmp1.r5rs")))
  (write-byte 1 hi)
  (close-output-port hi)
  (test (write-byte 1 hi) 'error))

(let ((hi (open-output-string)))
  (for-each
   (lambda (op)
     (test-e (op hi) (object->string op) 'output-port))
   (list read read-char read-byte peek-char char-ready? read-line))
  (close-output-port hi))

(test (output-port? (current-error-port)) #t)
(test (and (not (null? (current-error-port))) (input-port? (current-error-port))) #f)

(call-with-output-file "tmp1.r5rs"
  (lambda (p)
    (test (get-output-string p) 'error)
    (do ((i 0 (+ i 1)))
	((= i 256))
      (write-byte i p))))

(call-with-input-file "tmp1.r5rs"
  (lambda (p)
    (test (get-output-string p) 'error)
    (do ((i 0 (+ i 1)))
	((= i 256))
      (let ((b (read-byte p)))
	(if (not (= b i))
	    (format #t "read-byte got ~A, expected ~A~%" b i))))
    (let ((eof (read-byte p)))
      (if (not (eof-object? eof))
	  (format #t "read-byte at end: ~A~%" eof)))
    (let ((eof (read-byte p)))
      (if (not (eof-object? eof))
	  (format #t "read-byte at end: ~A~%" eof)))))

(call-with-output-file "tmp1.r5rs"
  (lambda (p)
    (do ((i 0 (+ i 1)))
	((= i 256))
      (write-char (integer->char i) p))))

(define our-eof #f)

(call-with-input-file "tmp1.r5rs"
  (lambda (p)
    (do ((i 0 (+ i 1)))
	((= i 256))
      (let ((b (read-char p)))
	(if (or (not (char? b))
		(not (char=? b (integer->char i))))
	    (format #t "read-char got ~A, expected ~A (~D: char? ~A)~%" b (integer->char i) i (char? (integer->char i))))))
    (let ((eof (read-char p)))
      (if (not (eof-object? eof))
	  (format #t "read-char at end: ~A~%" eof))
      (set! our-eof eof))
    (let ((eof (read-char p)))
      (if (not (eof-object? eof))
	  (format #t "read-char again at end: ~A~%" eof)))))

(test (eof-object? (integer->char 255)) #f)
(test (eof-object? our-eof) #t)
(test (char->integer our-eof) 'error)
(test (char? our-eof) #f)
(test (eof-object? ((lambda () our-eof))) #t)

(for-each
 (lambda (op)
   (test (op *stdout*) 'error)
   (test (op *stderr*) 'error)
   (test (op (current-output-port)) 'error)
   (test (op (current-error-port)) 'error)
   (test (op '()) 'error))
 (list read read-line read-char read-byte peek-char char-ready?))

(for-each
 (lambda (op)
   (test (op #\a *stdin*) 'error)
   (test (op #\a (current-input-port)) 'error)
   (test (op #\a '()) 'error))
 (list write display write-char))
	 
(test (write-byte 0 *stdin*) 'error)
(test (write-byte (char->integer #\space) *stdout*) (char->integer #\space))
(test (write-byte (char->integer #\space) *stderr*) (char->integer #\space))
(test (newline *stdin*) 'error)
(test (format *stdin* "hiho") 'error)

(test (port-filename *stdin*) "*stdin*")	 
(test (port-filename *stdout*) "*stdout*")	 
(test (port-filename *stderr*) "*stderr*")	

(test (input-port? *stdin*) #t) 
(test (output-port? *stdin*) #f) 
(test (port-closed? *stdin*) #f)
(test (input-port? *stdout*) #f) 
(test (output-port? *stdout*) #t) 
(test (port-closed? *stdout*) #f)
(test (input-port? *stderr*) #f) 
(test (output-port? *stderr*) #t) 
(test (port-closed? *stderr*) #f)

(test (port-line-number *stdin*) 0)
(test (port-line-number *stdout*) 'error)
(test (port-line-number *stderr*) 'error)

(test (open-input-file "[*not-a-file!*]-") 'error)
(test (call-with-input-file "[*not-a-file!*]-" (lambda (p) p)) 'error)
(test (with-input-from-file "[*not-a-file!*]-" (lambda () #f)) 'error)

(test (open-input-file "") 'error)
(test (call-with-input-file "" (lambda (p) p)) 'error)
(test (with-input-from-file "" (lambda () #f)) 'error)

;(test (open-output-file "/bad-dir/badness/[*not-a-file!*]-") 'error)
;(test (call-with-output-file "/bad-dir/badness/[*not-a-file!*]-" (lambda (p) p)) 'error)
;(test (with-output-to-file "/bad-dir/badness/[*not-a-file!*]-" (lambda () #f)) 'error)

(with-output-to-file "tmp.r5rs"
  (lambda ()
    (write-char #\a)
    (with-output-to-file "tmp1.r5rs"
      (lambda ()
	(format #t "~C" #\b)
	(with-output-to-file "tmp2.r5rs"
	  (lambda ()
	    (display #\c)))
	(display (with-input-from-file "tmp2.r5rs"
		   (lambda ()
		     (read-char))))))
    (with-input-from-file "tmp1.r5rs"
      (lambda ()
	(write-byte (read-byte))
	(write-char (read-char))))))

(with-input-from-file "tmp.r5rs"
  (lambda ()
    (test (read-line) "abc")))

(with-input-from-file "tmp.r5rs" ; this assumes tmp.r5rs has "abc" as above
  (lambda ()
    (test (read-char) #\a)
    (test (eval-string "(+ 1 2)") 3)
    (test (read-char) #\b)
    (with-input-from-string "(+ 3 4)"
      (lambda ()
	(test (read) '(+ 3 4))))
    (test (read-char) #\c)))

(test (eval-string (object->string (with-input-from-string "(+ 1 2)" (lambda () (read))))) 3)
(test (eval (eval-string "(with-input-from-string \"(+ 1 2)\" (lambda () (read)))")) 3)
(test (eval-string "(eval (with-input-from-string \"(+ 1 2)\" (lambda () (read))))") 3)
(test (eval-string (object->string (eval-string (format #f "(+ 1 2)")))) 3)


;;; -------- test that we can plow past errors --------

(if (and (defined? 'file-exists?) ; (ifdef name ...)?
	 (file-exists? "tests.data"))
    (delete-file "tests.data"))

(call-with-output-file "tests.data"
  (lambda (p)
    (format p "start ")
    (catch #t 
      (lambda () 
	(format p "next ") (abs "hi") (format p "oops "))
      (lambda args
	'error))
    (format p "done\n")))

(let ((str (call-with-input-file "tests.data" 
             (lambda (p) 
	       (read-line p)))))
  (if (or (not (string? str))
	  (not (string=? str "start next done")))
      (format #t ";call-with-output-file + error -> ~S~%" str)))

(let ((str (call-with-input-file "tests.data" 
             (lambda (p) 
	       (catch #t
		      (lambda ()
			(read-char p)
			(abs "hi")
			(read-char p))
		      (lambda args "s"))))))
  (if (or (not (string? str))
	  (not (string=? str "s")))
      (format #t ";call-with-input-file + error -> ~S~%" str)))

(if (and (defined? 'file-exists?)
	 (file-exists? "tests.data"))
    (delete-file "tests.data"))

(with-output-to-file "tests.data"
  (lambda ()
    (format #t "start ")
    (catch #t 
      (lambda () 
	(format #t "next ") (abs "hi") (format #t "oops "))
      (lambda args
	'error))
    (format #t "done\n")))

(let ((str (with-input-from-file "tests.data" 
             (lambda () 
	       (read-line)))))
  (if (or (not (string? str))
	  (not (string=? str "start next done")))
      (format #t ";with-output-to-file + error -> ~S~%" str)))

(let ((str (with-input-from-file "tests.data" 
             (lambda () 
	       (catch #t
		      (lambda ()
			(read-char)
			(abs "hi")
			(read-char))
		      (lambda args "s"))))))
  (if (or (not (string? str))
	  (not (string=? str "s")))
      (format #t ";with-input-from-file + error -> ~S~%" str)))

(test (call-with-output-string newline) (string #\newline))
(test (call-with-output-string append) "")

(let ((str (call-with-output-string
	    (lambda (p)
	      (format p "start ")
	      (catch #t 
		     (lambda () 
		       (format p "next ") (abs "hi") (format p "oops "))
		     (lambda args
		       'error))
	      (format p "done")))))
  (if (or (not (string? str))
	  (not (string=? str "start next done")))
      (format #t ";call-with-output-string + error -> ~S~%" str)))

(let ((str (with-output-to-string
	    (lambda ()
	      (format #t "start ")
	      (catch #t 
		     (lambda () 
		       (format #t "next ") (abs "hi") (format #t "oops "))
		     (lambda args
		       'error))
	      (format #t "done")))))
  (if (or (not (string? str))
	  (not (string=? str "start next done")))
      (format #t ";with-output-to-string + error -> ~S~%" str)))

(test (with-output-to-string (lambda () (format (current-output-port) "a test ~D" 123))) "a test 123")
;(test (with-output-to-string (lambda () (format *stdout* "a test ~D" 1234))) "a test 1234")

(test (string=? (with-output-to-string (lambda () (write #\null))) "#\\null") #t)
(test (string=? (with-output-to-string (lambda () (write #\space))) "#\\space") #t)
(test (string=? (with-output-to-string (lambda () (write #\return))) "#\\return") #t)
(test (string=? (with-output-to-string (lambda () (write #\escape))) "#\\escape") #t)
(test (string=? (with-output-to-string (lambda () (write #\tab))) "#\\tab") #t)
(test (string=? (with-output-to-string (lambda () (write #\newline))) "#\\newline") #t)
(test (string=? (with-output-to-string (lambda () (write #\backspace))) "#\\backspace") #t)
(test (string=? (with-output-to-string (lambda () (write #\alarm))) "#\\alarm") #t)
(test (string=? (with-output-to-string (lambda () (write #\delete))) "#\\delete") #t)

(test (string=? (with-output-to-string (lambda () (write-char #\space))) " ") #t)  ; weird -- the name is backwards
(test (string=? (with-output-to-string (lambda () (display #\space))) " ") #t)

(let ((str (call-with-input-string "12345"
	    (lambda (p)
	      (catch #t
		     (lambda ()
		       (read-char p)
		       (abs "hi")
		       (read-char p))
		     (lambda args "s"))))))
  (if (or (not (string? str))
	  (not (string=? str "s")))
      (format #t ";call-with-input-string + error -> ~S~%" str)))

(let ((str (with-input-from-string "12345"
	    (lambda ()
	      (catch #t
		     (lambda ()
		       (read-char)
		       (abs "hi")
		       (read-char))
		     (lambda args "s"))))))
  (if (or (not (string? str))
	  (not (string=? str "s")))
      (format #t ";with-input-from-string + error -> ~S~%" str)))

(for-each
 (lambda (arg)
   (test (port-line-number arg) 'error)
   (test (port-filename arg) 'error))
 (list "hi" -1 0 #\a 'a-symbol '#(1 2 3) '(1 . 2) '(1 2 3) 3.14 3/4 1.0+1.0i #t abs #<eof> #<unspecified> (lambda () 1)))

(test (catch #t (lambda () (eval-string (port-filename))) (lambda args #f)) #f)
(test (symbol? (string->symbol (port-filename))) #t)

(for-each
 (lambda (arg)
   (test
    (with-input-from-string (format #f "~A" arg)
      (lambda ()
	(read)))
    arg))
 (list 1 3/4 '(1 2) #(1 2) :hi #f #t))

(num-test (with-input-from-string "3.14" (lambda () (read))) 3.14)
(num-test (with-input-from-string "3.14+2i" (lambda () (read))) 3.14+2i)
(num-test (with-input-from-string "#x2.1" (lambda () (read))) 2.0625)
(test (with-input-from-string "'hi" (lambda () (read))) ''hi)
(test (with-input-from-string "'(1 . 2)" (lambda () (read))) ''(1 . 2))

(test
 (let ((cin #f)
       (cerr #f))
   (catch #t
	  (lambda ()
	    (with-input-from-string "123"
	      (lambda ()
		(set! cin (current-input-port))
		(error 'testing "jump out"))))
	  (lambda args
	    (set! cerr #t)))
   (format #f "~A ~A" cin cerr))
 "<input-string-port (closed)> #t")

;;; old form:  "<port string input (closed)> #t")

(test
 (let ((cout #f)
       (cerr #f))
   (catch #t
	  (lambda ()
	    (with-output-to-string
	      (lambda ()
		(set! cout (current-output-port))
		(error 'testing "jump out"))))
	  (lambda args
	    (set! cerr #t)))
   (format #f "~A ~A" cout cerr))
 "<output-string-port (closed)> #t")

;;; old form:  "<port string output (closed)> #t")

(call-with-output-file "tmp1.r5rs"
  (lambda (p)
    (display "1" p)
    (newline p)
    (newline p)
    (display "2345" p)
    (newline p)))

(call-with-input-file "tmp1.r5rs"
  (lambda (p)
    (test (read-line p) "1")
    (test (read-line p) "")
    (test (read-line p) "2345")
    (test (eof-object? (read-line p)) #t)))

(let ((p (open-output-file "tmp1.r5rs" "a")))
  (display "678" p)
  (newline p)
  (close-output-port p))

(test (let ((p (open-output-file "tmp1.r5rs" "xyzzy"))) (close-output-port p)) 'error)
(test (let ((p (open-input-file "tmp1.r5rs" "xyzzy"))) (close-input-port p)) 'error)

(call-with-input-file "tmp1.r5rs"
  (lambda (p)
    (test (read-line p) "1")
    (test (read-line p) "")
    (test (read-line p) "2345")
    (test (read-line p) "678")
    (test (eof-object? (read-line p)) #t)))

(for-each
 (lambda (arg)
   (test (port-filename arg) 'error))
 (list "hi" -1 #\a 1 0 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t '() (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (port-filename arg) 'error))
 (list "hi" -1 #\a 1 0 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t '() (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (open-input-file "s7test.scm" arg) 'error)
   (test (open-output-file "test.data" arg) 'error))
 (list -1 #\a 1 0 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #f #t '() (list 1 2 3) '(1 . 2)))

(test (current-input-port '()) 'error)
(test (current-output-port '()) 'error)
(test (current-error-port '()) 'error)

(for-each
 (lambda (op)
   (let ((tag (catch #t (lambda () (op)) (lambda args 'error))))
     (if (not (eq? tag 'error))
	 (format #t ";(~A) -> ~A (expected 'error)~%" op tag))))
 (list set-current-input-port set-current-error-port set-current-output-port 
       close-input-port close-output-port
       write display write-byte write-char format                     ; newline
       ;read read-char read-byte peek-char char-ready? read-line      ; these can default to current input
       call-with-output-file call-with-input-file
       call-with-output-string call-with-input-string
       with-input-from-string with-input-from-file
       with-output-to-file
       open-output-file open-input-file 
       open-input-string))

(for-each
 (lambda (op)
   (let ((tag (catch #t (lambda () (op 1 2 3 4 5)) (lambda args 'error))))
     (if (not (eq? tag 'error))
	 (format #t ";(~A 1 2 3 4 5) -> ~A (expected 'error)~%" op tag))))
 (list set-current-input-port set-current-error-port set-current-output-port 
       close-input-port close-output-port
       write display write-byte write-char format newline
       read read-char read-byte peek-char char-ready? read-line
       call-with-output-file call-with-input-file
       call-with-output-string call-with-input-string
       with-input-from-string with-input-from-file
       with-output-to-file
       open-output-file open-input-file 
       open-input-string))

;;; (string-set! (with-input-from-string "\"1234\"" (lambda () (read))) 1 #\a)

(test (>= (length (with-output-to-string (lambda () (write (make-string 512 #\tab))))) 512) #t)
(test (>= (length (with-output-to-string (lambda () (write (make-string 512 #\newline))))) 512) #t)
(test (>= (length (with-output-to-string (lambda () (write (make-string 512 #\"))))) 512) #t)
(test (>= (length (with-output-to-string (lambda () (write (make-string 512 #\x65))))) 512) #t)

(if (and (defined? 'file-exists?)
	 (file-exists? "/home/bil/test"))
    (let ((old-path *load-path*))
      (set! *load-path* (cons "/home/bil/test" *load-path*))

      (with-output-to-file "/home/bil/test/load-path-test.scm"
	(lambda ()
	  (format #t "(define (load-path-test) *load-path*)~%")))

      (load "load-path-test.scm")
      (if (or (not (defined? 'load-path-test))
	      (not (equal? *load-path* (load-path-test))))
	  (format #t ";*load-path*: ~S, but ~S~%" *load-path* (load-path-test)))
      (set! *load-path* old-path)))




;;; -------- poke at the reader --------

(test (cdr '(1 ."a")) "a")
(test (cadr '(1 .#d2)) '.#d2)
(test '(1 .(2 3)) '(1 2 3))
(test '(1 .(2 3)) '(1 . (2 3)))
(test (+ .(2 .(3))) 5)
(test (cadr '(1 '0,)) ''0,)
(test (equal? 3 ' 3) #t)
(test (equal? '   
	             3 3) #t)
(test (equal? '"hi" ' "hi") #t)
(test (equal? '#\a '    #\a) #t)
(test (let ((nam()e 1)) 1) 'error)
(test (let ((nam""e 1)) nam""e) 'error) ; this was 1 originally
(test (cadr '(1 ']x)) '']x)
(test `1 1)
(test (equal? '(1 .(1 .())) '(1 1)) #t)
(test (equal? '("hi"."ho") ' ("hi" . "ho")) #t)
(test (equal? '("hi""ho") '("hi" "ho")) #t)
(test '("""""") '("" "" ""))
(test '(#|;"();|#) '())
(test '(#||##\# #||##b1) '(#\# 1))
(test (#|s'!'|#*) 1)
(test (#|==|#) ())
(test -#|==|#1 'error) ; unbound variable
(test '((). '()) '(() quote ()))
(test '(1. . .2) '(1.0 . 0.2))
(test (equal? '(().()) '(())) #t)
(test (equal? '(()()) '(() ())) #t)
(test (equal? '(()..()) '(() .. ())) #t)
(test '((().()).()) '((())))
(test '(((().()).()).()) '(((()))))
(test '((().(().())).()) '((() ())))
(test '((()().(().()))) '((() () ())))
(test '(1 .;
	  2) '(1 . 2))
(test (vector .(1 .(2))) #(1 2))
(test (vector 0. .(.1)) #(0.0 0.1))
(test '(a #|foo||# b) '(a b)) ; from bug-guile
(test '(a #|foo|||# b) '(a b))
(test '(a #|foo||||# b) '(a b))
(test '(a #|foo|||||# b) '(a b))

(test (char? #\#) #t)
(test (eval-string "'#<vct>") 'error)
(test (eval-string "'(#<vct>)") 'error)
(test (car `(,.1e0)) .1)
(test (car `(,.1E0)) .1)
(test (let ((x "hi")) (set! x"asdf") x) "asdf")
(test (let* ((x "hi") (y x)) (set! x "asdf") y) "hi")
(test (let ((x 1)) (set! x(list 1 2)) x) '(1 2))
(num-test (let ((x 1)) (set!;"
			x;)
			12.;(
			);#|
	       x) 12.0)
(test (let ((\x00}< 1) (@:\t{ 2)) (+ \x00}< @:\t{)) 3)
(test (let ((| 1) (|| 2) (||| 3)) (+ || | |||)) 6)
(test (let ((|a#||#b| 1)) |a#||#b|) 1)
(test (let ((@,@'[1] 1) (\,| 2)) (+ @,@'[1] \,|)) 3)
(test (list"0"0()#()#\a"""1"'x(list)+(cons"""")#f) (list "0" 0 () #() #\a "" "1" 'x (list) + '("" . "") #f))
(test (let ((x, 1)) x,) 1)
(test (length (eval-string (string #\' #\( #\1 #\space #\. (integer->char 200) #\2 #\)))) 2) ; will be -1 if dot is for improper list, 3 if dot is a symbol
(test (eval-string "(list \\\x001)") 'error)
(test (eval-string "(list \\\x00 1)") 'error)
(test (+ `,0(angle ```,`11)) 0)
(test (map . (char->integer "123")) '(49 50 51))
(test (map .(values "0'1")) '(#\0 #\' #\1))
(test (map /""'(123)) '())
(num-test (+ 1 .()) 1)
(test (let () (define (x .()) (list .())) (x)) ())

;; how is ...#(... parsed?
(test (eval-string "'(# (1))") 'error)
(test (let ((lst (eval-string "'(#(1))"))) (and (= (length lst) 1) (vector? (car lst)))) #t)                     ; '(#(1))
(test (let ((lst (eval-string "'(-#(1))"))) (and (= (length lst) 2) (symbol? (car lst)) (pair? (cadr lst)))) #t) ; '(-# (1))
(test (let ((lst (eval-string "'(1#(1))"))) (and (= (length lst) 2) (symbol? (car lst)) (pair? (cadr lst)))) #t) ; '(1# (1))
(test (let ((lst (eval-string "'('#(1))"))) (and (= (length lst) 1) (vector? (cadar lst)))) #t)                  ; '((quote #(1)))
(test (let ((lst (eval-string "'(()#())"))) (and (= (length lst) 2) (null? (car lst)) (vector? (cadr lst)))) #t) ; '(() #())
(test (let ((lst (eval-string "'(().())"))) (and (= (length lst) 1) (null? (car lst)))) #t)                      ; '(())
(test (let ((lst (eval-string "'(()-())"))) (and (= (length lst) 3) (null? (car lst)) (null? (caddr lst)))) #t)  ; '(() - ())
(test (let ((lst (eval-string "'(().#())"))) (and (= (length lst) 3) (null? (car lst)) (null? (caddr lst)))) #t) ; '(() .# ())
(test (let ((lst (eval-string "'((). #())"))) (and (= (length lst) -1) (null? (car lst)) (vector? (cdr lst)))) #t) ; '(() . #())
(test (let ((lst (eval-string "'(\"\"#())"))) (and (= (length lst) 2) (string? (car lst)) (vector? (cadr lst)))) #t) ; '("" #())
(test (length (car '("#\\("))) 3)
(test (length (car '("#\\\""))) 3)
(test (char=? ((car '("#\\\"")) 2) #\") #t)
(test (length '(()#\(())) 3)
(test (length (eval-string "'(()#\\(())")) 3)
(test (char=? ((eval-string "'(()#\\#())") 1) #\#) #t)
(test (length (list""#t())) 3)
(test (length (list""#())) 2)
(test (length (eval-string "'(#xA(1))")) 2)
(test (length '(#xA""#(1))) 3)
(test (length (eval-string "'(#xA\"\"#(1))")) 3)
(test (length (eval-string "'(1#f)")) 1)
(test (eval-string "'(#f#())") 'error)
(test (length '(#f())) 2)
(test (length '(#f"")) 2)
(test (eval-string "#F") 'error)
(test (eval-string "'(#<eof>#<eof>)") 'error)
(test (eval-string "'(#<eof>#())") 'error)
(test (equal? '('#()) '(#())) #f)
(test (equal? (list '#()) '(#())) #t)
(test (equal? '('#()) '('#())) #t)
(test (equal? '('#()) '(`#())) #f) ;  [guile agrees]
(test (equal? '('()) '(`())) #f) ; ! quote != quasiquote [guile agrees]
(test (equal? '('(1)) '(`(1))) #t) ;  but lists are different? [guile says #f]
(test (equal? '('#(1)) '(`#(1))) #f) ; [guile agrees]
(test (equal? '('#()) '(#())) #f)
(test (equal? '(`#()) '(`#())) #t)
(test (equal? '#() `#()) #t)
(test (equal? (list '#()) (list `#())) #t)
(test (equal? (list '#()) '(`#())) #t)
(test (equal? '(`#()) '(#())) #t)
(test (equal? `#() '#()) #t) ; and also (1) () #(1) etc
(test (equal? `'#() ''#()) #t) ; "
(test (equal? '`#() ''#()) #f) ; it equals '#() -- this is consistent -- see below
(test (equal? '`#() ``#()) #t)

(test (equal? '() '()) #t)
(test (equal? (quote ()) '()) #t)
(test (equal? '() (quote ())) #t)
(test (equal? (quote ()) (quote ())) #t)
(test (equal? `(1) '(1)) #t)
(test (equal? (quasiquote (1)) '(1)) #t)
(test (equal? `(1) (quote (1))) #t)
(test (equal? (quasiquote (1)) (quote (1))) #t)
(test (equal? ``''1 '``'1) #t)
(test (equal? (quasiquote `(quote (quote 1))) '``'1) #t)
(test (equal? ``''1 (quote ``(quote 1))) #t)
(test (equal? (quasiquote `(quote (quote 1))) (quote ``(quote 1))) #t)
(test (equal? '``'#f ```'#f) #t)
(test (equal? (quote ``(quote #f)) ```'#f) #t)
(test (equal? '``'#f (quasiquote ``(quote #f))) #t)
(test (equal? (quote ``(quote #f)) (quasiquote ``(quote #f))) #t)
;;; etc:

#|
(equal? (quote `1) (quote (quasiquote 1))) -> #f
the reader sees `1 and turns it into 1 in the 1st case, but does not collapse the 2nd case to 1
  (who knows, quasiquote might have been redefined in context... but ` can't be redefined):
:(define (` a) a)
;define: define a non-symbol? 'a
;    (define ('a) a)

this is different from guile which does not handle ` at read time except to expand it:

guile> (quote `1) 
(quasiquote 1)

:(quote `1)
1

so anything that quotes ` is not going to equal quote quasiquote

(define (check-strs str1 str2)
  (for-each
   (lambda (arg)
     (let ((expr (format #f "(equal? ~A~A ~A~A)" str1 arg str2 arg)))
       (let ((val (catch #t 
			 (lambda () (eval-string expr))
			 (lambda args 'error))))
	 (format #t "--------~%~S -> ~S" expr val)
	 (let* ((parens3 0)
		(parens4 0)
		(str3 (apply string-append (map (lambda (c)
						 (if (char=? c #\`)
						     (if (= parens3 0)
							 (begin
							   (set! parens3 (+ parens3 1))
							   "(quasiquote ")
							 "`")
						     (if (char=? c #\')
							 (begin
							   (set! parens3 (+ parens3 1))
							   "(quote ")
							 (string c))))
						str1)))
		(str4 (apply string-append (map (lambda (c)
						 (if (char=? c #\`)
						     (if (= parens4 0)
							 (begin
							   (set! parens4 (+ parens4 1))
							   "(quasiquote ")
							 "`")
						     (if (char=? c #\')
							 (begin
							   (set! parens4 (+ parens4 1))
							   "(quote ")
							 (string c))))
						str2))))
	   (let ((expr (format #f "(equal? ~A~A~A ~A~A)" str3 arg (make-string parens3 #\)) str2 arg)))
	     (let* ((val1 (catch #t 
			       (lambda () (eval-string expr))
			       (lambda args 'error)))
		    (trouble (and (not (eq? val1 'error))
				  (not (eq? val1 val)))))
	       (if trouble
		   (format #t "~%~8T~A~S -> ~S~A" bold-text expr val1 unbold-text)
		   (format #t "~%~8T~S -> ~S" expr val1))))
	   (let ((expr (format #f "(equal? ~A~A ~A~A~A)" str1 arg str4 arg (make-string parens4 #\)))))
	     (let* ((val1 (catch #t 
			       (lambda () (eval-string expr))
			       (lambda args 'error)))
		    (trouble (and (not (eq? val1 'error))
				  (not (eq? val1 val)))))
	       (if trouble
		   (format #t "~%~8T~A~S -> ~S~A" bold-text expr val1 unbold-text)
		   (format #t "~%~8T~S -> ~S" expr val1))))
	   (let ((expr (format #f "(equal? ~A~A~A ~A~A~A)" str3 arg (make-string parens3 #\)) str4 arg (make-string parens4 #\)))))
	     (let* ((val1 (catch #t 
			       (lambda () (eval-string expr))
			       (lambda args 'error)))
		    (trouble (and (not (eq? val1 'error))
				  (not (eq? val1 val)))))
	       (if trouble
		   (format #t "~%~8T~A~S -> ~S~A~%" bold-text expr val1 unbold-text)
		   (format #t "~%~8T~S -> ~S~%" expr val1))))
	   ))))
   (list "()" "(1)" "#()" "#(1)" "1" "#f")))
   ;; (list ",(+ 1 2)" "\"\"" "(())" "#\\1" "3/4" ",1")

(check-strs "'" "'")
(check-strs "`" "'")
(check-strs "'" "`")
(check-strs "`" "`")

(let ((strs '()))
  (do ((i 0 (+ i 1)))
      ((= i 4))
    (let ((c1 ((vector #\' #\` #\' #\`) i))
	  (c2 ((vector #\' #\' #\` #\`) i)))
      (do ((k 0 (+ k 1)))
	  ((= k 4))
	(let ((d1 ((vector #\' #\` #\' #\`) k))
	      (d2 ((vector #\' #\' #\` #\`) k)))
	  (let ((str1 (string c1 c2))
		(str2 (string d1 d2)))
	    (if (not (member (list str1 str2) strs))
		(begin
		  (check-strs str1 str2)
		  (set! strs (cons (list str1 str2) strs))
		  (set! strs (cons (list str2 str1) strs))))))))))

(let ((strs '()))
  (do ((i 0 (+ i 1)))
      ((= i 8))
    (let ((c1 ((vector #\' #\` #\' #\` #\' #\` #\' #\`) i))
	  (c2 ((vector #\' #\' #\` #\` #\' #\' #\` #\`) i))
	  (c3 ((vector #\' #\' #\' #\' #\` #\` #\` #\`) i)))
      (do ((k 0 (+ k 1)))
	  ((= k 8))
	(let ((d1 ((vector #\' #\` #\' #\` #\' #\` #\' #\`) k))
	      (d2 ((vector #\' #\' #\` #\` #\' #\' #\` #\`) k))
	      (d3 ((vector #\' #\' #\' #\' #\` #\` #\` #\`) k)))
	  (let ((str1 (string c1 c2 c3))
		(str2 (string d1 d2 d3)))
	    (if (not (member (list str1 str2) strs))
		(begin
		  (check-strs str1 str2)
		  (set! strs (cons (list str1 str2) strs))
		  (set! strs (cons (list str2 str1) strs))))))))))


;;; --------------------------------

(do ((i 0 (+ i 1)))
    ((= i 256))
  (if (and (not (= i (char->integer #\))))
	   (not (= i (char->integer #\"))))
      (let ((str (string #\' #\( #\1 #\space #\. (integer->char i) #\2 #\))))
	(catch #t
	       (lambda ()
		 (let ((val (eval-string str)))
		   (format #t "[~D] ~A -> ~S (~S ~S)~%" i str val (car val) (cdr val))))
	       (lambda args
		 (format #t "[~D] ~A -> ~A~%" i str args))))))

(let ((chars (vector (integer->char 0) #\newline #\space #\tab #\. #\, #\@ #\= #\x #\b #\' #\` 
		     #\# #\] #\[ #\} #\{ #\( #\) #\1 #\i #\+ #\- #\e #\_ #\\ #\" #\: #\; #\> #\<)))
  (let ((nchars (vector-length chars)))
    (do ((len 2 (+ len 1)))
	((= len 3))
      (let ((str (make-string len))
	    (ctrs (make-vector len 0)))

	(do ((i 0 (+ i 1)))
	    ((= i (expt nchars len)))

	  (let ((carry #t))
	    (do ((k 0 (+ k 1)))
		((or (= k len)
		     (not carry)))
	      (vector-set! ctrs k (+ 1 (vector-ref ctrs k)))
	      (if (= (vector-ref ctrs k) nchars)
		  (vector-set! ctrs k 0)
		  (set! carry #f)))
	    (do ((k 0 (+ k 1)))
		((= k len))
	      (string-set! str k (vector-ref chars (vector-ref ctrs k)))))

	  (format #t "~A -> " str)
	  (catch #t
		 (lambda ()
		   (let ((val (eval-string str)))
		     (format #t " ~S -> ~S~%" str val)))
		 (lambda args
		   ;(format #t " ~A~%" args)
		   #f
		   )))))))
|#

(let ((äåæéîå define)
      (ìåîçôè length)
      (äï do)
      (ìåô* let*)
      (éæ if)
      (áâó abs)
      (ìïç log)
      (óåô! set!))

  (äåæéîå (óòã-äõòáôéïî å)
    (ìåô* ((ìåî (ìåîçôè å))
           (åø0 (å 0))
           (åø1 (å (- ìåî 2)))
           (áìì-ø (- åø1 åø0))
           (äõò 0.0))
      (äï ((é 0 (+ é 2)))
          ((>= é (- ìåî 2)) äõò)
        (ìåô* ((ø0 (å é))
               (ø1 (å (+ é 2)))
               (ù0 (å (+ é 1))) ; 1/ø ø ðïéîôó
               (ù1 (å (+ é 3)))
               (áòåá (éæ (< (áâó (- ù0 ù1)) .0001)
                         (/ (- ø1 ø0) (* ù0 áìì-ø))
                         (* (/ (- (ìïç ù1) (ìïç ù0)) 
                               (- ù1 ù0)) 
                            (/ (- ø1 ø0) áìì-ø)))))
         (óåô! äõò (+ äõò (áâó áòåá)))))))

  (num-test (óòã-äõòáôéïî (list 0 1 1 2)) 0.69314718055995)
  (num-test (óòã-äõòáôéïî (vector 0 1 1 2)) 0.69314718055995))

(test (let ((ÿa 1)) ÿa) 1)
(test (+ (let ((!a 1)) !a) (let (($a 1)) $a) (let ((%a 1)) %a) (let ((&a 1)) &a) (let ((*a 1)) *a) (let ((+a 1)) +a) (let ((-a 1)) -a) (let ((.a 1)) .a) (let ((/a 1)) /a) (let ((0a 1)) 0a) (let ((1a 1)) 1a) (let ((2a 1)) 2a) (let ((3a 1)) 3a) (let ((4a 1)) 4a) (let ((5a 1)) 5a) (let ((6a 1)) 6a) (let ((7a 1)) 7a) (let ((8a 1)) 8a) (let ((9a 1)) 9a) (let ((<a 1)) <a) (let ((=a 1)) =a) (let ((>a 1)) >a) (let ((?a 1)) ?a) (let ((@a 1)) @a) (let ((Aa 1)) Aa) (let ((Ba 1)) Ba) (let ((Ca 1)) Ca) (let ((Da 1)) Da) (let ((Ea 1)) Ea) (let ((Fa 1)) Fa) (let ((Ga 1)) Ga) (let ((Ha 1)) Ha) (let ((Ia 1)) Ia) (let ((Ja 1)) Ja) (let ((Ka 1)) Ka) (let ((La 1)) La) (let ((Ma 1)) Ma) (let ((Na 1)) Na) (let ((Oa 1)) Oa) (let ((Pa 1)) Pa) (let ((Qa 1)) Qa) (let ((Ra 1)) Ra) (let ((Sa 1)) Sa) (let ((Ta 1)) Ta) (let ((Ua 1)) Ua) (let ((Va 1)) Va) (let ((Wa 1)) Wa) (let ((Xa 1)) Xa) (let ((Ya 1)) Ya) (let ((Za 1)) Za) (let (([a 1)) [a) (let ((\a 1)) \a) (let ((]a 1)) ]a) (let ((^a 1)) ^a) (let ((_a 1)) _a) (let ((aa 1)) aa) (let ((ba 1)) ba) (let ((ca 1)) ca) (let ((da 1)) da) (let ((ea 1)) ea) (let ((fa 1)) fa) (let ((ga 1)) ga) (let ((ha 1)) ha) (let ((ia 1)) ia) (let ((ja 1)) ja) (let ((ka 1)) ka) (let ((la 1)) la) (let ((ma 1)) ma) (let ((na 1)) na) (let ((oa 1)) oa) (let ((pa 1)) pa) (let ((qa 1)) qa) (let ((ra 1)) ra) (let ((sa 1)) sa) (let ((ta 1)) ta) (let ((ua 1)) ua) (let ((va 1)) va) (let ((wa 1)) wa) (let ((xa 1)) xa) (let ((ya 1)) ya) (let ((za 1)) za) (let (({a 1)) {a) (let ((|a 1)) |a) (let ((}a 1)) }a) (let ((~a 1)) ~a) (let (( a 1))  a) (let ((¡a 1)) ¡a) (let ((¢a 1)) ¢a) (let ((£a 1)) £a) (let ((¤a 1)) ¤a) (let ((¥a 1)) ¥a) (let ((¦a 1)) ¦a) (let ((§a 1)) §a) (let ((¨a 1)) ¨a) (let ((©a 1)) ©a) (let ((ªa 1)) ªa) (let ((«a 1)) «a) (let ((¬a 1)) ¬a) (let ((­a 1)) ­a) (let ((®a 1)) ®a) (let ((¯a 1)) ¯a) (let ((°a 1)) °a) (let ((±a 1)) ±a) (let ((²a 1)) ²a) (let ((³a 1)) ³a) (let ((´a 1)) ´a) (let ((µa 1)) µa) (let ((¶a 1)) ¶a) (let ((·a 1)) ·a) (let ((¸a 1)) ¸a) (let ((¹a 1)) ¹a) (let ((ºa 1)) ºa) (let ((»a 1)) »a) (let ((¼a 1)) ¼a) (let ((½a 1)) ½a) (let ((¾a 1)) ¾a) (let ((¿a 1)) ¿a) (let ((Àa 1)) Àa) (let ((Áa 1)) Áa) (let ((Âa 1)) Âa) (let ((Ãa 1)) Ãa) (let ((Äa 1)) Äa) (let ((Åa 1)) Åa) (let ((Æa 1)) Æa) (let ((Ça 1)) Ça) (let ((Èa 1)) Èa) (let ((Éa 1)) Éa) (let ((Êa 1)) Êa) (let ((Ëa 1)) Ëa) (let ((Ìa 1)) Ìa) (let ((Ía 1)) Ía) (let ((Îa 1)) Îa) (let ((Ïa 1)) Ïa) (let ((Ða 1)) Ða) (let ((Ña 1)) Ña) (let ((Òa 1)) Òa) (let ((Óa 1)) Óa) (let ((Ôa 1)) Ôa) (let ((Õa 1)) Õa) (let ((Öa 1)) Öa) (let ((×a 1)) ×a) (let ((Øa 1)) Øa) (let ((Ùa 1)) Ùa) (let ((Úa 1)) Úa) (let ((Ûa 1)) Ûa) (let ((Üa 1)) Üa) (let ((Ýa 1)) Ýa) (let ((Þa 1)) Þa) (let ((ßa 1)) ßa) (let ((àa 1)) àa) (let ((áa 1)) áa) (let ((âa 1)) âa) (let ((ãa 1)) ãa) (let ((äa 1)) äa) (let ((åa 1)) åa) (let ((æa 1)) æa) (let ((ça 1)) ça) (let ((èa 1)) èa) (let ((éa 1)) éa) (let ((êa 1)) êa) (let ((ëa 1)) ëa) (let ((ìa 1)) ìa) (let ((ía 1)) ía) (let ((îa 1)) îa) (let ((ïa 1)) ïa) (let ((ða 1)) ða) (let ((ña 1)) ña) (let ((òa 1)) òa) (let ((óa 1)) óa) (let ((ôa 1)) ôa) (let ((õa 1)) õa) (let ((öa 1)) öa) (let ((÷a 1)) ÷a) (let ((øa 1)) øa) (let ((ùa 1)) ùa) (let ((úa 1)) úa) (let ((ûa 1)) ûa) (let ((üa 1)) üa) (let ((ýa 1)) ýa) (let ((þa 1)) þa) (let ((ÿa 1)) ÿa)) 181)

;;; there are about 50 non-printing chars, some of which would probably work as well


;; (eval-string "(eval-string ...)") is not what it appears to be -- the outer call
;;    still sees the full string when it evaluates, not the string that results from
;;    the inner call.


(let () ; from scheme bboard
  (define (maxlist list) 
    (define (maxlist' l max) 
      (if (null? l) max 
	  (if (> (car l) max) 
	      (maxlist' (cdr l) (car l)) 
	      (maxlist' (cdr l) max)))) 
    (if (null? list) 'undef 
	(maxlist' list (car list)))) 
  (test (maxlist '(1 2 3)) 3) ; quote is ok in s7 if not the initial char (sort of like a number)

  (let ((h'a 3))
    (test h'a 3))
  (let ((1'2 32))
    (test 1'2 32))
  (let ((1'`'2 32))
    (test 1'`'2 32))
  (let ((1'`,@2 32))
    (test 1'`,@2 32))

  (test (define '3 32) 'error) ;define quote: syntactic keywords tend to behave badly if redefined
  )

(let ((|,``:,*|',## 1)
      (0,,&:@'>>.<# 2)
      (@.*0`#||\<,, 3)
      (*&:`&'>#,*<` 4)
      (*0,,`&|#*:`> 5)
      (>:|<*.<@:\|` 6)
      (*',>>:.'@,** 7)
      (0|.'@<<:,##< 8)
      (<>,\',\.>>#` 9)
      (@#.>|&#&,\0* 10)
      (0'.`&<','<<. 11)
      (&@@*<*\'&|., 12)
      (|0*&,':|0\** 13)
      (<:'*@<>*,<&` 14)
      (>@<@<|>,`&'. 15)
      (@#,00:<:@*.\ 16)
      (*&.`\>#&,&., 17)
      (0|0|`,,..<@, 18)
      (0@,'>\,,&.@# 19)
      (>@@>,000`\#< 20)
      (|>*'',<:&@., 21)
      (|>,0>0|,@'|. 22)
      (0,`'|'`,:`@` 23)
      (<>#'>,,\'.'& 24)
      (*..,|,.,&&@0 25))
  (+ |,``:,*|',## 0,,&:@'>>.<# @.*0`#||\<,, *&:`&'>#,*<` *0,,`&|#*:`> >:|<*.<@:\|` *',>>:.'@,**
      0|.'@<<:,##< <>,\',\.>>#` @#.>|&#&,\0* 0'.`&<','<<.  &@@*<*\'&|., |0*&,':|0\** <:'*@<>*,<&`
      >@<@<|>,`&'. @#,00:<:@*.\ *&.`\>#&,&., 0|0|`,,..<@, 0@,'>\,,&.@# >@@>,000`\#<
      |>*'',<:&@., |>,0>0|,@'|. 0,`'|'`,:`@` <>#'>,,\'.'& *..,|,.,&&@0))

#|
(let ((first-chars (list #\. #\0 #\@ #\! #\& #\| #\* #\< #\>))
      (rest-chars (list #\. #\0 #\@ #\! #\| #\, #\# #\' #\\ #\` #\, #\: #\& #\* #\< #\>)))
  (let ((first-len (length first-chars))
	(rest-len (length rest-chars)))
    (let ((n 100)
	  (size 12))
      (let ((str (make-string size #\space)))
	(do ((i 0 (+ i 1)))
	    ((= i n))
	  (set! (str 0) (first-chars (random first-len)))
	  (do ((k 1 (+ 1 k)))
	      ((= k size))
	    (set! (str k) (rest-chars (random rest-len))))
	  (catch #t (lambda ()
		      (let ((val (eval-string (format #f "(let () (define ~A 3) ~A)" str str))))
			(format #t "~A -> ~A~%" str val)))
		 (lambda args
		   (format #t "~A error: ~A~%" str args))))))))
|#

(let ((List 1)
      (LIST 2)
      (lIsT 3)
      (-list 4)
      (_list 5)
      (+list 6))
  (test (apply + (list List LIST lIsT -list _list +list)) 21))

(let ()
  (define (\ arg) (+ arg 1))
  (test (+ 1 (\ 2)) 4)
  (define (@\ arg) (+ arg 1))
  (test (+ 1 (@\ 2)) 4)
  (define (@,\ arg) (+ arg 1))
  (test (+ 1 (@,\ 2)) 4)
  (define (\,@\ arg) (+ arg 1))
  (test (+ 1 (\,@\ 2)) 4)
  )

;;; these are from the r7rs discussions
(test (let ((a'b 3)) a'b) 3) ; allow variable names like "can't-go-on" or "don't-ask"
(test (let () (define (f x y) (+ x y)) (let ((a 3) (b 4)) (f a, b))) 'error) ; unbound variable a,
(test (let () (define (f x y) (+ x y)) (let ((a 3) (b 4)) (f a ,b))) 'error) ; unquote outside quasiquote





;;; -------- object->string
;;; object->string

(test (string=? (object->string 32) "32") #t)
(test (string=? (object->string 32.5) "32.5") #t)
(test (string=? (object->string 32/5) "32/5") #t)
(test (object->string 1+i) "1+1i")
(test (string=? (object->string "hiho") "\"hiho\"") #t)
(test (string=? (object->string 'symb) "symb") #t)
(test (string=? (object->string (list 1 2 3)) "(1 2 3)") #t)
(test (string=? (object->string (cons 1 2)) "(1 . 2)") #t)
(test (string=? (object->string '#(1 2 3)) "#(1 2 3)") #t)
(test (string=? (object->string +) "+") #t)
(test (object->string (object->string (object->string "123"))) "\"\\\"\\\\\\\"123\\\\\\\"\\\"\"")
(test (object->string #<eof>) "#<eof>")
(test (object->string (if #f #f)) "#<unspecified>")
(test (object->string #<undefined>) "#<undefined>")
(test (object->string #f) "#f")
(test (object->string #t) "#t")
(test (object->string '()) "()")
(test (object->string #()) "#()")
(test (object->string "") "\"\"")
(test (object->string abs) "abs")
(test (object->string lambda) "lambda")
(test (object->string +) "+")
(test (object->string +) "+")
(test (object->string '''2) "''2")
(test (object->string (lambda () #f)) "#<closure>")
(test (call-with-exit (lambda (return) (object->string return))) "#<goto>")
(test (call/cc (lambda (return) (object->string return))) "#<continuation>")
(test (let () (define-macro (hi a) `(+ 1 ,a)) (object->string hi)) "#<macro>")
(test (let () (define (hi a) (+ 1 a)) (object->string hi)) "hi")
(test (let () (define* (hi a) (+ 1 a)) (object->string hi)) "hi")
(test (object->string dynamic-wind) "dynamic-wind")
(test (object->string (make-procedure-with-setter (lambda () 1) (lambda (val) val))) "#<closure>")
(test (object->string object->string) "object->string")
(test (object->string 'if) "if")
(test (object->string begin) "begin")
(test (object->string let) "let")

(test (object->string #\n #f) "n")
(test (object->string #\n) "#\\n")
(test (object->string #\r) "#\\r")
(test (object->string #\r #f) "r")
(test (object->string #\t #f) "t")
(test (object->string #\t) "#\\t")

(test (object->string "a\x00b" #t) "\"a\\x00b\"")
(test (object->string "a\x00b" #f) "a")

#|
(do ((i 0 (+ i 1))) 
    ((= i 256)) 
  (let ((c (integer->char i))) 
    (let ((str (object->string c))) 
      (if (and (not (= (length str) 3))       ; "#\\a"
	       (or (not (char=? (str 2) #\x))
		   (not (= (length str) 5)))) ; "#\\xee"
	  (format #t "(#t) ~C: ~S~%" c str))
      (set! str (object->string c #f))
      (if (not (= (length str) 1))
	  (format #t "(#f) ~C: ~S~%" c str)))))
this prints:
(#t) : "#\\null"
(#f) : ""
(#t) : "#\\x1"
(#t) : "#\\x2"
(#t) : "#\\x3"
(#t) : "#\\x4"
(#t) : "#\\x5"
(#t) : "#\\x6"
(#t) : "#\\x7"
(#t): "#\\x8"
(#t) 	: "#\\tab"
(#t) 
: "#\\newline"
(#t) 
     : "#\\xb"
(#t) 
     : "#\\xc"
: "#\\return"
(#t) : "#\\xe"
(#t) : "#\\xf"
(#t)  : "#\\space"
|#

(test (object->string #\x30) "#\\0")
(test (object->string #\x91) "#\\x91")
(test (object->string #\x10) "#\\x10")
(test (object->string #\xff) "#\\xff")
(test (object->string #\x55) "#\\U")
(test (object->string #\x7e) "#\\~")
(test (object->string #\newline) "#\\newline")
(test (object->string #\return) "#\\return")
(test (object->string #\tab) "#\\tab")
(test (object->string #\null) "#\\null")
(test (object->string #\space) "#\\space")
(test (object->string (integer->char 8)) "#\\backspace")
(test (object->string ''#\a) "'#\\a")
(test (object->string (list 1 '.' 2)) "(1 .' 2)")
(test (object->string (quote (quote))) "(quote)")
(test (object->string (quote quote)) "quote")
(test (object->string (quote (quote (quote)))) "'(quote)")

(test (object->string) 'error)
(test (object->string 1 2) 'error)
(test (object->string 1 #f #t) 'error)
(test (object->string abs) "abs")
(test(let ((val 0)) (cond (else (set! val (object->string else)) 1)) val) "else")
(test (cond (else (object->string else))) "else")
(test (object->string (string->symbol (string #\; #\" #\)))) "(symbol \";\\\")\")")

(test (object->string "hi" #f) "hi")
(test (object->string "h\\i" #f) "h\\i")
(test (object->string -1.(list? -1e0)) "-1.0")

(test (object->string catch) "catch")
(test (object->string lambda) "lambda")
(test (object->string dynamic-wind) "dynamic-wind")
(test (object->string quasiquote) "quasiquote")
;(test (object->string else) "else") ; this depends on previous code
(test (object->string do) "do")

(for-each
 (lambda (arg)
   (test (object->string 1 arg) 'error)
   (test (object->string arg) (with-output-to-string (lambda () (write arg))))
   (test (object->string arg #t) (with-output-to-string (lambda () (write arg))))
   (test (object->string arg #f) (with-output-to-string (lambda () (display arg)))))
 (list "hi" -1 #\a 1 0 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i '() (list 1 2 3) '(1 . 2)))

(test (symbol? (string->symbol (object->string "" #f))) #t)
(test (string->symbol (object->string #(1 #\a (3)) #f)) (symbol "#(1 #\\a (3))"))
(test (string->list (object->string #(1 2) #f)) '(#\# #\( #\1 #\space #\2 #\)))
(test (string->list (object->string #(1 #\a (3)) #f)) '(#\# #\( #\1 #\space #\# #\\ #\a #\space #\( #\3 #\) #\)))
(test (reverse (object->string #2D((1 2) (3 4)) #f))  "))4 3( )2 1((D2#")
