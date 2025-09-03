;;;; -*- mode: lisp -*-

(in-package #:nyxt-user)

;;; From https://github.com/ericdrgn/drgn.nyxt/blob/main/themes/drgn-dark.lisp

;;configure status buffer area with only tabs and modes section
(defun my-format-status (window)
  (let ((buffer (current-buffer window)))
    (markup:markup
     (:div :id "container"
           (:div :id "tabs"
                 (markup:raw (format-status-tabs)))
           (:div :id "modes"
                 (markup:raw
                  (format-status-load-status buffer)
                  (format-status-modes buffer window)))))))

(define-configuration window
  ((status-formatter #'my-format-status)))

;configuration window
(define-configuration window
  ((message-buffer-style
    (str:concat
     %slot-default%
     (cl-css:css
      '((body
         :font-size "11px"
         :font-family "monospace,monospace"
         :background-color "black"
         :color "white")))))))

;prompt buffer
(define-configuration prompt-buffer
  ((style (str:concat
           %slot-default%
           (cl-css:css
            '((*
               :font-size "11px"
               :font-family "monospace,monospace")
              (body
               :background-color "black"
               :color "white")
              ("#prompt-area"
               :background-color "black")
              ("#input"
               :background-color "black"
               :color "white")
              (".source-name"
               :background-color "black"
               :color "white")
              (".source-content"
               :background-color "black")
              (".source-content th"
               :border "1px solid white"
               :background-color "black")
              ("#selection"
               :background-color "white"
               :color "black")
              (.marked :background-color "black"
                       :font-weight "bold"
                       :color "white")
              (.selected :background-color "black"
                         :color "white")))))))

;internal buffer
(define-configuration internal-buffer
  ((style
    (str:concat
     %slot-default%
     (cl-css:css
      '((*
         :font-size "11px"
         :font-family "monospace,monospace")
        (title
         :color "white")
        (body
         :background-color "black"
         :color "white")
        (hr
         :color "white")
        (a
         :color "white")
        (.button
         :color "black"
         :background-color "white")))))))

;history tree
(define-configuration nyxt/history-tree-mode:history-tree-mode
  ((nyxt/history-tree-mode::style
    (str:concat
     %slot-default%
     (cl-css:css
      '((*
         :font-size "11px"
         :font-family "monospace,monospace")
        (body
         :background-color "black"
         :color "white")
        (hr
         :color "darkgray")
        (a
         :color "white")
        ("ul li::before"
         :background-color "white")
        ("ul li::after"
         :background-color "white")
        ("ul li:only-child::before"
         :background-color "white")))))))

;highlight boxes
(define-configuration nyxt/web-mode:web-mode
  ((nyxt/web-mode:highlighted-box-style
    (cl-css:css
     '((".nyxt-hint.nyxt-highlight-hint"
        :background "black")))
    :documentation "The style of highlighted boxes, e.g. link hints.")))

;Styling status buffer 
(define-configuration status-buffer
  ((style (str:concat
           %slot-default%
           (cl-css:css
            '((*
               :font-size "11px"
               :font-family "monospace,monospace")
              ("#container"
                :grid-template-columns "90% 10%")
              ("#modes"
               :background-color "black"
               :border-top "1px solid white")
              (".button:hover" :color "white")
              ("#tabs"
               :background-color "black"
               :color "white"
               :border-top "1px solid white")
              (".tab:hover" :color "white")))))))
