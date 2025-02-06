;;;; $DOOM/keys.el -*- lexical-binding: t; -*-


;;; ĉefaferoj

(defmacro map-workspace-keys (map)
  "Map the workspace switching keys in MAP."
  `(map! :map ,map
         :g "s-1" '+workspace/switch-to-0
         :g "s-2" '+workspace/switch-to-1
         :g "s-3" '+workspace/switch-to-2
         :g "s-4" '+workspace/switch-to-3
         :g "s-5" '+workspace/switch-to-4
         :g "s-6" '+workspace/switch-to-5
         :g "s-7" '+workspace/switch-to-6
         :g "s-8" '+workspace/switch-to-7
         :g "s-9" '+workspace/switch-to-8
         :g "s-0" '+workspace/switch-to-final))

(defmacro map-company-keys (map)
  "Map tab to company-complete in MAP."
  `(map! :map ,map
         :i "<tab>" 'company-complete
         :i "TAB"   'company-complete))

(defun bind-workspace-keys ()
  "Bind the workspace keys."
  (map-workspace-keys global-map)
  (map-workspace-keys vterm-mode-map)
  (map-workspace-keys sly-mrepl-mode-map)
  (map-workspace-keys treemacs-mode-map))

(defun bind-company-keys ()
  "Bind the company keys."
  (map-company-keys global-map))

(defun bind-toplevel-keys ()
  "Bind the toplevel keys."
  ;; general
  (map! :g "s-b" 'switch-to-buffer
        :g "s-i" 'evil-insert-digraph
        :g "s-." 'doom/reload
        :g "s-`" 'evil-switch-to-windows-last-buffer
        :g "s-d" 'my-dired
        :g "s-f" 'my-find-file-cwd
        :g "s-F" 'my-find-file-home
        :g "s-h" 'replace-regexp
        :g "s-H" 'replace-string
        :g "s-a" 'org-agenda
        :g "s-n" 'org-capture
        :g "s-p" '+treemacs/toggle
        :g "s-t" 'my-new-workspace-cwd
        :g "s-T" 'my-new-workspace-home
        :g "s-u" 'undo-fu-only-undo
        :g "s-r" 'undo-fu-only-redo
        :g "s-e" 'my-collapse-all-windows
        :g "s-E" 'my-expand-all-windows)
  ;; workspaces
  (map! :g "s-D" '+workspace/delete
        :g "s-g" 'my-garbage-collect-workspaces
        :g "s-G" 'my-garbage-collect-buffers
        :g "s-s" 'my-save-workspace
        :g "s-k" 'my-switch-or-load-workspace
        :g "s-o" '+workspace/other
        :g "s-y" '+workspace/display
        :g "s-," '+workspace/rename
        :g "s-;" 'my-rename-all-workspaces
        :g "s-w" 'my-workspace-kill
        :g "s-W" '+workspace/kill-session
        :g "s-[" '+workspace/switch-left
        :g "s-]" '+workspace/switch-right
        :g "s-{" '+workspace/swap-left
        :g "s-}" '+workspace/swap-right)
  ;; windows
  (map! :niv "S-<left>" 'evil-window-left
        :niv "S-<right>" 'evil-window-right
        :niv "S-<up>" 'evil-window-up
        :niv "S-<down>" 'evil-window-down)
  ;; main
  (map! :n "K" 'join-line ; was +lookup/documentation
        :n "g g" 'my-goto-first-line
        :n "G" 'my-goto-line
        :n "[ <" 'beginning-of-buffer
        :n "] >" 'end-of-buffer
        :n "?" 'evil-ex-search-backward
        :n "/" 'evil-ex-search-forward
        :n "(" 'sp-down-sexp
        :n ")" 'sp-up-sexp
        :n "{" 'sp-backward-up-sexp
        :n "}" 'sp-backward-down-sexp
        :nv "\\" 'repeat
        :n "RET" 'newline-and-indent
        :n "<RET>" 'newline-and-indent))

(defun bind-main-keys ()
  "Bind the main leader keys."
  (map! :leader
        :desc "Execute extended command"  "<SPC>" 'execute-extended-command
        :desc "Dired"                     "d" '+default/dired
        :desc "Eval expression "          ":" 'pp-eval-expression
        :desc "Shell command"             "!" 'shell-command
        :desc "Shell command on region"   "|" 'shell-command-on-region
        :desc "Vterm toggle"              "'" 'my-vterm
        :desc "Open a.org"                "a" 'my-open-a-org
        :desc "Open scratch buffer"       "A" 'my-open-scratch-bufer
        :desc "Mark sexp"                 "v" 'mark-sexp
        :desc "Mark defun"                "V" 'mark-defun
        :desc "Mark buffer"               "C-v" 'mark-whole-buffer
        :desc "Select window"             "o" 'ace-window
        :desc "Maximize window"           "w m" 'doom/window-maximize-buffer
        :desc "Transpose frame"           "w t" 'transpose-frame)
  (map! :leader
        :desc "Save all buffers"          "f S" 'save-all-buffers
        :desc "Find file at point"        "f ." 'find-file-at-point
        :desc "Edit HISTFILE"             "f h" 'my-edit-histfile
        :desc "Projectle replace"         "p $" 'projectile-replace
        :desc "Projectile replace regexp" "p %" 'projectile-replace-regexp
        :desc "Switch to buffer"          "b b" 'consult-buffer
        :desc "Buffer menu"               "b B" 'buffer-menu
        :desc "Find function"             "h C-f" 'find-function
        :desc "Find variable"             "h C-v" 'find-variable))

(defun bind-y-keys ()
  "Bind y-prefix keys."
  (map! :leader
        (:prefix-map ("y" . "smartparens")
         :desc "Forward kill sexp"       "k" 'sp-kill-sexp
         :desc "Backward kill sexp"      "K" 'sp-backward-kill-sexp
         :desc "Forward change sexp"     "c" 'change-sexp
         :desc "Backward change sexp"    "C" 'backward-change-sexp
         :desc "Forward copy sexp"       "y" 'sp-copy-sexp
         :desc "Backward copy sexp"      "Y" 'sp-backward-copy-sexp
         :desc "Transpose sexp"          "t" 'sp-transpose-sexp
         :desc "Unwrap sexp"             "u" 'sp-unwrap-sexp
         :desc "Raise sexp"              "r" 'sp-raise-sexp
         :desc "Forward slurp sexp"      "s" 'sp-forward-slurp-sexp
         :desc "Backward slurp sexp"     "S" 'sp-backward-slurp-sexp
         :desc "Forward barf sexp"       "b" 'sp-forward-barf-sexp
         :desc "Backward barf sexp"      "B" 'sp-backward-barf-sexp
         :desc "Absorb sexp"             "a" 'sp-absorb-sexp
         :desc "Convolute sexp"          "v" 'sp-convolute-sexp
         :desc "Wrap with ()"            "(" 'wrap-with-parens
         :desc "Wrap with []"            "[" 'wrap-with-brackets
         :desc "Wrap with {}"            "{" 'wrap-with-braces
         :desc "Wrap with ''"            "'" 'wrap-with-single-quotes
         :desc "Wrap with \"\""          "\"" 'wrap-with-double-quotes)))

(defun bind-z-keys ()
  "Bind z-prefix keys."
  (map! :leader
        (:prefix-map
         ("x" . "x-menu")
         (:prefix-map ("c" . "clear")
          :desc "Clear buffer"             "b" 'clear-buffer
          :desc "Clear output"             "o" 'clear-output
          :desc "Clear lines"              "l" 'flush-lines)
         (:prefix-map ("d" . "dired")
          :desc "Complete edits"           "c" 'wdired-finish-edit
          :desc "Edit dired"               "e" 'wdired-change-to-wdired-mode)
         (:prefix-map ("e" . "export")
          :desc "Org export as HTML"        "h" 'org-html-export-to-html
          :desc "Org Pandoc export as HTML" "H" 'org-pandoc-export-as-html5
          :desc "Org export as PDF"         "p" 'org-latex-export-to-pdf)
         (:prefix-map ("o" . "open")
          :desc "Open as HTML"             "h" 'my-open-html-file
          :desc "Open as PDF"              "p" 'my-open-pdf-file)
         (:prefix-map ("F" . "fill")
          :desc "Set fill column"          "c" 'set-fill-column
          :desc "Fill region"              "f" 'fill-region)
         (:prefix-map ("f" . "fold")
          :desc "Vimish avy fold"          "a" 'vimish-fold-avy
          :desc "Vimish delete fold"       "d" 'vimish-fold-delete
          :desc "Vimish delete all folds"  "D" 'vimish-fold-delete-all
          :desc "Vimish create fold"       "c" 'vimish-fold
          :desc "Vimish toggle fold"       "t" 'vimish-fold-toggle
          :desc "Vimish toggle all folds"  "T" 'vimish-fold-toggle-all)
         (:prefix-map ("i" . "insert")
          "u" nil "f" nil "F" nil "i" nil "r" nil "s" nil "y" nil
          :desc "Insert from kill ring"    "k" '+default/yank-pop
          :desc "Insert file"              "f" 'insert-file
          :desc "Insert comment line"      "l" 'insert-comment-line
          :desc "Insert char"              "c" 'insert-char
          :desc "Insert emoji"             "e" 'emojify-insert-emoji)
         (:prefix-map ("r" . "register")
          :desc "Point to register"        "." 'point-to-register
          :desc "Copy to register"         "c" 'copy-to-register
          :desc "Insert register"          "i" 'insert-register
          :desc "Jump to register"         "j" 'jump-to-register
          :desc "Rectangle to register"    "r" 'copy-rectangle-to-register
          :desc "Show registers"           "s" 'evil-show-registers
          :desc "Window register"          "w" 'window-configuration-to-register
          :desc "Kill rectangle"           "k" 'kill-rectangle
          :desc "Delete rectangle"         "d" 'delete-rectangle
          :desc "Yank rectangle"           "y" 'yank-rectangle
          :desc "Paste rectangle"          "p" 'yank-rectangle)
         (:prefix-map ("x" . "delete")
          :desc "Delete region"            "r" 'delete-region
          :desc "Delete horizontal space"  "h" 'delete-horizontal-space
          :desc "Just one space"           "o" 'just-one-space)
         (:prefix-map ("y" . "yank")
          :desc "Yank buffer to clipboard" "b" 'yank-buffer-to-clipboard
          :desc "Yank defun to clipboard"  "d" 'yank-defun-to-clipboard
          :desc "Yank region to clipboard" "r" 'yank-region-to-clipboard))))

(defun bind-mac-keys ()
  "Bind macOS keys."
  (setq mac-option-modifier 'none))

(defun bind-org-keys ()
  "Bind org keys."
  (map! :localleader
        :map org-mode-map
        :desc "Org Meta Return" "RET" 'org-meta-return))

(defun bind-sly-keys ()
  "Bind sly keys."
  (map! :map sly-mrepl-mode-map
        :n "<up>" 'sly-mrepl-previous-input-or-button
        :n "<down>" 'sly-mrepl-next-input-or-button
        :i "<up>" 'sly-mrepl-previous-input-or-button
        :i "<down>" 'sly-mrepl-next-input-or-button
        :i "<tab>" 'sly-mrepl-indent-and-complete-symbol
        :i "TAB" 'sly-mrepl-indent-and-complete-symbol)
  (map! :map sly-mrepl-mode-map
        :i "<tab>" 'company-complete
        :i "TAB" 'company-complete)
  (map! :localleader
        :map sly-mode-map
        :desc "Switch to REPL" :nv "o" 'my-switch-to-sly-mrepl-window))


;;; toplevel

(bind-workspace-keys)
(bind-company-keys)
(bind-toplevel-keys)
(bind-main-keys)
(bind-y-keys)
(bind-z-keys)
(bind-mac-keys)
(bind-org-keys)
(bind-sly-keys)
