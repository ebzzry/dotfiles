;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; user.lisp --- a playground package to play with project

(uiop:define-package :project/src/user
  (:nicknames #:project-user)
  (:use #:cl #:marie #:meria
        #:project/src/driver))

(in-package #:project-user)
