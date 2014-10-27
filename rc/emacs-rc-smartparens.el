(require 'smartparens-config)

(setq sp-show-pair-delay 0)
(setq sp-highlight-pair-overlay nil)
(setq sp-autoescape-string-quote nil)

(smartparens-global-mode t)

;; https://github.com/Fuco1/smartparens/wiki/Permissions#pre-and-post-action-hooks
(sp-local-pair '(c-mode c++-mode) "{" nil
	       :post-handlers '((my-create-newline-and-enter-sexp "RET")))
(defun my-create-newline-and-enter-sexp (&rest _ignored)
  "Open a new brace or bracket expression, with relevant newlines and indent."
  (newline)
  (forward-line -2)
  (indent-according-to-mode)
  (forward-line)
  (indent-according-to-mode)
  (forward-line)
  (indent-according-to-mode)
  (forward-line -1)
  (indent-according-to-mode))
