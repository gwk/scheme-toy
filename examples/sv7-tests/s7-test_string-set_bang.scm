(let ((str (make-string 10 #\x)))
  (string-set! str 3 (integer->char 0))
  (test (string=? str "xxx") #f)
  (test (char=? (string-ref str 4) #\x) #t)
  (string-set! str 4 #\a)
  (test (string=? str "xxx") #f)
  (test (char=? (string-ref str 4) #\a) #t)
  (string-set! str 3 #\x)
  (test (string=? str "xxxxaxxxxx") #t))

(test (string-set! "hiho" 1 #\c) #\c)
(test (set! ("hi" 1 2) #\i) 'error)
(test (set! ("hi" 1) "ho") 'error)
(test (set! ("hi") #\i) 'error)
(test (let ((x "hi") (y 'x)) (string-set! y 0 #\x) x) 'error)
(test (let ((str "ABS")) (set! (str 0) #\a)) #\a)
(test (let ((str "ABS")) (string-set! str 0 #\a)) #\a)
(test (let ((str "ABS")) (set! (string-ref str 0) #\a)) #\a)

(test (let ((hi (make-string 3 #\a)))
	(string-set! hi 1 (let ((ho (make-string 4 #\x)))
			    (string-set! ho 1 #\b)
			    (string-ref ho 0)))
	hi)
      "axa")

(test (string-set! "hiho" (expt 2 32) #\a) 'error)

(test (let ((hi (string-copy "hi"))) (string-set! hi 2 #\H) hi) 'error)
(test (let ((hi (string-copy "hi"))) (string-set! hi -1 #\H) hi) 'error)
(test (let ((g (lambda () "***"))) (string-set! (g) 0 #\?)) #\?)
(test (string-set! "" 0 #\a) 'error)
(test (string-set! "" 1 #\a) 'error)
(test (string-set! (string) 0 #\a) 'error)
(test (string-set! (symbol->string 'lambda) 0 #\a) #\a)
(test (let ((ho (make-string 0 #\x))) (string-set! ho 0 #\a) ho) 'error)
(test (let ((str "hi")) (string-set! (let () str) 1 #\a) str) "ha") ; (also in Guile)
(test (let ((x 2) (str "hi")) (string-set! (let () (set! x 3) str) 1 #\a) (list x str)) '(3 "ha"))
(test (let ((str "hi")) (set! ((let () str) 1) #\b) str) "hb")
(test (let ((str "hi")) (string-set! (let () (string-set! (let () str) 0 #\x) str) 1 #\x) str) "xx")
(test (let ((str "hi")) (string-set! (let () (set! str "hiho") str) 3 #\x) str) "hihx") ; ! (this works in Guile also)

(for-each
 (lambda (arg)
   (test (string-set! arg 0 #\a) 'error))
 (list #\a 1 () (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (string-set! "hiho" arg #\a) 'error))
 (list #\a -1 123 4 "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (string-set! "hiho" 0 arg) 'error))
 (list 1 "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (equal? (let ((str "hiho")) (string-set! str 2 #\null) str) "hi") #f)
(test (string=? (let ((str "hiho")) (string-set! str 2 #\null) str) "hi") #f)
(test (let* ((s1 "hi") (s2 s1)) (string-set! s2 1 #\x) s1) "hx")
(test (let* ((s1 "hi") (s2 (copy s1))) (string-set! s2 1 #\x) s1) "hi")

(test (eq? (car (catch #t (lambda () (set! ("hi") #\a)) (lambda args args))) 'wrong-number-of-args) #t)
(test (eq? (car (catch #t (lambda () (set! ("hi" 0 0) #\a)) (lambda args args))) 'wrong-number-of-args) #t) ; (vector-set! 1 ...)
(test (eq? (car (catch #t (lambda () (set! (("hi" 0) 0) #\a)) (lambda args args))) 'syntax-error) #t) ; (set! (1 ...))