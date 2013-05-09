(test (eq? 'a 3) #f)
(test (eq? #t 't) #f)
(test (eq? "abs" 'abc) #f)
(test (eq? "hi" '(hi)) #f)
(test (eq? "hi" "hi") #f)
(test (eq? "()" '()) #f)
(test (eq? '(1) '(1)) #f)
(test (eq? '(#f) '(#f)) #f)
(test (eq? #\a #\b) #f)
(test (eq? #t #t) #t)
(test (eq? #f #f) #t)
(test (eq? #f #t) #f)
(test (eq? (null? '()) #t) #t)
(test (eq? (null? '(a)) #f) #t)
(test (eq? (cdr '(a)) '()) #t)
(test (eq? 'a 'a) #t)
(test (eq? 'a 'b) #f)
(test (eq? 'a (string->symbol "a")) #t)
(test (eq? (symbol "a") (string->symbol "a")) #t)
(test (eq? :a :a) #t)
(test (eq? ':a 'a) #f)
(test (eq? ':a ':a) #t)
(test (eq? :a a:) #f)
(test (eq? ':a 'a:) #f)
(test (eq? 'a: 'a:) #t)
(test (eq? ':a: 'a:) #f)
(test (eq? 'a (symbol "a")) #t)
(test (eq? :: '::) #t)
;(test (eq? ': (symbol->keyword (symbol ""))) #t)
(test (eq? ':a (symbol->keyword (symbol "a"))) #t) ; but not a:
(test (eq? '(a) '(b)) #f)
(test (let ((x '(a . b))) (eq? x x)) #t)
(test (let ((x (cons 'a 'b))) (eq? x x)) #t)
(test (eq? (cons 'a 'b) (cons 'a 'b)) #f)
(test (eq? "abc" "cba") #f)
(test (let ((x "hi")) (eq? x x)) #t)
(test (eq? (string #\h #\i) (string #\h #\i)) #f)
(test (eq? '#(a) '#(b)) #f)
(test (let ((x (vector 'a))) (eq? x x)) #t)
(test (eq? (vector 'a) (vector 'a)) #f)
(test (eq? car car) #t)
(test (eq? car cdr) #f)
(test (let ((x (lambda () 1))) (eq? x x)) #t)
(test (let ((x (lambda () 1))) (let ((y x)) (eq? x y))) #t)
(test (let ((x (lambda () 1))) (let ((y (lambda () 1))) (eq? x y))) #f)
(test (eq? 'abc 'abc) #t)
(test (eq? eq? eq?) #t)
(test (eq? (if #f 1) 1) #f)
(test (eq? '() '(#||#)) #t)
(test (eq? '() '(#|@%$&|#)) #t)
(test (eq? '#||#hi 'hi) #t) ; ??
(test (eq? '; a comment
         hi 'hi) #t) ; similar:
    (test (cadr '#| a comment |#(+ 1 2)) 1)
    (test `(+ 1 ,@#||#(list 2 3)) '(+ 1 2 3))
    (test `(+ 1 ,#||#(+ 3 4)) '(+ 1 7))
    ;; but not splitting the ",@" or splitting a number:
    (test (+ 1 2.0+#||#3i) 'error)
    (test `(+ 1 ,#||#@(list 2 3)) 'error)
(test (eq? #||# (#|%%|# append #|^|#) #|?|# (#|+|# list #|<>|#) #||#) #t)
(test (eq? '() ;a comment
	   '()) #t)
(test (eq? 3/4 3) #f)
(test (eq? '() '()) #t)
(test (eq? '() '(  )) #t)
(test (eq? '()'()) #t)
(test (eq? '()(list)) #t)
(test (eq? '() (list)) #t)
(test (eq? (begin) (append)) #t)
(test (let ((lst (list 1 2 3))) (eq? lst (apply list lst))) #f) ; changed 26-Sep-11

;(test (eq? 1/0 1/0) #f)
;(test (let ((+nan.0 1/0)) (eq? +nan.0 +nan.0)) #f)
;; these are "unspecified" so any boolean value is ok

(test (eq? ''2 '2) #f)
(test (eq? '2 '2) #t) ; unspecified??
(test (eq? '2 2) #t)
(test (eq? ''2 ''2) #f)
(test (eq? ''#\a '#\a) #f)
(test (eq? '#\a #\a) #t) ; was #f 
(test (eq? 'car car) #f)
(test (eq? '() ()) #t)
(test (eq? ''() '()) #f)
(test (eq? '#f #f) #t)
(test (eq? '#f '#f) #t)
(test (eq? #f '  #f) #t)
(test (eq? '()'()) #t) ; no space
(test (#||# eq? #||# #f #||# #f #||#) #t)
(test (eq? (current-input-port) (current-input-port)) #t)
(test (let ((f (lambda () (quote (1 . "H"))))) (eq? (f) (f))) #t)
(test (let ((f (lambda () (cons 1 (string #\H))))) (eq? (f) (f))) #f)
(test (eq? *stdin* *stdin*) #t)
(test (eq? *stdout* *stderr*) #f)
(test (eq? *stdin* *stderr*) #f)
(test (eq? else else) #t)
(test (eq? :else else) #f)
(test (eq? :else 'else) #f)
(test (eq? :if if) #f)
(test (eq? 'if 'if) #t)
(test (eq? :if :if) #t)

(test (eq? (string) (string)) #f)
(test (eq? (string) "") #f)
(test (eq? (vector) (vector)) #f)
(test (eq? (vector) #()) #f)
(test (eq? (list) (list)) #t)
(test (eq? (list) ()) #t)
(test (eq? (hash-table) (hash-table)) #f)
(test (eq? (current-environment) (current-environment)) #t)
(test (eq? (global-environment) (global-environment)) #t)
(test (eq? (procedure-environment abs) (procedure-environment abs)) #t) ; or any other built-in...
(test (eq? letrec* letrec*) #t)

(test (eq? (current-input-port) (current-input-port)) #t)
(test (eq? (current-error-port) (current-error-port)) #t)
(test (eq? (current-output-port) (current-output-port)) #t)
(test (eq? (current-input-port) (current-output-port)) #f)

(test (eq? (string #\a) (string #\a)) #f)
(test (eq? "a" "a") #f)
(test (eq? #(1) #(1)) #f)
(test (let ((a "hello") (b "hello")) (eq? a b)) #f)
(test (let ((a "foo")) (eq? a (copy a))) #f)

(display ";this should display #t: ")
(begin #| ; |# (display #t))
(newline)

(test (;
       eq? ';!
       (;)()#
	);((")";
       ;"#|)#""
       '#|";"|#(#|;|#); ;#
	 ;\;"#"#f 
	       )#t)

(test (+ #| this is a comment |# 2 #| and this is another |# 3) 5)
(test (eq? #| a comment |# #f #f) #t)
(test (eq? #| a comment |##f #f) #t)  ; ??
(test (eq? #| a comment | ##f|##f #f) #t) ; ??
(test (eq? #||##||##|a comment| ##f|##f #f) #t)

(test (+ ;#|
            3 ;|#
            4)
      7)
(test (+ #| ; |# 3
		 4)
      7)

(test (eq? (if #f #t) (if #f 3)) #t)

(test (eq?) 'error)           ; "this comment is missing a double-quote
(test (eq? #t) 'error)        #| "this comment is missing a double-quote |#
(test (eq? #t #t #t) 'error)  #| and this has redundant starts #| #| |#
(test (eq? #f . 1) 'error)
(test (eq #f #f) 'error)

(let ((things (vector #t #f #\space '() "" 0 1 3/4 1+i 1.5 '(1 .2) '#() (vector) (vector 1) (list 1) 'f 't #\t)))
  (do ((i 0 (+ i 1)))
      ((= i (- (vector-length things) 1)))
    (do ((j (+ i 1) (+ j 1)))
	((= j (vector-length things)))
      (if (eq? (vector-ref things i) (vector-ref things j))
	  (format #t ";(eq? ~A ~A) -> #t?~%" (vector-ref things i) (vector-ref things j))))))

;;; these are defined at user-level in s7 -- why are other schemes so coy about them?
(test (eq? (if #f #f) #<unspecified>) #t)
(test (eq? (symbol->value '_?__undefined__?_) #<undefined>) #t)
(test (eq? #<eof> #<eof>) #t)
(test (eq? #<undefined> #<undefined>) #t)
(test (eq? #<unspecified> #<unspecified>) #t)
(test (eq? #<eof> #<undefined>) #f)
(test (eq? #<eof> '()) #f)

(test (let () (define-macro (hi a) `(+ 1 ,a)) (eq? hi hi)) #t)
(test (let () (define (hi a) (+ 1 a)) (eq? hi hi)) #t)
(test (let ((x (lambda* (hi (a 1)) (+ 1 a)))) (eq? x x)) #t)

(test (eq? quasiquote quasiquote) #t)
(test (eq? `quasiquote 'quasiquote) #t)
(test (eq? 'if (keyword->symbol :if)) #t)
(test (eq? 'if (string->symbol "if")) #t)
(test (eq? (copy lambda) (copy 'lambda)) #f)
(test (eq? if 'if) #f)
(test (eq? if `if) #f)
(test (eq? if (keyword->symbol :if)) #f)
(test (eq? if (string->symbol "if")) #f)
(test (eq? lambda and) #f)
(test (eq? let let*) #f)
(test (eq? quote quote) #t)
(test (eq? '"hi" '"hi") #f) ; guile also
(test (eq? '"" "") #f)
(test (eq? '"" '"") #f)
(test (eq? "" "") #f)
(test (eq? #() '#()) #f)
(test (eq? #() #()) #f)
(test (eq? '#() '#()) #f)
(test (let ((v #())) (eq? v #())) #f)
(test (let ((v '#())) (eq? v '#())) #f)
(test (let ((v #())) (eq? v v)) #t)

;;; a ridiculous optimizer typo...
(test (let ((sym 'a)) (define (hi a) (eq? (cdr a) sym)) (hi '(a a))) #f)
(test (let ((sym 'a)) (define (hi a) (eq? (cdr a) sym)) (hi '(a . a))) #t)
(test (let ((sym 'a)) (define (hi a) (eq? (cdr a) sym)) (hi '(a . b))) #f)

(for-each
 (lambda (arg)
   (let ((x arg)
	 (y arg))
     (if (not (eq? x x))
	 (format #t ";(eq? x x) of ~A -> #f?~%" x))
     (if (not (eq? x arg))
	 (format #t ";(eq? x arg) of ~A ~A -> #f?~%" x arg))
     (if (not (eq? x y))
	 (format #t ";(eq? x y) of ~A ~A -> #f?~%" x y))))
 ;; actually I hear that #f is ok here for numbers
 (list "hi" '(1 2) (integer->char 65) 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3/4 #\f (lambda (a) (+ a 1)) :hi (if #f #f) #<eof> #<undefined>))
;; this used to include 3.14 and 1+i but that means the (eq? x x) case differs from the (eq? 3.14 3.14) case

(define comment-start (port-line-number))
#|
:'(1(1))
(1 (1))
:'(1#(1))
(1# (1))
|#
(if (not (= (- (port-line-number) comment-start) 7)) (format *stderr* ";block comment newline counter: ~D ~D~%" comment-start (port-line-number)))

;;; this comes from G Sussman
(let ()
  (define (counter count)
    (lambda ()
      (set! count (+ 1 count))
      count))

  (define c1 (counter 0))
  (define c2 (counter 0))

  (test (eq? c1 c2) #f)
  (test (eq? c1 c1) #t)
  (test (eq? c2 c2) #t)

  (test (let ((p (lambda (x) x))) (eqv? p p)) #t))
