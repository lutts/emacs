;;
;; get file extension
;;
(defun get-ext (file-name)
  (file-name-extension file-name))


;;
;; get the base name of the file
;;
(defun base-name (file-name)
  (file-name-sans-extension file-name))


(defun curr-file ()
  "Return the filename (without directory) of the current buffer"
  (file-name-nondirectory (buffer-file-name (current-buffer)))
  )

(defun string/ends-with (s ending)
  "Return non-nil if string S ends with ENDING."
  (cond ((>= (length s) (length ending))
	 (let ((elength (length ending)))
	   (string= (substring s (- 0 elength)) ending)))
	(t nil)))

(defun string/starts-with (s begins)
  "Return non-nil if string S starts with BEGINS."
  (cond ((>= (length s) (length begins))
	 (string-equal (substring s 0 (length begins)) begins))
	(t nil)))


;; underscore <---> camelcase
;; from http://www.emacswiki.org/emacs/CamelCase

(defun mapcar-head (fn-head fn-rest list)
  "Like MAPCAR, but applies a different function to the first element."
  (if list
      (cons (funcall fn-head (car list)) (mapcar fn-rest (cdr list)))))

(defun camelize (s)
  "Convert under_score string S to CamelCase string."
  (interactive)
  (mapconcat 'identity (mapcar
			'(lambda (word) (capitalize (downcase word)))
			(split-string s "_")) ""))

(defun camelize-method (s)
  "Convert under_score string S to camelCase string."
  (mapconcat 'identity (mapcar-head
			'(lambda (word) (downcase word))
			'(lambda (word) (capitalize (downcase word)))
			(split-string s "_")) ""))

(defun un-camelcase-string (s &optional sep start)
  "Convert CamelCase string S to lower case with word separator SEP.
    Default for SEP is a hyphen \"_\".
If third argument START is non-nil, convert words after that
    index in STRING."
  (let ((case-fold-search nil))
    (while (string-match "[A-Z]" s (or start 1))
      (setq s (replace-match (concat (or sep "_")
				     (downcase (match-string 0 s)))
			     t nil s)))
    (downcase s)))
