;;;; klavkombinoj.lisp

(uiop:define-package #:stumpo/klavkombinoj
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj
        #:stumpo/komandoj))

(in-package #:stumpo/klavkombinoj)

(set-prefix-key (kbd "C-;"))
(define-key *root-map* (kbd "h") '*help-map*)

(defparameter *supraj-klavkombinoj*
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

    ("XF86Go"                  . "sxargi-touchring")
    ("XF86Back"                . "malpliigi-zomon")
    ("XF86Forward"             . "pliigi-zomon")
    ("XF86AudioLowerVolume"    . "malpliigi-sonforton")
    ("XF86AudioRaiseVolume"    . "pliigi-sonforton")
    ("S-XF86AudioLowerVolume"  . "malpliigi-sonforton-2")
    ("S-XF86AudioRaiseVolume"  . "pliigi-sonforton-2")
    ("XF86Display"             . "run-shell-command disper -e")
    ("S-XF86Display"           . "run-shell-command disper -c")
    ("XF86AudioMute"           . "mutigi-sonforton")
    ("S-XF86AudioMute"         . "sonfortecon-kvindekigu")
    ("XF86MonBrightnessDown"   . "malpliigi-ekranbrilon")
    ("XF86MonBrightnessUp"     . "pliigi-ekranbrilon")
    ("S-XF86MonBrightnessDown" . "minimumigi-ekranbrilon")
    ("S-XF86MonBrightnessUp"   . "maksimumigi-ekranbrilon")
    )
  "Asocia listo de klavaj:komandaj paroj por *TOP-MAP*.")

(defparameter *radikaj-klavkombinoj*
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

    ("a" . "montri-staton")
    ("b" . "forpeli-musmontrilon")
    ("c" . "centrigi-musmontrilon")

    ("d"   . "malkonekti-1")
    ("C-d" . "malkonekti-2")

    ("k"   . "mortigi")
    ("C-k" . "dakere-mortigi")
    ("e"   . "run-shell-command screenshot region")
    ("C-e" . "run-shell-command screenshot full")

    ("`" . "run-shell-command disper --cycle")
    ("t" . "run-shell-command tx")
    ("x" . "run-shell-command config-x")

    ("w"   . "run-shell-command shell lisp $HOME/bin/wallpaper wallhaven")
    ("C-w" . "run-shell-command shell lisp $HOME/bin/wallpaper chromecast")

    ("A" . "run-shell-command av")
    ("B" . "run-shell-command qb")
    ("C" . "run-shell-command ca")
    ("D" . "run-shell-command discord")
    ("E" . "run-shell-command ce")
    ("G" . "run-shell-command gu")
    ("J" . "run-shell-command qj")
    ("K" . "run-shell-command kt")
    ("L" . "run-shell-command lo")
    ("M" . "run-shell-command ms")
    ("N" . "run-shell-command nb")
    ("P" . "run-shell-command kp")
    ("Q" . "run-shell-command qb")
    ("O" . "run-shell-command ts")
    ("R" . "run-shell-command qbt")
    ("S" . "run-shell-command syn")
    ("T" . "run-shell-command td")
    ("V" . "run-shell-command vr")
    ("X" . "run-shell-command xscreensaver-command -blank")
    ("Z" . "run-shell-command zm")

    ("Up"   . "maksimumigi-ekranbrilon")
    ("Down" . "minimumigi-ekranbrilon"))
  "Asocia listo de klavkombinoj:komandoj por *ROOT-MAP*.")

(defparameter *ne-radikaj-klavkombinoj*
  `("C-c" "C-q" "M-Left" "M-Right"
    "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12"
    "C-0" "C-1" "C-2" "C-3" "C-4" "C-5" "C-6" "C-7" "C-8" "C-9")
  "Asocia listo de klavkombinoj por malmapado.")

(defun sxargi-klavkombinojn ()
  "La plej supra nivelo funkcio."
  (mapi-klavkombinojn *top-map* *supraj-klavkombinoj*)
  (mapi-klavkombinojn *root-map* *radikaj-klavkombinoj*)
  (malmapi-klavkombinojn *root-map* *ne-radikaj-klavkombinoj*))

(registri-komencan-krocxilon #'sxargi-klavkombinojn)
