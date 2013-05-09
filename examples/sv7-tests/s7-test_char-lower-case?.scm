(test (char-lower-case? #\A) #f)
(test (char-lower-case? #\a) #t)

(for-each
 (lambda (arg)
   (if (not (char-lower-case? arg))
 (format #t ";(char-lower-case? ~A) -> #f?~%" arg)))
 a-to-z)

(for-each
 (lambda (arg)
   (if (char-lower-case? arg)
 (format #t ";(char-lower-case? ~A) -> #t?~%" arg)))
 cap-a-to-z)

(test (char-lower-case? 1) 'error)
(test (char-lower-case?) 'error)
(test (char-lower-case? 1) 'error)
(test (char-lower-case?) 'error)
(test (char-lower-case? #\a #\b) 'error)
(test (char-lower-case #\a) 'error)

;;  (test (char-lower-case? #\xb5) #t)  ; what is this?  in Snd it's #t, in ex1 it's #f -- is this a locale choice?
(test (char-lower-case? #\xb6) #f)

(for-each
 (lambda (c)
   (test (and (not (char-upper-case? c)) 
	(not (char-lower-case? c))) #t))
 (map integer->char (list 0 1 2 3 32 33 34 170 182 247)))
