;;; C/C++ Settings

;;; ppindent config:indenting preprocessor statement
;;; provide two funcitons: ppindent-c and ppindent-h
(require 'ppindent)

;;; C mode configurations

;; gtags
(autoload 'gtags-mode "gtags" "" t)

(add-hook 'gtags-select-mode-hook
	  '(lambda ()
	     (setq hl-line-face 'underline)
	     (hl-line-mode 1)
	     ))

(add-hook 'gtags-mode-hook
	  '(lambda ()
	     (define-key gtags-mode-map (kbd "C-c a b") 'gtags-pop-stack)
	     (define-key gtags-mode-map (kbd "C-c a f") 'gtags-find-file)
	     (define-key gtags-mode-map (kbd "C-c a p") 'gtags-parse-file)
	     (define-key gtags-mode-map (kbd "C-c a e") 'gtags-find-with-grep)
	     (define-key gtags-mode-map (kbd "C-c a s") 'gtags-find-symbol)
	     (define-key gtags-mode-map (kbd "C-c a c") 'gtags-find-rtag)
	     (define-key gtags-mode-map (kbd "C-c a g") 'gtags-find-tag)
	     ))

(add-hook 'gtags-select-mode-hook
	  '(lambda ()
	     (define-key gtags-select-mode-map (kbd "RET") 'gtags-select-tag)
	     ))

(add-hook 'c-mode-common-hook
	  '(lambda()
	     ;;preprocessor
	     (setq c-macro-prompt-flag t)
	     (setq c-basic-offset 8)
	     (setq tab-width 8 indent-tabs-mode t)
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
	     (gtags-mode 1)
	     (require 'ifdef)
	     (local-set-key (kbd "C-c I") 'ifdef-mark)
	     (imenu-add-menubar-index)
	     )
	  )

;; linux kernel codeing style
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
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
			 (string-match "linux" filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))

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

;;; C++ mode configurations
(add-hook 'c++-mode-hook
	  '(lambda ()
	     (c-set-style "stroustrup")
	     (c-subword-mode 1)))

