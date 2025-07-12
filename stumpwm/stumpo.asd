;;;; stumpo.asd

#-asdf3.1 (error "ASDF 3.1 or bust!")

(defpackage :stumpo-sistemo
  (:use #:cl #:asdf))

(in-package #:stumpo-sistemo)

(defsystem :stumpo
  :name "stumpo"
  :version "2.1.0"
  :description "StumpWM-agordo"
  :license "CC0"
  :author "Rommel MARTINEZ <rommel.martinez@astn-group.com>"
  :class :package-inferred-system
  :depends-on ("stumpwm"
               "swank"
               "scripts"
               "pelo"
               "clx-truetype"
               "ttf-fonts"
               #:stumpo/komunajxoj
               #:stumpo/cxefagordo
               #:stumpo/komandoj
               #:stumpo/klavkombinoj
               #:stumpo/grupoj
               #:stumpo/transpasoj
               #:stumpo/postsxargo
               #:stumpo/pelilo))
