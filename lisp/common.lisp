;;;; -*- mode: lisp; encoding: utf-8 -*-

(defun ql (&rest args)
  "Load a system using Quicklisp."
  (apply #'ql:quickload args))

(defmacro in (package)
  "Change the current package to `package'."
  `(in-package ,package))

(defun use (package)
  "Import the external symbols of `package' to the current package."
  (use-package package))
