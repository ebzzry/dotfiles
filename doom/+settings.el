;;; $DOOMDIR/settings.el -*- lexical-binding: t; -*-


;;; agordoj

(def setup-font ()
  "Setup Doom fonts."
  (when (string-equal (system-name) "la-orka")
    (set-frame-font "FiraCode Nerd Font Mono-12" nil t)))

(def set-modes (modes)
  "Loop over modes to set specific values."
  (cl-loop for (key . val) in modes
           do (when (fboundp key)
                (funcall key val))))

(def setup-ui ()
  "Setup UI options."
  (set-modes '((menu-bar-mode . -1)
               (tool-bar-mode . -1)
               (scroll-bar-mode . -1)
               (line-number-mode . 1)
               (horizontal-scroll-bar-mode . -1)
               (column-number-mode . 1)
               (transient-mark-mode . 1)
               (size-indication-mode . 1)))
  (unless window-system
    (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
    (global-set-key (kbd "<mouse-5>") 'scroll-up-line)))

(def system-select (darwin other)
  "Return DARWIN if the current system is Darwin, otherwise return OTHER."
  (if (string= system-type 'darwin) darwin other))

(def setup-variables ()
  "Setup Emacs-wide variables."
  (setq user-full-name "Rommel Martínez"
        user-mail-address "ebzzry@icloud.com"
        user-login-name (getenv "USER")
        inferior-lisp-program (system-select "lispworks" "sbcl")
        insert-directory-program (system-select "/opt/homebrew/bin/gls" "ls")
        case-fold-search nil
        vc-follow-symlinks t
        undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))
        native-comp-async-report-warnings-errors nil
        warning-minimum-level :error
        enable-local-variables :safe
        ls-lisp-use-insert-directory-program t
        large-file-warning-threshold nil)
  (setq doom-theme 'doom-manegarm
        +evil-want-o/O-to-continue-comments nil
        fancy-splash-image nil
        display-line-numbers-type nil
        evil-move-cursor-back t
        evil-escape-key-esquence nil
        auto-save-default t
        confirm-kill-emacs nil
        bookmark-file (my-doom-path "bookmarks")
        grep-program "ggrep"
        version-control t)
  (setq make-backup-files nil
        backup-directory-alist `(("." . "~/Developer/dat/backups/"))
        backup-by-copying t
        delete-old-versions t
        kept-new-versions 10
        kept-old-versions 10)
  (setq-default fill-column 80
                sh-basic-offset 2)
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8))

(def setup-templates ()
  "Setup the snippets system."
  (set-file-template! "/*.org$" :trigger "__.org" :mode 'org-mode)
  (set-file-template! "/*.asd$" :trigger "__.asd" :mode 'lisp-mode)
  (set-file-template! "/*.lisp$" :trigger "__.lisp" :mode 'lisp-mode)
  (set-file-template! "/*.s$" :trigger "__.s" :mode 'asm-mode)
  (set-file-template! "/*.sh$" :trigger "__.sh" :mode 'sh-mode)
  (set-file-template! "/*.nix$" :trigger "__.nix" :mode 'nix-mode)
  (set-file-template! "/apps\\.nix$" :trigger "__apps.nix" :mode 'nix-mode)
  (set-file-template! "/packages\\.nix$" :trigger "__packages.nix" :mode 'nix-mode)
  (set-file-template! "/shells\\.nix$" :trigger "__shells.nix" :mode 'nix-mode)
  (set-file-template! "/flake\\.nix$" :trigger "__flake.nix" :mode 'nix-mode)
  (set-file-template! "/makefile$" :trigger "__makefile" :mode 'makefile-mode)
  (set-file-template! "/*.tex$" :trigger "__.tex" :mode 'latex-mode)
  (set-file-template! "/letter\\.tex$" :trigger "__letter.tex" :mode 'latex-mode))

(def setup-hooks ()
  "Setup the common hooks."
  (add-hook 'lisp-mode-hook 'turn-on-auto-fill)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-auto-fill)
  (add-hook 'after-save-hook 'backup-each-save)
  (add-hook 'before-save-hook 'time-stamp))

(def alist-keys (alist)
  (mapcar 'car alist))

(defvar my-custom-digraphs
  '(((?p ?p) . ?\x20B1)                     ;₱
    ((?a ?a) . ?\x2227) ((?& ?&) . ?\x2227) ;∧
    ((?o ?o) . ?\x2228) ((?| ?|) . ?\x2228) ;∨
    ((?n ?n) . ?\x00AC) ((?! ?!) . ?\x00AC) ;¬
    )
  "Association list of my custom digraphs.")

(def setup-digraphs ()
  "Remove my custom digraphs from the existing digraphs table."
  (require 'evil-digraphs)
  (let ((keys (alist-keys my-custom-digraphs)))
    (cl-loop for key in keys
             do (setq evil-digraphs-table
                      (assoc-delete-all key evil-digraphs-table)))
    (setq evil-digraphs-table
          (append evil-digraphs-table
                  my-custom-digraphs))))

(def unassoc (key alist)
  "Remove KEY from ALIST"
  (delq (assoc key alist) alist))

(def setup-modes ()
  (add-to-list 'auto-mode-alist '("\\.[kK]\\'" . lisp-mode))
  (add-to-list 'display-buffer-alist '("*Async Shell Command*"
                                       display-buffer-no-window (nil))))

(defvar *my-time-stamp-pattern*
  "10/Last update:[ \t]+\\\\?[\"<]+%a %b %d %02H:%02M:%02S %Y %5z\\\\?[\">]"
  "My own time stamp pattern.")

(def my-markdown-mode-hook ()
  (set (make-local-variable 'time-stamp-pattern) *my-time-stamp-pattern*))

(add-hook 'markdown-mode-hook 'my-markdown-mode-hook)


;;; top-level

(setup-font)
(setup-ui)
(setup-variables)
(setup-templates)
(setup-hooks)
(setup-digraphs)
(setup-modes)
