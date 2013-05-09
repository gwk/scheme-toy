(if with-bignums
    (begin
      (test (bignum? (bignum "2")) #t)
      (test (bignum? (bignum "#e1.5")) #t)

      (num-test (bignum "6/3") 2)
      (num-test (bignum "+3/6") 1/2)
      (num-test (bignum "7447415382/3") 2482471794)

      (for-each
       (lambda (n)
	 (test (bignum? n) #f))
       (list 0 1 -1 1/3 1.0 1+i 1073741824 1.0e8 1+1.0e8i "hi" '() (integer->char 65) #f #t '(1 2) 'a-symbol _ht_ (cons 1 2) (make-vector 3) abs))

      (for-each 
       (lambda (n)
	 (test (bignum? n) #t))
       (list 1.0e30 -1.0e20+i 1.0+1.0e80i 1e100 1267650600228229401496703205376 -1267650600228229401496703205376
	     1180591620717411303424/3 3/1180591620717411303424 1180591620717411303424/1180591620717411303423
	     1267650600228229401496703205376.99 -1267650600228229401496703205376.88 0.1231231231231231231231231231))
      (for-each
       (lambda (n)
	 (test (bignum n) 'error)
	 (test (bignum "1.0" n) 'error))
       (list "hi" (integer->char 65) #f #t '(1 2) 'a-symbol (cons 1 2) '() _ht_ (make-vector 3) 1 3/4 1.5 1+i abs))

      (test (bignum?) 'error)
      (test (bignum? 1 2) 'error)

      (test (bignum) 'error)
      (test (bignum "hi" "ho") 'error)
      (test (bignum "") 'error)
      (test (bignum " ") 'error)
      (test (bignum " 1 ") 'error)
      (test (bignum "abc") 'error)
      (test (bignum "1/2/3") 'error)
      ))
