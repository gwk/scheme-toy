(define control-ops (list lambda define quote if begin set! let let* letrec cond case and or do
			  call/cc eval apply for-each map values call-with-values dynamic-wind))
(for-each
 (lambda (op)
   (if (not (eq? op op))
       (format #t "~A not eq? to itself?~%" op)))
 control-ops)

(for-each
 (lambda (op)
   (if (not (eqv? op op))
       (format #t "~A not eqv? to itself?~%" op)))
 control-ops)

(for-each
 (lambda (op)
   (if (not (equal? op op))
       (format #t "~A not equal? to itself?~%" op)))
 control-ops)

(define question-ops (list boolean? eof-object? string?
		           number? integer? real? rational? complex? char?
			   list? vector? pair? null?))

(for-each
 (lambda (ques)
   (for-each
    (lambda (op)
      (if (ques op)
	  (format #t ";(~A ~A) returned #t?~%" ques op)))
    control-ops))
 question-ops)

(let ((unspecified (if #f #f)))
  (for-each
   (lambda (op)
     (if (op unspecified)
	 (format #t ";(~A #<unspecified>) returned #t?~%" op)))
   question-ops))

(for-each 
 (lambda (s)
   (if (not (symbol? s))
       (format #t ";(symbol? ~A returned #f?~%" s)))
 '(+ - ... !.. $.+ %.- &.! *.: /:. <-. =. >. ?. ~. _. ^.))
