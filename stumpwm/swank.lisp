;;;; swank.lisp

(uiop:define-package #:stumpo/swank
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj))

(in-package #:stumpo/swank)

(defvar *swanka-pordo* 4004
  "La pordnumero de swank.")

(defun sxargi-swank ()
  "Ŝargi swank."
  (let* ((prefikso "lsof -i :")
         (pordo *swank-pordo*)
         (komando (concatenate 'string prefikso (write-to-string pordo))))
    (when (zerop (length (ignore-errors (uiop:run-program komando :output :string))))
      (swank-loader:init)
      (swank:create-server :port *swank-pordo*
                           :style swank:*communication-style*
                           :dont-close t))))

(registri-komencan-krocxilon #'sxargi-swank)
