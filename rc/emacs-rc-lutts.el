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
