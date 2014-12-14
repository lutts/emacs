;;; environment variables
(when (equal system-type 'gnu/linux)
      (message "Emacs Run on GNU/Linux")
      (setenv "PATH" (concat "/home/lutts/lib/Qt5_debug/bin:/opt/texlive/2011/bin/x86_64-linux:" (getenv "PATH")))
      (setenv "MY_GTAGSLIBPATH" "/home/lutts/devel1/Qt/qt-everywhere-opensource-src-5.3.2")
      (setq exec-path (append exec-path '("/home/lutts/lib/Qt5_debug/bin")))
      (setq exec-path (append exec-path '("/opt/texlive/2011/bin/x86_64-linux"))))

(when (string= (getenv "USER") "lutts")
  (setenv "PATH" (concat (getenv "PATH") ":/home/lutts/tools/bin:/home/lutts/tools/usr/sbin:/home/lutts/tools/usr/bin"))
  (setq exec-path (append exec-path '("/home/lutts/tools/bin")))
  (setq exec-path (append exec-path '("/home/lutts/tools/usr/sbin")))
  (setq exec-path (append exec-path '("/home/lutts/tools/usr/bin")))
)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(ecb-layout-name "lutts")
 '(ecb-layout-window-sizes (quote (("lutts" (0.23684210526315788 . 0.4791666666666667) (0.23684210526315788 . 0.5) (0.19473684210526315 . 0.9791666666666666)) ("left-symboldef" (0.3263157894736842 . 0.2916666666666667) (0.3263157894736842 . 0.22916666666666666) (0.3263157894736842 . 0.22916666666666666) (0.3263157894736842 . 0.22916666666666666)))))
 '(ecb-options-version "2.40")
 '(menu-bar-mode t)
 '(mode-line-format (quote ("%e" #("-" 0 1 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification #("   " 0 3 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) mode-line-position (vc-mode vc-mode) #("  " 0 2 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) (which-func-mode ("" which-func-format #("--" 0 2 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")))) mode-line-modes  (global-mode-string (#("--" 0 2 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")) global-mode-string)) #("-%-" 0 3 (help-echo "mouse-1: Select (drag to resize)
mouse-2: Make current window occupy the whole frame
mouse-3: Remove current window from display")))))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(tabbar-selected-face ((t (:inherit tabbar-default-face :foreground "blue" :box (:line-width 2 :color "white" :style pressed-button)))))
 '(tabbar-unselected-face ((t (:inherit tabbar-default-face :foreground "DarkGreen" :box (:line-width 2 :color "white" :style released-button))))))

;(add-to-list 'safe-local-variable-values '(MY_GTAGSLIBPATH . "/home/lutts/devel1/Qt/qt-everywhere-opensource-src-5.3.2"))
(put 'MY_GTAGSLIBPATH 'safe-local-variable (lambda (xx) t))

;;;;;;;;;;;;;;;; standard emacs setting that do not depend on third party addons ;;;;;;;;;;;;;;;;

;;; so we can use emacsclient to start a buffer
(server-start)

;;; remove the boring startup message
(setq inhibit-startup-message t)

(setq user-full-name "Lutts Cao")
(setq user-mail-address "lutts.cao@gmail.com")

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;;; Emacs title bar to reflect file name
(defun frame-title-string ()
   "Return the file name of current buffer, using ~ if under home directory"
   (let
      ((fname (or
                 (buffer-file-name (current-buffer))
                 (buffer-name))))
      ;;let body
      (when (string-match (getenv "HOME") fname)
        (setq fname (replace-match "~" t t fname)))
      fname))

(setq frame-title-format '((:eval (frame-title-string))))
(setq icon-title-format "%b")

;;;window size and initial position
;(set-frame-height (selected-frame) 48)
(set-frame-position (selected-frame) 0 0)

;;; we want to keep the line as is, we are programmers, we have no long lines
(setq line-move-visual nil)
;;; must set line-move-visual to nil to set track-eol
(setq track-eol t)

(setq default-major-mode 'text-mode)

(setq make-backup-files nil) ; Don't want any backup files

;;; bridge emacs to system clipboard, to we can copy and paste between emacs and the system apps
(setq x-select-enable-clipboard t)

;;; yes, we are programmers
(setq-default fill-column 80)

;;; auto revert mode configuration
;;; revert buffer periodly, so we can edit a file in another place and emacs will reflect the change imediatly
(global-auto-revert-mode 1)

;;; display time in 24hour format in mode line
;;(display-time-mode 1)
;;(setq display-time-24hr-format t)
;;(setq display-time-day-and-date t)

;;; mouse releated
(mouse-avoidance-mode 'animate)
;; Enable the mouse wheel
(mouse-wheel-mode t)
;; Mouse wheel scrolls buffer under pointer; this is useful for examining a
;; help buffer or something
(setq mouse-wheel-follow-mouse t)

;(setq scroll-conservatively 10000)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; scale text when Ctrl+wheel
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

;(global-set-key "\C-x\C-b" 'buffer-menu)

;;copy word
(defun copy-word (&optional arg)
  "Copy words at point."
  (interactive "P")
  (save-excursion
    (let ((beg (progn (if (looking-back "[a-zA-Z]" 1) (backward-word 1)) (point)))
	  (end (progn (forward-word arg) (point))))
      (copy-region-as-kill beg end))
    )
)

(global-set-key (kbd "C-c w") 'copy-word)

;;copy line
(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line."
  (interactive "P")
  (save-excursion
    (let (
	  (beg (line-beginning-position))
	  (end (line-end-position))
	  )
      (copy-region-as-kill beg end)
      )
    )
)

(global-set-key (kbd "C-c l") 'copy-line)

;; format(indent) the code after yank
(dolist (command '(yank yank-pop))
       (eval `(defadvice ,command (after indent-region activate)
                (and (not current-prefix-arg)
                     (member major-mode '(emacs-lisp-mode lisp-mode
                                                          clojure-mode    scheme-mode
                                                          haskell-mode    ruby-mode
                                                          rspec-mode      python-mode
                                                          c-mode          c++-mode
                                                          objc-mode       plain-tex-mode))
                     (let ((mark-even-if-inactive transient-mark-mode))
                       (indent-region (region-beginning) (region-end) nil))))))

(defun insert-new-line-up ()
  "Opens a new line before the current line.
Equivalent to beginning-of-line, open-line."
  (interactive)
  (beginning-of-line)
  (open-line 1)
  (indent-according-to-mode))

(global-set-key (kbd "<C-S-return>") 'insert-new-line-up)

(defun insert-new-line-down ()
  "Opens a new line after the current line. "
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(global-set-key (kbd "<C-return>") 'insert-new-line-down)


;; Shift the select region right if distance if posive, left if negative
(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark tt)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys.
(global-set-key [C-S-right] 'shift-right)
(global-set-key [C-S-left] 'shift-left)

;;comment line(bind to `Ctrl-c ;' in C mode)
(defun comment-line (&optional arg)
  "Comment the line where the point is in."
  (interactive "P")
  (save-excursion
    (let (
	  (beg (line-beginning-position))
	  (end (line-end-position))
	  )
      (comment-region beg end arg)
      )))


;; delete selection mode(replace by type text,delete by DEL)
(delete-selection-mode t)

;; display the current function name in the mode line
(which-function-mode t)

;; if the current character is `tab', strech the cursor
(setq x-stretch-cursor t)

;; see metching pairs of parenttheses
(show-paren-mode 1)

(setq tramp-mode nil)

;; turn on image file support
(auto-image-file-mode)

;; don't use dialog boxes to ask questions
(setq use-dialog-box nil)

;; don't use a file dialog to ask for files
(setq use-file-dialog nil)

;; font settings
(if (display-graphic-p)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
			charset
			(font-spec :family "Microsoft YaHei" :size 14))))

;;(set-face-attribute 'default nil
;;		    :family "Consolas" :height 120)

(set-face-attribute 'default nil
		    :family "Anonymous Pro" :height 120)

;;;;;;;;;;;;;;;; third-party addons ;;;;;;;;;;;;;;;;

;;; add commonly used paths
(setq my-base-path "~/emacs/")

(add-to-list 'load-path (concat my-base-path "cc-mode"))
(add-to-list 'load-path (concat my-base-path "elisp"))
(add-to-list 'load-path (concat my-base-path "elisp/bookmarkplus"))

(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; load common utilities
;(require 'ahei-misc)
;(require 'eval-after-load)
;(require 'util)

(load (concat my-base-path "rc/emacs-rc-color-theme.el"))

;;tabbar
(require 'tabbar)
(tabbar-mode)
(global-set-key [(control >)] 'tabbar-forward-tab)
(global-set-key [(control <)] 'tabbar-backward-tab)

;;; highlight line
(require 'highline)
;(setq highline-face 'highlight)
(set-face-background 'highline-face "#2d2d2d")
(global-highline-mode 1)

;;; highlight the matching parentheses surrounding point
(require 'highlight-parentheses)

;;; mic-paren
(require 'mic-paren)
(paren-activate)
(setq paren-message-show-linenumber 'absolute)

;;; session restore
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

;;; make shell scirpt executable after save
(setq prefix-function-name t)
(require 'shebang)

;;; highlight symbol
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)

;; GIT
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; smooth scrolling
(require 'smooth-scrolling)
(load (concat my-base-path "rc/emacs-rc-lutts.el"))
(load (concat my-base-path "rc/emacs-rc-eshell.el"))
(load (concat my-base-path "rc/emacs-rc-buffer-switching.el"))

;; company mode
(add-hook 'after-init-hook 'global-company-mode)

;(load (concat my-base-path "rc/emacs-rc-cedet.el"))
;(load (concat my-base-path "rc/emacs-rc-ecb.el"))
(load (concat my-base-path "rc/emacs-rc-c-c++.el"))
(load (concat my-base-path "rc/emacs-rc-hide-show.el"))
(load (concat my-base-path "rc/emacs-rc-java.el"))
;(load (concat my-base-path "rc/emacs-rc-auto-complete.el"))
(load (concat my-base-path "rc/emacs-rc-desktop.el"))

;;; smartparents
(load (concat my-base-path "rc/emacs-rc-smartparens.el"))

(load (concat my-base-path "rc/emacs-rc-cmake.el"))


;; elpy
;(elpy-enable)
;(setq elpy-rpc-backend "jedi")

;; ibus mode
;; do not enable ibus by default because I rarely use it
;(require 'ibus)
;(add-hook 'after-make-frame-functions
;	  (lambda (new-frame)
;	    (select-frame new-frame)
;	    (or ibus-mode (ibus-mode-on))))

;; bookmark manager
(require 'bm)
(global-set-key (kbd "<C-f5>") 'bm-toggle)
(global-set-key (kbd "<f5>")   'bm-next)
(global-set-key (kbd "<S-f5>") 'bm-previous)

;;increase max-specpdl-size this big to start the debugger
;(setq max-specpdl-size  5000)

(split-window-tile-3)

;;;;;;;;;; required packages ;;;;;;;;;;;;
;;     name       --- list-packages name  --- homepage
;; * company mode --- company             --- http://company-mode.github.io/

(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
(add-to-list 'yas-snippet-dirs (concat my-base-path "snippets"))
(yas-reload-all)

;(define-key yas-minor-mode-map (kbd "<tab>") nil)
;(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "C-=") 'yas/expand)

(defun yas--magit-email-or-default ()
  "Get email from GIT or use default"
  (if (magit-get-top-dir ".")
      (magit-get "user.email")
    user-mail-address))

(defun yas--magit-username-or-default ()
  "Get username from GIT or use default"
  (if (magit-get-top-dir ".")
      (magit-get "user.name")
    user-full-name))

;; auto-insert
(auto-insert-mode)
(setq auto-insert-directory (concat my-base-path "auto-insert"))
(setq auto-insert-query nil)  ; If you don't want to be prompted before insertion

(define-auto-insert "\\.\\([C]\\|cc\\|cpp\\)$"  "template.c")
(define-auto-insert "\\.\\([Hh]\\|hh\\|hpp\\)$" "template.h")
;(define-auto-insert "\\.sh$" "template.sh")
;(define-auto-insert "\\.el$" "template.el")
;(define-auto-insert "\\.py$" "template.py")

(defadvice auto-insert  (around yasnippet-expand-after-auto-insert activate)
  "expand auto-inserted content as yasnippet templete,
  so that we could use yasnippet in autoinsert mode"
  (let ((is-new-file (and (not buffer-read-only)
                          (or (eq this-command 'auto-insert)
                              (and auto-insert (bobp) (eobp))))))
    ad-do-it
    (let ((old-point-max (point-max))
          (yas-indent-line nil))
      (when is-new-file
        (goto-char old-point-max)
        (yas-expand-snippet (buffer-substring-no-properties (point-min) (point-max)))
        (delete-region (point-min) old-point-max)))))

;(add-to-list 'load-path "~/.emacs.d/plugins/cpputils-cmake")
;(require 'cpputils-cmake)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
