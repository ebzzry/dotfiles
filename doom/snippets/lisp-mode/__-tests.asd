;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; project-tests.asd --- test ASDF file for project

(defsystem #:project-tests
    :name "project-tests"
    :version (:read-file-form #P"version-tests.sexp")
    :description ""
    :author ""
    :class :package-inferred-system
    :depends-on (#:fiveam
                 #:marie
                 #:project
                 #:project/t/core-tests
                 #:project/t/driver-tests
                 #:project/t/user-tests)
    :perform (test-op (o c) (uiop:symbol-call :project/t/core-tests :run-tests)))
