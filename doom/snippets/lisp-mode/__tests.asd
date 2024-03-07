;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; foo-tests.asd --- test ASDF file for the Foo system

(defsystem #:foo-tests
    :name "foo-tests"
    :version (:read-file-form #P"version-tests.sexp")
    :description "Tests for the Foo system"
    :author "Valmiz"
    :class :package-inferred-system
    :depends-on (#:fiveam
                 #:foo
                 #:foo/t/run
                 #:foo/t/driver)
    :perform (test-op (o c) (uiop:symbol-call :foo/t/run :run-tests)))
