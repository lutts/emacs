;;;; ifdef - Parse the #if...#elif...#else...#endif block in a C file.
;;;; Mark them with different colors according to the nest level.
;;;; Author: Dai Yuwen
;;;; License: GPL
;;;; $Date: 2006/02/12 06:54:14 $

;;;; Usage: open a C file, then M-x ifdef-mark
;;;; You can add a hook to the C-mode, and bind `ifdef-mark' with C-c C-i:
;;;; (add-hook 'c-mode-common-hook '(lambda ()
;;;;				 (require 'ifdef)
;;;;				 (global-set-key [?\C-c ?\C-i] 'ifdef-mark)))

; import hif-xxx-regexp
(require 'hideif)

(defface ifdef-highlight-face1
  '((((type tty pc) (class color))
     (:background "turquoise3"))
    (((class color) (background light))
     (:background "paleturquoise"))
    (((class color) (background dark))
     (:background "paleturquoise4"))
    (t (:underline t)))
  "The face of the out most #if...#endif block."
  :group 'ifdef)

(defface ifdef-highlight-face2
  '((((type tty pc) (class color))
     (:background "paleGreen1"))
    (((class color) (background light))
     (:background "paleGreen2"))
    (((class color) (background dark))
     (:background "darkGreen"))
    (t (:underline t)))
  "The face of the 2nd level #if...#endif block."
  :group 'ifdef)

(defface ifdef-highlight-face3
  '((((type tty pc) (class color))
     (:background "yellow3"))
    (((class color) (background light))
     (:background "yellow"))
    (((class color) (background dark))
     (:background "yellow4"))
    (t (:underline t)))
  "The face of the 3rd level #if...#endif block."
  :group 'ifdef)

(defface ifdef-highlight-face4
  '((((type tty pc) (class color))
     (:background "pink3"))
    (((class color) (background light))
     (:background "pink"))
    (((class color) (background dark))
     (:background "pink4"))
    (t (:underline t)))
  "The face of the in most #if...#endif block."
  :group 'ifdef)

(defface ifdef-highlight-if-face
  '((((class color) (background dark))
     (:overline "lavender"))
    (((class color) (background light))
     (:overline "violet red"))
    (t ()))
  "The overline face to mark start."
  :group 'ifdef)

(defface ifdef-highlight-end-face
  '((((class color) (background dark))
     (:underline "lavender"))
    (((class color) (background light))
     (:underline "violet red"))
    (t ()))
  "The overline face to mark end."
  :group 'ifdef)

(defface ifdef-grey-face
  '((t (:foreground "slategrey")))
  "The face of code in #if 0 ... #endif block."
  :group 'ifdef)

;; put the faces in a hash table, only 4 colors
(defvar ifdef-face-table (make-hash-table :test 'eql :size 16))
(puthash 1 'ifdef-highlight-face1 ifdef-face-table)
(puthash 2 'ifdef-highlight-face2 ifdef-face-table)
(puthash 3 'ifdef-highlight-face3 ifdef-face-table)
(puthash 4 'ifdef-highlight-face4 ifdef-face-table)
(puthash -1 'ifdef-grey-face ifdef-face-table)

;; the overlay list
(defvar ifdef-overlay-list nil)
(defvar ifdef-marked-flag nil)

(defun ifdef-makeup (level pos begin end)
  "Mark the region from BEGIN to END with the LEVELth face, POS (1: if, 2: else, 3: end)."
  (save-excursion
    (unless begin
      (setq begin (point))
      (setq end (progn (hif-end-of-line) (point))))
    (let ((ov (make-overlay begin end))
	  (face (gethash level ifdef-face-table)))
      (when face
	(overlay-put ov 'face face)
	(overlay-put ov 'priority 0)
	(push ov ifdef-overlay-list)
	;; add if/else/end face
	(setq face
	      (cond ((= pos 1)
		     'ifdef-highlight-if-face)
		    ((= pos 3)
		     'ifdef-highlight-end-face)
		    (t
		     nil)))
	(when face
	  (setq ov (make-overlay begin end))
	  (overlay-put ov 'face face)
	  (overlay-put ov 'priority 0)
	  (push ov ifdef-overlay-list))
	))))

(defconst hif-if0-regexp (concat hif-cpp-prefix "if[ \t]+0[ \t&]*.*$"))
(defconst hif-if1-regexp (concat hif-cpp-prefix "if[ \t]+1[ \t|]*.*$"))

(defun hif-looking-at-if0()
  (looking-at hif-if0-regexp))

(defun hif-looking-at-if1()
  (looking-at hif-if1-regexp))

(defun hif-range-start-tail(range)
  (save-excursion
    (goto-char (hif-range-start range))
    (hif-end-of-line)
    (forward-line)
    (beginning-of-line)
    (point)))

(defun hif-range-else-tail(range)
  (save-excursion
    (goto-char (hif-range-else range))
    (hif-end-of-line)
    (forward-line)
    (beginning-of-line)
    (point)))

(defun hif-range-end-tail(range)
  (save-excursion
    (goto-char (hif-range-end range))
    (hif-end-of-line)
    (forward-line)
    (beginning-of-line)
    (point)))

(defun ifdef-find-any(end)
  "Move to next #if..., #else, or #endif, at point or after."
  (prog1
      (re-search-forward hif-ifx-else-endif-regexp end t)
    (beginning-of-line)))

(defun ifdef-mark(&optional begin end nest)
  "Parse the level of #if...#else...#endif. Mark them with
different colors."
  (interactive)
  (make-variable-buffer-local 'ifdef-marked-flag)
  (make-variable-buffer-local 'ifdef-overlay-list)
  (if ifdef-marked-flag		 ; if already marked, remove the marks
      (ifdef-remove-marks)
    (ifdef-apply-marks (point-min) (point-max) 0)
    (setq ifdef-marked-flag t)))

(defun ifdef-apply-marks(begin end nest)
  "Parse the level of #if...#else...#endif. Mark them with
different colors."
  (save-excursion
    (goto-char begin)
    (let (found)
      (while (ifdef-find-any end)
	(cond ((hif-looking-at-ifX)	; #if...
	       (setq nest (1+ nest))
	       (ifdef-makeup nest 1 nil nil) ; mark it
	       ;; deal with #if 1 / 0
	       (setq found (or (and (hif-looking-at-if1) 1)
			       (and (hif-looking-at-if0) 2)))
	       (when found
		 (let ((range (hif-find-range))
		       range-end)
		   (if (= found 1)
		       ;; #if 1, need to deal with else only
		       (when (hif-range-else range)
			 (ifdef-apply-marks (hif-range-start-tail range)
					    (hif-range-else-tail range)
					    nest)
			 (setq range-end (hif-range-end range))
			 (ifdef-makeup -1 -1
				       (hif-range-else-tail range)
				       range-end)
			 (goto-char (1- range-end)))
		     ;; #if 0
		     (setq range-end (or (hif-range-else range)
					 (hif-range-end range)))
		     (ifdef-makeup -1 -1
				   (hif-range-start-tail range)
				   range-end)
		     (goto-char (1- range-end))))))

	      ((hif-looking-at-else)
	       (ifdef-makeup nest 2 nil nil))

	      ((hif-looking-at-endif)
	       (ifdef-makeup nest 3 nil nil)
	       (setq nest (1- nest)))

	      (t
	       (error "Error #if statement?")))
	(if (<= nest 0)			; found the out most #endif
	    (setq nest 0))
	(hif-end-of-line)))))

(defun ifdef-remove-marks ()
  (dolist (ov ifdef-overlay-list)
    (delete-overlay ov)
    (setq ifdef-overlay-list nil)
    (setq ifdef-marked-flag nil)))	; reset the flag

;;;; add (require 'ifdef) in your .emacs file
(provide 'ifdef)
