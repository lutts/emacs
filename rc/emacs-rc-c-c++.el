;;; C/C++ Settings

;;; ppindent config:indenting preprocessor statement
;;; provide two funcitons: ppindent-c and ppindent-h
(require 'ppindent)

;;; C mode configurations

;; gtags
;(load "~/emacs/rc/emacs-rc-gtags.el")

;; xgtags
(load "~/emacs/rc/emacs-rc-xgtags.el")

(defun my-cc-mode-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist '(
                              ;(?` ?` _ "''")
			      (?` -1 ?{ " " _ " " ?}?, >)
                              (?\" _ "\"")
			      (?< _ ">")
			      (?{ > \n > _ \n ?} >)))
  (setq skeleton-pair t)
;(local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  ;(local-set-key (kbd "`") 'skeleton-pair-insert-maybe)
;(local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
;(local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
;(local-set-key (kbd "<") 'skeleton-pair-insert-maybe)
  )

;(add-hook 'c-mode-common-hook 'my-cc-mode-auto-pair)

;(require 'autopair)
;(autopair-global-mode)


;(defun electric-pair ()
;      "If at end of line, insert character pair without surrounding spaces.
;    Otherwise, just insert the typed character."
;      (interactive)
;      (if (eolp) (let (parens-require-spaces) (insert-pair)) (self-insert-command 1)))
;
;(add-hook 'c-mode-common-hook
;	  (lambda ()
;	    (local-set-key (kbd "\"") 'electric-pair)
;	    (local-set-key (kbd "\'") 'electric-pair)
;	    (local-set-key (kbd "(") 'electric-pair)
;	    (local-set-key (kbd "[") 'electric-pair)
;	    (local-set-key (kbd "{") 'electric-pair)))

;; automatically delete trailing whitespace when save buffer
(defun progmodes-hooks ()
  "Hooks for programming modes"
  (add-hook 'before-save-hook 'progmodes-write-hooks))

(defun progmodes-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (delete-trailing-whitespace)))

(add-hook 'c-mode-common-hook 'progmodes-hooks)

;; Setting Tab to indent region if anything i selected
(defun tab-indents-region ()
  (local-set-key (kbd "<tab>") 'fledermaus-maybe-tab)
  )

(defun fledermaus-maybe-tab ()
  (interactive)
  (if (and transient-mark-mode mark-active)
      (indent-region (region-beginning) (region-end) nil)
    (c-indent-command)))

(add-hook 'c-mode-common-hook
	  '(lambda()
	     ;;preprocessor
	     (setq c-macro-prompt-flag t)
	     (setq c-basic-offset 4)
	     (setq tab-width 4 indent-tabs-mode t)
	     (setq fill-column 80)
	     (setq comment-column 30)
	     (highlight-parentheses-mode 1)
	     (tab-indents-region)
             ;;bind newline-and-indent to RET
	     (local-set-key (kbd "RET") 'newline-and-indent)
	     (local-set-key (kbd "C-c ;") 'comment-line)
	     (c-toggle-hungry-state 1)
	     (delete-selection-mode t)
	     ; can use M-x delete-trailing-whitespace <RET> to delete all trailing whitespace within cur buf
	     (setq show-trailing-whitespace t)
	     (paren-toggle-open-paren-context 1)
	     ;cscope configuration
	     (require 'xcscope)
	     (setq cscope-do-not-update-database t)
	     (require 'ifdef)
	     (imenu-add-menubar-index)
	     )
	  )

(defun my-c-common-hook ()
  (setq c-basic-offset 8)
  (setq tab-width 8 indent-tabs-mode t)
)

(defun my-c++-common-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4 indent-tabs-mode nil)
)

(add-hook 'c-mode-hook 'my-c-common-hook)
(add-hook 'c++-mode-hook 'my-c++-common-hook)

;; linux kernel codeing style
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
			 (or (string-match "linux" filename)
			     (string-match "kernel" filename)))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))

;;; C++ mode configurations
;(add-hook 'c++-mode-hook
;	  '(lambda ()
;	     (c-set-style "stroustrup")))
