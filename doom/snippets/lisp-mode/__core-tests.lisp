;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; core-tests.lisp -- main test file for core

(uiop:define-package #:project/t/core-tests
  (:use #:cl
        #:fiveam
        #:marie
        #:project))

(in-package #:project/t/core-tests)

(def run-tests ()
  "Run all the tests defined in the suite."
  (run-all-tests))
