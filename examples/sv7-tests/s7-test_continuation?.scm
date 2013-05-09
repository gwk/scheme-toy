(for-each
 (lambda (arg)
   (test (continuation? arg) #f))
 (list -1 #\a 1 #f _ht_ '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi abs '#(()) (list 1 2 3) '(1 . 2) "hi" (lambda () 1)))
  
(test (let ((cont #f)) 
	(and (call/cc (lambda (x) (set! cont x) (continuation? x)))
	     (continuation? cont)))
      #t)
(test (let ((cont #f)) 
	(or (call-with-exit (lambda (x) (set! cont x) (continuation? x)))
	    (continuation? cont)))
      #f) ; x is not a continuation
	
(test (continuation?) 'error)
(test (continuation? 1 2) 'error)
