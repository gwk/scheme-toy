;;; trying to avoid top-level definitions here

(let ()
  (define x 2)
  (test (+ x 1) 3)
  (set! x 4)
  (test (+ x 1) 5)
  (let ()
    (define (tprint x) #t)
    (test (tprint 56) #t)
    (let ()
      (define first car)
      (test (first '(1 2)) 1)
      (let ()
	(define foo (lambda () (define x 5) x))
	(test (foo) 5)
	(let ()
	  (define (foo x) ((lambda () (define x 5) x)) x)
	  (test (foo 88) 88))))))


(test (letrec ((foo (lambda (arg) (or arg (and (procedure? foo) (foo 99)))))) (define bar (foo #f)) (foo #f)) 99)
(test (letrec ((foo 77) (bar #f) (retfoo (lambda () foo))) (define baz (retfoo)) (retfoo)) 77)

(test (let () (define .. 1) ..) 1)

(test (let () (define (hi a) (+ a 1)) (hi 2)) 3)
(test (let () (define (hi a . b) (+ a (cadr b) 1)) (hi 2 3 4)) 7)
(test (let () (define (hi) 1) (hi)) 1)
(test (let () (define (hi . a) (apply + a)) (hi 1 2 3)) 6)

(for-each
 (lambda (arg)
   (test (let () (define x arg) x) arg))
 (list "hi" -1 #\a 1 'a-symbol '#(1 2 3) 3.14 3/4 1.0+1.0i #t (list 1 2 3) '(1 . 2)))

(test ((lambda (x) (define (hi a) (+ a 1)) (hi x)) 1) 2)
(test (let ((x 2)) (define f (lambda (y) (+ y x))) (f 3)) 5)
(begin (define r5rstest-plus (lambda (x y) (+ x y))) (define r5rstest-x 32))
(test (r5rstest-plus r5rstest-x 3) 35)
(test (let ((x 2.0)) (define (hi a) (set! a 3.0)) (hi x) x) 2.0)

(test (let () (define (asdf a) (define (asdf a) (+ a 1)) (+ a (asdf a))) (asdf 4)) 9)
(test (let ((asdf 1)) (define (asdf a) (define (asdf a) (+ a 1)) (+ a (asdf a))) (asdf 4)) 9)
(test (let () (define (a1 a) (define (a2 a) (define (a3 a) (define (a4 a) (+ a 1)) (+ (a4 a) 1)) (+ (a3 a) 1)) (+ (a2 a) 1)) (a1 0)) 4)

(test (let () (define (hi1 a) (define (hi1 b) (+ b 1)) (hi1 a)) (hi1 1)) 2)
(test (let () (define (hi1 a) (begin (define (hi1 b) (+ b 1))) (hi1 a)) (hi1 1)) 2)
(test (let ((j 0) (k 0))
	(define (hi1 a)
	  (let ((hi1 (lambda (b) 
		       (set! k (+ k 1)) 
		       (hi1 (- b 1)))))
	    (if (<= a 0)
		(list j k)
		(begin
		  (set! j (+ j 1))
		  (hi1 (- a 1))))))
	(hi1 3))
      '(2 2))

(test (procedure? (let () (define (a) a) (a))) #t)
(let ((oddp (lambda (a) (not (even? a)))))
   (define (hi a) (and (a 123) (a 321))) 
   (test (hi oddp) #t))

(test (define) 'error)
(test (define*) 'error)
(test (define x) 'error)
(test (define . x) 'error)
(test (define x 1 2) 'error)
(test (define x x) 'error)
(test (define x x x) 'error)
(test (define x x . x) 'error)
(test (let ((x 0)) (define x (x . x))) 'error)
(test (define (x x) . x) 'error)
(test (eval-string "(define (x .) 1)") 'error) ; need eval-string else a read error that halts our tests
(test (eval-string "(define (x) (+ 1 .))") 'error)
(test (define (x x) x . x) 'error)
(test (let () (define (x x) x) (x 0)) 0)
(test (define (x 1)) 'error)
(test (define (x)) 'error)
(test (define 1 2) 'error)
(test (define "hi" 2) 'error)
(test (define :hi 2) 'error)
(test (define x 1 2) 'error)
(test (define x 1 . 2) 'error)
(test (define x . 1) 'error)
(test (define x (lambda ())) 'error)
(test (define #<eof> 3) 'error)
(test (define (#<undefined>) 4) 'error)
(test (define (:hi a) a) 'error)
(test (define (hi: a) a) 'error)
(test (define (#b1 a) a) 'error)
(test (define (hi #b1) #b1) 'error)
(test (define () 1) 'error)
(test (let() (define #(hi a) a)) 'error)
(test (let () (define hi (lambda args args)) (hi 1 . 2)) 'error)
(test (let () (define . 1) 1) 'error)
(test (let () (define func (do () (#t (lambda (y) 2)))) (func 1)) 2)
(test (let () (define* x 3)) 'error)
(test (let () (define (hi) 1 . 2)) 'error)
(test (let () (define (hi) (1) . "hi")) 'error)

(let ()
  (define (make-func) (define (a-func a) (+ a 1)))
  (test (symbol? (make-func)) #t)
  (test (symbol->value (make-func)) #<undefined>))

(let () (test (if (and (define x 3) (define y 4)) (+ x y)) 7))
(let () (test (if (not (and (define x 2) (define y 4))) (+ x y) (if (define x 3) x)) 3))
(let () (test (if (and (define x 2) (not (define y 4))) (+ x y) (- x y)) -2))
(test (let () (define (f a) (lambda () a)) (+ ((f 1)) ((f 2)))) 3)
(test (let () (define (hi) (let ((a 1)) (set! a 2) (define (ho) a) (set! a 3) (ho))) (hi)) 3)
;;; (define-macro (make-lambda args . body) `(apply lambda* ',args '(,@body))): (make-lambda (a b) (+ a b))

;; y combinator example from some CS website
(let ()
  (define Y
    (lambda (X)
      ((lambda (procedure)
         (X (lambda (arg) ((procedure procedure) arg))))
       (lambda (procedure)
         (X (lambda (arg) ((procedure procedure) arg)))))))

  (define M
    (lambda (func-arg)
      (lambda (l)
        (if (null? l)
            'no-list
            (if (null? (cdr l))
                (car l)
                (max (car l) (func-arg (cdr l))))))))

  (test ((Y M) '(4 5 6 3 4 8 6 2)) 8))

(test (((lambda (X)
	  ((lambda (procedure)
	     (X (lambda (arg) ((procedure procedure) arg))))
	   (lambda (procedure)
	     (X (lambda (arg) ((procedure procedure) arg))))))
	(lambda (func-arg)
	  (lambda (n)
	    (if (zero? n)
		1
		(* n (func-arg (- n 1)))))))
       5)
      120)

;;; from a paper by Mayer Goldberg
(let ()
  (define curry-fps
    (lambda fs
      (let ((xs
	     (map
	      (lambda (fi)
		(lambda xs
		  (apply fi
			 (map
			  (lambda (xi)
			    (lambda args
			      (apply (apply xi xs) args)))
			  xs))))
	      fs)))
	(map (lambda (xi)
	       (apply xi xs)) xs))))
  
  (define E
    (lambda (even? odd?)
      (lambda (n)
        (if (zero? n) #t ; return Boolean True
            (odd? (- n 1))))))
  
  (define O
    (lambda (even? odd?)
      (lambda (n)
        (if (zero? n) #f ; return Boolean False
            (even? (- n 1))))))
  
  (define list-even?-odd? (curry-fps E O))
  (define new-even? (car list-even?-odd?))
  (define new-odd? (cadr list-even?-odd?))
  
  (test (new-even? 6) #t)
  (test (new-odd? 6) #f))

(let ()
  (define (Cholesky:decomp P)
    ;; from Marco Maggi based on a Scheme bboard post
    ;; (Cholesky:decomp '((2 -2) (-2 5))) -> ((1.4142135623731 0) (-1.4142135623731 1.7320508075689))
    (define (Cholesky:make-square L)
      (define (zero-vector n)
	(if (zero? n)
	    '()
	    (cons 0 (zero-vector (- n 1)))))
      (map (lambda (v)
	     (append v (zero-vector (- (length L) (length v)))))
	   L))
    (define (Cholesky:add-element P L i j)
      (define (Cholesky:smaller P)
	(if (null? (cdr P))
	    '()
	    (reverse (cdr (reverse P)))))
      (define (Cholesky:last-row L)
	(car (reverse L)))
      (define (matrix:element A i j)
	(list-ref (list-ref A i) j))
      (define (Cholesky:make-element P L i j)
	(define (Cholesky:partial-sum L i j)
	  (let loop ((k j))
	    (case k
	      ((0) 0)
	      ((1) (* (matrix:element L i 0)
		      (matrix:element L j 0)))
	      (else
	       (+ (* (matrix:element L i k)
		     (matrix:element L j k))
		  (loop (- k 1)))))))
	(let ((x (- (matrix:element P i j)
		    (Cholesky:partial-sum L i j))))
	  (if (= i j)
	      (sqrt x)
	      (/ x (matrix:element L j j)))))
      (if (zero? j)
	  (append L `((,(Cholesky:make-element P L i j))))
	  (append (Cholesky:smaller L)
		  (list (append
			 (Cholesky:last-row L)
			 (list (Cholesky:make-element P L i j)))))))
    (Cholesky:make-square
     (let iter ((i 0) (j 0) (L '()))
       (if (>= i (length P))
	   L
	   (iter (if (= i j) (+ 1 i) i)
		 (if (= i j) 0 (+ 1 j))
		 (Cholesky:add-element P L i j))))))
  (let* ((lst (Cholesky:decomp '((2 -2) (-2 5))))
	 (lst0 (car lst))
	 (lst1 (cadr lst)))
    (if (or (> (abs (- (car lst0) (sqrt 2))) .0001)
	    (not (= (cadr lst0) 0))
	    (> (abs (+ (car lst1) (sqrt 2))) .0001)
	    (> (abs (- (cadr lst1) (sqrt 3))) .0001))
	(format #t ";cholesky decomp: ~A~%" lst))))

(let ()
  (define* (a1 (b (let ()
		    (define* (a1 (b 32)) b)
		    (a1))))
    b)
  (test (a1) 32)
  (test (a1 1) 1))

(test (let ((x 1)) (cond (else (define x 2))) x) 2)
(test (let ((x 1)) (and (define x 2)) x) 2)
(test (let () (begin 1)) 1)
(test (let () (begin (define x 1) x)) 1)

(let ()
  (define (f64 arg0 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 arg10 arg11 arg12 arg13 arg14 arg15 arg16 arg17 arg18 arg19 arg20 arg21 arg22 arg23 arg24 arg25 arg26 arg27 arg28 arg29 arg30 arg31 arg32 arg33 arg34 arg35 arg36 arg37 arg38 arg39 arg40 arg41 arg42 arg43 arg44 arg45 arg46 arg47 arg48 arg49 arg50 arg51 arg52 arg53 arg54 arg55 arg56 arg57 arg58 arg59 arg60 arg61 arg62 arg63 arg64) 
    (+ arg0 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 arg10 arg11 arg12 arg13 arg14 arg15 arg16 arg17 arg18 arg19 arg20 arg21 arg22 arg23 arg24 arg25 arg26 arg27 arg28 arg29 arg30 arg31 arg32 arg33 arg34 arg35 arg36 arg37 arg38 arg39 arg40 arg41 arg42 arg43 arg44 arg45 arg46 arg47 arg48 arg49 arg50 arg51 arg52 arg53 arg54 arg55 arg56 arg57 arg58 arg59 arg60 arg61 arg62 arg63 arg64))
  (test (f64 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64) 
	2080))

#|
(let ((n 12))
  (let ((nums (do ((lst '() (cons i lst))
		   (i 0 (+ i 1)))
		  ((> i n) (reverse lst)))))
    (format #t "(let ((f~D (lambda (~{arg~D~^ ~})~%    (+ ~{arg~D~^ ~}))))~%  (f~D ~{~D~^ ~}))~%" n nums nums n nums)))
|#

(test (let ((f128 (lambda (arg128 arg127 arg126 arg125 arg124 arg123 arg122 arg121 arg120 arg119 arg118 arg117 arg116 arg115 arg114 arg113 arg112 arg111 arg110 arg109 arg108 arg107 arg106 arg105 arg104 arg103 arg102 arg101 arg100 arg99 arg98 arg97 arg96 arg95 arg94 arg93 arg92 arg91 arg90 arg89 arg88 arg87 arg86 arg85 arg84 arg83 arg82 arg81 arg80 arg79 arg78 arg77 arg76 arg75 arg74 arg73 arg72 arg71 arg70 arg69 arg68 arg67 arg66 arg65 arg64 arg63 arg62 arg61 arg60 arg59 arg58 arg57 arg56 arg55 arg54 arg53 arg52 arg51 arg50 arg49 arg48 arg47 arg46 arg45 arg44 arg43 arg42 arg41 arg40 arg39 arg38 arg37 arg36 arg35 arg34 arg33 arg32 arg31 arg30 arg29 arg28 arg27 arg26 arg25 arg24 arg23 arg22 arg21 arg20 arg19 arg18 arg17 arg16 arg15 arg14 arg13 arg12 arg11 arg10 arg9 arg8 arg7 arg6 arg5 arg4 arg3 arg2 arg1 arg0)
		    (+ arg128 arg127 arg126 arg125 arg124 arg123 arg122 arg121 arg120 arg119 arg118 arg117 arg116 arg115 arg114 arg113 arg112 arg111 arg110 arg109 arg108 arg107 arg106 arg105 arg104 arg103 arg102 arg101 arg100 arg99 arg98 arg97 arg96 arg95 arg94 arg93 arg92 arg91 arg90 arg89 arg88 arg87 arg86 arg85 arg84 arg83 arg82 arg81 arg80 arg79 arg78 arg77 arg76 arg75 arg74 arg73 arg72 arg71 arg70 arg69 arg68 arg67 arg66 arg65 arg64 arg63 arg62 arg61 arg60 arg59 arg58 arg57 arg56 arg55 arg54 arg53 arg52 arg51 arg50 arg49 arg48 arg47 arg46 arg45 arg44 arg43 arg42 arg41 arg40 arg39 arg38 arg37 arg36 arg35 arg34 arg33 arg32 arg31 arg30 arg29 arg28 arg27 arg26 arg25 arg24 arg23 arg22 arg21 arg20 arg19 arg18 arg17 arg16 arg15 arg14 arg13 arg12 arg11 arg10 arg9 arg8 arg7 arg6 arg5 arg4 arg3 arg2 arg1 arg0))))
	(f128 128 127 126 125 124 123 122 121 120 119 118 117 116 115 114 113 112 111 110 109 108 107 106 105 104 103 102 101 100 99 98 97 96 95 94 93 92 91 90 89 88 87 86 85 84 83 82 81 80 79 78 77 76 75 74 73 72 71 70 69 68 67 66 65 64 63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0))
      8256)

(test (let ((f512 (lambda (arg0 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 arg10 arg11 arg12 arg13 arg14 arg15 arg16 arg17 arg18 arg19 arg20 arg21 arg22 arg23 arg24 arg25 arg26 arg27 arg28 arg29 arg30 arg31 arg32 arg33 arg34 arg35 arg36 arg37 arg38 arg39 arg40 arg41 arg42 arg43 arg44 arg45 arg46 arg47 arg48 arg49 arg50 arg51 arg52 arg53 arg54 arg55 arg56 arg57 arg58 arg59 arg60 arg61 arg62 arg63 arg64 arg65 arg66 arg67 arg68 arg69 arg70 arg71 arg72 arg73 arg74 arg75 arg76 arg77 arg78 arg79 arg80 arg81 arg82 arg83 arg84 arg85 arg86 arg87 arg88 arg89 arg90 arg91 arg92 arg93 arg94 arg95 arg96 arg97 arg98 arg99 arg100 arg101 arg102 arg103 arg104 arg105 arg106 arg107 arg108 arg109 arg110 arg111 arg112 arg113 arg114 arg115 arg116 arg117 arg118 arg119 arg120 arg121 arg122 arg123 arg124 arg125 arg126 arg127 arg128 arg129 arg130 arg131 arg132 arg133 arg134 arg135 arg136 arg137 arg138 arg139 arg140 arg141 arg142 arg143 arg144 arg145 arg146 arg147 arg148 arg149 arg150 arg151 arg152 arg153 arg154 arg155 arg156 arg157 arg158 arg159 arg160 arg161 arg162 arg163 arg164 arg165 arg166 arg167 arg168 arg169 arg170 arg171 arg172 arg173 arg174 arg175 arg176 arg177 arg178 arg179 arg180 arg181 arg182 arg183 arg184 arg185 arg186 arg187 arg188 arg189 arg190 arg191 arg192 arg193 arg194 arg195 arg196 arg197 arg198 arg199 arg200 arg201 arg202 arg203 arg204 arg205 arg206 arg207 arg208 arg209 arg210 arg211 arg212 arg213 arg214 arg215 arg216 arg217 arg218 arg219 arg220 arg221 arg222 arg223 arg224 arg225 arg226 arg227 arg228 arg229 arg230 arg231 arg232 arg233 arg234 arg235 arg236 arg237 arg238 arg239 arg240 arg241 arg242 arg243 arg244 arg245 arg246 arg247 arg248 arg249 arg250 arg251 arg252 arg253 arg254 arg255 arg256 arg257 arg258 arg259 arg260 arg261 arg262 arg263 arg264 arg265 arg266 arg267 arg268 arg269 arg270 arg271 arg272 arg273 arg274 arg275 arg276 arg277 arg278 arg279 arg280 arg281 arg282 arg283 arg284 arg285 arg286 arg287 arg288 arg289 arg290 arg291 arg292 arg293 arg294 arg295 arg296 arg297 arg298 arg299 arg300 arg301 arg302 arg303 arg304 arg305 arg306 arg307 arg308 arg309 arg310 arg311 arg312 arg313 arg314 arg315 arg316 arg317 arg318 arg319 arg320 arg321 arg322 arg323 arg324 arg325 arg326 arg327 arg328 arg329 arg330 arg331 arg332 arg333 arg334 arg335 arg336 arg337 arg338 arg339 arg340 arg341 arg342 arg343 arg344 arg345 arg346 arg347 arg348 arg349 arg350 arg351 arg352 arg353 arg354 arg355 arg356 arg357 arg358 arg359 arg360 arg361 arg362 arg363 arg364 arg365 arg366 arg367 arg368 arg369 arg370 arg371 arg372 arg373 arg374 arg375 arg376 arg377 arg378 arg379 arg380 arg381 arg382 arg383 arg384 arg385 arg386 arg387 arg388 arg389 arg390 arg391 arg392 arg393 arg394 arg395 arg396 arg397 arg398 arg399 arg400 arg401 arg402 arg403 arg404 arg405 arg406 arg407 arg408 arg409 arg410 arg411 arg412 arg413 arg414 arg415 arg416 arg417 arg418 arg419 arg420 arg421 arg422 arg423 arg424 arg425 arg426 arg427 arg428 arg429 arg430 arg431 arg432 arg433 arg434 arg435 arg436 arg437 arg438 arg439 arg440 arg441 arg442 arg443 arg444 arg445 arg446 arg447 arg448 arg449 arg450 arg451 arg452 arg453 arg454 arg455 arg456 arg457 arg458 arg459 arg460 arg461 arg462 arg463 arg464 arg465 arg466 arg467 arg468 arg469 arg470 arg471 arg472 arg473 arg474 arg475 arg476 arg477 arg478 arg479 arg480 arg481 arg482 arg483 arg484 arg485 arg486 arg487 arg488 arg489 arg490 arg491 arg492 arg493 arg494 arg495 arg496 arg497 arg498 arg499 arg500 arg501 arg502 arg503 arg504 arg505 arg506 arg507 arg508 arg509 arg510 arg511 arg512)
    (+ arg0 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 arg10 arg11 arg12 arg13 arg14 arg15 arg16 arg17 arg18 arg19 arg20 arg21 arg22 arg23 arg24 arg25 arg26 arg27 arg28 arg29 arg30 arg31 arg32 arg33 arg34 arg35 arg36 arg37 arg38 arg39 arg40 arg41 arg42 arg43 arg44 arg45 arg46 arg47 arg48 arg49 arg50 arg51 arg52 arg53 arg54 arg55 arg56 arg57 arg58 arg59 arg60 arg61 arg62 arg63 arg64 arg65 arg66 arg67 arg68 arg69 arg70 arg71 arg72 arg73 arg74 arg75 arg76 arg77 arg78 arg79 arg80 arg81 arg82 arg83 arg84 arg85 arg86 arg87 arg88 arg89 arg90 arg91 arg92 arg93 arg94 arg95 arg96 arg97 arg98 arg99 arg100 arg101 arg102 arg103 arg104 arg105 arg106 arg107 arg108 arg109 arg110 arg111 arg112 arg113 arg114 arg115 arg116 arg117 arg118 arg119 arg120 arg121 arg122 arg123 arg124 arg125 arg126 arg127 arg128 arg129 arg130 arg131 arg132 arg133 arg134 arg135 arg136 arg137 arg138 arg139 arg140 arg141 arg142 arg143 arg144 arg145 arg146 arg147 arg148 arg149 arg150 arg151 arg152 arg153 arg154 arg155 arg156 arg157 arg158 arg159 arg160 arg161 arg162 arg163 arg164 arg165 arg166 arg167 arg168 arg169 arg170 arg171 arg172 arg173 arg174 arg175 arg176 arg177 arg178 arg179 arg180 arg181 arg182 arg183 arg184 arg185 arg186 arg187 arg188 arg189 arg190 arg191 arg192 arg193 arg194 arg195 arg196 arg197 arg198 arg199 arg200 arg201 arg202 arg203 arg204 arg205 arg206 arg207 arg208 arg209 arg210 arg211 arg212 arg213 arg214 arg215 arg216 arg217 arg218 arg219 arg220 arg221 arg222 arg223 arg224 arg225 arg226 arg227 arg228 arg229 arg230 arg231 arg232 arg233 arg234 arg235 arg236 arg237 arg238 arg239 arg240 arg241 arg242 arg243 arg244 arg245 arg246 arg247 arg248 arg249 arg250 arg251 arg252 arg253 arg254 arg255 arg256 arg257 arg258 arg259 arg260 arg261 arg262 arg263 arg264 arg265 arg266 arg267 arg268 arg269 arg270 arg271 arg272 arg273 arg274 arg275 arg276 arg277 arg278 arg279 arg280 arg281 arg282 arg283 arg284 arg285 arg286 arg287 arg288 arg289 arg290 arg291 arg292 arg293 arg294 arg295 arg296 arg297 arg298 arg299 arg300 arg301 arg302 arg303 arg304 arg305 arg306 arg307 arg308 arg309 arg310 arg311 arg312 arg313 arg314 arg315 arg316 arg317 arg318 arg319 arg320 arg321 arg322 arg323 arg324 arg325 arg326 arg327 arg328 arg329 arg330 arg331 arg332 arg333 arg334 arg335 arg336 arg337 arg338 arg339 arg340 arg341 arg342 arg343 arg344 arg345 arg346 arg347 arg348 arg349 arg350 arg351 arg352 arg353 arg354 arg355 arg356 arg357 arg358 arg359 arg360 arg361 arg362 arg363 arg364 arg365 arg366 arg367 arg368 arg369 arg370 arg371 arg372 arg373 arg374 arg375 arg376 arg377 arg378 arg379 arg380 arg381 arg382 arg383 arg384 arg385 arg386 arg387 arg388 arg389 arg390 arg391 arg392 arg393 arg394 arg395 arg396 arg397 arg398 arg399 arg400 arg401 arg402 arg403 arg404 arg405 arg406 arg407 arg408 arg409 arg410 arg411 arg412 arg413 arg414 arg415 arg416 arg417 arg418 arg419 arg420 arg421 arg422 arg423 arg424 arg425 arg426 arg427 arg428 arg429 arg430 arg431 arg432 arg433 arg434 arg435 arg436 arg437 arg438 arg439 arg440 arg441 arg442 arg443 arg444 arg445 arg446 arg447 arg448 arg449 arg450 arg451 arg452 arg453 arg454 arg455 arg456 arg457 arg458 arg459 arg460 arg461 arg462 arg463 arg464 arg465 arg466 arg467 arg468 arg469 arg470 arg471 arg472 arg473 arg474 arg475 arg476 arg477 arg478 arg479 arg480 arg481 arg482 arg483 arg484 arg485 arg486 arg487 arg488 arg489 arg490 arg491 arg492 arg493 arg494 arg495 arg496 arg497 arg498 arg499 arg500 arg501 arg502 arg503 arg504 arg505 arg506 arg507 arg508 arg509 arg510 arg511 arg512))))
  (f512 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 479 480 481 482 483 484 485 486 487 488 489 490 491 492 493 494 495 496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512))
      131328)


(let ((x 32))
  (define (f1) x)
  (define x 33)
  (test (f1) 33))

#|
(let ()
  (define (f2 a) (+ a 1))
  (define (f1 a) (f2 a))
  (define (f2 a) (- a))
  (test (f1 12) -12)) ; hmmm
;; I can't decide about this -- shouldn't it be consistent with the global case?
(let ()
  (define (f2 a) (+ a 2))
  (define (f1 a) (f2 a))
  (define (f2 a) (- a 2))
  (format #t "f1: ~A~%" (f1 12)))

(let ()
  (define (f1 a) (+ a 2))
  (define + *)
  (format #t "f1: ~A~%" (f1 12)))
|#

(let ()
  (define (c-2)
    (let ((v (vector 1 2 3)))
      (define (c-1 a b) (+ (vector-ref a 0) (* b 32)))
      (let ((c (c-1 v 1)))
	(test c 33)
	(set! c-1 vector-ref))
      (let ((d (c-1 v 1)))
	(test d 2))))
  (c-2))

(let ()
  (define (c-2)
    (let ((v (vector 1 2 3)))
      (let ()
	(define (c-1 a b) (+ (vector-ref a 0) (* b 32)))
	(let ((c (c-1 v 1)))
	  (set! c-1 vector-ref)))
      (test (c-1 v 1) 'error)))
  (c-2))
(let ()
  (define (f4 a b c d e) (list a b c d e))
  (test (f4 1 2 3 4 5) '(1 2 3 4 5)))
