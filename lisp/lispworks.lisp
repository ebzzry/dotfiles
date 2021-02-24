;;;; -*- mode: lisp; encoding: utf-8 -*-


;;;-----------------------------------------------------------------------------
;;; Haŭtoj
;;;-----------------------------------------------------------------------------

(asdf:make :editor-color-theme)
(editor-color-theme:color-theme "ebzzry")


;;;-----------------------------------------------------------------------------
;;; Komandoj
;;;-----------------------------------------------------------------------------

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


;;;-----------------------------------------------------------------------------
;;; Transpasoj
;;;-----------------------------------------------------------------------------

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


;;;-----------------------------------------------------------------------------
;;; Klavoj
;;;-----------------------------------------------------------------------------

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

(defun bind-keys (keys &rest args)
  "Bind keys from KEYS"
  (loop :for (command . key) :in keys
        :do (apply #'editor:bind-key (append (list key command) args))))

(defparameter *synonyms*
  '(("Clear" . "Clear Listener")
    ("RB"    . "Revert Buffer")))

(defun make-syns (synonyms)
  "Make command synonyms"
  (loop :for (synonym . command) :in synonyms
        :do (editor:make-command-synonym synonym command)))

(defun customize-prompt ()
  "Customize the listener prompt"
  (setf editor::*prompt* "~&~A ~D~[~:;~:* : ~D~] > "))

(defun customize-editor ()
  "Customize the editor."
  (setf (editor:variable-value `editor:backups-wanted) nil))

(defun set-defaults ()
  (setf cl:*compile-print* 1)
  (hcl:toggle-source-debugging t)
  (lw:set-default-character-element-type 'character))


;;;-----------------------------------------------------------------------------
;;; Ŝanĝoj
;;;-----------------------------------------------------------------------------

(defun main (&rest args)
  "Load customizations"
  (bind-keys *global-keys* :global :emacs)
  (bind-keys *listener-keys* :mode "Execute")
  (make-syns *synonyms*)
  (customize-prompt)
  (customize-editor)
  (set-defaults))

(main)
