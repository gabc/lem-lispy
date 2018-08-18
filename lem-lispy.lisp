;;;; lem-lispy.lisp

(in-package #:lem-lispy)

(define-minor-mode lispy-mode
    (:name "lispy"
     :keymap *lispy-mode-keymap*))

(defun at-open-p (&optional (point (current-point)))
  (looking-at point "\\("))

(define-command lispy-down () ()
  (if (at-open-p)
      (progn
        (forward-sexp)
        (forward-sexp)
        (backward-sexp))
      (insert-character (current-point) #\j)))

(define-command lispy-up () ()
  (if (at-open-p)
      (progn
        (backward-sexp))        
      (insert-character (current-point) #\k)))

(define-command lispy-comment-sexp () ()
  (when (at-open-p)
    (mark-sexp))
  (lem.language-mode::comment-or-uncomment-region))

(define-key *lispy-mode-keymap* "M-;" 'lispy-comment-sexp)
(define-key *lispy-mode-keymap* "j" 'lispy-down)
(define-key *lispy-mode-keymap* "k" 'lispy-up)