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