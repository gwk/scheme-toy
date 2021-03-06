(test (string-ci<=? "A" "B") #t)
(test (string-ci<=? "a" "B") #t)
(test (string-ci<=? "A" "b") #t)
(test (string-ci<=? "a" "b") #t)
(test (string-ci<=? "9" "0") #f)
(test (string-ci<=? "A" "A") #t)
(test (string-ci<=? "A" "a") #t)
(test (string-ci<=? "" "") #t)
(test (string-ci<=? ":LPC`" ",O0>affA?(") #f)

(test (string-ci<=? "t" "_") #t)
(test (string-ci<=? "a" "]") #t)
(test (string-ci<=? "z" "^") #t)
(test (string-ci<=? "G888E>beF)*mwCNnagP" "`2uTd?h") #t)

(test (string-ci<=? "A" "b" "C") #t)
(test (string-ci<=? "c" "B" "A") #f)
(test (string-ci<=? "A" "B" "B") #t)
(test (string-ci<=? "a" "A" "A") #t)
(test (string-ci<=? "B" "b" "A") #f)
(test (string-ci<=? "foo" "foo" "foo") #t)
(test (string-ci<=? "foo" "foo" "") #f)
(test (string-ci<=? "FOO" "fOo" "fooo") #t)
(test (string-ci<=? "78mdL82*" "EFaCrIdm@_D+" "eMu\\@dSSY") #t)
(test (string-ci<=? "`5pNuFc3PM<rNs" "e\\Su_raVNk6HD" "vXnuN7?S0?S(w+M?p") #f)

(test (string-ci<=? "fOo" "fo" 1.0) 'error)
(test (let ((s1 "abcd") (s2 "ABCD")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci<=? s1 s2)) #t)
(test (let ((s1 "abcd") (s2 "ABCE")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci<=? s1 s2)) #t)
(test (let ((s1 "abcd") (s2 "ABC")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci<=? s1 s2)) #f)
(test (let ((s1 "abc") (s2 "ABCD")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci<=? s1 s2)) #t)

(for-each
 (lambda (arg)
   (test (string-ci<=? "hi" arg) 'error)
   (test (string-ci<=? arg "hi") 'error))
 (list #\a '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
