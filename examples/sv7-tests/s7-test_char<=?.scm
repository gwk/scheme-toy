(test (char<=? #\d #\x) #t)
(test (char<=? #\d #\d) #t)

(test (char<=? #\a #\e #\y #\z) #t)
(test (char<=? #\a #\e #\e #\y) #t)
(test (char<=? #\A #\B) #t)
(test (char<=? #\a #\b) #t)
(test (char<=? #\9 #\0) #f)
(test (char<=? #\A #\A) #t)
(test (char<=? #\space #\space) #t)

(test (char<=? #\a #\e #\y #\z) #t)
(test (char<=? #\a #\e #\e #\y) #t)
(test (char<=? #\e #\e #\d #\y) #f)
(test (apply char<=? a-to-z) #t)
(test (apply char<=? cap-a-to-z) #t)
(test (apply char<=? mixed-a-to-z) #f)
(test (apply char<=? digits) #t)
(test (apply char<=? (reverse a-to-z)) #f)
(test (apply char<=? (reverse cap-a-to-z)) #f)
(test (apply char<=? (reverse mixed-a-to-z)) #f)
(test (apply char<=? (reverse digits)) #f)
(test (char<=? #\b #\c #\a) #f)
(test (char<=? #\B #\B #\A) #f)
(test (char<=? #\b #\c #\e) #t)

(test (char<=? #\b #\a "hi") 'error)
(test (char<=? #\b #\a 0) 'error)
(test (char<=?) 'error)
