;;; $DOOM/settings.el -*- lexical-binding: t; -*-


;;; agordoj

(defun setup-fonts ()
  "Setup Doom fonts."
  (setq doom-font (font-spec :family "Commitmono" :size 11)))

(defun set-modes (modes)
  "Loop over modes to set specific values."
  (cl-loop for (key . val) in modes
           do (when (fboundp key)
                (funcall key val))))

(defun setup-ui ()
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

(defun system-select (darwin other)
  "Return DARWIN if the current system is Darwin, otherwise return OTHER."
  (if (string= system-type 'darwin) darwin other))

(defun setup-variables ()
  "Setup Emacs-wide variables."
  (setq user-full-name "Rommel Martínez"
        user-mail-address "rommel.martinez@valmiz.com"
        user-login-name (getenv "USER")
        inferior-lisp-program (system-select "lw" "sbcl")
        insert-directory-program (system-select "/opt/homebrew/bin/gls" "ls")
        case-fold-search nil
        vc-follow-symlinks t
        undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))
        make-backup-files t
        backup-directory-alist `((".*" . "~/Developer/dat/backups/"))
        auto-save-file-name-transforms `((".*" "~/Developer/dat/backups/" t))
        native-comp-async-report-warnings-errors nil
        warning-minimum-level :error
        enable-local-variables :safe
        ls-lisp-use-insert-directory-program t
        large-file-warning-threshold nil)
  (setq doom-theme 'doom-manegarm
        +evil-want-o/O-to-continue-comments nil
        fancy-splash-image "~/Pictures/Private/doom-splash/wallhaven-333472-550x.png"
        display-line-numbers-type nil
        evil-move-cursor-back t
        auto-save-default t
        confirm-kill-emacs nil
        bookmark-file (my-doom-path "bookmarks")
        grep-program "ggrep")
  (setq-default fill-column 80)
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8))

(defun setup-templates ()
  (set-file-template! "/*.org$" :trigger "__.org" :mode 'org-mode)
  (set-file-template! "/*.asd$" :trigger "__.asd" :mode 'lisp-mode)
  (set-file-template! "/*-tests\\.asd$" :trigger "__-tests.asd" :mode 'lisp-mode)
  (set-file-template! "/version\\.sexp$" :trigger "__version.sexp" :mode 'lisp-mode)
  (set-file-template! "/version-tests\\.sexp$" :trigger "__version.sexp" :mode 'lisp-mode)
  (set-file-template! "/\\(scratch\\|test\\|core\\|ex\\)-?\\(?:[0-9]\\)*\\.lisp$" :trigger "__.lisp" :mode 'lisp-mode)
  (set-file-template! "/driver\\.lisp$" :trigger "__driver.lisp" :mode 'lisp-mode)
  (set-file-template! "/user\\.lisp$" :trigger "__user.lisp" :mode 'lisp-mode)
  (set-file-template! "/core-tests\\.lisp$" :trigger "__core-tests.lisp" :mode 'lisp-mode)
  (set-file-template! "/driver-tests\\.lisp$" :trigger "__driver-tests.lisp" :mode 'lisp-mode)
  (set-file-template! "/user-tests\\.lisp$" :trigger "__user-tests.lisp" :mode 'lisp-mode)
  (set-file-template! "/*.s$" :trigger "__.s" :mode 'asm-mode))

(defun setup-hooks ()
  "Setup the common hooks."
  (add-hook 'lisp-mode-hook 'turn-on-auto-fill)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-auto-fill))

(defun alist-keys (alist)
  (mapcar 'car alist))

(defvar my-custom-digraphs
  '(((?p ?p) . ?\x20B1) ;₱

    ((?a ?a) . ?\x2227) ;∧
    ((?o ?o) . ?\x2228) ;∨
    ((?n ?n) . ?\x00AC) ;¬

    ((?& ?&) . ?\x2227) ;∧
    ((?| ?|) . ?\x2228) ;∨
    ((?! ?!) . ?\x00AC) ;¬
    )
  "Association list of my custom digraphs.")

(defun setup-digraphs ()
  "Remove my custom digraphs from the existing digraphs table."
  (let ((keys (alist-keys my-custom-digraphs)))
    (cl-loop for key in keys
             do (setq evil-digraphs-table
                      (assoc-delete-all key evil-digraphs-table)))
    (setq evil-digraphs-table
          (append evil-digraphs-table
                  my-custom-digraphs))))

(defun setup-modes ()
  (add-to-list 'auto-mode-alist '("\\.vos\\'" . lisp-mode))
  (add-to-list 'display-buffer-alist '("*Async Shell Command*" display-buffer-no-window (nil))))


;;; top-level

(setup-ui)
(setup-variables)
(setup-templates)
(setup-hooks)
(setup-modes)
(setup-digraphs)
