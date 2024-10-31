;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; driver-tests.lisp --- top-level definitions for the tests

(uiop:define-package :project/t/driver-tests
  (:nicknames #:project/t)
  (:use #:uiop/common-lisp
        #:marie)
  (:use-reexport #:project/t/core-tests))

(provide "project/t")
(provide "PROJECT/T")
