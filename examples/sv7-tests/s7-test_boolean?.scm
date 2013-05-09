(test (boolean? #f) #t)
(test (boolean? #t) #t)
(test (boolean? 0) #f)
(test (boolean? 1) #f)
(test (boolean? "") #f)
(test (boolean? #\0) #f)
(test (boolean? '()) #f)
(test (boolean? '#()) #f)
(test (boolean? 't) #f)
(test (boolean? (list)) #f)
(test ( boolean? #t) #t)
(test (boolean? boolean?) #f)
(test (boolean? or) #f)
(test (   ; a comment 
       boolean?  ;;; and another
       #t
       )
      #t)

(for-each
 (lambda (arg)
   (if (boolean? arg)
       (format #t ";(boolean? ~A) -> #t?~%" arg)))
 (list "hi" '(1 2) (integer->char 65) 1 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #\f (lambda (a) (+ a 1)) :hi (if #f #f) #<eof> #<undefined>))

(test (recompose 12 boolean? #f) #t)

(test (boolean?) 'error)
(test (boolean? #f #t) 'error)
(test (boolean #f) 'error)
(test (boolean? (lambda (x) #f)) #f)
(test (boolean? and) #f)
(test (boolean? if) #f)
(test (boolean? (values)) #f)
;(test (boolean? else) #f) ; this could also be an error -> unbound variable, like (symbol? else)
