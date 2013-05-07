; simplest fib implementation calculates one step larger than desired
(define fib
  (lambda (n)
    (define fib_rec
      (lambda (a b count)
        (if (eq? count n)
          a
          (fib_rec b (+ a b) (+ count 1)))))
    (fib_rec 0 1 0)))

; more complex version checks zero case specially so that the recursion can return the larger of the two arguments.
(define fib1
  (lambda (n)
    (if (eq? n 0)
      0
      (begin
        (define fib_rec
          (lambda (a b count)
            (if (eq? count n)
              b
              (fib_rec b (+ a b) (+ count 1)))))
        (fib_rec 0 1 1)))))


(define fib_1000_exp
     43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875)

(test (fib  1000) fib_1000_exp)
(test (fib1 1000) fib_1000_exp)
