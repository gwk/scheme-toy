(test (char-whitespace? #\a) #f)
(test (char-whitespace? #\A) #f)
(test (char-whitespace? #\z) #f)
(test (char-whitespace? #\Z) #f)
(test (char-whitespace? #\0) #f)
(test (char-whitespace? #\9) #f)
(test (char-whitespace? #\space) #t)
(test (char-whitespace? #\tab) #t)
(test (char-whitespace? #\newline) #t)
(test (char-whitespace? #\return) #t)
(test (char-whitespace? #\linefeed) #t)
(test (char-whitespace? #\null) #f)
(test (char-whitespace? #\;) #f)
(test (char-whitespace? #\xb) #t)
(test (char-whitespace? #\x0b) #t)
(test (char-whitespace? #\xc) #t)
(test (char-whitespace? #\xd) #t) ; #\return
(test (char-whitespace? #\xe) #f) 

(for-each
 (lambda (arg)
   (if (char-whitespace? arg)
 (format #t ";(char-whitespace? ~A) -> #t?~%" arg)))
 mixed-a-to-z)

(for-each
 (lambda (arg)
   (if (char-whitespace? arg)
 (format #t ";(char-whitespace? ~A) -> #t?~%" arg)))
 digits)

(test (char-whitespace?) 'error)
(test (char-whitespace? #\a #\b) 'error)
