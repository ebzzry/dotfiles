;;;; komunajxoj.lisp

(uiop:define-package #:stumpo/komunajxoj
  (:use #:cl
        #:stumpwm)
  (:export #:registri-komencan-krocxilon
           #:pravalorizi))

(in-package #:stumpo/komunajxoj)

(defvar *komenca-krocxilo* nil
  "Funkcioj kiuj estas rulitaj kiam StumWM komenciĝas.")

(defun registri-komencan-krocxilon (krocxilo)
  "Registry rulontan krocxilan funkcion kiam StumpWM komenciĝas."
  (uiop:register-hook-function '*komenca-krocxilo* krocxilo))

(defun pravalorizi ()
  "Voki la kroĉilajn funkciojn kiam StumpWM komenciĝas."
  (uiop:call-functions *komenca-krocxilo*))
