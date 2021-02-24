;;;; swanko.lisp

(uiop:define-package #:stumpo/swanko
  (:use #:cl
        #:stumpwm
        #:stumpo/komuno))

(in-package #:stumpo/swanko)

(defvar *swanka-pordo* 4004
  "La implicita pordo por swanka uzado")

(defun swankon-certigu ()
  "La swankon sxargu se gxi ne funkcias"
  (let* ((prefikso "lsof -i :")
         (pordo *swanka-pordo*)
         (komando (concatenate 'string prefikso (write-to-string pordo))))
    (when (zerop (length (ignore-errors (uiop:run-program komando :output :string))))
      (swank-loader:init)
      (swank:create-server :port *swanka-pordo*
                           :style swank:*communication-style*
                           :dont-close t))))

(defun swankon-sxargu ()
  "La plej supra nivela funkcio"
  (swankon-certigu))

(komencan-krocxilon-registru #'swankon-sxargu)
