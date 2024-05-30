;;;; komandoj.lisp

(uiop:define-package #:stumpo/komandoj
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj)
  (:export #:mapi-klavkombinojn
           #:malmapi-klavkombinojn))

(in-package #:stumpwm)

(defun plenumi (komando &optional (mesagxo ""))
  "Ŝelan komandon plenumi."
  (run-shell-command komando)
  (message mesagxo))

(defun akiri-sonforton ()
  "La valoron de la sonforteco akiri."
  (handler-bind ((error (λ (c)
                          (declare (ignore c))
                          (invoke-restart 'continue))))
    (inferior-shell:run/ss "pamixer --get-volume")))

(defun formati-sonforton ()
  "La formatigitan valoron de la sonforteco reveni."
  (format nil "S: ~A" (akiri-sonforton)))

(defcommand komando (&optional initial-input)
    (:rest)
  "Komandon el la uzanto legi."
  (let ((kmd (completing-read (current-screen)
                              "komando: "
                              (all-commands) :initial-input (or initial-input ""))))
    (unless kmd
      (throw 'error :abort))
    (when (plusp (length kmd))
      (eval-command kmd t))))

(defcommand nenio ()
    ()
  "Nenion faru.")

(defcommand sonfortecon-montru ()
    ()
  "La sisteman sonfortecon montri."
  (message "~A" (akiri-sonforton)))

(defcommand mutigi-sonforton ()
    ()
  "La sisteman sonfortecon mutigi."
  (plenumi "pamixer --toggle-mute" (akiri-sonforton)))

(defcommand malpliigi-sonforton ()
    ()
  "La sisteman sonfortecon malpliigi."
  (plenumi "pamixer --decrease 5" (formati-sonforton)))

(defcommand pliigi-sonforton ()
    ()
  "La sisteman sonfortecon pliigi."
  (plenumi "pamixer --increase 5" (formati-sonforton)))

(defcommand montri-staton ()
    ()
  "La sisteman staton montri."
  (message "~A~%"
           (uiop:with-output (str nil)
             (format str "~%~A" (inferior-shell:run/ss "date"))
             (format str "~%~A" (scripts:battery-status)))))

(defcommand malpliigi-ekranbrilon ()
    ()
  "La ekranan brilecon malpliigi."
  (plenumi "sudo light -U 10 -s sysfs/backlight/intel_backlight" "-10"))

(defcommand pliigi-ekranbrilon ()
    ()
  "La ekranan brilecon pliigi."
  (plenumi  "sudo light -A 10 -s sysfs/backlight/intel_backlight" "+10"))

(defcommand minimumigi-ekranbrilon ()
    ()
  "La ekranan brilecon minimumigi."
  (plenumi "sudo light -S 0 -s sysfs/backlight/intel_backlight" "0%"))

(defcommand maksimumigi-ekranbrilon ()
    ()
  "La ekranan brilecon maksimumigi."
  (plenumi "sudo light -S 100 -s sysfs/backlight/intel_backlight" "100%"))

(defcommand sxargi-config-x ()
    ()
  "Na config-x sxargi."
  (scripts:config-x)
  (message "x"))

(defcommand sxargi-touchring ()
    ()
  "Na touchring sxargi."
  (scripts:touchring-set)
  (message "T: ~A" (write-to-string (scripts:touchring-status) :base 10)))

(defcommand akiri-ehxosondon ()
    ()
  "La resulton de ping akiri."
  (message (pelo/pelo:get-ping "1.1.1.1")))

(defcommand malpliigi-zomon ()
    ()
  "La retkameraan zomon malpliigi."
  (scripts:webcam "decrease-zoom"))

(defcommand pliigi-zomon ()
    ()
  "La retkameraan zomon pliigi."
  (scripts:webcam "increase-zoom"))

(defcommand minimumigi-zomon ()
    ()
  "La retkameraan zomon minimumigi."
  (scripts:webcam "minimum-zoom"))

(defcommand maksimumigi-zomon ()
    ()
  "La retkameraan zomon maksimumigi."
  (scripts:webcam "maximum-zoom"))


(defcommand centrigi-musmontrilon ()
    ()
  "La musmontrilon centrigi."
  (let* ((ekrano (current-screen))
         (x (/ (screen-width ekrano) 2))
         (y (/ (screen-height ekrano) 2)))
    (ratwarp x y)))

(defcommand forpeli-musmontrilon ()
    ()
  "La musmontrilon forpeli."
  (banish-pointer))

(defcommand ekranfono (type)
    ((:string "wallpaper "))
  "La ekranfono agordi."
  (run-shell-command (marie:cat "wallpaper " type)))

(defun malkonekti (&rest addresses)
  "Bludentajn aparatojn malkonekti."
  (let ((cmd "echo disconnect ~A | bluetoothctl"))
    (loop :for address :in addresses
          :do (run-shell-command (format nil cmd address)))))

(defcommand malkonekti-1 ()
    ()
  "La bludentajn ludtabuletojn malkonekti."
  (malkonekti "84:30:95:55:DE:FF"       ;Sony DualShock 4 #3
              "1C:A0:B8:53:E8:84"       ;Sony DualShock 4 #1
              "1C:A0:B8:F1:ED:3A"       ;Sony DualShock 4 #2
              "34:88:5D:79:FA:5E"       ;Logitech K380
              ))

(defcommand malkonekti-2 ()
    ()
  "La bludentajn ludtabuletojn malkonekti."
  (malkonekti "20:18:12:00:04:5C"       ;FiiO BTA10
              ))

(defcommand zz ()
    ()
  "La komputilon suspendi."
  (run-shell-command "sudo pm-suspend"))

(defcommand zzz ()
    ()
  "La komputilon letargiigi."
  (run-shell-command "sudo pm-hibernate"))

(defcommand mortigi (programo)
  ((:string "pkill -9 "))
  (run-shell-command (format nil "pkill -9 ~A" programo)))

(defcommand dakere-mortigi (programo)
  ((:string "docker stop "))
  (run-shell-command (format nil "docker stop ~A" programo)))

(defcommand rekomencigi-retkonekton ()
  ()
  "La retkonekton rekomencigi."
  (run-shell-command "nmcli c down urso")
  (run-shell-command "nmcli c up urso")
  (message "r"))

(defcommand run (commmand)
  "Alinomo de RUN-COMMAND"
  (run-shell-command command))

(in-package #:stumpo/komandoj)

(defun mapi-klavkombinojn (mapo klavoj)
  "La klavajn-valarajn duojn en KLAVOJ al MAPO mapi."
  (loop :for (klavo . valoro) :in klavoj
        :do (define-key mapo (kbd klavo) valoro)))

(defun malmapi-klavkombinojn (mapo klavoj)
  "La klavajn-valarajn duojn en KLAVOJ al MAPO mapi."
  (loop :for klavo :in klavoj
        :do (undefine-key mapo (kbd klavo))))
