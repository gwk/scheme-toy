(test (char-alphabetic? #\a) #t)
(test (char-alphabetic? #\$) #f)
(test (char-alphabetic? #\A) #t)
(test (char-alphabetic? #\z) #t)
(test (char-alphabetic? #\Z) #t)
(test (char-alphabetic? #\0) #f)
(test (char-alphabetic? #\9) #f)
(test (char-alphabetic? #\space) #f)
(test (char-alphabetic? #\;) #f)
(test (char-alphabetic? #\.) #f)
(test (char-alphabetic? #\-) #f)
(test (char-alphabetic? #\_) #f)
(test (char-alphabetic? #\^) #f)
(test (char-alphabetic? #\[) #f)

;(test (char-alphabetic? (integer->char 200)) #t) ; ??
(test (char-alphabetic? (integer->char 127)) #f)  ; backspace

(for-each
 (lambda (arg)
   (if (char-alphabetic? arg)
 (format #t ";(char-alphabetic? ~A) -> #t?~%" arg)))
 digits)

(for-each
 (lambda (arg)
   (if (not (char-alphabetic? arg))
 (format #t ";(char-alphabetic? ~A) -> #f?~%" arg)))
 mixed-a-to-z)

(test (char-alphabetic?) 'error)
(test (char-alphabetic? #\a #\b) 'error)  

(for-each
 (lambda (op)
   (for-each
    (lambda (arg)
(test (op arg) 'error))
    (list "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
    3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list char-upper-case? char-lower-case? char-upcase char-downcase char-numeric? char-whitespace? char-alphabetic?))



(test 
 (let ((unhappy '()))
   (do ((i 0 (+ i 1))) 
 ((= i 256)) 
     (let* ((ch (integer->char i))
      (chu (char-upcase ch))
      (chd (char-downcase ch)))

 (if (and (not (char=? ch chu))
	  (not (char-upper-case? chu)))
     (format #t ";(char-upper-case? (char-upcase ~C)) is #f~%" ch))

 (if (and (not (char=? ch chd))
	  (not (char-lower-case? chd)))
     (format #t ";(char-lower-case? (char-downcase ~C)) is #f~%" ch))

 (if (or (and (not (char=? ch chu))
	      (not (char=? ch (char-downcase chu))))
	 (and (not (char=? ch chd))
	      (not (char=? ch (char-upcase chd))))
	 (and (not (char=? ch chd))
	      (not (char=? ch chu)))
	 (not (char-ci=? chu chd))
	 (not (char-ci=? ch chu))
	 (and (char-alphabetic? ch)
	      (or (not (char-alphabetic? chd))
		  (not (char-alphabetic? chu))))
	 (and (char-numeric? ch)
	      (or (not (char-numeric? chd))
		  (not (char-numeric? chu))))
	 (and (char-whitespace? ch)
	      (or (not (char-whitespace? chd))
		  (not (char-whitespace? chu))))
	 (and (char-alphabetic? ch)
	      (char-whitespace? ch))
	 (and (char-numeric? ch)
	      (char-whitespace? ch))
	 (and (char-alphabetic? ch)
	      (char-numeric? ch)))
     ;; there are characters that are alphabetic but the result of char-upcase is not an upper-case character
     ;; 223 for example, or 186 for lower case
     (set! unhappy (cons (format #f "~C: ~C ~C (~D)~%" ch chu chd i) unhappy)))))
   unhappy)
 '())

(for-each
 (lambda (op)
   (for-each
    (lambda (arg)
(test (op #\a arg) 'error))
    (list "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
    3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list char=? char<? char<=? char>? char>=? char-ci=? char-ci<? char-ci<=? char-ci>? char-ci>=?))

(for-each
 (lambda (op)
   (for-each
    (lambda (arg)
(test (op arg #\a) 'error))
    (list "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
    3.14 3/4 1.0+1.0i #f #t :hi (if #f #f) (lambda (a) (+ a 1)))))
 (list char=? char<? char<=? char>? char>=? char-ci=? char-ci<? char-ci<=? char-ci>? char-ci>=?))
