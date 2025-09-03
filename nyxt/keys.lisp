;;;; -*- mode: lisp -*-

;; (in-package #:nyxt-user)

;;; keys
;; (define-configuration buffer
;;     ((override-map (let ((map (make-keymap "my-override-map")))
;;                      (define-key map
;;                        "M-x" 'execute-command
;;                        "C-l" 'set-url-new-buffer
;;                        "C-L" 'set-url)
;;                      map))))

;;; hints
(define-configuration nyxt/web-mode:web-mode
    ((nyxt/web-mode:hints-alphabet "aoeuidhtns")
     (glyph "λ")))

