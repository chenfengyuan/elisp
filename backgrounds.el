;;; backgrounds.el --- a backgrouds setter script for emacs

;; Copyright (C) 2012 by Chen Fengyuan
;; Author   : Fengyuan Chen <cfy1990@gmail.com>
;; Version  : 0.1

;; This file is part of GNU Emacs.

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

(eval-when-compile (require 'cl))

(defvar backgrounds-timer nil
  "this variable stores of the timer")

(defvar backgrounds-directory "/home/cfy/.backgrounds/"
  "the images in backgrounds-directory will be used")

(defvar backgrounds-files nil
  "the variable stores the images' path")

(defvar backgrounds-random-sort t
  "if non-nil the images will be random setted")

(defvar backgrounds-interval 60
  "the interval between two images")

(defun backgrounds-files-in-directory (directory &optional full-name match-regex nosort)
  (loop for i in (directory-files-and-attributes directory full-name match-regex nosort)
	unless (cadr i)
	collect (car i)))

(defun backgrounds-random-sort-function (a b)
  (if (= 0 (random 2))
      t))

(defun get-images-in-directory ()
  (setq backgrounds-files (backgrounds-files-in-directory backgrounds-directory t))
  (when backgrounds-random-sort
    (setq backgrounds-files (sort backgrounds-files 'backgrounds-random-sort-function)))
  backgrounds-files)

(defun backgrounds-get-images-if-need ()
  (unless backgrounds-files
    (get-images-in-directory)))

(defun backgrounds-set ()
  (backgrounds-get-images-if-need)
  (call-process "~/.bin/backgrounds" nil nil nil "--set-auto" (pop backgrounds-files)))

(defun backgrounds-toggle ()
  (if backgrounds-timer
      (progn
	(cancel-timer backgrounds-timer)
	(setq backgrounds-timer nil)
	(setq backgrounds-files nil))
    (progn
      (backgrounds-get-images-if-need)
      (setq backgrounds-timer
	    (run-at-time 0 backgrounds-interval 'backgrounds-set))))
  backgrounds-timer)

(provide 'backgrounds)
