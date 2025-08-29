;;;; -*- mode: lisp; syntax: common-lisp; base: 10; -*-

#-asdf (require "asdf")

(defun add-to-registry (&rest paths)
  "Add PATHS to the system registry."
  (loop :for path :in paths
        :do (pushnew (home-path path) asdf:*central-registry* :test #'uiop:pathname-equal)))

(add-to-registry "common-lisp/")
