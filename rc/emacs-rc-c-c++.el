;;; C/C++ Settings

;;; ppindent config:indenting preprocessor statement
;;; provide two funcitons: ppindent-c and ppindent-h
(require 'ppindent)

;;; C mode configurations

;; xgtags
(load (concat my-base-path "rc/emacs-rc-xgtags.el"))

;; automatically delete trailing whitespace when save buffer
(defun progmodes-hooks ()
  "Hooks for programming modes"
  (add-hook 'before-save-hook 'progmodes-write-hooks))

(defun progmodes-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (delete-trailing-whitespace)))

(add-hook 'c-mode-common-hook 'progmodes-hooks)

;; Setting Tab to indent region if anything is selected
(defun tab-indents-region ()
  (local-set-key (kbd "<tab>") 'fledermaus-maybe-tab)
  )

(defun fledermaus-maybe-tab ()
  (interactive)
  (if (and transient-mark-mode mark-active)
      (indent-region (region-beginning) (region-end) nil)
    (c-indent-command)))

(defun qt-customizations ()
  "Set up c-mode and related modes. Includes support for Qt code (signal, slots and alikes)."

  ;; base-style
  ;; (c-set-style "stroustrup")
  ;; qt keywords and stuff ...
  ;; set up indenting correctly for new qt kewords
  (setq c-protection-key (concat "\\<\\(public\\|public slot\\|protected"
                                 "\\|protected slot\\|private\\|private slot"
                                 "\\)\\>")
        c-C++-access-key (concat "\\<\\(signals\\|public\\|protected\\|private"
                                 "\\|public slots\\|protected slots\\|private slots"
                                 "\\)\\>[ \t]*:"))

  ;; modify the colour of slots to match public, private, etc ...
  (font-lock-add-keywords 'c++-mode '(("\\<\\(slots\\|signals\\)\\>" . font-lock-type-face)))
  ;; make new font for rest of qt keywords
  (make-face 'qt-keywords-face)
  (set-face-foreground 'qt-keywords-face "BlueViolet")
  ;; qt keywords
  (font-lock-add-keywords 'c++-mode '(("\\<Q_[A-Z]*\\>" . 'qt-keywords-face)))
  (font-lock-add-keywords 'c++-mode '(("\\<SIGNAL\\|SLOT\\>" . 'qt-keywords-face)))
  (font-lock-add-keywords 'c++-mode '(("\\<Q[A-Z][A-Za-z]*\\>" . 'qt-keywords-face)))
  (font-lock-add-keywords 'c++-mode '(("\\<Q[A-Z_]+\\>" . 'qt-keywords-face)))
  (font-lock-add-keywords 'c++-mode
                          '(("\\<q\\(Debug\\|Wait\\|Printable\\|Max\\|Min\\|Bound\\)\\>" . 'font-lock-builtin-face)))

  (setq c-macro-names-with-semicolon '("Q_OBJECT" "Q_PROPERTY" "Q_DECLARE" "Q_ENUMS"))
  (c-make-macro-with-semi-re)
  )

;; and treat .pro files like makefiles
(setq auto-mode-alist (cons '("\\.pro$" . makefile-mode) auto-mode-alist))

; Make .h files be C++ mode
(setq auto-mode-alist(cons '("\\.h$"   . c++-mode)  auto-mode-alist))

(add-hook 'c-mode-common-hook 'qt-customizations)

(setq cc-other-file-alist
 (quote
  (("\\.cc\\'"
    (".h" ".hh"))
   ("\\.hh\\'"
    (".cc" ".C"))
   ("\\.c\\'"
    (".h"))
   ("\\.m\\'"
    (".h"))
   ("\\.h\\'"
    (".cc" ".c" ".C" ".CC" ".cxx" ".cpp" ".m"))
   ("\\.C\\'"
    (".H" ".hh" ".h"))
   ("\\.H\\'"
    (".C" ".CC"))
   ("\\.CC\\'"
    (".HH" ".H" ".hh" ".h"))
   ("\\.HH\\'"
    (".CC"))
   ("\\.c\\+\\+\\'"
    (".h++" ".hh" ".h"))
   ("\\.h\\+\\+\\'"
    (".c++"))
   ("\\.cpp\\'"
    (".hpp" ".hh" ".h"))
   ("\\.hpp\\'"
    (".cpp"))
   ("\\.cxx\\'"
    (".hxx" ".hh" ".h"))
   ("\\.hxx\\'"
    (".cxx")))))

(add-hook 'c-mode-common-hook
	  '(lambda()
	     ;;preprocessor
	     (setq c-macro-prompt-flag t)
	     (setq fill-column 80)
	     (setq comment-column 30)
	     (highlight-parentheses-mode 1)
	     (tab-indents-region)
             ;;bind newline-and-indent to RET
	     (local-set-key (kbd "RET") 'newline-and-indent)
	     (local-set-key (kbd "C-c ;") 'comment-line)
	     (local-set-key (kbd "C-x C-o") 'ff-find-other-file)
	     (local-set-key (kbd "C-x C-u") 'lutts-switch-to-test-file)
	     (local-set-key (kbd "C-c .") 'company-gtags)
	     (local-set-key (kbd "M-/") 'company-dabbrev)
	     (local-set-key (kbd "C-c m") 'compile)
	     (local-set-key (kbd "C-c i") 'recompile)
	     (local-set-key (kbd "C-c g") 'magit-status)
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
	     ; company mode settings
	     (setq company-backends (delete 'company-semantic company-backends))
	     (add-to-list 'company-clang-arguments "-fPIE -std=c++11 -v")
	     ;(setq company-backends (delete 'company-clang company-backends))
	     )
	  )

(require 'compile)
(setq compilation-scroll-output 'first-error)

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (format "make -C %s"
			 (locate-dominating-file
			  default-directory
			  (lambda (parent)
			    (directory-files parent nil ".*Makefile$")))))))

(defun my-c-common-hook ()
  (setq c-basic-offset 8)
  (setq tab-width 8 indent-tabs-mode t)
)


(add-hook 'c-mode-hook 'my-c-common-hook)

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

;; C++ Coding Style
;(add-hook 'c++-mode-hook
;	  '(lambda ()
;	     (c-set-style "stroustrup")))

;(defun my-c++-common-hook ()
;  (setq tab-width 4 indent-tabs-mode nil)
;  )
;
;(add-hook 'c++-mode-hook 'my-c++-common-hook)

;; if using google style, uncomment this line
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;(load (concat my-base-path "rc/emacs-rc-tempo.el"))

;(add-hook 'c-mode-common-hook
;          (lambda ()
;            (if (derived-mode-p 'c-mode 'c++-mode)
;                (cppcm-reload-all)
;              )))
