;;;; -*- mode: lisp; coding: utf-8 -*-

(declaim (optimize (debug 3)))

(defun home-path (path)
  "Return from PATH a path relative to the home directory."
  (merge-pathnames path (user-homedir-pathname)))

#-quicklisp
(let ((file (home-path "quicklisp/setup.lisp")))
  (when (probe-file file)
    (load file)))

#+(and quicklisp clisp abcl)
(ql:quickload :asdf)

#+quicklisp
(progn
  (defun update-registry (&rest paths)
    "Add PATH to the system registry."
    (loop :for path :in paths
          :do (pushnew (home-path path) asdf:*central-registry* :test #'uiop:pathname-equal)))

  (update-registry "common-lisp/" "quicklisp/quicklisp/")

  (defun load-config (path)
    "Load subsystem from PATH."
    (let ((base (home-path "hejmo/ktp/lisp/")))
      (load (merge-pathnames path base))))

  #+sbcl (load-config "sbcl")
  #+lispworks (load-config "lispworks"))
