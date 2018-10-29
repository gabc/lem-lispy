;;;; lem-lispy.lisp

;; I probably want commands to work when the region is active
;; even if `point' is not on an (, just because I don't want to
;; enter text when the region is active and could take that into account.
(in-package #:lem-lispy)

(define-minor-mode lispy-mode
    (:name "lispy"
     :keymap *lispy-mode-keymap*))

(defun at-open-p (&optional (point (current-point)))
  (char= #\( (character-at point)))
(defun at-close-p (&optional (point (current-point)))
  ;; Needs the `-1' otherwise it doesn't work.
  ;; This is the way to say "previous char"
  (char= #\) (character-at point -1)))

(defmacro lispy-cond (open-block end-block else)
  `(cond ((at-open-p)
          ,open-block)
         ((at-close-p)
          ,end-block)
         (t ,else)))

;; (define-command lispy-down () ()
;;   (if (at-open-p)
;;       (progn
;;         (forward-sexp)
;;         (forward-sexp)
;;         (backward-sexp))
;;       (self-insert 1)))

(define-command lispy-down () ()
  (lispy-cond
   (progn (forward-sexp) (forward-sexp) (backward-sexp))
   (progn (forward-sexp))
   (self-insert 1)))

(define-command lispy-up () ()
  (lispy-cond
   (backward-sexp)
   (progn (backward-sexp) (backward-sexp) (forward-sexp))
   (self-insert 1)))

(define-command lispy-forward () ()
  (lispy-cond
   (forward-sexp)
   (backward-sexp)
   (self-insert 1)))

(define-command lispy-comment-sexp () ()
  (when (and (not (region-active)) (at-open-p))
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
    (insert-character start #\Space)
    (forward-sexp 1)
    (insert-character end #\) )
    (backward-sexp 1)
    (forward-char)))

(define-command lispy-surround () ()
  (if (at-open-p)
      (surround)
      (self-insert 1)))

(define-key *lispy-mode-keymap* "M-;" 'lispy-comment-sexp)
(define-key *lispy-mode-keymap* "j" 'lispy-down)
(define-key *lispy-mode-keymap* "k" 'lispy-up)
(define-key *lispy-mode-keymap* "m" 'lispy-mark-list)
(define-key *lispy-mode-keymap* "s" 'lispy-surround)
(define-key *lispy-mode-keymap* "d" 'lispy-forward)
(define-key *lispy-mode-keymap* "M-(" 'lispy-surround)