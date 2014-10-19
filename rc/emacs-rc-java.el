;; java settings begin

(require 'java-mode-indent-annotations)

(add-hook 'java-mode-hook
	  '(lambda()
	     (setq c-basic-offset 4
		   tab-width 4
		   indent-tabs-mode nil)
	     (java-mode-indent-annotations-setup)
	     (xgtags-mode 1)
	     ))

(autoload 'smali-mode "smali-mode.el" "Major mode for editing smali files" t)
(setq auto-mode-alist
      (cons '("\\.smali" . smali-mode) auto-mode-alist))

;; java settings end
