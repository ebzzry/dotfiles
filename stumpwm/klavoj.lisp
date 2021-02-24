;;;; klavoj.lisp

(uiop:define-package #:stumpo/klavoj
  (:use #:cl
        #:stumpwm
        #:stumpo/komuno
        #:stumpo/komandoj))

(in-package #:stumpo/klavoj)

(set-prefix-key (kbd "C-;"))
(define-key *root-map* (kbd "h") '*help-map*)

(defparameter *supraj-mapklavoj*
  '(("C-Escape"   . "delete")
    ("M-S-Escape" . "kill-window")

    ("C-ISO_Left_Tab" . "fprev")
    ("C-Tab"          . "fnext")

    ("M-ISO_Left_Tab" . "pull-hidden-previous")
    ("M-Tab"          . "pull-hidden-next")

    ("C-S-Up"    . "exchange-direction up")
    ("C-S-Down"  . "exchange-direction down")
    ("C-S-Left"  . "exchange-direction left")
    ("C-S-Right" . "exchange-direction right")

    ("M-S-Up"    . "move-window up")
    ("M-S-Down"  . "move-window down")
    ("M-S-Left"  . "move-window left")
    ("M-S-Right" . "move-window right")

    ("M-Prior"   . "gprev")
    ("M-Next"    . "gnext")

    ("C-M-Prior" . "gprev-with-window")
    ("C-M-Next"  . "gnext-with-window")

    ("C-1" . "gselect 1")
    ("C-2" . "gselect 2")
    ("C-3" . "gselect 3")
    ("C-4" . "gselect 4")
    ("C-5" . "gselect 5")
    ("C-6" . "gselect 6")
    ("C-7" . "gselect 7")
    ("C-8" . "gselect 8")
    ("C-9" . "gselect 9")
    ("C-0" . "gselect 0")

    ("C-M-1" . "gmove 1")
    ("C-M-2" . "gmove 2")
    ("C-M-3" . "gmove 3")
    ("C-M-4" . "gmove 4")
    ("C-M-5" . "gmove 5")
    ("C-M-6" . "gmove 6")
    ("C-M-7" . "gmove 7")
    ("C-M-8" . "gmove 8")
    ("C-M-9" . "gmove 9")
    ("C-M-0" . "gmove 0")

    ("XF86Go"                  . "na-touch-ring-sxargu")
    ("XF86Back"                . "zomon-malpliigu")
    ("XF86Forward"             . "zomon-pliigu")

    ("XF86AudioLowerVolume"    . "sonfortecon-malpliigu")
    ("XF86AudioRaiseVolume"    . "sonfortecon-pliigu")
    ("S-XF86AudioLowerVolume"  . "sonfortecon-malpliigu-2")
    ("S-XF86AudioRaiseVolume"  . "sonfortecon-pliigu-2")

    ("XF86Display"             . "run-shell-command disper -e")
    ("S-XF86Display"           . "run-shell-command disper -c")

    ("XF86AudioMute"           . "sonfortecon-mutigu")
    ("S-XF86AudioMute"         . "sonfortecon-kvindekigu")

    ("XF86MonBrightnessDown"   . "ekranbrilecon-minimumigu")
    ("XF86MonBrightnessUp"     . "ekranbrilecon-maksimumigu")

    ("S-XF86MonBrightnessDown" . "zomon-malpliigu")
    ("S-XF86MonBrightnessUp"   . "zomon-pliigu"))
  "Asocia listo de klavaj:komandaj paroj por *TOP-MAP*.")

(defparameter *radikaj-mapklavoj*
  '(("C-;" . "send-escape")

    ("Return"   . "pull-hidden-next")
    ("C-Return" . "pull-hidden-next")
    ("SPC"      . "gother")
    ("C-SPC"    . "gother")

    ("%"  . "hsplit")
    ("\"" . "vsplit")
    ("$"  . "remove-split")

    ("!" . "run-shell-command")
    ("." . "loadrc")
    ("," . "restart-soft")
    (":" . "eval")
    (";" . "komando")
    ("<" . "sprev")
    (">" . "snext")
    ("f" . "fullscreen")
    ("o" . "only")

    ("a" . "staton-montru")
    ("b" . "musmontrilon-forpelu")
    ("c" . "musmontrilon-centrigu")

    ("d"   . "malkonektu-1")
    ("C-d" . "malkonektu-2")

    ("k"   . "mortigu")
    ("C-k" . "dakere-mortigu")

    ("`" . "run-shell-command disper --cycle")
    ("e" . "run-shell-command screenshot region")
    ("E" . "run-shell-command screenshot full")
    ("t" . "run-shell-command tx")
    ("w" . "run-shell-command shell lisp ~/bin/wallpaper wallhaven")
    ("W" . "run-shell-command shell lisp ~/bin/wallpaper chromecast")
    ("x" . "run-shell-command config-x")

    ("A" . "run-shell-command av")
    ("B" . "run-shell-command qb")
    ("C" . "run-shell-command ca")
    ("D" . "run-shell-command kd")
    ("G" . "run-shell-command gu")
    ("I" . "run-shell-command Discord")
    ("J" . "run-shell-command qj")
    ("K" . "run-shell-command kt")
    ("L" . "run-shell-command libreoffice")
    ("M" . "run-shell-command musescore")
    ("P" . "run-shell-command kp")
    ("Q" . "run-shell-command qb")
    ("S" . "run-shell-command steam")
    ("T" . "run-shell-command td")
    ("V" . "run-shell-command viber")
    ("X" . "run-shell-command vb")
    ("Z" . "run-shell-command zoom-us"))
  "Asocia listo de klavaj:komandaj paroj por *ROOT-MAP*.")

(defparameter *ne-radikaj-mapklavoj*
  `("C-e" "C-c" "C-q" "M-Left" "M-Right"
    "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12"
    "C-0" "C-1" "C-2" "C-3" "C-4" "C-5" "C-6" "C-7" "C-8" "C-9")
  "Asocia listo de klavoj por malmapado.")

(defun klavojn-sxargu ()
  "La plej supra nivelo funkcio."
  (klavojn-mapu *top-map* *supraj-mapklavoj*)
  (klavojn-mapu *root-map* *radikaj-mapklavoj*)
  (klavojn-malmapu *root-map* *ne-radikaj-mapklavoj*))

(komencan-krocxilon-registru #'klavojn-sxargu)
