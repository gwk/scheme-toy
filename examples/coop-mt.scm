#!/usr/bin/env csis

; a simpler cooperative multitasking system using call/cc.

; a list of continuations waiting to run.
(define *queue* '())

(define (empty-queue?)
  (null? *queue*))

(define (enqueue x)
  (set! *queue* (append *queue* (list x))))

(define (dequeue)
  (let ((x (car *queue*)))
    (set! *queue* (cdr *queue*))
    x))

; starts a new thread running (proc).
(define (fork proc)
  (call/cc
    (lambda (k)
      (enqueue k)
      (proc))))

; yields the processor to another thread, if there is one.
(define (yield)
  (call/cc
    (lambda (k)
      (enqueue k)
      ((dequeue) #f))))

; terminates the current thread, or the entire program if there are no other threads left.
(define (thread-exit)
  (if (empty-queue?)
    (exit)
    ((dequeue) #f)))


; body of some typical Scheme thread that does stuff:
(define (action str)
  (lambda ()
    (let loop ((n 0))
      ;(format #t "~A ~A\n" str n)
      (display str)
      (display "\n")
      (yield)
      (loop (+ 1 n)))))

;;; Create two threads, and start them running.
(fork (action "A"))
(fork (action "B"))
(thread-exit)
