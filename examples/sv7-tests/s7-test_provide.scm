(test (provided?) 'error)
(test (or (null? *features*) (pair? *features*)) #t)
(test (provided? 1 2 3) 'error)
(provide 's7test)
(test (provided? 's7test) #t)
(test (provided? 'not-provided!) #f)
(test (provided? 'begin) #f)
(test (provided? if) 'error)
(test (provided? quote) 'error)

(test (provide quote) 'error)
(test (provide 1 2 3) 'error)
(test (provide) 'error)
(test (provide lambda) 'error)

(provide 's7test) ; should be a no-op
(let ((count 0))
  (for-each
   (lambda (p)
     (if (eq? p 's7test)
	 (set! count (+ count 1)))
     (if (not (provided? p))
	 (format #t ";~A is in *features* but not provided? ~A~%" p *features*)))
   *features*)
  (if (not (= count 1))
      (format #t ";*features* has ~D 's7test entries? ~A~%" count *features*)))

(for-each
 (lambda (arg)
   (test (provide arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (provided? arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i #t #f '() '#(()) (list 1 2 3) '(1 . 2)))

(for-each
 (lambda (arg)
   (test (set! *gc-stats* arg) 'error))
 (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() '#(()) (list 1 2 3) '(1 . 2)))
(test *gc-stats* #f)

(let ((f (sort! *features* (lambda (a b) (string<? (object->string a #f) (object->string b #f))))))
  (let ((last 'not-in-*features*))
    (for-each
     (lambda (p)
       (if (eq? p last)
	   (format #t ";*features has multiple ~A? ~A~%" p *features*))
       (set! last p))
     f)))

(for-each
 (lambda (arg)
   (test (set! *safety* arg) 'error)
   (test (set! *features* arg) 'error)
   (test (set! *load-path* arg) 'error)
   (test (set! *#readers* arg) 'error)
   )
 (list #\a '#(1 2 3) 3.14 3/4 1.0+1.0i abs 'hi #t #f '#(())))
(test (let ((*features* 123)) *features*) 'error)
(test (let ((*safety* '(1 2 3))) *safety*) 'error)
(test (set! *load-path* (list 1 2 3)) 'error)

(test (integer? *vector-print-length*) #t)
(test (or (null? *#readers*) (pair? *#readers*)) #t)
(test (or (null? *load-path*) (pair? *load-path*)) #t)

(let ((old-len *vector-print-length*))
  (for-each
   (lambda (arg)
     (test (set! *vector-print-length* arg) 'error))
   (list -1 #\a '#(1 2 3) 3.14 3/4 1.0+1.0i abs 'hi '() #t #f '#(()) (list 1 2 3) '(1 . 2)))
  (set! *vector-print-length* old-len))


(let ((old-vlen *vector-print-length*))
  (set! *vector-print-length* 0)
  (test (format #f "~A" #()) "#()")
  (test (format #f "~A" #(1 2 3 4)) "#(...)")
  (set! *vector-print-length* 1)
  (test (format #f "~A" #()) "#()")
  (test (format #f "~A" #(1)) "#(1)")
  (test (format #f "~A" #(1 2 3 4)) "#(1 ...)")
  (set! *vector-print-length* 2)
  (test (format #f "~A" #(1 2 3 4)) "#(1 2 ...)")
  (set! *vector-print-length* old-vlen))

(if with-bignums
    (let ((old-vlen *vector-print-length*))
      (set! *vector-print-length* (bignum "0"))
      (test (format #f "~A" #()) "#()")
      (test (format #f "~A" #(1 2 3 4)) "#(...)")
      (set! *vector-print-length* (bignum "1"))
      (test (format #f "~A" #()) "#()")
      (test (format #f "~A" #(1)) "#(1)")
      (test (format #f "~A" #(1 2 3 4)) "#(1 ...)")
      (set! *vector-print-length* (bignum "2"))
      (test (format #f "~A" #(1 2 3 4)) "#(1 2 ...)")
      (set! *vector-print-length* old-vlen)))
