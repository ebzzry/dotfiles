;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; user-tests.lisp --- a playground package to play with project

(uiop:define-package :project/t/user-tests
  (:nicknames #:project-tests-user)
  (:use #:cl #:marie #:meria
        #:project/t/driver-tests))

(in-package #:project-tests-user)
