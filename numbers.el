(eval-when-compile
  (require 'cl))

(defvar random-numbers
  ["0" "nought" "null" "nil" "nothing"])
;;;###autoload
(defun random-number (max)
  (let ((n (random max)))
    (if (= n 0)
	(let ((n (random (length random-numbers))))
	  (elt random-numbers n))
      (number-to-string n))))
;;;###autoload
(defun insert-random-number (n max)
  (interactive "nHow many numbers: ")
  (dotimes (i (1- n))
    (insert (random-number max) " "))
  (insert (random-number max))
  (insert "\n"))
;;;###autoload
(defun output-random-numbers-to-file (file n max)
  (interactive "fFile: \nnNumbers: \nnMaximize: ")
  (with-temp-file file
    (insert-random-number n max)))
(provide 'numbers)
