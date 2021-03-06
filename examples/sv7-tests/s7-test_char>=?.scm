(test (char>=? #\e #\d) #t)
(test (char>=? #\A #\B) #f)
(test (char>=? #\a #\b) #f)
(test (char>=? #\9 #\0) #t)
(test (char>=? #\A #\A) #t)
(test (char>=? #\space #\space) #t)

(test (char>=? #\d #\c #\b #\a) #t)
(test (char>=? #\d #\d #\c #\a) #t)
(test (char>=? #\e #\d #\b #\c #\a) #f)
(test (apply char>=? a-to-z) #f)
(test (apply char>=? cap-a-to-z) #f)
(test (apply char>=? mixed-a-to-z) #f)
(test (apply char>=? digits) #f)
(test (apply char>=? (reverse a-to-z)) #t)
(test (apply char>=? (reverse cap-a-to-z)) #t)
(test (apply char>=? (reverse mixed-a-to-z)) #f)
(test (apply char>=? (reverse digits)) #t)
(test (char>=? #\d #\c #\a) #t)
(test (char>=? #\d #\c #\c) #t)
(test (char>=? #\B #\B #\C) #f)
(test (char>=? #\b #\c #\e) #f)

(test (char>=? #\a #\b "hi") 'error)
(test (char>=? #\a #\b 0) 'error)
(test (char>=?) 'error)
