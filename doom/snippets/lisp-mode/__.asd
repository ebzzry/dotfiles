;;;; -*- mode: lisp; syntax: common-lisp; base: 10; -*-
;;;; project.asd --- main ASDF file for project

(defsystem #:project
    :name "project"
    :version (:read-file-form #P"version.sexp")
    :description ""
    :author ""
    :class :package-inferred-system
    :depends-on (#:marie
                 #:project/src/core
                 #:project/src/driver
                 #:project/src/user)
    :in-order-to ((test-op (test-op "project-tests"))))
