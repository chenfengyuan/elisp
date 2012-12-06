(eval-when-compile (require 'cl))
(defvar next-spec-day-runningp)
(setq next-spec-day-runningp nil)
(defun next-spec-day ()
  (unless next-spec-day-runningp
    (setq next-spec-day-runningp t)
    (dolist (type '("NEXT-SPEC-DEADLINE" "NEXT-SPEC-SCHEDULED"))
      (when (stringp (org-entry-get nil type))
	(let* ((time (org-entry-get nil (substring type (length "NEXT-SPEC-"))))
	       (pt (if time (org-parse-time-string time) (decode-time (current-time))))
	       (func (read-from-whole-string (org-entry-get nil type))))
	  (incf (nth 3 pt))
	  (do nil
	      ((let* ((d (nth 3 pt))
		      (m (nth 4 pt))
		      (y (nth 5 pt))
		      (date (list m d y))
		      entry)
		 (eval func))
	       (funcall
		(if (string= "NEXT-SPEC-DEADLINE" type)
		    'org-deadline
		  'org-schedule)
		nil
		(format-time-string (car org-time-stamp-formats) (apply 'encode-time pt))))
	    (incf (nth 3 pt))
	    (setf pt (decode-time (apply 'encode-time pt)))))))
    (if (or
	 (org-entry-get nil "NEXT-SPEC-SCHEDULED")
	 (org-entry-get nil "NEXT-SPEC-DEADLINE"))
	(org-entry-put nil "TODO" (car org-todo-heads)))
    (setq next-spec-day-runningp nil)))
(add-hook 'org-after-todo-state-change-hook 'next-spec-day)