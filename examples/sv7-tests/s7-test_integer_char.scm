(test (integer->char (char->integer #\.)) #\.)
(test (integer->char (char->integer #\A)) #\A)
(test (integer->char (char->integer #\a)) #\a)
(test (integer->char (char->integer #\space)) #\space)
(test (char->integer (integer->char #xf0)) #xf0)

(do ((i 0 (+ i 1)))
    ((= i 256)) 
  (if (not (= (char->integer (integer->char i)) i)) 
      (format #t ";char->integer ~D ~A != ~A~%" i (integer->char i) (char->integer (integer->char i)))))

(test (reinvert 12 integer->char char->integer 60) 60)

(test (char->integer 33) 'error)
(test (char->integer) 'error)
(test (integer->char) 'error)
(test (integer->char (expt 2 31)) 'error)
(test (integer->char (expt 2 32)) 'error)
(test (integer->char 12 14) 'error)
(test (char->integer #\a #\b) 'error)
;(test (char->integer #\ÿ) 255) ; emacs confusion?
(test (eval-string (string-append "(char->integer " (format #f "#\\~C" (integer->char 255)) ")")) 255)

(for-each
 (lambda (arg)
   (test (char->integer arg) 'error))
 (list -1 1 0 123456789 "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(for-each
 (lambda (arg)
   (test (integer->char arg) 'error))
 (list -1 257 123456789 -123456789 #\a "hi" '() (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi most-positive-fixnum 1/0 (if #f #f) (lambda (a) (+ a 1))))

(test (#\a) 'error)
(test (#\newline 1) 'error)
