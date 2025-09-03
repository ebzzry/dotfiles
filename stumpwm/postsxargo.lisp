;;;; postsxargo.lisp

(uiop:define-package #:stumpo/postsxargo
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj))

(in-package #:stumpo/postsxargo)

;;(run-shell-command "xsetroot -solid black")
;;(run-shell-command "paperview ~/e/dat/paperview/scenes/cliff 10")
(run-shell-command "deco ~/.deco")
