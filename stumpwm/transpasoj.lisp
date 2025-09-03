;;;; transpasoj.lisp

(uiop:define-package #:stumpo/transpasoj
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj))

(in-package #:stumpwm)

(defcommand loadrc () ()
  "Reload the @file{~/.stumpwmrc} file."
  (handler-case
      (with-restarts-menu (load-rc-file nil))
    (error (c)
      (message "^1*^BEstis eraro: ^n~A" c))
    (:no-error (&rest args)
      (declare (ignore args))
      (message "ω"))))

(in-package #:stumpo/transpasoj)
