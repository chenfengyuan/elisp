(eval-when-compile
  (require 'cl))

(defvar random-numbers
  ["0" "nought" "null" "nil" "nothing" "1" "2" "3" "4" "5" "6" "7" "8" "9"])
;;;###autoload
(defun random-number ()
  (let ((n (random (length random-numbers))))
    (if (vectorp (elt random-numbers n))
	(elt (elt random-numbers n)
	     (random (length (elt random-numbers n))))
      (elt random-numbers n))))
;;;###autoload
(defun insert-random-number (n)
  (interactive "nHow many numbers: ")
  (dotimes (i n)
    (insert (concat (random-number) " "))))
(provide 'numbers)
