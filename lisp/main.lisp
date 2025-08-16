;;;; -*- mode: lisp; syntax: common-lisp; base: 10; encoding: utf-8 -*-

(in-package #:cl-user)

;; (declaim (optimize (speed 0) (compilation-speed 0) (safety 3) (debug 3)))

(defun home-path (path)
  (merge-pathnames path (user-homedir-pathname)))

(defun load-config (path)
  (let ((base (home-path "~/etc/lisp/")))
    (load (merge-pathnames path base))))

(dolist (x '("asdf" "quicklisp" "vega" "impl"))
  (load-config x))
