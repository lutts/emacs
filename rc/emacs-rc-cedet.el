;;; cedet

(add-to-list 'load-path "~/emacs/cedet-1.1/common")

(defvar user-include-dirs
  '("."
    "./include"
    "./common"
    )
  "User include dirs for c/c++ mode")

(load-file "~/emacs/cedet-1.1/common/cedet.el")
(global-ede-mode 1)
(ede-enable-generic-projects)

(require 'ede-linux)

;;; semantic mode selection
;; (semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(semantic-load-enable-gaudy-code-helpers)
(semantic-load-enable-excessive-code-helpers)

;; smart complitions
(require 'semantic-ia)
(require 'semantic-c)

(setq-mode-local c-mode semanticdb-find-default-throttle
		 '(project unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
		 '(project unloaded system recursive))

;(global-semantic-decoration-mode 1)
;(require 'semantic-decorate-include nil 'noerror)
;(semantic-toggle-decoration-style "semantic-tag-boundary" -1)

(if window-system
    (semantic-load-enable-semantic-debugging-helpers)
  (progn (global-semantic-show-unmatched-syntax-mode 1)
	 (global-semantic-show-parser-state-mode 1)))

;(ignore-errors (semantic-load-enable-primary-exuberent-ctags-support))

(global-srecode-minor-mode 1)

;; gnu global support
(when (cedet-gnu-global-version-check t)
  (message "Found gnu global on this system")
  (require 'semanticdb-global)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

;; ctags
(when (cedet-ectag-version-check t)
  (message "Found ctags on this system")
  (require 'semanticdb-ectag)
  (semantic-load-enable-primary-exuberent-ctags-support))

(mapc (lambda (dir)
	(semantic-add-system-include dir 'c++-mode)
	(semantic-add-system-include dir 'c-mode))
      user-include-dirs)

(ede-linux-project-root "/home/lutts/android/disk2/linux/4780/linux-2.6.31.3")
