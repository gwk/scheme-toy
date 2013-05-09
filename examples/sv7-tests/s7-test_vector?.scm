(test (vector? (make-vector 6)) #t)
(test (vector? (make-vector 6 #\a)) #t)
(test (vector? (make-vector 0)) #t)
;; (test (vector? #*1011) #f)
(test (vector? '#(0 (2 2 2 2) "Anna")) #t)
(test (vector? '#()) #t)
(test (vector? '#("hi")) #t)
(test (vector? (vector 1)) #t)
(test (let ((v (vector 1 2 3))) (vector? v)) #t)

(for-each
 (lambda (arg)
   (test (vector? arg) #f))
 (list #\a 1 () (list 1) '(1 . 2) #f "hi" 'a-symbol abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 1.0+1.0i #t :hi (if #f #f) (lambda (a) (+ a 1))))

(test (vector?) 'error)
(test (vector? #() #(1)) 'error)
(test (vector? begin) #f)
(test (vector? vector?) #f)

;;; make a shared ref -- we'll check it later after enough has happened that an intervening GC is likely

(define check-shared-vector-after-gc #f)
(let ((avect (make-vector '(6 6) 32)))
  (do ((i 0 (+ i 1)))
      ((= i 6))
    (do ((j 0 (+ j 1)))
	((= j 6))
      (set! (avect i j) (cons i j))))
  (set! check-shared-vector-after-gc (avect 3)))
