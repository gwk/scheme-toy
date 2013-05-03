; comment
(define fibonacci
  (lambda (n)
    (if (= n 0)
      0
      (begin
        (define fib
          (lambda (a b count)
            (if (= count n)
              b
              (fib b (+ a b) (+ count 1)))))
        (fib 0 1 1)))))

(display (fibonacci 10))
