;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; driver.lisp --- top-level definitions for exporting definitions under a single package

(uiop:define-package #:project/src/driver
  (:nicknames #:project)
  (:use #:uiop/common-lisp)
  (:use-reexport #:project/src/core))

(provide "project")
(provide "PROJECT")
