;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

(package-initialize)

(setq byte-compile-warnings '(cl-functions))

(defun emacs-home ()
  (expand-file-name "~/src/emacs/"))

(defun emacs-path (path)
  (let ((dir (emacs-home)))
    (concat dir path)))

(defun make-emacs-path (x y)
  (emacs-path (concat x "/" y)))

(defun emacs-path-src (path)
  (make-emacs-path "src" path))

(defun emacs-path-lib (path)
  (make-emacs-path "lib" path))

(cl-loop for file in '(overrides
                       general
                       libraries
                       keys
                       custom
                       find
                       private)
         do (progn (load (emacs-path-src (prin1-to-string file)))))
