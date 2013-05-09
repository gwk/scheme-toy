(test (string=? "foo" "foo") #t)
(test (string=? "foo" "FOO") #f)
(test (string=? "foo" "bar") #f)
(test (string=? "FOO" "FOO") #t)
(test (string=? "A" "B") #f)
(test (string=? "a" "b") #f)
(test (string=? "9" "0") #f)
(test (string=? "A" "A") #t)
(test (string=? "" "") #t)
(test (string=? (string #\newline) (string #\newline)) #t)

(test (string=? "A" "B" "a") #f)
(test (string=? "A" "A" "a") #f)
(test (string=? "A" "A" "A") #t)
(test (string=? "foo" "foo" "foo") #t)
(test (string=? "foo" "foo" "") #f)
(test (string=? "foo" "foo" "fOo") #f)

(test (string=? "foo" "FOO" 1.0) 'error)

(test (let ((str (string #\" #\1 #\\ #\2 #\")))	(string=? str "\"1\\2\"")) #t)
(test (let ((str (string #\\ #\\ #\\)))	(string=? str "\\\\\\")) #t)
(test (let ((str (string #\")))	(string=? str "\"")) #t)
(test (let ((str (string #\\ #\"))) (string=? str "\\\"")) #t)
(test (let ((str (string #\space #\? #\)))) (string=? str " ?)")) #t)
(test (let ((str (string #\# #\\ #\t))) (string=? str "#\\t")) #t)
(test (string=? (string #\x (integer->char #xf0) #\x) (string #\x (integer->char #x70) #\x)) #f)
(test (string=? (string #\x (integer->char #xf0) #\x) (string #\x (integer->char #xf0) #\x)) #t)

(test (string=? (string) "") #t)
(test (string=? (string) (make-string 0)) #t)
(test (string=? (string-copy (string)) (make-string 0)) #t)
(test (string=? "" (make-string 0)) #t)
(test (string=? "" (string-append)) #t)
(test (string=? (string #\space #\newline) " \n") #t)

(test (string=? "......" "...\
...") #t)
(test (string=? "\n" (string #\newline)) #t)
(test (string=? "\
\
\
\
" "") #t)
(test (string=? "" (string #\null)) #f)
(test (string=? (string #\null #\null) (string #\null)) #f)
(test (string=? "" "asd") #f)
(test (string=? "asd" "") #f)
(test (string=? "xx" (make-string 2 #\x) (string #\x #\x) (list->string (list #\x #\x)) (substring "axxb" 1 3) (string-append "x" "x")) #t)
(test (let ((s1 "1234") (s2 "1245")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string=? s1 s2)) #f)
(test (let ((s1 "1234") (s2 "1234")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string=? s1 s2)) #t)
(test (let ((s1 "1234") (s2 "124")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string=? s1 s2)) #f)
(test "\x3012" "012")

(for-each
 (lambda (arg)
   (test (string=? "hi" arg) 'error)
   (test (string=? arg "hi") 'error))
 (list #\a '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))


;; this strikes me as highly dubious
(test (call-with-input-string "1\n2" (lambda (p) (read p))) 1)
(test (call-with-input-string "1\\ \n2" (lambda (p) (read p))) (symbol "1\\"))

(test (call-with-input-string "1\
2" (lambda (p) (read p))) 12)

(test (let ((xyzzy 32)) (call-with-input-string "xy\
zzy" (lambda (p) (read p)))) 'xyzzy)

(test (let ((xyzzy 32)) (call-with-input-string "xy\
zzy" (lambda (p) (eval (read p))))) 32)

(test (let ((xyzzy 32)) (call-with-input-string "(set! xyzzy;\
 this is presumably a comment
 321)" (lambda (p) (eval (read p)))) xyzzy) 321)

(test (let ((xyzzy 32)) (call-with-input-string "(set! xyzzy;\
 this is presumably a comment;\
 and more commentary
 321)" (lambda (p) (eval (read p)))) xyzzy) 321)
