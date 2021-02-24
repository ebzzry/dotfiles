;;;; komuno.lisp

(uiop:define-package #:stumpo/komuno
  (:use #:cl
        #:stumpwm
        #:marie))

(in-package #:stumpo/komuno)

(defvar *komenca-krocxilo* nil
  "Funkcioj por la StumpWM-an startigon plenumi.")

(def komencan-krocxilon-registru (krocxilo)
  "La krocxilan funkcion registru por plenumi kiam StumpWM komencigxas."
  (uiop:register-hook-function '*komenca-krocxilo* krocxilo))

(def pravalorizu ()
  "La krocxilan funkcion plenumu kiam StumpWM komencigxas."
  (uiop:call-functions *komenca-krocxilo*))
