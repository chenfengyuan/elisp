(defun ed2k-url-unhex ()
  (interactive)
  (let ((str (current-kill 0)))
    (when (and
	 (stringp str)
	 (string= (upcase (substring-no-properties str 0 17)) "ED2K://%7CFILE%7C")
	 (string= (upcase (substring-no-properties str (- (length str) 4))) "%7C/"))
      (setq str (url-unhex-string str))
      (kill-new str t))))
