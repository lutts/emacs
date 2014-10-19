;; gtags
(autoload 'gtags-mode "gtags" "" t)

(add-hook 'gtags-mode-hook
	  '(lambda ()
	     (define-key gtags-mode-map (kbd "C-c a f") 'gtags-find-file-other-window)
	     (define-key gtags-mode-map (kbd "C-c a p") 'gtags-parse-file)
	     (define-key gtags-mode-map (kbd "C-c a e") 'gtags-find-with-grep-other-window)
	     (define-key gtags-mode-map (kbd "C-c a s") 'gtags-find-symbol-other-window)
	     (define-key gtags-mode-map (kbd "C-c a c") 'gtags-find-rtag-other-window)
	     (define-key gtags-mode-map (kbd "C-c a g") 'gtags-find-tag-other-window)
	     ))

(add-hook 'gtags-select-mode-hook
	  '(lambda ()
	     (setq hl-line-face 'underline)
	     (hl-line-mode 1)
	     (define-key gtags-select-mode-map (kbd "RET") 'gtags-select-tag-other-window)
	     ))

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (xgtags-mode 1)))