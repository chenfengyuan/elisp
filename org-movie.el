;;; org-movie.el
;; This file is not part of Emacs

;; Copyright (C) 2012 by Chen Fengyuan
;; Author:          Chen Fengyuan(jeova.sanctus.unus@gmail.com)
;; Maintainer:      Chen Fengyuan(jeova.sanctus.unus@gmail.com)
;; Created:         2012-5-16

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Installation:
;;
;; Put this file on your Emacs-Lisp load path and add the following to your
;; ~/.emacs startup file
;;
;; (require 'org-movie)
;;
;; then you can press C-c C-o at link like movie:/path/to/foo.avi in .org files
;; set org-movie-command to your favouriable mplayer.
;; BTW:my english is poor,so if the document is not corrcet,please let me know,thanks:)
(require 'org)

(org-add-link-type "movie" 'org-movie-open)
(add-hook 'org-store-link-functions 'org-movie-store-link)

(defcustom org-movie-command "smplayer"
  "The shell command to be used to play a movie."
  :group 'org-link
  :type '(string))

(defcustom org-movie-suffix (concat
			     (regexp-opt
			      '(".mkv" ".rm" ".rmvb" ".avi" ".3gp" ".mp4")) "$")
  "The regexp to determine if a file is a movie."
  :group 'org-link
  :type '(string))
(defun org-movie-open (path)
  "Play movie on PATH."
  (start-process "org-movie-open" nil org-movie-command path))

(defun org-movie-store-link ()
  "Store a link to a manpage."
  (when (eq major-mode 'dired-mode)
    (let ((file (expand-file-name (dired-get-filename nil t)))
	  (case-fold-search t)
	  link pos)
      (when (and file (string-match org-movie-suffix file))
	(setq link (concat "movie:" file))
	(org-store-link-props
            :type "movie"
            :link link
            :description (file-name-nondirectory file))))))

(provide 'org-movie)

     ;;; org-movie.el ends here
