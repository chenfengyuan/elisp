(defun map-lines (buffer fn)
  (let ((strings (with-current-buffer buffer (split-string (buffer-string) "\n"))))
    (with-temp-buffer
      (loop for i in strings
	    do (insert (funcall fn i))
	    do (insert ?\n))
      (buffer-swap-text (get-buffer buffer)))))

