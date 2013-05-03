
(define message
  (lambda (cont msg)
    (call/cc 
      (lambda (newCont) 
        (cont (cons newCont msg))))))

(define f
  (lambda (cont name index)
    (if (<= index 9)
      (begin
        (display name index)
        (define msg-list (message cont (+ 1 index)))
        (f (car msg-list) name (cdr msg-list)))
      (display name "done"))))

(define msg
  (call/cc
    (lambda (cont) (f cont "f1:" 1))))

(f (car msg) "f2:" (cdr msg))
