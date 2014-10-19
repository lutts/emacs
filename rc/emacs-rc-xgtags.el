(require 'xgtags)

(defun xgtags--file-header ()
  "get the current file's header file name."
  (concat (base-name (curr-file)) ".h"))

(defun xgtags-find-header-file ()
  "Input pattern and move to the top of the file."
  (interactive)
  (xgtags--find-with "Find file:"
                     :option 'path
                     :get-token 'xgtags--file-header
                     :history nil))

(add-hook 'xgtags-mode-hook
	  '(lambda ()
	     ;; I use this keys because these keybindings can finish with just the left hand
	     (define-key xgtags-mode-map (kbd "C-c a f") 'xgtags-find-file)
	     (define-key xgtags-mode-map (kbd "C-c a t") 'xgtags-find-header-file)
	     (define-key xgtags-mode-map (kbd "C-c a e") 'xgtags-find-with-grep)
	     (define-key xgtags-mode-map (kbd "C-c a s") 'xgtags-find-symbol) ; inconvinient, but I do not use this often
	     (define-key xgtags-mode-map (kbd "C-c a c") 'xgtags-find-rtag)
	     (define-key xgtags-mode-map (kbd "C-c a g") 'xgtags-find-tag)
	     ))

(setq xgtags-goto-tag 'unique)

;(defun my-generate-gtags-files ()
;  "Generate gtags reference file for global."
;  (interactive)
;  (cd
;   (read-from-minibuffer
;    "directory: "
;    default-directory))
;  (shell-command "gtags --gtagslabel gtags")
;  (xgtags-make-complete-list))

(custom-set-faces
 ;; xgtags faces
 ;;
 '(xgtags-file-face ((t (:foreground "salmon3" :weight bold))))
 '(xgtags-match-face ((((class color) (background dark)) (:foreground "green3"))))
 '(xgtags-line-number-face ((((class color) (background dark)) (:foreground "maroon3"))))
 '(xgtags-line-face ((((class color) (background dark)) (:foreground "yellow3"))))
 '(xgtags-file-selected-face ((t (:foreground "salmon3" :weight bold))))
 '(xgtags-match-selected-face ((t (:foreground "green2" :weight bold))))
 '(xgtags-line-selected-face ((t (:foreground "yellow2" :weight bold))))
 '(xgtags-line-number-selected-face ((t (:foreground "maroon2" :weight bold))))
 )

;; xgtags-select-mode-hook
(add-hook 'xgtags-select-mode-hook
	  '(lambda ()
	     (define-key xgtags-select-mode-map (kbd "RET") 'xgtags-select-tag-near-point)
	     ))

;(defun xgtags-select-tag-other-window ()
;  "Selete gtag tag other window."
;  (interactive)
;  (xgtags-select-tag-near-point)
;  (delete-other-windows)
;  (split-window-vertically 12)
;  (switch-to-buffer "*xgtags*"))

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (xgtags-mode 1)))