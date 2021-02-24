;;;; komandoj.lisp

(uiop:define-package #:stumpo/komandoj
  (:use #:cl
        #:stumpwm
        #:stumpo/komuno
        #:marie))

(in-package #:stumpwm)

(defun plenumu (komando &optional (mesagxo ""))
  "Ŝelan komandon plenumu."
  (run-shell-command komando)
  (message mesagxo))

(defun sonfortecon-akiru ()
  "La valoron de la sonforteco akiru."
  (handler-bind ((error (λ (c)
                          (declare (ignore c))
                          (invoke-restart 'continue))))
    (inferior-shell:run/ss "pamixer --get-volume")))

(defun sonfortecon-formatu ()
  "La formatigitan valoron de la sonforteco revenu."
  (format nil "S: ~A" (sonfortecon-akiru)))

(defcommand komando (&optional initial-input)
    (:rest)
  "Komandon el la uzanto legu."
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
  "La sisteman sonfortecon montru."
  (message "~A" (sonfortecon-akiru)))

(defcommand sonfortecon-mutigu ()
    ()
  "La sisteman sonfortecon mutigu."
  (plenumu "pamixer --toggle-mute" (sonfortecon-akiru)))

(defcommand sonfortecon-malpliigu ()
    ()
  "La sisteman sonfortecon malpliigu."
  (plenumu "pamixer --decrease 5" (sonfortecon-formatu)))

(defcommand sonfortecon-pliigu ()
    ()
  "La sisteman sonfortecon pliigu."
  (plenumu "pamixer --increase 5" (sonfortecon-formatu)))

(defcommand staton-montru ()
    ()
  "La sisteman staton montru."
  (message "~A~%"
           (uiop:with-output (str nil)
             (format str "~%~A" (inferior-shell:run/ss "date"))
             (format str "~%~A" (scripts:battery-status)))))

(defcommand ekranbrilecon-malpliigu ()
    ()
  "La ekranan brilecon malpliigu."
  (plenumu "xbacklight -dec 5" "-5"))

(defcommand ekranbrilecon-pliigu ()
    ()
  "La ekranan brilecon pliigu."
  (plenumu "xbacklight -inc 5" "+5"))

(defcommand ekranbrilecon-minimumigu ()
    ()
  "La ekranan brilecon minimumigu."
  (plenumu "sudo light -S 0 -s sysfs/backlight/intel_backlight" "0%"))

(defcommand ekranbrilecon-maksimumigu ()
    ()
  "La ekranan brilecon maksimumigu."
  (plenumu "sudo light -S 100 -s sysfs/backlight/intel_backlight" "100%"))

(defcommand na-config-x-sxargu ()
    ()
  "Na config-x sxargu."
  (scripts:config-x)
  (message "x"))

(defcommand na-touchring-sxargu ()
    ()
  "Na touchring sxargu."
  (scripts:touchring-set)
  (message "T: ~A" (write-to-string (scripts:touchring-status) :base 10)))

(defcommand ehxosondon-akiru ()
    ()
  "La resulton de ping akiru."
  (message (pelo/pelo:get-ping "1.1.1.1")))

(defcommand zomon-malpliigu ()
    ()
  "La retkameraan zomon malpliigu."
  (scripts:decrease-zoom))

(defcommand zomon-pliigu ()
    ()
  "La retkameraan zomon pliigu."
  (scripts:increase-zoom))

(defcommand zomon-minimumigu ()
    ()
  "La retkameraan zomon minimumigu."
  (scripts:minimum-zoom))

(defcommand zomon-maksimumigu ()
    ()
  "La retkameraan zomon maksimumigu."
  (scripts:maximum-zoom))

(defcommand musmontrilon-centrigu ()
    ()
  "La musmontrilon centrigu."
  (let* ((ekrano (current-screen))
         (x (/ (screen-width ekrano) 2))
         (y (/ (screen-height ekrano) 2)))
    (ratwarp x y)))

(defcommand musmontrilon-forpelu ()
    ()
  "La musmontrilon forpelu."
  (banish-pointer))

(defcommand ekranfono (type)
    ((:string "wallpaper "))
  "La ekranfono agordu."
  (run-shell-command (marie:cat "wallpaper " type)))

(defun malkonektu (&rest addresses)
  "Bludentajn aparatojn malkonektu."
  (let ((cmd "echo disconnect ~A | bluetoothctl"))
    (loop :for address :in addresses
          :do (run-shell-command (format nil cmd address)))))

(defcommand malkonektu-1 ()
    ()
  "La bludentajn ludtabuletojn malkonektu."
  (malkonektu "1C:A0:B8:53:E8:84"       ;Sony DualShock 4 #1
              "1C:A0:B8:F1:ED:3A"       ;Sony DualShock 4 #2
              "34:88:5D:79:FA:5E"       ;Logitech K380
              ))

(defcommand malkonektu-2 ()
    ()
  "La bludentajn ludtabuletojn malkonektu."
  (malkonektu "20:18:12:00:04:5C"       ;FiiO BTA10
              ))

(defcommand zz ()
    ()
  "La komputilon suspendu."
  (run-shell-command "sudo pm-suspend"))

(defcommand zzz ()
    ()
  "La komputilon letargiigu."
  (run-shell-command "sudo pm-hibernate"))

(defcommand mortigu (programo)
  ((:string "pkill -9 "))
  (run-shell-command (format nil "pkill -9 ~A" programo)))

(defcommand dakere-mortigu (programo)
  ((:string "docker stop "))
  (run-shell-command (format nil "docker stop ~A" programo)))

(defcommand retkonekton-rekomencigu ()
  ()
  "La retkonekton rekomencigu."
  (run-shell-command "nmcli c down urso")
  (run-shell-command "nmcli c up urso")
  (message "r"))

(defcommand run (commmand)
  "Alinomo de RUN-COMMAND"
  (run-shell-command command))

(in-package #:stumpo/komandoj)

(def klavojn-mapu (mapo klavoj)
  "La klavajn-valarajn duojn en KLAVOJ al MAPO mapu."
  (loop :for (klavo . valoro) :in klavoj
        :do (define-key mapo (kbd klavo) valoro)))

(def klavojn-malmapu (mapo klavoj)
  "La klavajn-valarajn duojn en KLAVOJ al MAPO mapu"
  (loop :for klavo :in klavoj
        :do (undefine-key mapo (kbd klavo))))
