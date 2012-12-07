;; How to use:
;; 1. add `(load "/path/to/next-spec-day")` to your dot emacs file.
;; 2. set `NEXT-SPEC-DEADLINE` and/or `NEXT-SPEC-SCHEDULED` property of a TODO task,like this:
;;         * TODO test
;;           SCHEDULED: <2013-06-16 Sun> DEADLINE: <2012-12-31 Mon -3d>
;;           :PROPERTIES:
;;           :NEXT-SPEC-DEADLINE: (= (calendar-extract-day date) (calendar-last-day-of-month (calendar-extract-month date) (calendar-extract-year date)))
;;           :NEXT-SPEC-SCHEDULED: (org-float 6 0 3)
;;           :END:
;;     The value of NEXT-SPEC-DEADLINE will return `non-nil` if `date` is last day of month,and the value of NEXT-SPEC-SCHEDULED will return `non-nil` if `date` is the fathers' day(the third Sunday of June).
;; 3. Then,when you change the TODO state of that tasks,the timestamp will be changed automatically(include lead time of warnings settings).
;; Notes:
;; 1. Execute `(setq next-spec-day-runningp nil)' after your sexp signal some erros,
;; 2. You can also use some useful sexp from next-spec-day-alist,like:
;; * TODO test
;;   SCHEDULED: <2013-03-29 Fri>
;;   :PROPERTIES:
;;   :NEXT-SPEC-SCHEDULED: last-workday-of-month
;;   :END:
;; 3. If you encounter some errors like 'org-insert-time-stamp: Wrong type argument: listp, "<2013-03-29 星期五>"' when change the TODO state,please try a new version of org mode.To use the new version:
;; (1). download the new version of org mode from orgmode.org,then uncompress it.
;; (2). add (add-to-list 'load-path "/path/to/org-*.*.*/lisp") to your .emacs file,make sure it's before any (require 'org).If you are not sure,just insert it to the first line of your dot emacs file.
;; (3). restart your emacs,everything should be fine.
(eval-when-compile (require 'cl))
(defvar next-spec-day-runningp)
(setq next-spec-day-runningp nil)
(defvar next-spec-day-alist
  '((last-workday-of-month
     .
     ((or
       (and (= (calendar-last-day-of-month m y) d) (/= (calendar-day-of-week date) 0) (/= (calendar-day-of-week date) 6))
       (and (< (- (calendar-last-day-of-month m y) d) 3) (string= (calendar-day-name date) "Friday")))))
    (last-day-of-month
     .
     ((= (calendar-extract-day date) (calendar-last-day-of-month (calendar-extract-month date) (calendar-extract-year date)))))
    (fathers-day
     .
     ((org-float 6 0 3))))
  "contain some useful sexp")
(defun next-spec-day ()
  (unless next-spec-day-runningp
    (setq next-spec-day-runningp t)
    (catch 'exit
      (dolist (type '("NEXT-SPEC-DEADLINE" "NEXT-SPEC-SCHEDULED"))
	(when (stringp (org-entry-get nil type))
	  (let* ((time (org-entry-get nil (substring type (length "NEXT-SPEC-"))))
		 (pt (if time (org-parse-time-string time) (decode-time (current-time))))
		 (func (ignore-errors (read-from-whole-string (org-entry-get nil type)))))
	    (unless func (message "Sexp is wrong") (throw 'exit nil))
	    (when (symbolp func)
	      (setq func (cadr (assoc func next-spec-day-alist))))
	    (incf (nth 3 pt))
	    (setf pt (decode-time (apply 'encode-time pt)))
	    (do ((i 0 (1+ i)))
		((or
		  (> i 1000)
		  (let* ((d (nth 3 pt))
			 (m (nth 4 pt))
			 (y (nth 5 pt))
			 (date (list m d y))
			 entry)
		    (eval func)))
		 (if (> i 1000)
		     (message "No satisfied in 1000 days")
		   (funcall
		    (if (string= "NEXT-SPEC-DEADLINE" type)
			'org-deadline
		      'org-schedule)
		    nil
		    (format-time-string
		     (if (and
			  time
			  (string-match
			   "[[:digit:]]\\{2\\}:[[:digit:]]\\{2\\}"
			   time))
			 (cdr org-time-stamp-formats)
		       (car org-time-stamp-formats))
		     (apply 'encode-time pt)))))
	      (incf (nth 3 pt))
	      (setf pt (decode-time (apply 'encode-time pt)))))))
      (if (or
	   (org-entry-get nil "NEXT-SPEC-SCHEDULED")
	   (org-entry-get nil "NEXT-SPEC-DEADLINE"))
	  (org-entry-put nil "TODO" (car org-todo-heads))))
    (setq next-spec-day-runningp nil)))
(add-hook 'org-after-todo-state-change-hook 'next-spec-day)
(unless (fboundp 'read-from-whole-string) (require 'thingatpt))
(unless (fboundp 'calendar-last-day-of-month) (require 'thingatpt))
