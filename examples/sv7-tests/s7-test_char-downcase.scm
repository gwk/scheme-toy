(test (char-downcase #\A) #\a)
(test (char-downcase #\a) #\a)
(test (char-downcase #\?) #\?)
(test (char-downcase #\$) #\$)
(test (char-downcase #\.) #\.)
(test (char-downcase #\_) #\_)
(test (char-downcase #\\) #\\)
(test (char-downcase #\5) #\5)
(test (char-downcase #\)) #\))
(test (char-downcase #\%) #\%)
(test (char-downcase #\0) #\0)
(test (char-downcase #\space) #\space)

(for-each
 (lambda (arg1 arg2)
   (if (not (char=? (char-downcase arg1) arg2))
 (format #t ";(char-downcase ~A) != ~A?~%" arg1 arg2)))
 cap-a-to-z
 a-to-z)

(test (recompose 12 char-downcase #\A) #\a)

(test (char-downcase) 'error)
(test (char-downcase #\a #\b) 'error)
