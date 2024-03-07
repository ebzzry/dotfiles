;;;; -*- mode: lisp; encoding: utf-8 -*-

(in-package :cl-user)


;;; common

(declaim (optimize (debug 3)))

(defun home-path (path)
  "Return from PATH a path relative to the home directory."
  (merge-pathnames path (user-homedir-pathname)))

(defun load-config (path)
  "Load subsystem from PATH."
  (let ((base (home-path "hejmo/ktp/lisp/")))
    (load (merge-pathnames path base))))


;;; modules

(load-config "asdf")
(load-config "quicklisp")
(load-config "common")

#+lispworks (load-config "lispworks")
#+sbcl (load-config "sbcl")
#+ecl (load-config "ecl")
#+clisp (load-config "clisp")
#+clozure (load-config "ccl")
#+allegro (load-config "allegro")


;;; vega

(pushnew :vega-object-sqlite-backend *features*)
(pushnew :vega-blob-sqlite-backend *features*)
