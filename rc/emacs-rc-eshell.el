;;; eshell
(setq eshell-prompt-function
      (lambda nil
	(concat
	 (eshell/pwd)
	 " \n$ ")))

(setq eshell-prompt-regexp "[#$] ")

(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
	(beginning-of-line))))
(add-hook 'eshell-mode-hook
	  '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

(defun eshell/clear ()
  "04Dec2001 - sailor, to clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; open file in eshell
(defalias 'open 'find-file-other-window)

(require 'shell-pop)
;; (shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode "eshell")
(shell-pop-set-internal-mode-shell "/bin/bash")
;; the number for the percentage of the selected window. if 100, shell-pop use the whole of selected window, not spliting.
(shell-pop-set-window-height 60)
;; shell-pop-up position. You can choose "top" or "bottom".
(shell-pop-set-window-position "bottom")
(global-set-key [f8] 'shell-pop)