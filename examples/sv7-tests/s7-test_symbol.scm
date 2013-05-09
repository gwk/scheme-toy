(test (symbol->string 'hi) "hi")
(test (string->symbol (symbol->string 'hi)) 'hi)
(test (eq? (string->symbol "hi") 'hi) #t)
(test (eq? (string->symbol "hi") (string->symbol "hi")) #t)

(test (string->symbol "hi") 'hi)

(test (let ((str (symbol->string 'hi)))
	(catch #t (lambda () (string-set! str 1 #\x)) (lambda args 'error)) ; can be disallowed
	(symbol->string 'hi))
      "hi")

(test (symbol->string 'sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789)
      "sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789")
(test (string->symbol "sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789")
      'sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789)
(test (let ((sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 32))
	(+ sym0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 1))
      33)

(test (symbol->string (string->symbol "hi there")) "hi there")
(test (symbol->string (string->symbol "Hi There")) "Hi There")
(test (symbol->string (string->symbol "HI THERE")) "HI THERE")
(test (symbol->string (string->symbol "")) "")
(test (symbol? (string->symbol "(weird name for a symbol!)")) #t)
(test (symbol->string (string->symbol "()")) "()")
(test (symbol->string (string->symbol (string #\"))) "\"")
(test (symbol->string 'quote) "quote")
(test (symbol->string if) 'error)
(test (symbol->string quote) 'error)

(test (symbol? (string->symbol "0")) #t)
(test (symbol? (symbol "0")) #t)
(test (symbol? (symbol ".")) #t) ; hmmm
(test (let () (define |.| 1) (+ |.| 2)) 3)
(test (string->symbol "0e") '0e)
(test (string->symbol "1+") '1+)
(test (symbol? (string->symbol "1+i")) #t)
(test (string->symbol ":0") ':0)
(test (symbol? (string->symbol " hi") ) #t)
(test (symbol? (string->symbol "hi ")) #t)
(test (symbol? (string->symbol "")) #t)

(test (reinvert 12 string->symbol symbol->string "hiho") "hiho")

(test (symbol->string) 'error)
(test (string->symbol) 'error)
(test (symbol->string 'hi 'ho) 'error)
(test (string->symbol "hi" "ho") 'error)

(test (symbol? (string->symbol (string #\x (integer->char 255) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 8) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 128) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 200) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 255) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 20) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 2) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 7) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 17) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 170) #\x))) #t)
(test (symbol? (string->symbol (string #\x (integer->char 0) #\x))) #t)       ; but the symbol's name here is "x"
(test (eq? (string->symbol (string #\x (integer->char 0) #\x)) 'x) #t)        ;   hmmm...
(test (symbol? (string->symbol (string #\x #\y (integer->char 127) #\z))) #t) ; xy(backspace)z

(test (symbol? (string->symbol (string #\; #\" #\)))) #t)
(test (let (((symbol ";")) 3) (symbol ";")) 'error)
(test (symbol? (symbol "")) #t)
(test (symbol? (symbol (string))) #t)
(test (symbol? (symbol (make-string 0))) #t)
(test (symbol? (symbol (string-append))) #t)

(for-each
 (lambda (arg)
   (test (symbol->string arg) 'error))
 (list #\a 1 "hi" '() (list 1) '(1 . 2) #f (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (string->symbol arg) 'error)
   (test (symbol arg) 'error))
 (list #\a 1 () (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (symbol? (string->symbol (string arg))) #t)
   (test (symbol? (symbol (string arg))) #t))
 (list #\; #\, #\. #\) #\( #\" #\' #\` #\x33 #\xff #\x7f #\# #\]))

(test (symbol) 'error)
(test (symbol "hi" "ho") 'error)

(let ()
  (define-macro (string-case selector . clauses)
    `(case (symbol ,selector)
       ,@(map (lambda (clause)
		(if (pair? (car clause))
		    `(,(map symbol (car clause)) ,@(cdr clause))
		    clause))
	      clauses)))

  (test (let ((str "hi"))
	  (string-case str
            (("hi" "ho") 1 2 3)
	    (("hiho") 2)
	    (else 4)))
	3))

(let ()
  (apply define (list (symbol "(#)") 3))
  (test (eval (symbol "(#)")) 3))


#|
(let ((str "(let ((X 3)) X)"))
  (do ((i 0 (+ i 1)))
      ((= i 256))
    (catch #t
	   (lambda ()
	     (if (symbol? (string->symbol (string (integer->char i))))
		 (catch #t
			(lambda ()
			  (set! (str 7) (integer->char i))
			  (set! (str 13) (integer->char i))
			  (let ((val (eval-string str)))
			    (format #t "ok: ~S -> ~S~%" str val)))
			(lambda args
			  (format #t "bad but symbol: ~S~%" str))))) ; 11 12 # ' , . 
	   (lambda args
	     (format #t "bad: ~C~%" (integer->char i))))))  ; # ( ) ' " . ` nul 9 10 13 space 0..9 ;

(let ((str "(let ((XY 3)) XY)"))
  (do ((i 0 (+ i 1)))
      ((= i 256))
    (do ((k 0 (+ k 1)))
	((= k 256))
      (catch #t
	     (lambda ()
	       (if (symbol? (string->symbol (string (integer->char i))))
		   (catch #t
			  (lambda ()
			    (set! (str 7) (integer->char i))
			    (set! (str 8) (integer->char k))
			    (set! (str 14) (integer->char i))
			    (set! (str 15) (integer->char k))
			    (let ((val (eval-string str)))
			      (format #t "ok: ~S -> ~S~%" str val)))
			  (lambda args
			    (format #t "bad but symbol: ~S~%" str))))) ; 11 12 # ' , . 
	     (lambda args
	       (format #t "bad: ~C~%" (integer->char i)))))))  ; # ( ) ' " . ` nul 9 10 13 space 0..9 ;
|#
