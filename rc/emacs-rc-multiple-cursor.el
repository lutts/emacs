;; Homepage: https://github.com/magnars/multiple-cursors.el

(require 'multiple-cursors)
;;; smartparents-mode's autopair messes with multiple cursors, so disable it
(add-hook 'multiple-cursors-mode-enabled-hook (lambda ()
                                                (smartparens-mode -1)))
(add-hook 'multiple-cursors-mode-disabled-hook (lambda ()
						 (smartparens-mode t)))

;; useful variables you may be want to check their value
;; mc/cmds-to-run-for-all
;; mc/cmds-to-run-once
