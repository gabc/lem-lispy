;;;; lem-lispy.lisp

(in-package #:lem-lispy)

(define-minor-mode lispy-mode
    (:name "lispy"
     :keymap *lispy-mode-keymap*))

(define-command lispy-down () ()
  (if (looking-at (current-point) "\\(")
      (progn
        (forward-sexp)
        (forward-sexp)
        (backward-sexp))
      (insert-character (current-point) #\j)))

(define-command lispy-up () ()
  (if (looking-at (current-point) "\\(")
      (progn
        (backward-sexp))        
      (insert-character (current-point) #\k)))

(define-key *lispy-mode-keymap* "j" 'lispy-down)
(define-key *lispy-mode-keymap* "k" 'lispy-up)