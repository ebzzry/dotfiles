;;;; cxefagordo.lisp

(uiop:define-package #:stumpo/cxefagordo
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj))

(in-package #:stumpo/cxefagordo)

(defun sxargi-cxefagordon ()
  "La plej supra nivela funkcio."
  (clear-window-placement-rules)

  (set-focus-color "#696969")
  (set-unfocus-color "#000000")

  (clx-truetype:cache-fonts)
  (set-font (make-instance 'xft:font :family "Liberation Mono" :subfamily "Regular" :size 10 :antialias t))

  (setf *shell-program* "/bin/sh"
        *mouse-focus-policy* :click
        *window-border-style* :thin
        *maxsize-border-width* 1
        *transient-border-width* 1
        *normal-border-width* 1
        *input-window-gravity* :bottom-right
        *message-window-gravity* :bottom-right
        *window-format* "%m%n%s%c"
        *screen-mode-line-format* '("%n |%W ^>| %d")
        *time-month-names* #("Januaro" "Februaro" "Marto" "Aprilo" "Majo" "Junio" "Julio" "Auxgusto" "Septembro" "Oktobro" "Novembro" "Decembro")
        *time-day-names* #("lundo" "mardo" "merkredo" "jxauxdo" "vendredo" "sabato" "dimancxo")
        *time-modeline-string* "^B%Y-%m-%e %H:%M^b"
        *mode-line-foreground-color* "Gray50"
        *mode-line-background-color* "Gray20")

  (enable-mode-line (current-screen) (current-head) t))

(registri-komencan-krocxilon #'sxargi-cxefagordon)
