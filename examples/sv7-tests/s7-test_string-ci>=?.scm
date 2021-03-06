(test (string-ci>=? "A" "B") #f)
(test (string-ci>=? "a" "B") #f)
(test (string-ci>=? "A" "b") #f)
(test (string-ci>=? "a" "b") #f)
(test (string-ci>=? "9" "0") #t)
(test (string-ci>=? "A" "A") #t)
(test (string-ci>=? "A" "a") #t)
(test (string-ci>=? "" "") #t)
(test (string-ci>=? "5d7?[o[:hop=ktv;9)" "p^r9;TAXO=^") #f)

(test (string-ci>=? "t" "_") #f)
(test (string-ci>=? "a" "]") #f)
(test (string-ci>=? "z" "^") #f)
(test (string-ci>=? "jBS" "`<+s[[:`l") #f)

(test (string-ci>=? "A" "b" "C") #f)
(test (string-ci>=? "C" "B" "A") #t)
(test (string-ci>=? "C" "B" "b") #t)
(test (string-ci>=? "a" "B" "B") #f)
(test (string-ci>=? "A" "A" "A") #t)
(test (string-ci>=? "B" "B" "A") #t)
(test (string-ci>=? "B" "b" "C") #f)
(test (string-ci>=? "foo" "foo" "foo") #t)
(test (string-ci>=? "foo" "foo" "") #t)
(test (string-ci>=? "foo" "foo" "fo") #t)
(test (string-ci>=? "tF?8`Sa" "NIkMd7" "f`" "1td-Z?teE" "-ik1SK)hh)Nq].>") #t)
(test (string-ci>=? "Z6a8P" "^/VpmWwt):?o[a9\\_N" "8[^h)<KX?[utsc") #f)

(test (string-ci>=? "fo" "foo" 1.0) 'error)
(test (let ((s1 "abcd") (s2 "ABCD")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci>=? s1 s2)) #t)
(test (let ((s1 "abcd") (s2 "ABCE")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci>=? s1 s2)) #f)
(test (let ((s1 "abcd") (s2 "ABC")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci>=? s1 s2)) #t)
(test (let ((s1 "abc") (s2 "ABCD")) (string-set! s1 1 #\null) (string-set! s2 1 #\null) (string-ci>=? s1 s2)) #f)

(for-each
 (lambda (arg)
   (test (string-ci>=? "hi" arg) 'error)
   (test (string-ci>=? arg "hi") 'error))
 (list #\a '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))
