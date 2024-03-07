;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; foo.lisp --- foo operations

(uiop:define-package #:foo/src/foo
  (:use #:cl
        #:marie
        #:foo/src/specials
        #:foo/src/utils))

(in-package #:foo/src/foo)
