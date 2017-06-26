;;; ox-blog-nikola.el --- Blogging plugin for nikola

;; Copyright (C) 2017  Oliver Marks

;; Author: Oliver Marks <oly@digitaloctave.com>
;; URL: https://github.com/olymk2/emacs-nikola
;; Keywords: Nikola blogging
;; Version: 0.1
;; Created 29 October 2016

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This provides a wrapper to the nikola blogging command, it will look for a .git
;; folder and treat this as your blog root. You can create new posts serve and build currently.
;; will likely add new functionality

;;; Code:


(require 'magit-popup)

(defun nikola-root ()
  (condition-case nil
    (let ((root-path (locate-dominating-file default-directory ".git")))
      (if root-path
        root-path
        (error "Missing .git not found in directory tree")))))


;;;###autoload (autoload 'drone-options-popup "magit" nil t)
(magit-define-popup nikola-exec-popup
  "Show popup buffer featuring tagg"
  'magit-commands
  :man-page "nikola"
  :switches '((?t "Continue on failure" "--continue"))
  :options '((?f "format" "--format=orgmode"))
  :actions  '(
              (?d "deploy" nikola-deploy)
              (?a "auto" nikola-auto)
              (?c "check" nikola-check)
              (?s "status" nikola-status)
              (?b "build" nikoa-build)
              (?r "serve" nikola-serve-popup))
  :default-action 'nikola-auto)

;;;###autoload
(magit-define-popup nikola-serve-popup
  "Show popup buffer featuring tagging commands."
  'magit-commands
  :man-page "nikola"
  :switches '((?o "Open browser" "--browser")(?d "Detach" "--detach"))
  :actions '((?s "serve" nikola-serve))
  :default-action 'nikola-exec)

;;;###autoload
(defun nikola-deploy (&optional args)
  (interactive (list (nikola-exec-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "deploy" (mapconcat 'identity args " "))))

;;;###autoload
(defun nikola-auto(&optional args)
  (interactive (list (nikola-exec-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "auto" (mapconcat 'identity args " "))))

;;;###autoload
(defun nikola-check(&optional args)
  (interactive (list (nikola-exec-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "check" (mapconcat 'identity args " "))))

;;;###autoload
(defun nikola-status(&optional args)
  (interactive (list (nikola-exec-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "status" (mapconcat 'identity args " "))))

;;;###autoload
(defun nikola-build (&optional args)
  (interactive (list (nikola-exec-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "build" (mapconcat 'identity args " "))))

;;;###autoload
(defun nikola-blog-post (&optional args)
  (interactive (list (nikola-serve-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "new_post" (mapconcat 'identity args " "))))

;;;###autoload
(defun nikola-serve (&optional args)
  (interactive (list (nikola-serve-arguments)))
  (let ((default-directory (nikola-root)))
    (nikola-exec "serve" (mapconcat 'identity args " "))))

(defun nikola-exec (args params)
  (let ((default-directory (nikola-root)))
    (compilation-start (format "nikola %s %s" args params))))

;;; ox-blog-nikola.el ends here
(provide 'ox-blog-nikola)
