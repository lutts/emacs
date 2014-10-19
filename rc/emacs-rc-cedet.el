;;; cedet

(add-to-list 'load-path "~/emacs/elisp/cedet-1.1/common")
(load-file "~/emacs/elisp/cedet-1.1/common/cedet.el")

;; (semantic-load-enable-minimum-features)
;;; semantic-idle-scheduler-mode
;;; semanticdb-minor-mode
;;; semanicdb-load-ebrowse-caches

(semantic-load-enable-code-helpers)
;;; minimum features
;;; imenu (TAGS)
;;; semantic-idle-summary-mode (show prototype on minibuffer)
;;; senator-minor-mode (senator menu)
;;; semantic-mru-bookmark-mode

;; (semantic-load-enable-gaudy-code-helpers)
;;; include enable-code-helpers
;;; semantic-stikyfunc-mode (TODO: turn off this feature)
;;; semantic-decoration-mode
;;; semantic-idle-comletions-mode

;; (semantic-load-enable-excessive-code-helpers)
;;; all above
;;; semantic-highlight-func-mode
;;; semantic-idle-highlight-mode
;;; semantic-decoration-on-*-members
;;; which-func-mode

(if window-system
    (semantic-load-enable-semantic-debugging-helpers)
  (progn (global-semantic-show-unmatched-syntax-mode 1)
	 (global-semantic-show-parser-state-mode 1)))

(custom-set-variables
 '(semantic-idle-scheduler-idle-time 3)
 '(semantic-self-insert-show-completion-function (lambda nil (semantic-ia-complete-symbol-menu (point))))
 '(global-semantic-tag-folding-mode t nil (semantic-util-modes)))

(setq senator-minor-mode-name "SN")
(setq semantic-imenu-auto-rebuild-directory-indexes nil)
(global-srecode-minor-mode 1)
(global-semantic-mru-bookmark-mode 1)
(global-semantic-decoration-mode 1)

(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1)

(require 'semantic-decorate-include nil 'noerror)

;; smart complitions
(require 'semantic-ia)

(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq-mode-local erlang-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))

;(ignore-errors (semantic-load-enable-primary-exuberent-ctags-support))

(require 'eassist)

;; customisation of modes
(defun alexott/cedet-hook ()
;  (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
  (local-set-key "\M-n" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
  ;;
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cf" 'semantic-complete-jump)
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cy" 'semantic-ia-show-summary)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key (kbd "C-c -") 'semantic-tag-folding-fold-block)
  (local-set-key (kbd "C-c +") 'semantic-tag-folding-show-block)
  (local-set-key [f11]  'semantic-mrub-switch-tags)
  )

;; for gdb debug fringe switch, it will not work when folding mode is on
(global-set-key (kbd "C-?") 'global-semantic-tag-folding-mode)

;; (add-hook 'semantic-init-hooks 'alexott/cedet-hook)
(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'scheme-mode-hook 'alexott/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'alexott/cedet-hook)
(add-hook 'erlang-mode-hook 'alexott/cedet-hook)

(defun alexott/c-mode-cedet-hook ()
  ;; (local-set-key "." 'semantic-complete-self-insert)
  ;; (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-ct" 'eassist-switch-h-cpp)
  (local-set-key "\C-xt" 'eassist-switch-h-cpp)
  (local-set-key "\C-cm" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)
  )
(add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook)

;; gnu global support
(when (cedet-gnu-global-version-check t)
  (require 'semanticdb-global)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

(setq semantic-symref-tool 'global)

;; ctags
(when (cedet-ectag-version-check t)
  (require 'semanticdb-ectag)
  (semantic-load-enable-primary-exuberent-ctags-support))

;; common includes for all projects
;; (semantic-add-system-include "~/exp/include" 'c++-mode)
;; (semantic-add-system-include "~/exp/include" 'c-mode)

(defun recur-list-files (dir re)
  "Returns list of files in directory matching to given regex"
  (when (file-accessible-directory-p dir)
    (let ((files (directory-files dir t))
          matched)
      (dolist (file files matched)
        (let ((fname (file-name-nondirectory file)))
          (cond
           ((or (string= fname ".")
                (string= fname "..")) nil)
           ((and (file-regular-p file)
                 (string-match re fname))
            (setq matched (cons file matched)))
           ((file-directory-p file)
            (let ((tfiles (recur-list-files file re)))
              (when tfiles (setq matched (append matched tfiles)))))))))))

;(defun c++-setup-boost (boost-root)
;  (when (file-accessible-directory-p boost-root)
;    (let ((cfiles (recur-list-files boost-root "\\(config\\|user\\)\\.hpp")))
;      (dolist (file cfiles)
;        (add-to-list 'semantic-lex-c-preprocessor-symbol-file file)))))

;;; ede customization
(require 'semantic-lex-spp)
(global-ede-mode t)
(ede-enable-generic-projects)
(require 'ede-linux)
(setq ede-locate-setup-options '(ede-locate-global ede-locate-base))

;
;(ede-cpp-root-project "Test"
;		      :name "Test Project"
;		      :file "~/work/project/CMakeLists.txt"
;		      :include-path '("/"
;				      "/Common"
;				      "/Interfaces"
;				      "/Libs"
;				      )
;		      :system-include-path '("~/exp/include")
;		      :spp-table '(("isUnix" . "")
;				   ("BOOST_TEST_DYN_LINK" . "")))
;


;; cpp-tests project definition
;(when (file-exists-p "~/projects/lang-exp/cpp/CMakeLists.txt")
;  (setq cpp-tests-project
;	(ede-cpp-root-project "cpp-tests"
;			      :file "~/projects/lang-exp/cpp/CMakeLists.txt"
;			      :system-include-path '("/home/ott/exp/include"
;						     boost-base-directory)
;			      :local-variables (list
;						(cons 'compile-command 'alexott/gen-cmake-debug-compile-string)
;						)
;			      )))

;(when (file-exists-p "~/work/emacs-head/README")
;  (setq emacs-project
;	(ede-emacs-project "emacs-head"
;			   :file "~/work/emacs-head/README")))