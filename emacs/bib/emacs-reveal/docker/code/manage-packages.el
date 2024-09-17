;;; manage-packages.el --- Management of packages and their requirements
;; -*- Mode: Emacs-Lisp -*-
;; -*- coding: utf-8 -*-

;; SPDX-FileCopyrightText: 2017-2019,2021 Jens Lechtenbörger
;; SPDX-License-Identifier: CC0-1.0

;;; Commentary:
;; Download packages with their required packages, optionally patch
;; them, then install.
;; Warning! Patch functionality makes use of shell-command without
;; quoting of arguments.  This will not work with (file and directory)
;; names that contain spaces or semicolons.
;; Only functions mp-install-pkgs and mp-install-stable-pkgs are meant
;; to be called by users.

;;; Code:
(require 'package)

;; TLSv1.3 does not work
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(defvar mp-target-directory nil
  "Absolute name of target directory.")

(defvar mp-melpa-variant '("melpa" . "https://melpa.org/packages/")
  "MELPA variant to use.")

(defun mp-make-absname (basename)
  "Make absolute name for BASENAME under `mp-target-directory'."
  (concat mp-target-directory basename))

(defun mp-archives ()
  "Make absolute name for file listing all archives."
  (mp-make-absname "archives.txt"))

(defun mp-geturl (pkg)
  "Download package PKG from its URL."
  (let* ((name (concat (package-desc-full-name pkg)
		       (package-desc-suffix pkg)))
	 (absname (mp-make-absname name))
	 (url (concat (package-archive-base pkg) name)))
    ;; Package may have been downloaded already.
    (unless (file-readable-p absname)
      (url-copy-file url absname)
      name)))

(defun mp-download-reqs (pkg-symbol)
  "Compute requirements for package PKG-SYMBOL."
  (let* ((pkg (cadr (assq pkg-symbol package-archive-contents)))
	 (reqs (package-compute-transaction (list pkg)
					    (package-desc-reqs pkg))))
    (delete nil (mapcar 'mp-geturl reqs))))

(defun mp-write-archives (filelist)
  "Append names of files in FILELIST to `mp-archives', one per line."
  (let ((absnames (mapcar 'mp-make-absname filelist)))
    (write-region (concat (mapconcat 'identity absnames "\n") "\n") nil
		  (mp-archives) 'append)))

(defun mp-read-lines (filename)
  "Read lines from FILENAME, return as list of strings."
  (with-temp-buffer
    (insert-file-contents filename)
    (split-string (buffer-string) "\n" t)))

(defun mp-read-archives ()
  "Read names of files from `mp-archives', return as list."
  (mp-read-lines (mp-archives)))

(defun mp-download-pkgs (packages)
  "Download PACKAGES and their requirements.
Write list of downloaded files to `mp-archives'."
  (package-initialize)
  (add-to-list 'package-archives mp-melpa-variant)
  (package-refresh-contents)
  (let ((filelist (mapcar 'mp-download-reqs packages)))
    (mapc 'mp-write-archives filelist)))

(defun mp-patch-tar (tarabsname patch)
  "Recreate tar archive TARABSNAME based on PATCH.
TARABSNAME and PATCH must be absolute paths."
  (let* ((tarabsdir (file-name-sans-extension tarabsname))
	 (tarname (file-name-nondirectory tarabsname))
	 (tardir (file-name-nondirectory tarabsdir)))
    (shell-command (format "tar -C %s -xf %s" mp-target-directory tarabsname))
    (shell-command (format "patch -d %s -p1 < %s" tarabsdir patch))
    (delete-file tarabsname)
    (shell-command (format "cd %s; tar cf %s %s"
			   mp-target-directory tarname tardir))
    (delete-directory tardir t)))

(defun mp-patch-archives (patchinfo)
  "Read lines from file PATCHINFO, invoke `mp-patch-tar' for each.
Each line of that file must contain the name of a package
archive (without directory), followed by a space character,
followed by the absolute path for a patch to be applied via
`mp-patch-tar'."
  (let ((patchlines (mp-read-lines patchinfo)))
    (dolist (line patchlines)
      (let* ((entries (split-string line " "))
	     (tar (car entries))
	     (patch (cadr entries)))
	(mp-patch-tar (concat mp-target-directory tar) patch)))))

(defun mp-download-patch (packages &optional patchinfo)
  "Download PACKAGES, optionally patch based on PATCHINFO.
First, download package archives via `mp-download-pkgs'.
Then, if optional PATCHINFO is non-nil, treat as name of a file
containing information what archives to patch via `mp-patch-archives'
how."
  (mp-download-pkgs packages)
  (when patchinfo
    (mp-patch-archives patchinfo)))

(defun mp-install-pkgs (packages directory &optional patchinfo)
  "Download PACKAGES to DIRECTORY and install them.
First, create DIRECTORY if it does not exist already.  Next, download
and, if optional PATCHINFO is non-nil, patch package archives via
`mp-download-patch'.  Then, install.  Finally, remove DIRECTORY."
  (mkdir directory t)
  (let ((mp-target-directory (file-name-as-directory
			      (expand-file-name directory))))
    (mp-download-patch packages patchinfo)
    (let ((files (mp-read-archives)))
      (mapc 'package-install-file files))
    (delete-directory directory t)))

(defun mp-install-stable-pkgs (packages directory)
  "Download PACKAGES from MELPA stable to DIRECTORY and install them."
  (let ((mp-melpa-variant '("melpa-stable" . "https://stable.melpa.org/packages/")))
    (mp-install-pkgs packages directory)))

(provide 'manage-packages)
;;; manage-packages.el ends here
