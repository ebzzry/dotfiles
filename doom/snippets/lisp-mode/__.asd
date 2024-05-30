;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; foo.asd --- main ASDF file for the Foo system

(defsystem #:foo
    :name "foo"
    :version (:read-file-form #P"version.sexp")
    :description ""
    :author "Valmiz"
    :class :package-inferred-system
    :depends-on (#:marie
                 #:pierre
                 #:foo/src/specials
                 #:foo/src/utils
                 #:foo/src/driver
                 #:foo/src/user)
    :in-order-to ((test-op (test-op "foo-tests"))))
