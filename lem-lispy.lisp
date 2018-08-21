;;;; lem-lispy.lisp

(in-package #:lem-lispy)

(define-minor-mode lispy-mode
    (:name "lispy"
     :keymap *lispy-mode-keymap*))

(defun at-open-p (&optional (point (current-point)))
  (char= #\( (character-at point)))

(define-command lispy-down () ()
  (if (at-open-p)
      (progn
        (forward-sexp)
        (forward-sexp)
        (backward-sexp))
      (self-insert 1)))

(define-command lispy-up () ()
  (if (at-open-p)
        (backward-sexp)
      (self-insert 1)))

(define-command lispy-comment-sexp () ()
  (when (at-open-p)
    (mark-sexp))
  (lem.language-mode::comment-or-uncomment-region))

(define-command lispy-mark-list () ()
  (if (at-open-p)
      (mark-sexp)
      (self-insert 1)))

(defun region-active (&optional (buffer (current-buffer)))
  (buffer-mark-p buffer))

(defun surround ()
  (let ((start (current-point))
        (end (current-point)))
    (when (region-active)
      (setf start (region-beginning)
            end (region-end)))
    (insert-character start #\( )
    (forward-sexp 1)
    (insert-character end #\) )
    (backward-sexp 1)))

(define-command lispy-surround () ()
  (if (at-open-p)
      (surround)
      (self-insert 1)))

(define-key *lispy-mode-keymap* "M-;" 'lispy-comment-sexp)
(define-key *lispy-mode-keymap* "j" 'lispy-down)
(define-key *lispy-mode-keymap* "k" 'lispy-up)
(define-key *lispy-mode-keymap* "m" 'lispy-mark-list)
(define-key *lispy-mode-keymap* "s" 'lispy-surround)