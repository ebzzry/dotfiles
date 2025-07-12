;;;; grupoj.lisp

(uiop:define-package #:stumpo/grupoj
  (:use #:cl
        #:stumpwm
        #:stumpo/komunajxoj))

(in-package #:stumpwm)

(defcommand grename (name) ((:string "Nova nomo de grupo: "))
  "La aktualan grupon renomu"
  (let ((group (current-group)))
    (cond ((find-group (current-screen) name)
           nil)
          ((or (zerop (length name))
               (string= name "."))
           (message "^1*^BError: empty name"))
          (t
           (cond ((and (char= (char name 0) #\.) ;change to hidden group
                       (not (char= (char (group-name group) 0) #\.)))
                  (setf (group-number group) (find-free-hidden-group-number (current-screen))))
                 ((and (not (char= (char name 0) #\.)) ;change from hidden group
                       (char= (char (group-name group) 0) #\.))
                  (setf (group-number group) (find-free-group-number (current-screen)))))
           (setf (group-name group) name)))))

(in-package #:stumpo/grupoj)

(defun sxargi-grupojn ()
  "La plej supra nivela funkcio."
  (run-commands
   "grename 1"
   "gnewbg 2"
   "gnewbg 3"
   "gnewbg 4"
   "gnewbg 5"
   "gnewbg 6"
   "gnewbg 7"
   "gnewbg 8"
   "gnewbg 9"
   "gnewbg 0"))

(registri-komencan-krocxilon #'sxargi-grupojn)
