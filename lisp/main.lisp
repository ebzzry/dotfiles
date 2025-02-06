;;;; -*- mode: lisp; encoding: utf-8 -*-

(in-package #:cl-user)

(declaim (optimize (speed 0)
                   (compilation-speed 0)
                   (safety 3)
                   (debug 3)))

(defun home-path (path)
  "Return a PATH relative to PATH."
  (merge-pathnames path (user-homedir-pathname)))

(defun load-config (path)
  "Load subsystem from PATH."
  (let ((base (home-path "~/etc/lisp/")))
    (load (merge-pathnames path base))))

(load-config "asdf")
(load-config "quicklisp")

(load-config "vega")

#+lispworks (load-config "lispworks")
#+sbcl (load-config "sbcl")
#+ecl (load-config "ecl")
#+clisp (load-config "clisp")
#+clozure (load-config "ccl")
#+allegro (load-config "allegro")
