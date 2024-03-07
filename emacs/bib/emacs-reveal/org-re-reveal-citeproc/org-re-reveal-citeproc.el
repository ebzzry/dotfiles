;;; org-re-reveal-citeproc.el --- Citations and bibliography for org-re-reveal  -*- lexical-binding: t; -*-
;; -*- Mode: Emacs-Lisp -*-
;; -*- coding: utf-8 -*-

;; SPDX-FileCopyrightText: 2021 Jens Lechtenbörger
;; SPDX-License-Identifier: GPL-3.0-or-later

;; Author: Jens Lechtenbörger
;; URL: https://gitlab.com/oer/org-re-reveal-citeproc
;; Version: 2.0.1
;; Package-Requires: ((emacs "25.1") (org "9.5") (citeproc "0.9") (org-re-reveal "3.0.0"))
;; Keywords: hypermedia, tools, slideshow, presentation, bibliography

;;; License:
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.
;; If not, see http://www.gnu.org/licenses/ or write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; This package extends `org-re-reveal' with support for a
;; bibliography slide based on package `citeproc' with citation
;; support of Org mode 9.5.  Thus, Org `cite' links are translated
;; into hyperlinks to the bibliography slide upon export by
;; `org-re-reveal'.  Also, export to PDF via LaTeX and export to
;; HTML with Org's usual export functionality work.
;;
;; This package is an alternative to `org-re-reveal-ref'.
;; While the latter which relies on `org-ref', `org-re-reveal-citeproc'
;; supports the new Org mode syntax introduced in in Org mode 9.5.
;;
;; * Install
;; 0. Install prerequisites
;;    - reveal.js: https://revealjs.com/
;;    - *Recent* Org mode: https://orgmode.org/
;;    - citeproc-org: MELPA or https://github.com/andras-simonyi/citeproc-el
;; 1. Install org-re-reveal and org-re-reveal-citeproc, either from MELPA
;;    or GitLab:
;;    - https://gitlab.com/oer/org-re-reveal/
;;    - https://gitlab.com/oer/org-re-reveal-citeproc/
;;    (a) Place their directories into your load path or install from MELPA
;;        (https://melpa.org/#/getting-started).
;;    (b) Load and configure org-re-reveal-citeproc.  E.g. place the following
;;        into your ~/.emacs and restart:
;;        (require 'org-re-reveal-citeproc)
;;        (add-to-list 'org-export-filter-paragraph-functions
;;	               #'org-re-reveal-citeproc-filter-cite)
;; 2. Load an Org file and export it to HTML.
;;    (a) Make sure that reveal.js is available in your current directory
;;        (e.g., as sub-directory or symbolic link).
;;    (b) Load "README.org", coming with org-re-reveal-citeproc:
;;        https://gitlab.com/oer/org-re-reveal-citeproc/-/blob/master/README.org
;;    (c) Export to HTML: Key bindings depend upon version of org-re-reveal.
;;        Starting with version 1.0.0, press "C-c C-e v v" (write HTML file)
;;        or "C-c C-e v b" (write HTML file and open in browser)
;;
;; * Customizable options
;; The value of `org-re-reveal-citeproc-bib' is used to generate hyperlinks
;; to the bibliography.  You must use its value as CUSTOM_ID on your
;; bibliography slide.
;;
;; Function org-re-reveal-citeproc-filter-cite makes sure that Org citations
;; point to the bibiography slide.  You should add
;; it to org-export-filter-paragraph-functions as shown above.

;;; Code:
(require 'citeproc)
(require 'oc-csl)
(require 'org-re-reveal)

(defcustom org-re-reveal-citeproc-bib "bibliography"
  "Specify name for link targets generated from citations.
Use that name as CUSTOM_ID for your bibliography slide."
  :group 'org-export-re-reveal
  :type 'string)

(defun org-re-reveal-citeproc-filter-cite (text backend _)
  "Replace citeproc reference links.
This function is added to `org-export-filter-paragraph-functions',
where TEXT is the paragraph, and BACKEND is checked for `re-reveal'."
  (when (and (org-export-derived-backend-p backend 're-reveal)
	     (string-match-p "<a href=\"#citeproc_bib_item_" text))
    (replace-regexp-in-string
     "<a href=\"#citeproc_bib_item_[0-9]+\""
     (concat "<a href=\"#"
             org-re-reveal--href-fragment-prefix
             org-re-reveal-citeproc-bib
             "\"")
     text)))

(defun org-re-reveal-citeproc-unload-function ()
  "Undo change of `org-export-filter-paragraph-functions'."
  (setq org-export-filter-paragraph-functions
        (delete #'org-re-reveal-citeproc-filter-cite
                org-export-filter-paragraph-functions))
  ;; Continue standard unloading
  nil)

(provide 'org-re-reveal-citeproc)
;;; org-re-reveal-citeproc.el ends here
