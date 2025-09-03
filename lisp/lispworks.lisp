;;;; -*- mode: lisp; encoding: utf-8 -*-


;;; aliaj pakoj

(ql:quickload :flexi-streams)


;;; komandoj

(editor:defcommand "Delete DWIM" (p)
     "Delete the highlighted region, or the next character if there is no highlighted region."
     "Delete highlighted region, otherwise next character."
  (let ((buffer (editor:current-buffer)))
    (if (editor::region-highlighted-p buffer)
        (editor:delete-region-command p)
      (editor:delete-next-character-command p))))

(editor:defcommand "Comment DWIM" (p)
     "Comment the highlighted region, or create a comment if there is no highlighted region."
     "Comment the highlighted region, otherwise the line."
  (let ((buffer (editor:current-buffer)))
    (if (editor::region-highlighted-p buffer)
        (editor::comment-region-command p)
      (editor:indent-for-comment-command p))))

(defun throw-to-top-level (&key message (stream (variable-value 'rubber-stream)))
  (let* ((buffer (rubber-stream-buffer stream))
         (point (buffer-point buffer)))
    (buffer-end point)
    (reset-rubber-stream stream buffer)
    (update-buffer-windows buffer)
    (throw #+:Harlequin-Common-Lisp 'sys::hclenv
           #+:lucid 'lucid::hclenv)))


;;; transpasoj

(defun clear-listener ()
  (let ((buffer (editor::current-buffer)))
    (editor:clear-buffer buffer)
    (throw-to-top-level-command nil)))

(editor:defcommand "Throw To Top Level" (p)
     "Throws to the top level."
     (declare (ignore p))
  (editor::istream-queue-out-of-band-input
   (editor::window-text-pane (editor::current-window))
   `(editor::throw-to-top-level :stream ,(editor::variable-value 'editor::rubber-stream))))

(editor:defcommand "Clear Listener" (p)
     "Clear the listener"
     "Clear the listener"
  (declare (ignore p))
  (let ((buffer (editor::current-buffer)))
    (when (editor::buffer-execute-p buffer)
      (clear-listener))))


;;; klavkombinoj

(defparameter *global-keys*
  '(("("         . "Insert Parentheses For Selection")
    ("\""        . "Insert Double Quotes For Selection")
    ("C-/"       . "Undo")
    ("M-k"       . "Backward Kill Form")
    ("C-k"       . "Forward Kill Form")
    ("M-:"       . "Evaluate Expression")
    ("M-o"       . "Just One Space")
    ("M-$"       . "Replace String")
    ("M-%"       . "Replace Regexp")
    ("C-d"       . "Delete DWIM")
    ("M-;"       . "Comment DWIM")
    ("M-&"       . "Directory Query Replace")
    ("M-Left"    . "Go Back")
    ("M-Right"   . "Go Forward")
    ("C-M-Space" . "Mark Form")
    ("Return"    . "Indent New Line")
    ("C-j"       . "New Line")))

(defparameter *listener-keys*
  '(("C-j" . "Indent New Line")
    ("M-k" . "Backward Kill Form")
    ("C-l" . "Clear")))

(defparameter *synonyms*
  '(("Clear"  . "Clear Listener")
    ("Revert" . "Revert Buffer")))

(defun setup-synonyms (&optional (synonyms *synonyms*))
  "Make command synonyms"
  (loop :for (synonym . command) :in synonyms
        :do (editor:make-command-synonym synonym command)))

(defun bind-keys (keys &rest args)
  "Bind keys from KEYS"
  (loop :for (command . key) :in keys
        :do (apply #'editor:bind-key (append (list key command) args))))

(defun setup-emacs-keybindings ()
  (bind-keys *global-keys* :global :emacs)
  (bind-keys *listener-keys* :mode "Execute"))

(defun setup-vim-keybindings ()
  (asdf:load-system :lw-vim-mode))

(defun setup-prompt ()
  "Customize the listener prompt"
  (setf editor::*prompt* "~&~A ~D~[~:;~:* : ~D~] > "))

(defun setup-editor ()
  "Customize the editor."
  (setf (editor:variable-value `editor:backups-wanted) nil))

;; (defun setup-editor-color-theme ()
;;   "Customire the editor color theme."
;;   (asdf:load-system :lw-editor-color-theme)
;;   (lw-editor-color-theme:color-theme "ebzzry"))

(defun setup-options ()
  (setf cl:*compile-print* 1)
  (hcl:toggle-source-debugging t)
  (lw:set-default-character-element-type 'character)
  (dbg:set-debugger-options :bindings t :catchers t :handler t :restarts t)
  (pushnew :utf-8 system:*specific-valid-file-encodings*)
  (lw:set-default-character-element-type 'character)

  #-mswindows
  (fli:set-locale "en_US.UTF-8")

  #-(and (or linux darwin) lispworks-64bit)
  (require "kw")

  (require "sqlite"))


;;; ŝargado

(defun main (&rest args)
  "Load customizations"
  (setup-vim-keybindings)
  (setup-synonyms)
  (setup-prompt)
  (setup-editor)
  ;; (setup-editor-color-theme)
  (setup-options))

(main)
