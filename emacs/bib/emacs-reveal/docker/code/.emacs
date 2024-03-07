;;; .emacs --- Initialization for emacs-reveal
;; Copyright (C) 2017-2020 Jens Lechtenbörger
;; SPDX-License-Identifier: CC0-1.0

;;; Commentary:
;; Initialization of emacs-reveal to generate reveal.js presentations
;; from Org files in Docker container emacs-reveal.
;; Automatically loaded when Emacs is started (unless arguments such
;; as --batch or -q are used).
;;
;; As first test, start "emacs", load the file Readme.org, which comes
;; with org-re-reveal (in subdirectory
;; /root/.emacs.d/elpa/emacs-reveal/org-re-reveal), and
;; invoke Org export functionality, e.g., by pressing `C-c C-e v v'.
;;
;; For more features of emacs-reveal, checkout out its Howto
;; presentation: https://gitlab.com/oer/emacs-reveal-howto

;;; Code:
(set-terminal-coding-system 'utf-8)

;; Enable custom packages.
(package-initialize)

;; Enable emacs-reveal with bundled Lisp packages.
(setq emacs-reveal-managed-install-p nil)
(add-to-list 'load-path "/root/.emacs.d/elpa/emacs-reveal")
(require 'emacs-reveal)

;; Disable plugins.
;; Remove the following line for more powerful features of emacs-reveal,
;; which require additional setup.
(setq oer-reveal-plugins nil)
