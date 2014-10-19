(require 'hideif)
(setq hide-ifdef-initially nil)

(defun hideif-hide-if0 ()
  "hide #if 0 blocks"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*#if[ \t]*0" nil t) (hide-ifdef-block))))

(defun hif-goto-endif ()
  "Goto #endif."
  (interactive)
  (unless (or (hif-looking-at-endif)
              (save-excursion)
	      (hif-ifdef-to-endif))))

(defun hif-goto-if ()
  "Goto #if."
  (interactive)
  (hif-endif-to-ifdef))

(defun hif-gototo-else ()
  "Goto #else."
  (hif-find-next-relevant)
  (cond ((hif-looking-at-else)
         'done)
	(hif-ifdef-to-endif) ; find endif of nested if
	(hif-ifdef-to-endif)) ; find outer endif or else
  ((hif-looking-at-else)
   (hif-ifdef-to-endif)) ; find endif following else
  ((hif-looking-at-endif)
   'done)
  (t
   (error "Mismatched #ifdef #endif pair")))

(require 'hide-comnt)

(require 'hide-region)
(setq hide-region-before-string "[======================该区域已")
(setq hide-region-after-string "被折叠======================]\n")


(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'java-mode-hook     'hs-minor-mode)

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (hide-ifdef-mode 1)
	    ;; hide-ifdef-mode
	    (define-key c-mode-base-map (kbd "C-c h C-h") 'hide-ifdef-block)
	    (define-key c-mode-base-map (kbd "C-c h C-s") 'show-ifdef-block)
	    (define-key c-mode-base-map (kbd "C-c h C-M-h") 'hide-ifdefs)
	    (define-key c-mode-base-map (kbd "C-c h C-M-s") 'show-ifdefs)

	    ;; hs-minor-mode
	    (define-key c-mode-base-map (kbd "C-c h h") 'hs-hide-block)
	    (define-key c-mode-base-map (kbd "C-c h s") 'hs-show-block)
	    (define-key c-mode-base-map (kbd "C-c h M-h") 'hs-hide-all)
	    (define-key c-mode-base-map (kbd "C-c h M-s") 'hs-show-all)

	    ;; hide-comnt
	    (define-key c-mode-base-map (kbd "C-c h H") 'hide/show-comments-toggle)

	    ;; hide-region
	    (define-key c-mode-base-map (kbd "C-c h r") 'hide-region-hide)
	    (define-key c-mode-base-map (kbd "C-c h C-r") 'hide-region-unhide)
	    )
	  )