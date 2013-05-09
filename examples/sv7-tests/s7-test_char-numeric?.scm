(test (char-numeric? #\a) #f)
(test (char-numeric? #\5) #t)
(test (char-numeric? #\A) #f)
(test (char-numeric? #\z) #f)
(test (char-numeric? #\Z) #f)
(test (char-numeric? #\0) #t)
(test (char-numeric? #\9) #t)
(test (char-numeric? #\space) #f)
(test (char-numeric? #\;) #f)
(test (char-numeric? #\.) #f)
(test (char-numeric? #\-) #f)
(test (char-numeric? (integer->char 200)) #f)
(test (char-numeric? (integer->char 128)) #f)
(test (char-numeric? (integer->char 216)) #f) ; 0 slash
(test (char-numeric? (integer->char 189)) #f) ; 1/2

(for-each
 (lambda (arg)
   (if (char-numeric? arg)
 (format #t ";(char-numeric? ~A) -> #t?~%" arg)))
 cap-a-to-z)

(for-each
 (lambda (arg)
   (if (char-numeric? arg)
 (format #t ";(char-numeric? ~A) -> #t?~%" arg)))
 a-to-z)

(test (char-numeric?) 'error)
(test (char-numeric? #\a #\b) 'error)
