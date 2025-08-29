;;;; -*- mode: lisp; syntax: common-lisp; base: 10; encoding: utf-8 -*-

(in-package #:cl-user)

(defun home-path (path)
  (merge-pathnames path (user-homedir-pathname)))

(defun load-config (c)
  (let ((base (home-path "~/etc/lisp/")))
    (load (merge-pathnames c base))))

(dolist (c '("asdf" "quicklisp" "impl" "vega"))
  (load-config c))
