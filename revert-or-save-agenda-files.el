(eval-when-compile
  (require 'cl))
(defun cfy/revert-or-save-agenda-files ()
  (loop for i in org-agenda-files
	do (with-current-buffer (or (find-buffer-visiting i) (find-file-noselect i))
	     (if (buffer-modified-p) (save-buffer) (revert-buffer nil t)))))
(defadvice org-agenda (before revert-or-save-agenda-files)
  "test"
  (cfy/revert-or-save-agenda-files))
(provide 'cfy/revert-or-save-agenda-files)

