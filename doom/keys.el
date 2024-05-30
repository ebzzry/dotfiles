;;;; $DOOM/keys.el -*- lexical-binding: t; -*-


;;; main

(defun setup-normal-mode-keys ()
  "Setup the keys for the normal mode."
  (map! :n "S-<left>" 'my-other-window-1
        :n "S-<right>" 'my-other-window
        :n "S-<up>" 'swap-up
        :n "S-<down>" 'swap-down
        :i "S-<left>" 'other-window-1
        :i "S-<right>" 'other-window
        :i "S-<up>" 'swap-up
        :i "S-<down>" 'swap-down)
  (map! :n "K" 'join-line ; was +lookup/documentation
        :n "RET" 'sp-newline
        :n "<RETURN>" 'sp-newline
        :n "<del>" 'delete-dwim
        :n "<deletechar>" 'delete-dwim
        :n "DEL" 'delete-dwim
        :n "?" 'evil-ex-search-backward
        :n "/" 'evil-ex-search-forward
        :n "(" 'sp-down-sexp
        :n ")" 'sp-up-sexp
        :n "{" 'sp-backward-up-sexp
        :n "}" 'sp-backward-down-sexp
        :n "g SPC" 'mark-sexp
        :n "g RET" 'mark-defun
        :n "g ("   'wrap-with-parens
        :n "g ["   'wrap-with-brackets
        :n "g {"   'wrap-with-braces
        :n "g '"   'wrap-with-single-quotes
        :n "g \""  'wrap-with-double-quotes))

(defun setup-leader-keys ()
  "Setup the main leader keys."
  (map! :leader
        :desc "Execute extended command"  "<SPC>" 'execute-extended-command
        :desc "Eval expression "          ":" 'pp-eval-expression
        :desc "Shell command"             "!" 'shell-command
        :desc "Shell command on region"   "|" 'shell-command-on-region
        :desc "Vterm"                     "'" '+vterm/toggle
        :desc "Beginning of buffer"       "<" 'beginning-of-buffer
        :desc "End of buffer"             ">" 'end-of-buffer)
  (map! :leader
        :desc "Save all buffers"          "f S" 'save-all-buffers
        :desc "Projectle replace"         "p $" 'projectile-replace
        :desc "Projectile replace regexp" "p %" 'projectile-replace-regexp))

(defun setup-y-keys ()
  "Setup y keys."
  (map! :leader
        (:prefix-map ("y" . "y")
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
         :desc "Convolute sexp"          "v" 'sp-convolute-sexp)))

(defun setup-z-keys ()
  "Setup z keys."
  (map! :leader
        (:prefix-map ("TAB" . "workspace")
         :desc "Swap with previous workspace"        "{"   #'+workspace/swap-left
         :desc "Swap with next workspace"            "}"   #'+workspace/swap-right)
        (:prefix-map
         ("z" . "z")
         (:prefix-map ("f" . "fill")
          :desc "Fill region"             "f" 'fill-region)
         (:prefix-map ("r" . "replace")
          :desc "Replace string"          "s" 'replace-string
          :desc "Replace regexp"          "r" 'replace-regexp)
         (:prefix-map ("R" . "register")
          :desc "Jump to register"                 "j" 'jump-to-register
          :desc "Window configuration to register" "w" 'window-configuration-to-register)
         (:prefix-map ("b" . "bookmarks")
          :desc "Edit bookmark"           "e" 'edit-bookmarks
          :desc "Save windows"            "s" 'save-windows
          :desc "Restore windows"         "r" 'restore-windows)
         (:prefix-map ("k" . "clear")
          :desc "Clear buffer"            "b" 'clear-buffer
          :desc "Clear output"            "o" 'clear-output)
         (:prefix-map ("e" . "export")
          :desc "Org export to HTML"      "h" 'org-html-export-to-html
          :desc "Org export to PDF"       "p" 'org-latex-export-to-pdf)
         (:prefix-map ("d" . "delete")
          :desc "Delete region"           "d" 'delete-region
          :desc "Delete horizontal space" "h" 'delete-horizontal-space
          :desc "Just one space"          "o" 'just-one-space)
         (:prefix-map ("i" . "insert")
          :desc "Insert comment line"     "c" 'insert-comment-line
          :desc "Insert char"             "i" 'insert-char)
         (:prefix-map ("c" . "copy")
          :desc "Copy region to clipboard" "c" 'copy-region-to-clipboard
          :desc "Copy defun to clipboard"  "d" 'copy-defun-to-clipboard))))

(defun setup-other-keys ()
  "Setup other keys."
  (map! :map magit-status-mode-map
        :n "q" 'magit-quit-session)
  (map! :map sly-mrepl-mode-map
        :n "<up>" 'sly-mrepl-previous-input-or-button
        :n "<down>" 'sly-mrepl-next-input-or-button
        :i "<up>" 'sly-mrepl-previous-input-or-button
        :i "<down>" 'sly-mrepl-next-input-or-button
        :i "<tab>" 'sly-mrepl-indent-and-complete-symbol
        :i "TAB" 'sly-mrepl-indent-and-complete-symbol)
  (map! :map sly-mrepl-mode-map
        :localleader
        :desc "SLY mrepl sync" "s" 'sly-mrepl-sync))



;;; top-level

(setup-normal-mode-keys)
(setup-leader-keys)
(setup-other-keys)
(setup-y-keys)
(setup-z-keys)
