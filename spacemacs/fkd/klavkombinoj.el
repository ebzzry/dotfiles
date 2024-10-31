;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

;;; funkcioj

(defun bind-normal-evil-key (key command)
  "Bind KEY to COMMAND in normal mode."
  (define-key evil-normal-state-map key command))

(defun bind-insert-evil-key (key command)
  "Bind KEY to COMMAND in insert mode."
  (define-key evil-insert-state-map key command)
  (define-key evil-replace-state-map key command))

(defun bind-visual-evil-key (key command)
  "Bind KEY to COMMAND in visual mode."
  (define-key evil-visual-state-map key command))

(defun bind-evil-key (key command)
  "Bind KEY to COMMAND in insert and normal Evil modes."
  (bind-normal-evil-key key command)
  (bind-insert-evil-key key command))

(defun unbind-evil-key (key)
  "Unbind KEY in both normal and insert Evil modes."
  (bind-normal-evil-key key 'ignore)
  (bind-insert-evil-key key 'ignore)
  (bind-visual-evil-key key 'ignore))

(defun bind-evil-motion-key (key command)
  "Bind KEY to COMMAND in evil motion mode."
  (define-key evil-motion-state-map key command))

(defun setup-evil-keys ()
  "Setup the keys for Evil."
  (bind-evil-key (kbd "S-<left>") 'other-window-1)
  (bind-evil-key (kbd "S-<right>") 'other-window)
  (bind-evil-key (kbd "S-<up>") 'swap-up)
  (bind-evil-key (kbd "S-<down>") 'swap-down)

  (bind-normal-evil-key (kbd "(") 'sp-down-sexp)
  (bind-normal-evil-key (kbd ")") 'sp-up-sexp)
  (bind-normal-evil-key (kbd "{") 'sp-backward-up-sexp)
  (bind-normal-evil-key (kbd "}") 'sp-backward-down-sexp)
  (bind-normal-evil-key (kbd "?") 'evil-ex-search-backward)
  (bind-normal-evil-key (kbd "/") 'evil-ex-search-forward)

  (bind-normal-evil-key (kbd "RET") 'sp-newline)
  (bind-normal-evil-key (kbd "<return>") 'sp-newline)

  (bind-normal-evil-key (kbd "DEL") 'evil-delete-backward-char)

  (bind-normal-evil-key (kbd "<delete>") 'delete-dwim)
  (bind-normal-evil-key (kbd "<deletechar>") 'delete-dwim)

  (bind-normal-evil-key (kbd "V") 'evil-visual-line)
  (bind-visual-evil-key (kbd "V") 'evil-visual-line)

  (bind-normal-evil-key (kbd "K") 'join-line)

  (bind-normal-evil-key (kbd "-") 'evil-previous-line-first-non-blank)
  (bind-normal-evil-key (kbd "+") 'evil-next-line-first-non-blank)

  (bind-insert-evil-key (kbd "C-o") 'evil-execute-in-normal-state)
  (bind-insert-evil-key (kbd "C-k") 'evil-insert-digraph)
  (bind-insert-evil-key (kbd "C-v") 'evil-quoted-insert)

  ;; (bind-normal-evil-key (kbd "TAB") 'evil-indent)
  (bind-insert-evil-key (kbd "TAB") 'complete-symbol)
  (bind-insert-evil-key (kbd "<tab>") 'complete-symbol)

  (bind-evil-motion-key "[<" 'backward-page)
  (bind-evil-motion-key "]>" 'forward-page))

(defun setup-global-keys ()
  "Setup keys for the global map."
  (define-key global-map (kbd "S-<left>") 'other-window-1)
  (define-key global-map (kbd "S-<right>") 'other-window)
  (define-key global-map (kbd "S-<up>") 'swap-up)
  (define-key global-map (kbd "S-<down>") 'swap-down))

(defun setup-main-leader-keys ()
  "Setup extra keybindings."
  (spacemacs/set-leader-keys dotspacemacs-emacs-command-key 'execute-extended-command)
  (spacemacs/set-leader-keys "hw" 'where-is)
  (spacemacs/set-leader-keys "xC" 'capitalize-region)
  (spacemacs/set-leader-keys "fV" 'find-version-file)
  (spacemacs/set-leader-keys ":" 'eval-expression)
  (spacemacs/set-leader-keys "id" 'insert-day-and-date)
  (spacemacs/set-leader-keys "iD" 'insert-date-and-time))


;;; .-klavoj

(defun setup-period-leader-keys ()
  "Setup leader keys for `.'."
  (spacemacs/declare-prefix "." "sexps")
  (spacemacs/set-leader-keys
    ".k" 'sp-kill-sexp
    ".K" 'sp-backward-kill-sexp
    ".c" 'change-sexp
    ".C" 'backward-change-sexp
    ".y" 'sp-copy-sexp
    ".Y" 'sp-backward-copy-sexp
    ".t" 'sp-transpose-sexp
    ".(" 'wrap-with-parens
    ".[" 'wrap-with-brackets
    ".{" 'wrap-with-braces
    ".u" 'sp-unwrap-sexp
    ".r" 'sp-raise-sexp
    ".s" 'sp-forward-slurp-sexp
    ".S" 'sp-backward-slurp-sexp
    ".b" 'sp-forward-barf-sexp
    ".B" 'sp-backward-barf-sexp
    ".a" 'sp-absorb-sexp
    ".v" 'sp-convolute-sexp
    ".o" 'slime-switch-to-output-buffer))


;;; o-klavoj

(defun setup-o-leader-keys ()
  "Setup leader keys for 'o'."
  (spacemacs/declare-prefix "o" "other")
  (spacemacs/set-leader-keys
    "ow" 'writeroom-mode
    "of" 'fill-region
    "oo" 'open-directory
    "ob" 'edit-bookmarks

    "o$" 'replace-string
    "o%" 'replace-regexp

    "os" 'save-windows
    "or" 'restore-windows

    "ov" 'mark-sexp
    "oV" 'mark-defun

    "oc" 'insert-comment-line
    "o;" 'copy-comment

    "ok" 'clear-buffer
    "oK" 'clear-output

    "oi" 'insert-char
    "od" 'delete-region

    "oH" 'delete-horizontal-space
    "oO" 'just-one-space

    "oh" 'org-html-export-to-html
    "op" 'org-latex-export-to-pdf

    "ot" 'switch-theme

    "oR" 'revert-buffer-all))


;;; funkcioj

(defun setup-mode-keys ()
  "Setup keys for different major modes."
  (define-key windmove-mode-map (kbd "S-<left>") 'other-window-1)
  (define-key windmove-mode-map (kbd "S-<right>") 'other-window)
  (define-key windmove-mode-map (kbd "S-<up>") 'swap-up)
  (define-key windmove-mode-map (kbd "S-<down>") 'swap-down)

  (define-key calendar-mode-map "h" 'calendar-backward-day)
  (define-key calendar-mode-map "l" 'calendar-forward-day)
  (define-key calendar-mode-map "H" 'calendar-backward-week)
  (define-key calendar-mode-map "L" 'calendar-forward-week))

(defun setup-keys ()
  "Setup keys."
  (setup-evil-keys)
  (setup-global-keys)
  (setup-main-leader-keys)
  (setup-period-leader-keys)
  (setup-o-leader-keys)
  (setup-left-bracket-leader-keys)
  (setup-right-bracket-leader-keys)
  (setup-mode-keys))
