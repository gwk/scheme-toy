(let ((hi (lambda* (a) a)))
  (test (hi 1) 1)
  (test (hi) #f)          ; all args are optional
  (test (hi :a 32) 32)    ; all args are keywords
  (test (hi 1 2) 'error)  ; extra args
  
  (for-each
   (lambda (arg)
     (test (hi arg) arg)
     (test (hi :a arg) arg))
   (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi abs '#(()) (list 1 2 3) '(1 . 2)))
  
  (test (hi :b 1) 'error))

(let ((hi (lambda* ((a 1)) a)))
  (test (hi 2) 2)
  (test (hi) 1)
  (test (hi :a 2) 2)
  
  (for-each
   (lambda (arg)
     (test (hi arg) arg)
     (test (hi :a arg) arg))
   (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi abs '#(()) (list 1 2 3) '(1 . 2))))

(let ((hi (lambda* (a (b "hi")) (list a b))))
  (test (hi) (list #f "hi"))
  (test (hi 1) (list 1 "hi"))
  (test (hi 1 2) (list 1 2))
  (test (hi :b 1) (list #f 1))
  (test (hi :a 1) (list 1 "hi"))
  (test (hi 1 :b 2) (list 1 2))
  (test (hi :b 3 :a 1) (list 1 3))
  (test (hi :a 3 :b 1) (list 3 1))
  (test (hi 1 :a 3) 'error)
  (test (hi 1 2 :a 3) 'error) ; trailing (extra) args
  (test (hi :a 2 :c 1) 'error)
  (test (hi 1 :c 2) 'error)
  
  (for-each
   (lambda (arg)
     (test (hi :a 1 :b arg) (list 1 arg))
     (test (hi :a arg) (list arg "hi"))
     (test (hi :b arg) (list #f arg))
     (test (hi arg arg) (list arg arg)))
   (list -1 #\a 1 '#(1 2 3) 3.14 3/4 1.0+1.0i '() 'hi abs '#(()) (list 1 2 3) '(1 . 2))))

(let ((hi (lambda* (a :key (b 3) :optional c) (list a b c))))
  (test (hi) (list #f 3 #f))
  (test (hi 1) (list 1 3 #f))
  (test (hi :c 32) (list #f 3 32))
  (test (hi :c 32 :b 43 :a 54) (list 54 43 32))
  (test (hi 1 2 3) (list 1 2 3))
  (test (hi :b 32) (list #f 32 #f))
  (test (hi 1 2 :c 32) (list 1 2 32)))

(let ((hi (lambda* (a :rest b) (list a b))))
  (test (hi 1 2 3) (list 1 (list 2 3)))
  (test (hi) (list #f ()))
  (test (hi :a 2) (list 2 '()))
  (test (hi :b 3) (list #f 3)))

(let ((hi (lambda* (a :rest b :rest c) (list a b c))))
  (test (hi 1 2 3 4 5) (list 1 (list 2 3 4 5) (list 3 4 5))))

(let ((hi (lambda* ((a 3) :key (b #t) :optional (c pi) :rest d) (list a b c d))))
  (test (hi) (list 3 #t pi ()))
  (test (hi 1 2 3 4) (list 1 2 3 (list 4))))

(let ((hi (lambda* ((a 'hi)) (equal? a 'hi))))
  (test (hi) #t)
  (test (hi 1) #f)
  (test (hi 'hi) #t)
  (test (hi :a 1) #f))

(let* ((x 32)
       (hi (lambda* (a (b x)) (list a b))))
  (test (hi) (list #f 32))
  (test (hi :a 1) (list 1 32)))

(let ((hi (lambda* (a . b) (list a b))))
  (test (hi 1 2 3) (list 1 (list 2 3)))
  (test (hi) (list #f ()))
  (test (hi :a 2) (list 2 '()))
  (test (hi :b 3) (list #f 3)))

(let ((hi (lambda* ((a 0.0) :optional (b 0.0)) (+ a b))))
  (num-test (hi 1.0) 1.0)
  (num-test (hi 1.0 2.0) 3.0)
  (num-test (hi) 0.0)
  (num-test (+ (hi) (hi 1.0) (hi 1.0 2.0)) 4.0)
  (num-test (+ (hi 1.0) (hi) (hi 1.0 2.0)) 4.0)
  (num-test (+ (hi 1.0) (hi 1.0 2.0) (hi)) 4.0)
  (num-test (+ (hi 1.0 2.0) (hi) (hi 1.0)) 4.0))

(test (let ((hi (lambda*))) (hi)) 'error)
(test (let ((hi (lambda* #f))) (hi)) 'error)
(test (let ((hi (lambda* "hi" #f))) (hi)) 'error)
(test (let ((hi (lambda* ("hi") #f))) (hi)) 'error)
(test (let ((hi (lambda* (a 0.0) a))) (hi)) 'error)
(test (let ((hi (lambda* (a . 0.0) a))) (hi)) 'error)
(test (let ((hi (lambda* ((a . 0.0)) a))) (hi)) 'error)
(test (let ((hi (lambda* ((a 0.0 "hi")) a))) (hi)) 'error)
(test (let ((hi (lambda* ((a 0.0 . "hi")) a))) (hi)) 'error)
(test (let ((hi (lambda* ((a)) a))) (hi)) 'error)
(test (let ((hi (lambda* (a 0.0) (b 0.0) (+ a b)))) (hi)) 'error)
(test (lambda (:key) 1) 'error)
(test (lambda (:key a) 1) 'error)

(test ((lambda* (:key) 1)) 'error) 
(test (let () (define* (hi :key) 1) (hi)) 'error)
(test  (let () (define* (hi :key :optional) 1) (hi)) 'error)

(test (lambda* (:key :optional :rest) 1) 'error)

(test (let ((akey :a) (bkey :b)) ((lambda* (a b) (list a b)) akey 32)) '(32 #f))
(test (let ((akey :a) (bkey :b)) ((lambda* (a b) (list a b)) bkey 12 akey 43)) '(43 12))
(test (let ((x 0)) (for-each (lambda* (a) (set! x (+ x a))) (list :a :a :a) (list 1 2 3)) x) 6) ; how can this work?

(test (let () (define* (hi) 0) (hi)) 0)
(test (let () (define* (hi) 0) (hi 1)) 'error)
(test (let () (define* (hi a . b) b) (hi 1 2 3)) '(2 3))
(test (let () (define* (hi a . b) b) (hi :a 1 2 3)) '(2 3))
(test (let () (define* (hi a . b) b) (hi 1)) '())
(test (let () (define* (hi a . b) b) (hi :a 1)) '())
(test (let () (define* (hi a . b) b) (hi)) '())
(test (let () (define* (hi a . a) a) (hi)) 'error)
(test (let () (define* (hi (a 1) . a) a) (hi)) 'error)
(test (let () (define* (hi (a 1) . b) b) (hi 2 3 4)) '(3 4))

(test (let () (define* (hi a :rest b) b) (hi 1 2 3)) '(2 3))
(test (let () (define* (hi a :rest b) b) (hi :a 1 2 3)) '(2 3))
(test (let () (define* (hi a :rest b) b) (hi 1)) '())
(test (let () (define* (hi a :rest b) b) (hi :a 1)) '())
(test (let () (define* (hi a :rest b) b) (hi)) '())

(test (let () (define* (hi :key a :rest b) b) (hi 1 2 3)) '(2 3))
(test (let () (define* (hi :key a :rest b) b) (hi :a 1 2 3)) '(2 3))
(test (let () (define* (hi :key a :rest b) b) (hi 1)) '())
(test (let () (define* (hi :key a :rest b) b) (hi :a 1)) '())
(test (let () (define* (hi :key a :rest b) b) (hi)) '())

(test (let () (define* (hi :optional a :rest b) b) (hi 1 2 3)) '(2 3))
(test (let () (define* (hi :optional a :rest b) b) (hi :a 1 2 3)) '(2 3))
(test (let () (define* (hi :optional a :rest b) b) (hi 1)) '())
(test (let () (define* (hi :optional a :rest b) b) (hi :a 1)) '())
(test (let () (define* (hi :optional a :rest b) b) (hi)) '())

(test (let () (define* (hi (a 1) . b) b) (hi 1 2 3)) '(2 3))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi)) '(#f 22 ()))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :a 1)) '(1 22 ()))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :b 1)) '(#f 1 ()))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :c 1)) '(#f 22 1))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :a 1 2)) '(1 2 ()))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :b 1 2 3)) 'error) ; b set twice
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :c 1 2 3)) '(#f 2 (3)))
(test (let () (define* (hi a (b 22) . c) (list a b c)) (hi :b 1 :a 2 3)) '(2 1 (3)))

(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi)) 1)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi :b :a :a 3)) 3)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi :b 3)) 1)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi :a 3)) 3)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi a: 3)) 3)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi 3)) 3)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi 3 :b 2)) 3)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi :c 1 :a 3 :b 2)) 3)
(test (let () (define* (hi (a 1) :optional :key :allow-other-keys) a) (hi :c 1 :a 3 :b 2)) 'error)
(test (let () (define* (hi :optional :key :rest a :allow-other-keys) a) (hi :c 1 :a 3 :b 2)) 'error)

(test (let () (define* (hi :optional (a 1) :optional (b 2)) a)) 'error)
(test (let () (define* (hi :optional :optional (a 2)) a) (hi 21)) 'error)
(test (let () (define* (hi optional: (a 1)) a) (hi 1)) 'error)
(test (let () (define* (hi :optional: (a 1)) a) (hi 1)) 'error)
(test (let () (define* (hi :key (a 1) :key (b 2)) a)) 'error)
(test (let () (define* (hi :key (a 1) :optional (b 2) :allow-other-keys :allow-other-keys) a)) 'error)
(test (let () (define* (hi :optional (a 1) :key :allow-other-keys) a) (hi :c 1 :a 3 :b 2)) 'error)
(test (let () (define* (hi :key :optional :allow-other-keys) 1) (hi :c 1 :a 3 :b 2)) 'error)
(test (let () (define* (hi :key :optional :allow-other-keys) 1) (hi)) 'error)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi :a 2 32)) 'error)
(test (let () (define* (hi (a 1) :allow-other-keys) a) (hi 2 32)) 'error)

(test (let () (define* (hi (a 1) :rest c :allow-other-keys) (list a c)) (hi :a 3 :b 2)) '(3 (:b 2)))
(test (let () (define* (hi (a 1) :rest c) (list a c)) (hi :a 3 :b 2)) '(3 (:b 2)))

(test (let () (define* (hi (a 1) (b 2) :allow-other-keys) (list a b)) (hi :c 21 :b 2)) '(1 2))
(test (let () (define hi (lambda* ((a 1) (b 2) :allow-other-keys) (list a b))) (hi :c 21 :b 2)) '(1 2))
(test (let () (define-macro* (hi (a 1) (b 2) :allow-other-keys) `(list ,a ,b)) (hi :c 21 :b 2)) '(1 2))

(test (let () (define* (f (a :b)) a) (list (f) (f 1) (f :c) (f :a :c) (f :a 1) (f))) '(:b 1 :c :c 1 :b))
(test (let () (define* (f a (b :c)) b) (f :b 1 :d)) 'error)
(test ((lambda* (:rest (b 1)) b)) 'error) ; "lambda* :rest parameter can't have a default value." ?
(test ((lambda* ((a 1) (b 2)) ((lambda* ((c (+ a (* b 3)))) c)))) 7)
(test ((lambda* ((a 1) (b 2)) ((lambda* ((c (+ a (* b 3)))) c))) :b 3) 10)
(test (let ((a 123)) ((lambda* ((a 1) (b 2)) ((lambda* ((c (+ a (* b 3)))) c))) :b a)) 370)
(test (let ((a 123)) ((lambda* ((a 1) (b 2)) ((lambda* ((c (+ a (let ((a -2)) (* b a))))) c))))) -3)
(test (let ((a 123)) ((lambda* ((a 1) (b 2)) ((lambda* ((c (+ (let ((a -2)) (* b a)) a))) c))))) -3)
(test (let ((a 123)) ((lambda* ((a 1) (b 2)) ((lambda* ((c (+ (let ((a 0)) (/ b a)) a))) c))))) 'error)
(test ((lambda* ((c (call/cc (lambda (return) (return 3))))) c)) 3)
(test ((lambda* ((a (do ((i 0 (+ i 1)) (sum 0)) ((= i 3) sum) (set! sum (+ sum i))))) (+ a 100))) 103)
(test ((lambda* ((a (do ((i 0 (+ i 1)) (sum 0)) ((= i 3) sum) (set! sum (+ sum i)))) b) (+ a b)) 1 2) 3)

;; some of these are questionable
(test ((lambda* ((x (lambda () 1))) (x))) 1)
(test ((lambda* ((x x) else) (+ x else)) 1 2) 'error) ; used to be 3
(test (symbol? ((lambda* ((y y)) y))) 'error) ; this used to be #t but now y is undefined
(test (symbol? ((lambda* ((y y) :key) y))) 'error) ; same
(test (procedure-arity (lambda* ((a 1) :allow-other-keys) a)) '(0 1 #f))
(test (procedure-arity (lambda* (:allow-other-keys) 34)) '(0 0 #f))
(test ((lambda* (:allow-other-keys) 34) :a 32) 34)
(test (procedure-arity (lambda* ((a 1) :rest b :allow-other-keys) a)) '(0 1 #t))
(test ((lambda* ((y x) =>) (list y =>)) 1 2) 'error) ; used to be '(1 2))
(test ((lambda* (=> (y x)) (list y =>)) 1) 'error) ; used to be  '(x 1))
(test ((lambda* ((y #2D((1 2) (3 4)))) (y 1 0))) 3)
(test ((lambda* ((y (symbol "#(1 #\\a (3))")) x) -1)) -1)
(test ((lambda* ((y (symbol "#(1 #\\a (3))")) x) y)) (symbol "#(1 #\\a (3))"))
(test ((lambda* ((y #(1 #\a (3)))) (y 0))) 1)
(test ((lambda* ((y ()) ()) y)) 'error)
(test ((lambda* ((y ()) (x)) y)) 'error)
(test ((lambda* ((=> "") else) else) else) #f)
(test ((lambda* (x (y x)) y) 1) #f)
(test ((lambda* (x (y x)) (let ((x 32)) y)) 1) #f)
(test ((lambda* ((x 1) (y x)) y)) 1)
(test ((lambda* ((x 1) (y (+ x 1))) y)) 2)
(test ((lambda* ((x y) (y x)) y)) 'error) ; used to be 'y
(test (let ((z 2)) ((lambda* ((x z) (y x)) y))) 2) ; hmmm
(test (keyword? ((lambda* ((x :-)) x))) #t)
(test ((apply lambda* (list (list (list (string->symbol "a") 1)) (string->symbol "a"))) (symbol->keyword (string->symbol "a")) 3) 3)
(test ((lambda* (:allow-other-keys) 1) :a 321) 1)
(test ((lambda* (:rest (a 1)) a)) 'error)
(test ((lambda* (:rest a) a)) '())
(test ((lambda* (:rest (a 1)) 1)) 'error)
(test (let ((b 2)) ((lambda* (:rest (a (let () (set! b 3) 4))) b))) 'error)
(test (let ((b 2)) ((lambda* ((a (let () (set! b 3) 4))) b))) 3)
(test ((lambda* (:rest hi :allow-other-keys (x x)) x)) 'error)
(test ((lambda* (:rest x y) (list x y)) 1 2 3) '((1 2 3) 2))
(test ((lambda* (:rest '((1 2) (3 4)) :rest (y 1)) 1)) 'error)
(test ((lambda* (:rest (list (quote (1 2) (3 4))) :rest (y 1)) 1)) 'error)
(test ((lambda* ((x ((list 1 2) 1))) x)) 2)
(test ((lambda* ((y ("hi" 0))) y)) #\h)
(test ((lambda* ((x ((lambda* ((x 1)) x)))) x)) 1)
(test ((lambda* (:rest) 3)) 'error)
(test ((lambda* (:rest 1) 3)) 'error)
(test ((lambda* (:rest :rest) 3)) 'error)
(test ((lambda* (:rest :key) 3)) 'error)
(test ((lambda* ((: 1)) :)) 1)
(test ((lambda* ((: 1)) :) :: 21) 21)
(test ((lambda* ((a 1)) a) a: 21) 21)
(test ((lambda* ((a 1)) a) :a: 21) 'error)
(test (let ((func (let ((a 3)) (lambda* ((b (+ a 1))) b)))) (let ((a 21)) (func))) 4)
(test (let ((a 21)) (let ((func (lambda* ((b (+ a 1))) b))) (let ((a 3)) (func)))) 22)
(test (let ((a 21)) (begin (define-macro* (func (b (+ a 1))) b) (let ((a 3)) (func)))) 4)
(test ((lambda* (:rest x :allow-other-keys y) x) 1) 'error)
(test ((lambda* (:allow-other-keys x) x) 1) 'error)
(test ((lambda* (:allow-other-keys . x) x) 1 2) 'error)
(test ((lambda* (:optional . y) y) 1 2 3) 'error)
(test ((lambda* (:optional . y) y)) 'error)
(test ((lambda* (:rest . (x)) x) 1 2) '(1 2))
(test ((lambda* (:rest . (x 1)) x) 1 2) 'error)
(test ((lambda* (:rest . (x)) x)) '())
(test ((lambda* (:optional . (x)) x) 1) 1)
(test ((lambda* (:optional . (x 1)) x) 1) 'error)
(test ((lambda* (:optional . (x)) x)) #f)
(test ((lambda* (:optional . (x)) x) 1 2) 'error)
(test ((lambda* (x :key) x) 1) 'error)
(test ((lambda* (:key :optional :rest x :allow-other-keys) x) 1) 'error)
(test (lambda* (key: x) x) 'error)
(test (lambda* (:key: x) x) 'error)
(test ((lambda* x x) 1) '(1))
(test (lambda* (((x) 1)) x) 'error)
(test ((lambda* ((a: 3)) a:) :a: 4) 'error)
(test ((lambda* ((a 3)) a) a: 4) 4)


(test ((lambda* a (list a)) 1 2 3) '((1 2 3)))
(test ((lambda* () #f) 1 2 3) 'error)
(test ((lambda* (a ) (list a)) 1) '(1))
(test ((lambda* (a b ) (list a b)) 1 2) '(1 2))
(test ((lambda* (a b :allow-other-keys ) (list a b)) 1 2 :c 3) '(1 2))
(test ((lambda* (a  . b ) (list a b)) 1 2 3) '(1 (2 3)))
(test ((lambda* (a :rest b ) (list a b)) 1 2 3) '(1 (2 3)))
(test ((lambda* (a :rest b :allow-other-keys ) (list a b)) 1 2 :c 3) '(1 (2 :c 3)))
(test ((lambda* (a :optional b ) (list a b)) 1 2) '(1 2))
(test ((lambda* (a :optional b :allow-other-keys ) (list a b)) 1) '(1 #f))
(test ((lambda* (a :key b ) (list a b)) :a 1 :b 2) '(1 2))
(test ((lambda* (a :key b :allow-other-keys ) (list a b)) 1 2 :c 3) '(1 2))
(test ((lambda* (a :allow-other-keys ) (list a)) :b 2) '(#f))
(test ((lambda* (:rest a ) (list a)) 1 2 3) '((1 2 3)))
(test ((lambda* (:rest a b ) (list a b)) 1 2 3) '((1 2 3) 2))
(test ((lambda* (:rest a b :allow-other-keys ) (list a b)) :c 1 2 3) '((:c 1 2 3) 1)) ; seems inconsistent
(test ((lambda* (:rest a  . b ) (list a b)) 1 2 3) '((1 2 3) (2 3)))
(test ((lambda* (:rest a :rest b ) (list a b)) 1 2 3) '((1 2 3) (2 3)))
(test ((lambda* (:rest a :rest b :allow-other-keys ) (list a b)) 1 2 3) '((1 2 3) (2 3)))
(test ((lambda* (:rest a :optional b ) (list a b)) 1 2 3) '((1 2 3) 2))
(test ((lambda* (:rest a :optional b :allow-other-keys ) (list a b)) 1 :c 2 3) '((1 :c 2 3) 3))
(test ((lambda* (:rest a :key b ) (list a b)) :a 1 :b 2) '((:a 1 :b 2) 1)) ; !!
(test ((lambda* (:rest a :key b :allow-other-keys ) (list a b)) :b 1 2 3) '((:b 1 2 3) 1))
(test ((lambda* (:rest a :allow-other-keys ) (list a)) 1 2 3) '((1 2 3)))
(test ((lambda* (:optional a ) (list a))) '(#f))
(test ((lambda* (:optional a b ) (list a b)) :b 1 :a 2) '(2 1))
(test ((lambda* (:optional a b :allow-other-keys ) (list a b)) :c 1 :b 2 :a 3) '(3 2))
(test ((lambda* (:optional a b :allow-other-keys ) (list a b)) :c 1 :a 3) '(3 #f))
(test ((lambda* (:optional a  . b ) (list a b)) 1 2 3) '(1 (2 3)))
(test ((lambda* (:optional a :rest b ) (list a b)) 1 2 3) '(1 (2 3)))
(test ((lambda* (:optional a :rest b :allow-other-keys ) (list a b)) 1 2 3) '(1 (2 3)))
(test ((lambda* (:optional a :key b ) (list a b)) 1 2) '(1 2))
(test ((lambda* (:optional a :key b :allow-other-keys ) (list a b)) :c 1 :d 2 :e 3) '(#f #f))
(test ((lambda* (:optional a :allow-other-keys ) (list a)) :c 1 2) '(2)) ; !!
(test ((lambda* (:key a ) (list a)) :a 1) '(1))
(test ((lambda* (:key a b ) (list a b)) :b 1) '(#f 1)) 
(test ((lambda* (:key a b :allow-other-keys ) (list a b)) :c 1 :d 2 :a 3) '(3 #f))
(test ((lambda* (:key a  . b ) (list a b)) 1 2 3) '(1 (2 3)))
(test ((lambda* (:key a :rest b ) (list a b))) '(#f ()))
(test ((lambda* (:key a :rest b :allow-other-keys ) (list a b)) 1) '(1 ()))
(test ((lambda* (:key a :optional b ) (list a b)) :b 1) '(#f 1))
(test ((lambda* (:key a :optional b :allow-other-keys ) (list a b)) :c 1) '(#f #f))
(test ((lambda* (:key a :allow-other-keys ) (list a))) '(#f))
(test ((lambda* (:allow-other-keys ) (list)) :a 1 :c 3) ())

(test ((lambda* (:rest a :rest b) (map + a b)) 1 2 3 4 5) '(3 5 7 9))
(test ((lambda* (:rest a c :rest b) (map (lambda (a b) (+ a b c)) a b)) 1 2 3 4 5) '(6 8 10))

(test ((lambda* (a :rest (b 2)) (list a b)) 1 2 3 4) 'error)
(test ((lambda* (:key (a 1) :allow-other-keys ) a) :b :b :b :b ) 1) ; ?

#|
(let ((choices (list "a " "b " " . " ":rest " ":optional "  ":key " ":allow-other-keys "))
      (args (list "1 " ":a " ":b " ":c ")))

  (define-bacro (display-abc)
    `(format #f "~A ~A" (if (defined? 'a) (symbol->value 'a) '?) (if (defined? 'b) (symbol->value 'b) '?)))

  (define (next-arg str n)

    (let ((expr (string-append str ")")))
      (catch #t
	(lambda ()
	  (let ((val (eval-string expr)))
	    (format #t "~A -> ~A~%" expr val)))
	(lambda args
	  ;(format #t "    ~A: ~A~%" expr (apply format #f (cadr args)))
	  'error)))

    (if (< n 6)
	(for-each
	 (lambda (arg)
	   (next-arg (string-append str arg) (+ n 1)))
	 args)))

  (define (next-choice str n)
    (next-arg (string-append str ") (display-abc)) ") 0)
    (if (< n 4)
	(for-each
	 (lambda (choice)
	   (next-choice (string-append str choice) (+ n 1)))
	 choices)))

  (for-each
   (lambda (choice)
     (next-arg (string-append "((lambda* " choice "(display-abc)) ") 0))
   choices)

  (next-choice "((lambda* (" 0))
|#

;;; here be bugs...
(test ((lambda* a a) :a) '(:a))
(test ((lambda* (a b :optional) a) 1) 'error)
(test ((lambda* (a b :optional :key c) a) 1) 'error)
(test ((lambda* (a . b ) (list a b)) :b 1) '(#f 1)) ; ??? why doesn't the 1st arg work this way?
(test ((lambda* (a :rest b) (list a b)) :b 1) '(#f 1))
(test ((lambda* (:rest a) (list a)) :a 1) '((:a 1))) ; surely these are inconsistent
(test ((lambda* (a  . b ) (list a b)) :b 1 1) '(#f (1))) ; so if trailer, overwrite is not error?

(test ((lambda* (:rest a b ) (list a b)) 1 1) '((1 1) 1))
(test ((lambda* (:rest a :rest b ) (list a b)) :a 1) '((:a 1) (1)))
(test ((lambda* (:allow-other-keys) #f) :c 1) #f)
(test ((lambda* (a :allow-other-keys) a) :a) #f) ; now that has to be wrong
;; why does ((lambda* (a) a) :a) get unknown key: (:a) in (:a)?
(test ((lambda* (a :allow-other-keys) a) :a 1 :a 2) 1) ; this is very tricky to catch
(test ((lambda* (a :allow-other-keys) a) :c :c :c :c) #f)
(test ((lambda* (a :allow-other-keys) a) :c) #f)
(test ((lambda* (a b :allow-other-keys ) (list a b)) :b :a :c 1 :a) '(#f :a))

(test ((lambda* (a :allow-other-keys ) a) :c 1 1) 1) ; ??
(test ((lambda* (:rest b (a 1)) (list a b))) '(1 ()))
(test ((lambda* (:allow-other-keys) #f) :b :a :a :b) #f)

(test ((lambda* (:key . x) x) :x 1) 'error)
(test ((lambda* (:key . x) x)) 'error)
(test ((lambda* (:optional . y) y) :y 1) 'error)
(test ((lambda* (:rest a b c) (list a b c)) 1 2 3 4) '((1 2 3 4) 2 3))

(test (let ((x 3)) (define* (f (x x)) x) (let ((x 32)) (f))) 3)
(test (let ((x 3)) (define-macro* (f (x x)) `,x) (let ((x 32)) (f))) 32)

(test (let () (define (x x) x) (x 1)) 1)
(test (procedure? (let () (define* (x (x #t)) x) (x x))) #t)
(test (procedure? (let () (define* (x (x x)) x) (x (x x)))) #t)
(test (procedure? (let () (define* (x (x x)) x) (x))) #t)
(test (apply + ((lambda* ((x (values 1 2 3))) x))) 6)
(test ((lambda* ((x (lambda* ((y (+ 1 2))) y))) (x))) 3)
;; (let () (define* (x (x (x))) :optional) (x (x x))) -> segfault infinite loop in prepare_closure_star

  ;;; define-macro
  ;;; define-macro*
  ;;; define-bacro
  ;;; define-bacro*

(test (let ((x 0)) (define-macro* (hi (a (let () (set! x (+ x 1)) x))) `(+ 1 ,a)) (list (let ((x -1)) (list (hi) x)) x)) '((1 0) 0))
(test (let ((x 0)) (define-bacro* (hi (a (let () (set! x (+ x 1)) x))) `(+ 1 ,a)) (list (let ((x -1)) (list (hi) x)) x)) '((1 0) 0))
(test (let ((x 0)) (define-macro* (hi (a (let () (set! x (+ x 1)) x))) `(+ x ,a)) (list (let ((x -1)) (list (hi) x)) x)) '((-1 0) 0))
(test (let ((x 0)) (define-bacro* (hi (a (let () (set! x (+ x 1)) x))) `(+ x ,a)) (list (let ((x -1)) (list (hi) x)) x)) '((-1 0) 0))

(test (let ((x 0)) (define-macro* (hi (a (let () (set! x (+ x 1)) x))) `(let ((x -1)) (+ x ,a))) (list (hi) x)) '(-1 0)) 
(test (let ((x 0)) (let ((x -1)) (+ x (let () (set! x (+ x 1)) x)))) -1)
(test (let ((x 0)) (define-macro (hi a) `(let ((x -1)) (+ x ,a))) (list (hi (let () (set! x (+ x 1)) x)) x)) '(-1 0))
(test (let () (define-macro (hi a) `(let ((b 1)) (+ ,a b))) (hi (+ 1 b))) 3)
(test (let ((b 321)) (define-macro (hi a) `(let ((b 1)) (+ ,a b))) (hi b)) 2)
(test (let ((b 321)) (define-macro* (hi (a b)) `(let ((b 1)) (+ ,a b))) (hi b)) 2)
(test (let ((b 321)) (define-macro* (hi (a b)) `(let ((b 1)) (+ ,a b))) (hi)) 2) ; ???
(test (let ((x 0)) (define-macro* (hi (a (let () (set! x (+ x 1)) x))) `(+ ,a ,a)) (hi)) 3) ; ??? -- default val is substituted directly
;; but (let () (define-macro* (hi a (b a)) `(+ ,a ,b)) (hi 1)) -> "a: unbound variable" -- "a" itself is substituted, but does not exist at expansion(?)

;; can we implement bacros via define-macro* default args?
;;  I don't think so -- macro arguments can't be evaluated in that environment because 
;;  only the default values have been set (on the previous parameters).

;; bacro ignores closure in expansion but macro does not:
(test (let ((x 1)) (define-macro (ho a) `(+ ,x ,a)) (let ((x 32)) (ho 3))) 4)
(test (let ((x 1)) (define-macro (ho a) `(+ x ,a)) (let ((x 32)) (ho 3))) 35)
(test (let ((x 1)) (define-bacro (ho a) `(+ ,x ,a)) (let ((x 32)) (ho 3))) 35)
(test (let ((x 1)) (define-bacro (ho a) `(+ x ,a)) (let ((x 32)) (ho 3))) 35)

(test (let ((x 1)) (define-macro* (ho (a x)) `(+ ,x ,a)) (let ((x 32)) (ho))) 33)
(test (let ((x 1)) (define-macro* (ho (a x)) `(+ x ,a)) (let ((x 32)) (ho))) 64)
(test (let ((x 1)) (define-bacro* (ho (a x)) `(+ x ,a)) (let ((x 32)) (ho))) 64)
(test (let ((x 1)) (define-bacro* (ho (a x)) `(+ ,x ,a)) (let ((x 32)) (ho))) 64)

(test (let ((x 1)) (define-macro* (ho (a (+ x 0))) `(+ ,x ,a)) (let ((x 32)) (ho))) 33)  ;; (+ 32 (+ x 0)) !?! macroexpand is confusing?
(test (let ((x 1)) (define-macro* (ho (a (+ x 0))) `(+ x ,a)) (let ((x 32)) (ho))) 64)   ;; (+ x (+ x 0))
(test (let ((x 1)) (define-bacro* (ho (a (+ x 0))) `(+ x ,a)) (let ((x 32)) (ho))) 64 )
(test (let ((x 1)) (define-bacro* (ho (a (+ x 0))) `(+ ,x ,a)) (let ((x 32)) (ho))) 64 )

(test (let () (define-macro* (hi :rest a) `(list ,@a)) (hi)) '())
(test (let () (define-macro* (hi :rest a) `(list ,@a)) (hi 1)) '(1))
(test (let () (define-macro* (hi :rest a) `(list ,@a)) (hi 1 2 3)) '(1 2 3))
(test (let () (define-macro* (hi a :rest b) `(list ,a ,@b)) (hi 1 2 3)) '(1 2 3))
(test (let () (define-macro* (hi (a 1) :rest b) `(list ,a ,@b)) (hi)) '(1))
(test (let () (define-macro* (hi (a 1) :rest b) `(list ,a ,@b)) (hi 2)) '(2))
(test (let () (define-macro* (hi (a 1) :rest b) `(list ,a ,@b)) (hi :a 2)) '(2))
(test (let () (define-macro* (hi (a 1) :rest b :allow-other-keys) `(list ,a ,@b)) (hi :a 2 :b 3)) '(2 :b 3))
(test (let () (define-macro* (mac1 a :rest b) `(,a ,@b)) (mac1 + 2 3 4)) 9)

					;  (test (let () (define-macro ,@a 23)) 'error)
					;  (test (let () (define-macro ,a 23)) 'error)
					; maybe this isn't right

(test ((lambda* ((a 1) :allow-other-keys) a) :b 1 :a 3) 3)
(test (let () (define-macro* (hi (a 1) :allow-other-keys) `(list ,a)) (hi :b 2 :a 3)) '(3))
(test ((lambda* ((a 1) :rest b :allow-other-keys) b) :c 1 :a 3) '())
(test ((lambda* ((a 1) :rest b :allow-other-keys) b) :b 1 :a 3) 'error) 
;; that is the rest arg is not settable via a keyword and it's an error to try to
;;   do so, even if :allow-other-keys -- ??

(test (let ((x 1)) (define* (hi (a x)) a) (let ((x 32)) (hi))) 1)
(test (let ((x 1)) (define* (hi (a (+ x 0))) a) (let ((x 32)) (hi))) 1)
(test (let ((x 1)) (define* (hi (a (+ x "hi"))) a) (let ((x 32)) (hi))) 'error)
(test (let ((x 1)) (define-macro* (ho (a (+ x "hi"))) `(+ x ,a)) (let ((x 32)) (ho))) 'error)

(let ()
  (define-macro (until test . body) `(do () (,test) ,@body))
  (test (let ((i 0) (sum 0)) (until (= i 4) (set! sum (+ sum i)) (set! i (+ i 1))) sum) 6))

(let ()
  (define-macro (glambda args) ; returns an anonymous macro that will return a function given a body
    `(symbol->value (define-macro (,(gensym) . body) 
                      `(lambda ,',args ,@body))))

  (test (let ((gf (glambda (a b))))  ; gf is now ready for any body that involves arguments 'a and 'b
	  ((gf (+ a b)) 1 2))        ; apply (lambda (a b) (+ a b)) to '(1 2)
	3))

(let ()
  (define-macro (alambda pars . body)
    `(letrec ((self (lambda* ,pars ,@body)))
       self))
  
  (test ((alambda (n) (if (<= n 0) () (cons n (self (- n 1))))) 9) '(9 8 7 6 5 4 3 2 1))
  
  (define-macro* (aif test then (else #<unspecified>))
    `(let ((it ,test))
       (if it ,then ,else)))
  
  (test (aif (+ 3 2) it) 5)
  (test (aif (> 2 3) it) #<unspecified>)
  (test (aif (> 2 3) #f it) #f)
  )

(let ()
  ;; how to protect a recursive macro call from being stepped on
  ;; (define-macro (mac a b) `(if (> ,b 0) (let ((,a (- ,b 1))) (mac ,a (- ,b 1))) ,b))
  ;; (mac mac 1)
  ;; attempt to apply the integer 0 to (0 1)?
  ;;    (mac mac 1)
  (define-macro (mac a b)
    (let ((gmac (gensym))) 
      (set! gmac mac) 
      `(if (> ,b 0) 
	   (let ((,a (- ,b 1))) 
	     (,gmac ,a (- ,b 1))) 
	   ,b)))
  (test (mac mac 10) 0))

(let ()
  (define-bacro* (incf var (inc 1)) `(set! ,var (+ ,var ,inc)))
  (define-bacro* (decf var (inc 1)) `(set! ,var (- ,var ,inc)))

  (test (let ((x 0)) (incf x)) 1)
  (test (let ((x 1.5)) (incf x 2.5) x) 4.0)
  (test (let ((x 10)) (decf x (decf x 1)) x) 1) 

  ;; ! -- left to right order I think (let ((x 10)) (set! x (- x (set! x (- x 1))))) so the 3rd x is 10
  ;; Clisp and sbcl return 0: (let ((x 10)) (decf x (decf x (decf x))) x) is also 0
  ;; but in clisp (let ((x 10)) (setf x (- x (setf x (- x 1)))) x) is 1
  ;; I didn't know these cases were different
  ;; (let ((x 10)) (set! x (- x (let () (set! x (- x 1)) x))) x) 1, Guile also says 1
  ;; cltl2 p 134ff is an unreadable discussion of this, but I think it says in this case CL goes right to left
  ;; weird! in CL (decf x (decf x)) != (setf x (- x (setf x (- x 1))))
  ;;   and (let ((x 10)) (let ((val (decf x))) (decf x val) x))?
  ;;   so by adhering to one evaluation order, we lose "referential transparency"?

  (test (let ((x 1+i)) (decf x 0+i)) 1.0))

(let ()

  ;; (define-bacro* (incf var (inc 1)) (set! var (+ (eval var) (eval inc))))
  ;; this form does not actually set the incoming variable (it sets the argument)
  ;; at OP_SET we see set (var (+ (eval var) (eval inc)))
  ;;                  set1 var 1
  ;;                  which leaves x unset
  ;; but below we see set (x 1)
  ;;                  set1 x 1

  (define-bacro* (incf var (inc 1)) (apply set! var (+ (eval var) (eval inc)) ()))
  (define-bacro* (decf var (inc 1)) (apply set! var (- (eval var) (eval inc)) ()))

  (test (let ((x 0)) (incf x)) 1)
  (test (let ((x 1.5)) (incf x 2.5) x) 4.0)
  (test (let ((x 10)) (decf x (decf x 1)) x) 1) 
  (test (let ((x 1+i)) (decf x 0+i)) 1.0))


(let ()
  (define-macro (and-call function . args)
    ;; apply function to each arg, stopping if returned value is #f
    `(and ,@(map (lambda (arg) `(,function ,arg)) args)))

  (let ((lst ()))
    (and-call (lambda (a) (and a (set! lst (cons a lst)))) (+ 1 2) #\a #f (format #t "oops!~%"))
    (test lst (list #\a 3))))

(let ()
  (define-macro (add a . b)
    `(if (null? ',b)
	 ,a
	 (+ ,a (add ,@b))))
  (test (add 1 2 3) 6)
  (test (add 1 (add 2 3) 4) 10))

(let ()
  (define mac (let ((var (gensym))) 
		(define-macro (mac-inner b) 
		  `(#_let ((,var 12)) (#_+ ,var ,b))) 
		mac-inner))
  (test (mac 1) 13)
  (test (let ((a 1)) (mac a)) 13))

(test (eq? call/cc #_call/cc) #t)

(let ((val #f))
  (define-macro (add-1 var)
    `(+ 1 (let ()
	    (set! val ',var)
	    ,var)))
  (define (add-2 var)
    (set! val var)
    (+ 1 var))
  (let ((free #t))
    (let ((res ((if free add-1 add-2) (+ 1 2 3))))
      (if (or (not (equal? val '(+ 1 2 3)))
	      (not (= res 7)))
	  (format #t ";mac/proc[#t]: ~A ~A~%" val res)))
    (set! free #f)
    (let ((res ((if free add-1 add-2) (+ 1 2 3))))
      (if (or (not (equal? val '6))
	      (not (= res 7)))
	  (format #t ";mac/proc[#f]: ~A ~A~%" val res)))))

;; define-macro* default arg expr does not see definition-time closure:
(test (let ((mac #f))
	(let ((a 32))
	  (define-macro* (hi (b (+ a 1))) `(+ ,b 2))
	  (set! mac hi))
	(mac))
      'error) ; ";a: unbound variable, line 4"

(test ((lambda* ((x (let ()
		      (define-macro (hi a)
			`(+ ,a 1))
		      (hi 2))))
		(+ x 1)))
      4)
(test (let () 
	(define-macro* (hi (x (let ()
				(define-macro (hi a)
				  `(+ ,a 1))
				(hi 2))))
	  `(+ ,x 1)) 
	(hi))
      4)

(test (let () (define* (hi b) b) (procedure? hi)) #t)

(test (let ()
	(define (hi a) a)
	(let ((tag (catch #t
			  (lambda () (hi 1 2 3))
			  (lambda args (car args)))))
	  (eq? tag 'wrong-number-of-args)))
      #t)

(test (let ()
	(define (hi a) a)
	(let ((tag (catch #t
			  (lambda () (hi))
			  (lambda args (car args)))))
	  (eq? tag 'wrong-number-of-args)))
      #t)

(test (let ()
	(define* (hi a) a)
	(let ((tag (catch #t
			  (lambda () (hi 1 2 3))
			  (lambda args (car args)))))
	  (eq? tag 'wrong-number-of-args)))
      #t)

(let ()
  ;; shouldn't this be let-if or let-if-and, not if-let?
  ;;   and why not add short-circuiting to it (at the variable bindings point)?
  ;;   not pretty, but we could do this via and-call + augment-environment
  ;; maybe use and-let* instead
  (define-macro* (if-let bindings true false) 
    (let* ((binding-list (if (and (pair? bindings) (symbol? (car bindings)))
			     (list bindings)
			     bindings))
	   (variables (map car binding-list)))
      `(let ,binding-list
	 (if (and ,@variables)
	     ,true
	     ,false))))

  (test (if-let ((a 1) (b 2)) (list a b) "oops") '(1 2)))

(let ()
  (defmacro old-and-let* (vars . body) ; from guile/1.8/ice-9/and-let-star.scm

  (define (expand vars body)
    (cond
     ((null? vars)
      (if (null? body)
	  #t
	  `(begin ,@body)))
     ((pair? vars)
      (let ((exp (car vars)))
        (cond
         ((pair? exp)
          (cond
           ((null? (cdr exp))
            `(and ,(car exp) ,(expand (cdr vars) body)))
           (else
            (let ((var (car exp)))
              `(let (,exp)
                 (and ,var ,(expand (cdr vars) body)))))))
         (else
          `(and ,exp ,(expand (cdr vars) body))))))
     (else
      (error "not a proper list" vars))))

  (expand vars body))

  (test (old-and-let* ((hi 3) (ho #f)) (+ hi 1)) #f))

(let ()
  (define-macro (and-let* vars . body)
    `(and ,@(map (lambda (var) `(begin (apply define ',var) ,(car var))) vars) (begin ,@body)))
  (test (and-let* ((hi 3) (ho #f)) (+ hi 1)) #f))


(let () ; from the pro CL mailing list
  (define-macro (do-leaves var tree . body)
    `(let ()
       (define (rec ,var)
	 (if (not (null? ,var))
	     (if (pair? ,var)
		 (begin
		   (rec (car ,var))
		   (rec (cdr ,var)))
		 (begin
		   ,@body))))
       (rec ,tree)))

  (test (let ((lst ())) 
	  (do-leaves hiho '(+ 1 (* 2 3)) 
	    (set! lst (cons hiho lst))) 
	  (reverse lst))
	'(+ 1 * 2 3)))


(test (let () (define (hi :a) :a) (hi 1)) 'error)
(test (let () (define* (hi :a) :a) (hi 1)) 'error)
(test (let () (define* (hi (:a 2)) a) (hi 1)) 'error)
(test (let () (define* (hi (a 1) (:a 2)) a) (hi 1)) 'error)
(test (let () (define* (hi (pi 1)) pi) (hi 2)) 'error)
(test (let () (define* (hi (:b 1) (:a 2)) a) (hi)) 'error)

(test (let () (define* (hi (a 1) (a 2)) a) (hi 2)) 'error)
(test (let () (define (hi a a) a) (hi 1 2)) 'error)
(test (let () (define hi (lambda (a a) a)) (hi 1 1)) 'error)
(test (let () (define hi (lambda* ((a 1) (a 2)) a)) (hi 1 2)) 'error)
(test (let () (define (hi (a 1)) a) (hi 1)) 'error)

(let () 
  (define* (hi (a #2d((1 2) (3 4)))) (a 1 0))
  (test (hi) 3)
  (test (hi #2d((7 8) (9 10))) 9))

(let () (define* (f :rest a) a) (test (f :a 1) '(:a 1)))
(let () (define* (f :rest a :rest b) (list a b)) (test (f :a 1 :b 2) '((:a 1 :b 2) (1 :b 2))))

(test (lambda :hi 1) 'error)
(test (lambda (:hi) 1) 'error)
(test (lambda (:hi . :hi) 1) 'error)
(test (lambda (i . i) 1 . 2) 'error)
(test (lambda (i i i i) (i)) 'error)
(test (lambda "hi" 1) 'error)
(test (lambda* ((i 1) i i) i) 'error)
(test (lambda* ((a 1 2)) a) 'error)
(test (lambda* ((a . 1)) a) 'error)
(test (lambda* ((0.0 1)) 0.0) 'error)

(test ((lambda* ((b 3) :rest x (c 1)) (list b c x)) 32) '(32 1 ()))
(test ((lambda* ((b 3) :rest x (c 1)) (list b c x)) 1 2 3 4 5) '(1 3 (2 3 4 5)))
;; these are in s7.html
(test ((lambda* ((a 1) :rest b :rest c) (list a b c)) 1 2 3 4 5) '(1 (2 3 4 5) (3 4 5)))

(test (let () (define-macro (hi a a) `(+ ,a 1)) (hi 1 2)) 'error)

(test (let ((c 1)) 
	(define* (a :optional (b c)) b) 
	(set! c 2) 
	(a))
      2)

(test (let ((c 1)) 
	(define* (a :optional (b c)) b) 
	(let ((c 32)) 
	  (a)))
      1)

(test (let ((c 1)) 
	(define* (a (b (+ c 1))) b) 
	(set! c 2) 
	(a))
      3)

(test (let ((c 1))
	(define* (a (b (+ c 1))) b)
	(set! c 2)
	(let ((c 123))
	  (a)))
      3)

(test (let* ((cc 1)
	     (c (lambda () (set! cc (+ cc 1)) cc)))
	(define* (a (b (c))) b)
	(list cc (a) cc))
      (list 1 2 2))

(let ()
  (define* (func (val ((lambda (a) (+ a 1)) 2))) val)
  (test (func) 3)
  (test (func 1) 1))

(let ()
  (define (make-iterator obj)
    (let ((ctr 0))
      (lambda ()
	(and (< ctr (length obj))
	     (let ((val (obj ctr)))
	       (set! ctr (+ ctr 1))
	       val)))))

  (let ((iter (make-iterator #(10 9 8 7 6 5 4 3 2 1 0))))
    (define* (func (val (iter))) val)

    (test (list (func) (func) (func)) '(10 9 8)))

  (let ((i1 (make-iterator #(1 2 3))) 
	(i2 (make-iterator #(1 2 3)))) 
    (test (morally-equal? i1 i2) #t)
    (test (equal? i1 i2) #f)
    (i1)
    (test (morally-equal? i1 i2) #f)
    (i2)
    (test (morally-equal? i1 i2) #t))
  (let ((i1 (make-iterator #(1 2 3))) 
	(i2 (make-iterator '(1 2 3))))
    (test (morally-equal? i1 i2) #f)))

  
(let ()
  (define-macro (mac-free-x y)
    `(set! x ,y))
  
  (define (mac-y1)
    (let ((x .1))
      (do ((i 0 (+ i 1))
	   (y 0.5 (+ y x)))
	  ((= i 10) y)
	(if (= i 2)
	    (mac-free-x 1.1)))))
  
  (define (mac-y0)
    (let ((x .1))
      (do ((i 0 (+ i 1))
	   (y 0.5 (+ y x)))
	  ((= i 10) y)
	(if (= i 2)
	    (set! x 1.1)))))
  
  (define-macro (mac-free-v) 
    `(v 1))
  
  (define-macro (set-mac-free-v z)
    `(vector-set! v 1 ,z))
  
  (set! (procedure-setter mac-free-v) set-mac-free-v)
  
  (define (mac-y2)
    (let ((v (vector 1.0 0.1 1.2)))
      (do ((i 0 (+ i 1))
	   (y 0.5 (+ y (vector-ref v 1))))
	  ((= i 10) y)
	(if (= i 2)
	    (set! (mac-free-v) 1.1)))))
  
  (define (mac-y3)
    (let ((v (vector 1.0 0.1 1.2)))
      (do ((i 0 (+ i 1))
	   (y 0.5 (+ y (vector-ref v 1))))
	  ((= i 10) y)
	(if (= i 2)
	    (vector-set! v 1 1.1)))))
  
  (let ((y0 (mac-y0))
	(y1 (mac-y1))
	(y2 (mac-y2))
	(y3 (mac-y3)))
    (if (not (morally-equal? y0 y1))
	(format #t "~A: ~A got ~S but expected ~S~%~%" (port-line-number) 'mac-y0 y0 y1))
    (if (not (morally-equal? y2 y3))
	(format #t "~A: ~A got ~S but expected ~S~%~%" (port-line-number) 'mac-y2 y2 y3)))

  (let ((y (+ (mac-y0) (mac-y1) (mac-y2) (mac-y3))))
    (if (> (abs (- y (* 4 9.5))) 1e-9)
	(format #t "(2) ~A: ~A got ~S but expected ~S~%~%" (port-line-number) 'mac-y0 y (* 4 9.5)))))
