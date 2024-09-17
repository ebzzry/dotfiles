;;; emacs-reveal.el --- Create OER as reveal.js presentations with Emacs  -*- lexical-binding: t; -*-
;; -*- Mode: Emacs-Lisp -*-
;; -*- coding: utf-8 -*-

;; SPDX-FileCopyrightText: 2017-2022 Jens Lechtenbörger
;; SPDX-License-Identifier: GPL-3.0-or-later

;; Author: Jens Lechtenbörger
;; URL: https://gitlab.com/oer/emacs-reveal
;; Version: 9.10.0
;; Package-Requires: ((emacs "25.1") (oer-reveal "3.0.0") (org-re-reveal-citeproc "2.0.1") (org-re-reveal-ref "1.0.0"))
;; Keywords: hypermedia, tools, slideshow, presentation, OER

;; Emacs-reveal supports citations that are hyperlinked to a bibliography
;; slide.  Traditionally, org-ref supported citations for Org mode, and
;; org-re-reveal-ref integrated org-ref into emacs-reveal.
;; In version 9.5, Org mode added a new citation format, which is supported
;; by citeproc, which is integrated with org-re-reveal-citeproc.
;; Customizable variable emacs-reveal-cite-pkg determines whether
;; org-re-reveal-ref or org-re-reveal-citeproc is used.
;; If dependencies (org-ref or citeproc) are missing,
;; installation from MELPA is offered.

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
;; The software emacs-reveal helps to create HTML presentations (with
;; audio explanations if you wish) with reveal.js from Org mode files
;; in GNU Emacs with org-re-reveal (a fork of org-reveal) and several
;; reveal.js plugins.  Generated presentations are usable with standard
;; browsers, also mobile and offline.
;;
;; Emacs-reveal grew out of a forked version of org-reveal
;; (https://github.com/yjwen/org-reveal) when its development stopped.
;; This led to the creation of org-re-reveal, org-re-reveal-ref, and
;; oer-reveal, upon which emacs-reveal is built.
;;
;; Just as org-reveal, emacs-reveal provides an export back-end for Org
;; mode (see https://orgmode.org/manual/Exporting.html).  As such, it
;; comes with Org's separation of contents and layout, allowing to
;; create presentations in a fashion similarly to Beamer LaTeX,
;; including the use of BibTeX files for bibliographic notes (for
;; classroom presentations), hyperlinks within and between
;; presentations, and the generation of a keyword index.
;; Beyond other similar projects, emacs-reveal comes with mechanisms
;; (a) to add audio explanations to presentations and (b) to share
;; free and open images and figures with proper attribution
;; information for their inclusion in open educational resources
;; (OER).  See there for OER presentations (HTML with reveal.js and
;; PDF generated from Org files via LaTeX) for a university course on
;; Operating Systems that are generated with emacs-reveal:
;; https://oer.gitlab.io/OS/
;;
;; A howto for the use of emacs-reveal is available over there:
;; https://gitlab.com/oer/emacs-reveal-howto/blob/master/howto.org
;; https://oer.gitlab.io/emacs-reveal-howto/howto.html (generated HTML)
;;
;; * Installation
;; You need Git to use emacs-reveal.  See there:
;; https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
;;
;; Emacs-reveal is only available from GitLab.
;;
;; By default, reveal.js presentations and a PDF variant are generated,
;; which requires a LaTeX installation.
;; See `oer-reveal-publish-org-publishing-functions'.
;;
;; The howto mentions several alternatives to install emacs-reveal.
;; Here is one:
;; 1. Choose directory, e.g., ~/.emacs.d/elpa, and clone software
;;    - cd ~/.emacs.d/elpa
;;    - git clone --recursive https://gitlab.com/oer/emacs-reveal.git
;;      - (Option `--recursive' downloads submodules)
;; 2. Add following lines to ~/.emacs
;;    - (add-to-list 'load-path "~/.emacs.d/elpa/emacs-reveal")
;;    - (require 'emacs-reveal)
;; 3. Restart Emacs (installation of `org-ref' or `citeproc' is offered,
;;    if necessary)
;;
;; * Usage
;; Load an Org file (e.g., Readme.org coming with `org-re-reveal') and
;; export it to HTML (e.g., `C-c C-e w w').  Note that this just
;; generates the HTML file but does neither publish images nor other
;; resources such as JavaScript or CSS files.
;; To publish a project with all related resources, please check out
;; the emacs-reveal howto mentioned above.
;; In particular, the howto contains a sample file "elisp/publish.el" to
;; publish reveal.js presentations from Org source files.
;; Note that the HTML version of the howto is generated in a Docker
;; image on GitLab; its YML configuration shows the necessary steps
;; to generate and publish the project:
;; https://gitlab.com/oer/emacs-reveal-howto/blob/master/.gitlab-ci.yml
;;
;; With version 4, reveal.js introduced incompatible changes in some paths.
;; The target version of reveal.js to be used with emacs-reveal is
;; determined by oer-reveal-revealjs-version, which in turn takes
;; precedence over org-re-reveal-revealjs-version.  Please consult its
;; doc string.

;;; Code:
(defgroup org-export-emacs-reveal nil
  "Options for exporting Org files to reveal.js HTML pressentations.
The options here are provided by package `emacs-reveal'.  They extend those
of `oer-reveal'."
  :tag "Org Export emacs-reveal"
  :group 'org-export-oer-reveal)

(defcustom emacs-reveal-managed-install-p t
  "Configure whether to update `emacs-reveal' and submodules or not.
By default, `emacs-reveal' tries to update itself and its submodules via Git.
This requires `git' and `make' to be installed.
If you set this to nil, you should install Lisp packages in
`emacs-reveal-lisp-packages' yourself.  In that case, you also need to
decide how to go about submodules of emacs-reveal, which are managed by
`oer-reveal' by default (maybe change `oer-reveal-submodules-dir' to
point to your manually managed directory and set
`oer-reveal-submodules-version' to nil)."
  :group 'org-export-emacs-reveal
  :type 'boolean
  :package-version '(emacs-reveal . "7.0.0"))

(defvar emacs-reveal-install-dir
  (file-name-directory (or load-file-name (buffer-file-name)))
  "Directory of file \"emacs-reveal.el\".")

(defcustom emacs-reveal-default-bibliography '("references.bib")
  "Default bibliography to assign to `org-ref-default-bibliography'.
A default helps to locate the bib file when the current buffer does not
specify one."
  :group 'org-export-emacs-reveal
  :type '(repeat :tag "List of BibTeX files" file)
  :package-version '(emacs-reveal . "7.1.0"))

(defcustom emacs-reveal-bibliography-entry-format
  '(("article" . "%a, %t, %j %v(%n), %p (%y). <a href=\"%U\">%U</a>")
    ("book" . "%a, %t, %u, %y. <a href=\"%U\">%U</a>")
    ("inproceedings" . "%a, %t, %b, %y. <a href=\"%U\">%U</a>")
    ("incollection" . "%a, %t, %b, %u, %y. <a href=\"%U\">%U</a>")
    ("misc" . "%a, %t, %i, %y.  <a href=\"%U\">%U</a>")
    ("phdthesis" . "%a, %t, %s, %y.  <a href=\"%U\">%U</a>")
    ("techreport" . "%a, %t, %i, %u (%y).  <a href=\"%U\">%U</a>")
    ("proceedings" . "%e, %t in %S, %u (%y)."))
  "Value to assign to `org-ref-bibliography-entry-format'.
This defines the layout of bibliography entries in presentations.
The default value displays article, book, inproceedings differently;
entries incollection, misc, and phdthesis are new, while entries
techreport and proceedings are defaults of `org-ref'."
  :group 'org-export-emacs-reveal
  :type '(alist :key-type (string) :value-type (string))
  :package-version '(emacs-reveal . "7.1.0"))

(defcustom emacs-reveal-cite-pkg 'org-re-reveal-ref
  "Default citation package to use.
If the value is `org-re-reveal-citeproc', upon loading, emacs-reveal adds
function `org-re-reveal-citeproc-filter-cite' to
`org-export-filter-paragraph-functions'."
  :group 'org-export-emacs-reveal
  :type '(choice (const org-re-reveal-ref)
                 (const org-re-reveal-citeproc))
  :package-version '(emacs-reveal . "9.0.0"))

(defvar emacs-reveal--cite-pkg-req
  (cond ((eq 'org-re-reveal-ref emacs-reveal-cite-pkg) 'org-ref)
        ((eq 'org-re-reveal-citeproc emacs-reveal-cite-pkg) 'citeproc))
  "Requirement for `emacs-reveal-cite-pkg'.")

(defun emacs-reveal--install-cite-pkg (explanation)
  "Show EXPLANATION and offer installation of `emacs-reveal--cite-pkg-req'."
  (unless (yes-or-no-p explanation)
    (error "Please install %s to use `emacs-reveal'" emacs-reveal--cite-pkg-req))
  (let ((package-archives (cons '("melpa" . "https://melpa.org/packages/") package-archives)))
    (package-refresh-contents)
    (package-install emacs-reveal--cite-pkg-req)
    (message-box
     "Installed %s.  Please restart Emacs to avoid issues with mixed Org installations."
     emacs-reveal--cite-pkg-req)))

;; org-ref and citeproc both have f as dependency.
;; If f is missing, offer to install emacs-reveal--cite-pkg-req.
;; Do not require emacs-reveal--cite-pkg-req here as that might pull in a
;; wrong Org version, since load-path has not been set up yet.
(package-initialize)
(condition-case nil
    (require 'f)
  (error
   (emacs-reveal--install-cite-pkg
    "Emacs-reveal: Dependency for citations not found.  Install from MELPA? ")))

(require 'f)
(defconst emacs-reveal-lisp-packages
  (list (f-join "org-mode" "lisp" "org-version.el")
        (f-join "org-re-reveal" "org-re-reveal.el")
        (f-join "org-re-reveal-citeproc" "org-re-reveal-citeproc.el")
        (f-join "org-re-reveal-ref" "org-re-reveal-ref.el")
        (f-join "oer-reveal" "oer-reveal.el"))
  "Lisp files of packages included as submodules.")

(defun emacs-reveal-submodules-ok ()
  "Check whether submodules are initialized properly.
Check whether (a) Lisp files for submodules in `emacs-reveal-lisp-packages'
are readable and (b) the JavaScript file \"reveal.js\" is readable.
If a check fails, return nil; otherwise, return directory of `emacs-reveal'."
  (let ((revealjs (f-join emacs-reveal-install-dir "emacs-reveal-submodules"
                          "reveal.js" "js" "reveal.js")))
    (when (and
           (not (memq nil
                      (mapcar #'file-readable-p
                              (mapcar (lambda (file)
                                        (f-join emacs-reveal-install-dir file))
                                      emacs-reveal-lisp-packages))))
           (file-readable-p revealjs))
      emacs-reveal-install-dir)))

(defun emacs-reveal-setup ()
  "Set up `emacs-reveal'.
If `emacs-reveal-managed-install-p' is t and a \".git\" is present,
invoke \"make setup\" to update `emacs-reveal' and submodules.
If submodules are present, add directories of Lisp packages to `load-path'."
  (when emacs-reveal-managed-install-p
    (if (file-readable-p (f-join emacs-reveal-install-dir ".git"))
        (let ((default-directory emacs-reveal-install-dir))
          (message "Emacs-reveal: \"make setup\" for submodules (large download upon first time; sets up Org mode) ...")
          (condition-case err
              (unless (= 0 (call-process "make" nil nil nil "setup"))
                (error "Status != 0"))
            (error (message-box "Emacs-reveal: Update with \"make setup\" failed: %s"
                                (error-message-string err))))
          (message "... done"))
      ;; Submodules might still be OK, e.g., in Docker.  Raise error if not.
      (unless (emacs-reveal-submodules-ok)
        (error "Must have a \".git\" subdirectory for managed install of `emacs-reveal'"))))
  (when (emacs-reveal-submodules-ok)
    (dolist (file emacs-reveal-lisp-packages)
      (add-to-list 'load-path (f-join emacs-reveal-install-dir
                                      (file-name-directory file))))))

(defun emacs-reveal-setup-oer-reveal ()
  "Set up `oer-reveal' for use with `emacs-reveal'.
If `oer-reveal' is used standalone, it manages installation and updating
of \"emacs-reveal-submodules\" itself.  When used as part of
`emacs-reveal' with properly installed submodules, `oer-reveal' should
not touch submodules.  Thus, set `oer-reveal-submodules-dir' to its
subdirectory under `emacs-reveal' and set
`oer-reveal-submodules-version' to nil.
Call `oer-reveal-setup-submodules', `oer-reveal-generate-include-files',
and `oer-reveal-publish-setq-defaults'."
  (when (emacs-reveal-submodules-ok)
    (let ((dir (f-join emacs-reveal-install-dir "emacs-reveal-submodules")))
      (setq oer-reveal-submodules-dir dir
            oer-reveal-submodules-version nil)))
  (oer-reveal-setup-submodules t)
  (oer-reveal-generate-include-files t)
  (oer-reveal-publish-setq-defaults))

;; Possibly update emacs-reveal (depending on emacs-reveal-managed-install-p);
;; set up load-path if necessary directories are present.
;; Afterwards, set up oer-reveal.
(emacs-reveal-setup)
(message "Using emacs-reveal with Org version: %s" (org-version))
(require 'oer-reveal-publish)
(emacs-reveal-setup-oer-reveal)

;; Set up bibliography in HTML.
(condition-case nil
    (require (eval 'emacs-reveal--cite-pkg-req))
  (error
   (emacs-reveal--install-cite-pkg
    (format
     "Emacs-reveal: Citation package %s not found.  Install from MELPA? "
     emacs-reveal--cite-pkg-req))))
(require (eval 'emacs-reveal-cite-pkg))
(cond ((eq 'org-re-reveal-ref emacs-reveal-cite-pkg)
       (setq org-ref-default-bibliography emacs-reveal-default-bibliography
             org-ref-bibliography-entry-format emacs-reveal-bibliography-entry-format))
      ((eq 'org-re-reveal-citeproc emacs-reveal-cite-pkg)
       (add-to-list 'org-export-filter-paragraph-functions
	            #'org-re-reveal-citeproc-filter-cite)))
(provide 'emacs-reveal)
;;; emacs-reveal.el ends here
