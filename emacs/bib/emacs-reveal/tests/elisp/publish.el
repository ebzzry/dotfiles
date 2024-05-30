;;; publish.el --- Publish reveal.js presentation from Org file
;; -*- Mode: Emacs-Lisp -*-
;; -*- coding: utf-8 -*-

;; SPDX-FileCopyrightText: 2020 Jens Lechtenbörger
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:
;; To create reveal.js presentations for the Org mode test cases,
;; use this file from its parent directory with the following shell
;; command:
;; emacs --batch --load elisp/publish.el

;;; Code:
(package-initialize)

;; For old Docker image, ensure Emacs 24.4 compatibility.
(setq org-ref-completion-library 'org-ref-reftex)

(setq emacs-reveal-managed-install-p nil)

;; Load emacs-reveal, use embedded submodules.
(add-to-list 'load-path (expand-file-name "../.." (file-name-directory load-file-name)))
(require 'emacs-reveal)

;; Don't create PDF.
(setq oer-reveal-publish-org-publishing-functions
      '(oer-reveal-publish-to-reveal))

;; Publish Org files.
(oer-reveal-publish-all)
;;; publish.el ends here
