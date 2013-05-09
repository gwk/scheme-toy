(test (char-position) 'error)
(test (char-position #\a) 'error)
(test (char-position #\a "abc" #\0) 'error)
(test (char-position #\a "abc" 0 1) 'error)
(test (string-position) 'error)
(test (string-position #\a) 'error)
(test (string-position "a" "abc" #\0) 'error)
(test (string-position "a" "abc" 0 1) 'error)

(for-each
 (lambda (arg) 
   (test (string-position arg "abc") 'error)
   (test (char-position arg "abc") 'error)
   (test (string-position "a" arg) 'error)
   (test (char-position #\a arg) 'error)
   (test (string-position "a" "abc" arg) 'error)
   (test (char-position #\a "abc" arg) 'error))
 (list () (list 1) '(1 . 2) #f 'a-symbol (make-vector 3) abs _ht_ quasiquote macroexpand 1/0 (log 0) 
       3.14 3/4 -1 most-negative-fixnum 1.0+1.0i :hi (if #f #f) (lambda (a) (+ a 1))))
(test (char-position #\a "abc" most-positive-fixnum) #f)
(test (char-position "a" "abc" most-positive-fixnum) #f)
(test (string-position "a" "abc" most-positive-fixnum) #f)

(test (char-position #\b "abc") 1)
(test (char-position #\b "abc" 0) 1)
(test (char-position #\b "abc" 1) 1)
(test (char-position "b" "abc") 1)
(test (char-position "b" "abc" 1) 1)
(test (char-position "b" "abc") 1)
(test (string-position "b" "abc") 1)
(test (string-position "b" "abc" 1) 1)
(test (string-position "b" "abc" 2) #f)
(test (string-position "b" "abc" 3) #f)
(test (char-position "b" "abc" 2) #f)
(test (char-position "b" "abc" 3) #f)
(test (char-position #\b "abc" 2) #f)
(test (char-position #\b "abc" 3) #f)
(test (char-position "ab" "abcd") 0)
(test (char-position "ab" "ffbcd") 2)
(test (char-position "ab" "ffacd") 2)
(test (string-position "ab" "ffacd") #f)
(test (string-position "ab" "ffabd") 2)
(test (string-position "ab" "ffabab" 2) 2)
(test (string-position "ab" "ffabab" 3) 4)
(test (string-position "ab" "ffabab" 4) 4)
(test (string-position "ab" "ffabab" 5) #f)
(test (string-position "abc" "ab") #f)
(test (string-position "abc" "") #f)
(test (string-position "" "") #f)
(test (char-position "\"" "a") #f)
(test (char-position "\"" "a\"b") 1)
(test (char-position #\" "a\"b") 1)
(test (string-position "\"hiho\"" "hiho") #f)
(test (string-position "\"hiho\"" "\"\"hiho\"") 1)

(test (string-position "" "a") #f) ; this is a deliberate choice in s7.c
(test (char-position "" "a") #f) 
(test (char-position #\null "a") 1)  ; ??
(test (char-position #\null "") #f)  ; ??
(test (string-position (string #\null) "a") 0) ; ??
(test (string-position (string #\null) "") #f) ; ??
(test (char-position #\null (string #\null)) 0) ; ??
(test (char-position #\null (string #\a #\null #\n)) 1)
(test (char-position "" (string #\a #\null #\n)) #f)
(test (char-position "" (string #\a #\n)) #f)

;; if "" as string-pos 1st, -> #f so same for char-pos, even if string contains a null

(let ()
  ;; actually more of a string-append/temp substring test
  (define (fixit str)
    (let ((pos (char-position #\& str)))
      (if (not pos)
	  str
	  (string-append (substring str 0 pos)
			 (let ((epos (char-position #\; str pos)))
			   (let ((substr (substring str (+ pos 1) epos)))
			     (let ((replacement (if (string=? substr "gt") ">"
						    (if (string=? substr "lt") "<"
							(if (string=? substr "mdash") "-"
							    (format #t "unknown: ~A~%" substr))))))
			       (string-append replacement
					      (fixit (substring str (+ epos 1)))))))))))
  (test (fixit "(let ((f (hz-&gt;radians 100)) (g (hz-&gt;radians 200))) (&lt; f g))")
	"(let ((f (hz->radians 100)) (g (hz->radians 200))) (< f g))"))
