;;;; stumpo.asd

#-asdf3.1 (error "ASDF 3.1 or bust!")

(defpackage :stumpo-sistemo
  (:use #:cl #:asdf))

(in-package #:stumpo-sistemo)

(defsystem :stumpo
  :name "stumpo"
  :version "2.0.2"
  :description "StumpWM-agordo"
  :license "CC0"
  :author "Rommel MARTINEZ <rom@mimix.io>"
  :class :package-inferred-system
  :depends-on ("stumpwm"
               "swank"
               "scripts"
               "pelo"
               "clx-truetype"
               "ttf-fonts"
               #:stumpo/komuno
               #:stumpo/cxefagordo
               #:stumpo/komandoj
               #:stumpo/klavoj
               #:stumpo/grupoj
               #:stumpo/transpasoj
               #:stumpo/postsxargo
               #:stumpo/pelilo))
