(num-test (logand 0 1) 0)
(num-test (logand 0 -1) 0)
(num-test (logand #b101 #b10001) 1)
(num-test (logand 1 3 6) 0)
(num-test (logand -1 3 6) 2)
(num-test (logand -6 1) 0)
(num-test (logand -6 3) 2)
(num-test (logand #b1 #b11 #b111 #b1111) #b1)
(num-test (logand -1 0 -1 -1) 0)
(num-test (logand 3 3 3 3) 3)
(num-test (logand 0) 0)
(num-test (logand -1) -1)
(num-test (logand 12341234 10001111) 9964242)
(num-test (logand -1 1) 1)
(num-test (logand -1 -1) -1)
(num-test (logand 1 -1) 1)
(num-test (logand 1 1) 1)
(num-test (logand 16 31) 16)
(num-test (logand 0 1/1) 0)
(num-test (logand 1/1 0) 0)
(num-test (logand 1 -1 -1) 1)
(num-test (logand 1 2 3 4) 0)
(num-test (logand 1 3 5 7) 1)
(num-test (logand -9223372036854775808 -1) -9223372036854775808)
(num-test (logand -9223372036854775808 -9223372036854775808) -9223372036854775808)
(num-test (logand -9223372036854775808 1) 0)
(num-test (logand -9223372036854775808 9223372036854775807 -9223372036854775808) 0)
(num-test (logand 9223372036854775807 -1) 9223372036854775807)
(num-test (logand 9223372036854775807 -9223372036854775808) 0)
(num-test (logand 9223372036854775807 1) 1)
(num-test (logand 9223372036854775807 9223372036854775807) 9223372036854775807)
(num-test (logand) -1)

(if with-bignums
    (begin
      (test (logand 9223372036854775808 -9223372036854775809) 0)
      (test (logand 618970019642690137449562111 (expt 2 88)) (expt 2 88))
      (num-test (logand (+ (expt 2 48) (expt 2 46)) (expt 2 48)) 281474976710656)
      (test (logand 0+92233720368547758081.0i) 'error)
      (test (logand 92233720368547758081.0) 'error)
      ))

(test (logand 0 1.0) 'error)
(test (logand 1+i) 'error)
(test (logand 0 1/2) 'error)
(test (logand 1.0 0) 'error)
(test (logand 1/2 0) 'error)
(test (logand 0 #\a) 'error)
(test (logand 0 "hi") 'error)
(test (logand #f '()) 'error)
