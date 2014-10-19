;; java settings begin
(add-hook 'java-mode-hook
	  '(lambda()
	     (gtags-mode 1)
	     ))

(autoload 'smali-mode "smali-mode.el" "Major mode for editing smali files" t)
(setq auto-mode-alist
      (cons '("\\.smali" . smali-mode) auto-mode-alist))

;; java settings end