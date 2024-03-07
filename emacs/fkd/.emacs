;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

(package-initialize)

(setq byte-compile-warnings '(cl-functions))

(require 'cl)

(defun emacs-home ()
  (expand-file-name "~/hejmo/ktp/emakso/"))

(defun emacs-init ()
  (emacs-path ".emakso"))

(defun emacs-path (path)
  (let ((dir (emacs-home)))
    (concat dir path)))

(defun make-emacs-path (x y)
  (emacs-path (concat x "/" y)))

(defun emacs-path-src (path)
  (make-emacs-path "fkd" path))

(defun emacs-path-lib (path)
  (make-emacs-path "bib" path))

(loop for file in '(transpasoj
                    gxeneralajxoj
                    bibliotekoj
                    klavoj
                    agordoj
                    trovi
                    privataj)
   do (progn (load (emacs-path-src (prin1-to-string file)))))
