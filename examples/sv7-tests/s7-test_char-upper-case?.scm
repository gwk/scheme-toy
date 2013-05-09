(test (char-upper-case? #\a) #f)
(test (char-upper-case? #\A) #t)

(for-each
 (lambda (arg)
   (if (not (char-upper-case? arg))
 (format #t ";(char-upper-case? ~A) -> #f?~%" arg)))
 cap-a-to-z)

(for-each
 (lambda (arg)
   (if (char-upper-case? arg)
 (format #t ";(char-upper-case? ~A) -> #t?~%" arg)))
 a-to-z)

;; non-alpha chars are "unspecified" here

(test (char-upper-case? 1) 'error)
(test (char-upper-case?) 'error)
(test (char-upper-case? 1) 'error)
(test (char-upper-case?) 'error)
(test (char-upper-case? #\a #\b) 'error)
(test (char-upper-case #\a) 'error)
