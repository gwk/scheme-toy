(define cont #f)
 
(define (test)
 (let ((i 0))
   ; call/cc calls its first function argument, passing
   ; a continuation variable representing this point in
   ; the program as the argument to that function.
   ;
   ; In this case, the function argument assigns that
   ; continuation to the variable cont.
   ;
   (call/cc (lambda (k) (set! cont k)))
   ;
   ; The next time cont is called, we start here.
   (set! i (+ i 1))
   i))

