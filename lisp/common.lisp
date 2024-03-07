;;;; -*- mode: lisp; encoding: utf-8 -*-

(defun ql (&rest args)
  "Load a system using Quicklisp."
  (apply #'ql:quickload args))

(defmacro in (package)
  "Change the current package to PACKAGE."
  `(in-package ,package))

(defun up (package)
  "Import the external symbols of PACKAGE to the current package."
  (use-package package))

(defun qs ()
  "Quit the system."
  (uiop:quit))

(defun ls (&rest args)
  "Apply ASDF:LOAD-SYSTEM to ARGS."
  (apply #'asdf:load-system args))

(defun ts (&rest args)
  "Apply ASDF:TEST-SYSTEM to ARGS."
  (apply #'asdf:test-system args))
