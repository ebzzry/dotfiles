;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

;;; elpa
(require 'package)

(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ;; ("marmalade" . "http://marmalade-repo.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))

;;(package-initialize)

;;; use-package
(require 'use-package)
(require 'bind-key)

;;; hyperspec
(use-package hyperspec
  :config (progn
            (let ((hyperspec-root (ef "/pub/dok/komputado/lingvoj/lispo/hyperspec/")))
              (setq common-lisp-hyperspec-root hyperspec-root
                    common-lisp-hyperspec-symbol-table (cc hyperspec-root "Data/Map_Sym.txt")))
            (defalias 'clhs 'hyperspec-lookup)))

;;; lisp
(defun my-lisp-mode-hook ()
  (setq lisp-indent-function 'common-lisp-indent-function)
  (setq common-lisp-style 'modern)
  (push '("\\.cl$" . lisp-mode) auto-mode-alist)
  (push '("\\.msl$" . lisp-mode) auto-mode-alist))
(add-hook 'lisp-mode-hook 'my-lisp-mode-hook)

;;; elisp
(defun my-emacs-lisp-mode-hook ()
  (setq lisp-indent-function 'lisp-indent-function))
(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)

;;; edit web forms
(use-package edit-server
  :if (and (fboundp 'daemonp)
           (daemonp)
           (locate-library "edit-server"))
  :config (progn
            (edit-server-start)))

;;; traditional server
(use-package server
  :config (progn
            (unless (server-running-p)
              (server-start))))

;;; zsh
(defun zsh-path (path)
  (let ((dir (ef "~/hejmo/ktp/zisxo/")))
    (concat dir path)))

;;; stumpwm
(defun stumpwm-path (path)
  (let ((dir (ef "~/hejmo/fkd/lispo/stumpo/")))
    (concat dir path)))

(defun stumpwm-connect ()
  (interactive)
  (slime-connect "localhost" "4004"))

;;; rectangles
(use-package rectangle-utils :ensure t)

;;; ido
(use-package ido
  :ensure t
  :config (progn (ido-mode t)))

;;; nix <3
(add-to-list 'load-path "/run/current-system/sw/share/emacs/site-lisp/")
(use-package nix-mode :ensure t)

;;; tramp
(use-package tramp
  :config (progn
            (add-to-list 'tramp-remote-path "/var/run/current-system/sw/bin")))

;;; ispell
(use-package ispell
  :config (progn
            (setq ispell-program-name "aspell"
                  ispell-extra-args '("--sug-mode=ultra"))))

;;; smartparens
(use-package smartparens-config
  :ensure smartparens
  :config (progn
            (show-smartparens-global-mode t)))

(defmacro def-pairs (pairs)
  "Define functions for pairing. PAIRS is an alist of (NAME . STRING) conses, where NAME is the function name that will be created and STRING is a single-character string that marks the opening character.

  (def-pairs ((paren . \"(\")
              (bracket . \"[\"))

defines the functions WRAP-WITH-PAREN and WRAP-WITH-BRACKET,respectively."
  `(progn
     ,@(loop for (key . val) in pairs
             collect
             `(defun ,(read (concat
                             "wrap-with-"
                             (prin1-to-string key)
                             "s"))
                  (&optional arg)
                (interactive "p")
                (sp-wrap-with-pair ,val)))))

(def-pairs ((paren . "(")
            (bracket . "[")
            (brace . "{")
            (single-quote . "'")
            (double-quote . "\"")))

;;; markdown
(use-package markdown-mode
  :ensure t
  :config (progn
            (add-hook 'markdown-mode-hook 'turn-on-smartparens-mode)
            (push '("\\.text$" . markdown-mode) auto-mode-alist)
            (push '("\\.markdown$" . markdown-mode) auto-mode-alist)
            (push '("\\.md$" . markdown-mode) auto-mode-alist)))

;;; scribble
(use-package scribble-mode
  :ensure t
  :config (progn
            (push '("\\.scrbl$" . scribble-mode) auto-mode-alist)))

;;; auto complete
(use-package auto-complete)

;;; geiser
(use-package geiser
  :ensure t
  :config (progn
            (setq geiser-active-implementations '(mit)
                  geiser-mode-smart-tab-p t)

            (add-hook 'geiser-mode-hook 'turn-on-smartparens-strict-mode)
            (add-hook 'geiser-repl-mode-hook 'turn-on-smartparens-strict-mode)))

(defun racket-save-history ()
  "Save the Racket input history."
  (interactive)
  (geiser-repl--write-input-ring)
  (message "Wrote %s" geiser-repl-history-filename))

(defun racket-load-history ()
  "Load the Racket input history."
  (interactive)
  (geiser-repl--history-setup)
  (message "Loaded %s" geiser-repl-history-filename))

(defun geiser! (&rest args)
  (interactive)
  (run-geiser 'racket)
  (delete-other-windows))

(defun my-geiser-mode-hook ()
  (put 'λ 'scheme-indent-function 1)
  (bind-keys
   :map geiser-mode-map
   ("C-x C-r" . geiser-eval-region)
   ("C-c t" . completion-at-point)))
(add-hook 'geiser-mode-hook 'my-geiser-mode-hook)

;;; scheme
(use-package r5rs)

;;; ocaml
(defun insert-auto-lambda (&optional arg)
  (interactive "p")
  (let ((sym (make-char 'greek-iso8859-7 107)))
    (case major-mode
      ((emacs-lisp-mode scheme-mode geiser-repl-mode)
       (progn
         (insert "(" sym " ())")
         (backward-char 2)))
      ((tuareg-mode tuareg-interactive-mode ocaml-mode)
       (progn
         (insert "(fun  -> )")
         (backward-char 5)))
      (t (insert sym)))))

(mapc #'(lambda (ext) (add-to-list 'completion-ignored-extensions ext))
      '(".cmo" ".cmx" ".cma" ".cmxa" ".cmi" ".cmxs" ".cmt" ".annot"))

(use-package merlin :ensure t)

(use-package tuareg
  :ensure t
  :config (progn
            (setq auto-mode-alist (append '(("\\.ml[ily]?$" . tuareg-mode)
                                            ("\\.topml$" . tuareg-mode))
                                          auto-mode-alist)
                  tuareg-interactive-program "utop")

            (add-hook 'tuareg-mode-hook 'merlin-mode t)
            (add-hook 'caml-mode-hook 'merlin-mode t)
            (define-key tuareg-mode-map "\C-x\C-r" 'tuareg-eval-region)))

(defconst tuareg-repl-history-filename
  (ef "~/.tuareg_history"))

(defconst tuareg-repl-history-size 1000000)

(defconst tuareg-repl-history-separator "\n}{\n")

(defsubst tuareg-repl-history-file ()
  (format "%s.%s" tuareg-repl-history-filename tuareg-interactive-program))

(defun tuareg-repl-read-input-ring ()
  (let ((comint-input-ring-file-name (tuareg-repl-history-file))
        (comint-input-ring-separator tuareg-repl-history-separator)
        (buffer-file-coding-system 'utf-8))
    (comint-read-input-ring t)))

(defun tuareg-repl-write-input-ring ()
  (let ((comint-input-ring-file-name (tuareg-repl-history-file))
        (comint-input-ring-separator tuareg-repl-history-separator)
        (buffer-file-coding-system 'utf-8))
    (comint-write-input-ring)))

(defun tuareg-repl-history-setup ()
  (set (make-local-variable 'comint-input-ring-size)
       tuareg-repl-history-size)
  (tuareg-repl-read-input-ring))

(defun ocaml-save-history ()
  "Save OCaml input history."
  (interactive)
  (let ((buffer-name "*ocaml-toplevel*"))
    (save-current-buffer
      (when (get-buffer buffer-name)
        (switch-to-buffer buffer-name)
        (tuareg-repl-write-input-ring)
        (message "Wrote %s" (tuareg-repl-history-file))))))

(defun ocaml-load-history ()
  "Load OCaml input history."
  (interactive)
  (let ((buffer-name "*ocaml-toplevel*"))
    (save-current-buffer
      (when (get-buffer buffer-name)
        (tuareg-repl-history-setup)
        (message "Loaded %s" (tuareg-repl-history-file))))))

;;; ocp-indent
(let ((path (concat
             (replace-regexp-in-string
              "\n$"
              ""
              (shell-command-to-string "opam config var share"))
             "/emacs/site-lisp")))
  (when (file-exists-p path)
    (add-to-list 'load-path path)
    (require 'ocp-indent)))

;;; merlin
(setq opam-share (substring
                  (shell-command-to-string
                   "opam config var share 2> /dev/null") 0))

(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))

(require 'merlin)

(add-hook 'tuareg-mode-hook 'merlin-mode t)
(add-hook 'caml-mode-hook 'merlin-mode t)

(setq merlin-use-auto-complete-mode 'easy
      merlin-command 'opam)

(define-key merlin-mode-map "\C-cu" 'merlin-use)

;;; clojure
(use-package cider
  :ensure t
  :config (progn
            (push '("\\.clj$" . clojure-mode) auto-mode-alist)

            (add-hook 'clojure-mode-hook 'turn-on-smartparens-strict-mode)
            (add-hook 'cider-repl-mode-hook 'turn-on-smartparens-strict-mode)
            (add-hook 'cider-repl-mode-hook 'subword-mode)

            (alias cr cider-restart)

            (setq nrepl-log-messages t
                  nrepl-hide-special-buffers t
                  cider-repl-result-prefix ";; => "
                  cider-interactive-eval-result-prefix ";; => "
                  cider-repl-use-clojure-font-lock t
                  cider-repl-wrap-history t
                  cider-repl-history-size 100000
                  cider-repl-history-file "~/.cider_history"
                  cider-repl-display-help-banner nil)

            (bind-keys
             :map cider-repl-mode-map
             ("C-j" . delete-indentation)
             ("C-<return>" . cider-repl-newline-and-indent))))

(use-package cider-scratch)

(defun clojure-save-history ()
  "Save CIDER input history."
  (interactive)
  (cider-repl-history-save cider-repl-history-file)
  (message "Wrote %s" cider-repl-history-file))

(defun clojure-load-history ()
  "Load CIDER input history."
  (interactive)
  (cider-repl-history-load cider-repl-history-file)
  (message "Loaded %s" cider-repl-history-file))

(defun switch-to-cider-scratch-buffer (&optional arg)
  (interactive)
  (switch-to-buffer
   (cider-find-or-create-scratch-buffer)))

(defun lisp-save-history ()
  "Save SLIME history"
  (slime-repl-save-merged-history slime-repl-history-file)
  (message "Wrote %s" slime-repl-history-file))

(defun lisp-load-history ()
  "Load SLIME history"
  (slime-repl-load-history slime-repl-history-file)
  (message "Loaded %s" slime-repl-history-file))

;;; common
(defun save-history ()
  "Save mode-specific input history."
  (interactive)
  (case major-mode
    (slime-repl-mode (lisp-save-history))
    (geiser-repl-mode (racket-save-history))
    (tuareg-interactive-mode (ocaml-save-history))
    (cider-repl-mode (clojure-save-history))
    (else nil)))
(defalias 'save! 'save-history)

(defun load-history ()
  "Load mode-specific input history."
  (interactive)
  (case major-mode
    (slime-repl-mode (lisp-load-history))
    (geiser-repl-mode (racket-load-history))
    (tuareg-interactive-mode (ocaml-load-history))
    (cider-repl-mode (clojure-load-history))
    (else nil)))
(defalias 'load! 'load-history)

(defun restart-repl ()
  "Restart the REPL."
  (interactive)
  (case major-mode
    (slime-repl-mode (slime-restart-inferior-lisp))
    (geiser-repl-mode (geiser-restart-repl))
    (else nil)))
(defalias 'restart! 'restart-repl)

;;; company
(use-package company
  :ensure t
  :config (progn (global-company-mode)
                 (setq company-ghc-show-info t)))

;;; emacs lisp
(add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)

;;; wdired
(use-package wdired
  :config (progn
            (alias wd wdired-change-to-wdired-mode)))

;;; backups
(use-package backup-dir
  :config (progn
            (setq backup-by-copying t
                  backup-directory-alist '(("." . "~/.saves"))
                  delete-old-versions t
                  kept-new-versions 4
                  kept-old-versions 4
                  version-control t
                  delete-old-versions t
                  backup-by-copying-when-linked t
                  bkup-backup-directory-info `((t ,(tmp-path ".backups.d")
                                                  ok-create
                                                  full-path
                                                  prepend-name))
                  tramp-bkup-backup-directory-info bkup-backup-directory-info)
            (make-variable-buffer-local 'backup-inhibited)

            (defun force-backup-of-buffer ()
              (let ((buffer-backed-up nil))
                (backup-buffer)))

            (add-hook 'before-save-hook 'force-backup-of-buffer)))

;;; undo tree
(use-package undo-tree
  :ensure t
  :bind (("C-x u" . undo-tree-visualize))
  :diminish undo-tree-mode)

;;; highlight thing
(use-package highlight-thing :ensure t)

;;; highlight chars
(use-package highlight-chars
  :config (progn
            (add-hook 'find-file-hook 'hc-highlight-tabs)
            (add-hook 'find-file-hook 'hc-highlight-hard-spaces)
            (add-hook 'find-file-hook 'hc-highlight-trailing-whitespace)))

;;; bamanzi windows
(use-package bamanzi-windows)

;;; xterm chars
(use-package xterm-chars)

;;; frame commands
(use-package frame-cmds)

;;; dired-k
(use-package dired-k
  :ensure t
  :config (progn
            (define-key dired-mode-map (kbd "K") 'dired-k)
            (define-key dired-mode-map (kbd "g") 'dired-k)
            (add-hook 'dired-initial-position-hook 'dired-k)))

;;; hooks
(add-hook 'prog-mode-hook 'turn-on-smartparens-mode)
(add-hook 'minibuffer-setup-hook 'turn-on-smartparens-strict-mode)

;;; magit
(use-package magit :ensure t)

;;; multiple-cursors
(use-package multiple-cursors :ensure t)

;;; notifications
(use-package notifications :ensure t)

;;; erc
(use-package erc
  :config (progn
            (setq erc-nick "ebzzry"
                  erc-user-full-name user-full-name
                  erc-session-user-full-name user-full-name
                  erc-log-insert-log-on-open nil
                  erc-log-channels t
                  erc-log-channels-directory "~/hejmo/dat/ŝtipoj/irc"
                  erc-save-buffer-on-part t
                  erc-hide-timestamps nil
                  erc-insert-timestamp-function 'erc-insert-timestamp-left
                  erc-timestamp-format "%H:%M "
                  erc-timestamp-only-if-changed-flag nil
                  erc-header-line-format nil)
            (add-hook 'erc-insert-post-hook 'erc-save-buffer-in-logs)
            (make-variable-buffer-local 'erc-fill-column)
            (add-hook 'window-configuration-change-hook
                      '(lambda ()
                         (save-excursion
                           (walk-windows
                            (lambda (w)
                              (let ((buffer (window-buffer w)))
                                (set-buffer buffer)
                                (when (eq major-mode 'erc-mode)
                                  (setq erc-fill-column (- (window-width w) 2)))))))))))

(use-package erc-nick-notify
  :config (eval-after-load 'erc '(erc-nick-notify-mode t)))

(use-package erc-desktop-notifications
  :config (progn
            (add-hook 'erc-server-PRIVMSG-functions 'erc-notifications-PRIVMSG)
            (add-hook 'erc-text-matched-hook 'erc-notifications-notify-on-match)))

(defun erc-freenode ()
  (interactive)
  (let* ((host "irc.freenode.net")
         (user erc-nick)
         (port 6667)
         (password (netrc-password host user port)))
    (erc :server host :nick erc-nick :port port :password password)))

(defun erc-bitlbee ()
  (interactive)
  (let* ((host "localhost")
         (user erc-nick)
         (port 6667))
    (erc :server host :port 6667 :nick erc-nick)))

(defun my-bitlbee-hook ()
  (when (string= (buffer-name) "&bitlbee")
    (let ((password (netrc-password "localhost" "ebzzry" "bitlbee")))
      (erc-message "PRIVMSG"
                   (concat (erc-default-target) " " "identify" " " password)
                   nil))))

(add-hook 'erc-join-hook 'my-bitlbee-hook)

;;; haskell
(use-package hindent :ensure t)
;; (use-package shm :ensure t)
;; (use-package company-ghc :ensure t)

(use-package intero
  :ensure t
  :config (progn
            (setq intero-blacklist (ef "~/hejmo/ktp/xmonad/xmonad.hs"))
            (intero-global-mode -1)))

(use-package haskell-mode
  :ensure t
  :config (progn
            (when (command-found "hindent")
              (require 'hindent)
              (add-hook 'haskell-mode-hook 'hindent-mode))

            (bind-keys
             :map haskell-mode-map
             ("M-q" . hindent-reformat-buffer)
             ("C-x C-x" . haskell-process-load-or-reload)
             ("C-c C-r" . haskell-process-restart)
             ("C-c ?" . ghc-display-errors))))

;; (add-hook 'haskell-mode-hook 'intero-mode)

;;; hindent
(defun hindent-reformat (&optional arg)
  "Reformat the declaration, fill, or region."
  (interactive "p")
  (if (region-active-p)
      (ci 'hindent-reformat-region)
    (ci 'hindent-reformat-decl-or-fill)))

(defun hindent-reformat-buffer (&optional arg)
  "Reformat the entire buffer."
  (interactive "p")
  (hindent-reformat-region (point-min) (point-max)))

;;; latex
(setq TeX-parse-self t
      TeX-auto-save t
      TeX-master nil
      TeX-PDF-mode t)
(add-hook 'latex-mode-hook 'turn-on-smartparens-strict-mode)

;;; lua
(use-package lua-mode
  :ensure t
  :config (progn
            (add-hook 'lua-mode-hook 'turn-on-smartparens-mode)))

;;; xboxdrv
(push '("\\.xboxdrv$" . conf-mode) auto-mode-alist)

;;; xmodmap-mode
(use-package xmodmap-mode
  :config (push '("\\.Xmodmap$" . xmodmap-mode) auto-mode-alist))

;;; hide-region
(use-package hide-region :ensure t)

;;; mac plists
(push '("\\.plist$" . xml-mode) auto-mode-alist)

;;; toml
(use-package toml-mode :ensure t)

;;; dockerfile mode
(use-package dockerfile-mode :ensure t)

;;; yaml mode
(use-package yaml-mode :ensure t)

;;; idris mode
(use-package idris-mode
  :ensure t
  :config (progn
            (push '("\\.idr$" . idris-mode) auto-mode-alist)
            (bind-keys
             :map idris-mode-map
             ("C-c t" . idris-type-at-point))))

;;; nasm
(use-package nasm-mode
  :ensure t
  :config (push '("\\.nasm$" . nasm-mode) auto-mode-alist))

;;; browse-url
(use-package browse-url-opera)

;;; visual-line-mode
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(add-hook 'markdown-mode-hook 'turn-on-visual-line-mode)

;;; csv-mode
(use-package csv-mode
  :ensure t
  :config (progn (setq csv-separators-char '(44 9 59)
                       csv-separators '("," "	" ";")
                       csv-separator-regexp "[,	;]")))

;;; ruby
(use-package inf-ruby
  :ensure t
  :config (progn
            (autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
            (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)))

(defun my-ruby-mode-hook ()
  (setq inf-ruby-buffer-command "nix shell --command irb"))
(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)

(use-package ruby-additional :ensure t)
(use-package scss-mode :ensure t)
(use-package sass-mode :ensure t)

;;; dedicated
(use-package dedicated
  :ensure t)

;;; ethan-wspace
(use-package ethan-wspace
  :ensure t
  :config (progn (global-ethan-wspace-mode 1)
                 (remove-hook 'before-save-hook 'ethan-wspace-clean-before-save-hook)))

;;; zoom-window
(use-package zoom-window
  :ensure t)

;;; buffer-move
(use-package buffer-move
  :ensure t)

;;; racket
(use-package racket-mode
  :ensure t
  :config (progn
            (push '("\\.rkt$" . racket-mode) auto-mode-alist)
            (add-hook 'racket-mode-hook 'turn-on-smartparens-strict-mode)
            (add-hook 'racket-repl-mode-hook 'turn-on-smartparens-strict-mode)))

;;; python
(add-hook 'python-mode-hook 'turn-on-smartparens-strict-mode)

;;; javascript
(use-package js2-mode
  :ensure t
  :config (progn
            (push '("\\.js$" . js2-mode) auto-mode-alist)
            (setq js2-basic-offset 2)
            (add-hook 'js2-mode-hook 'turn-on-smartparens-strict-mode)))

;;; json
(use-package json-mode
  :ensure t
  :config (progn
            (push '("\\.json$" . json-mode) auto-mode-alist)))

;;; systemd
(use-package systemd
  :ensure t)

;;; sly
(use-package sly-macrostep :ensure t)
(use-package sly-repl-ansi-color :ensure t)
(use-package sly-asdf :ensure t)

(defun my-sly-mode-hook ()
  (bind-keys
   :map sly-mode-map
   ("C-x M-e"     . sly-re-evaluate-defvar)
   ("C-c C-s M-r" . sly-stickers-clear-region-stickers)
   ("C-c p"   . sly-mrepl-set-package)
   ("C-c q"   . sly-quickload)
   ("C-c C-q" . sly-quickload)
   ("C-c r"   . sly-restart-inferior-lisp)
   ("C-c t"   . sly-asdf-test-system)
   ("C-c z"   . sly-mrepl)))

(defun my-sly-mrepl-mode-hook ()
  (bind-keys
   :map sly-mrepl-mode-map
   ("C-c p"   . sly-mrepl-set-package)
   ("C-c q"   . sly-quickload)
   ("C-c C-q" . sly-quickload)
   ("C-c r"   . sly-restart-inferior-lisp)
   ("C-c t"   . sly-asdf-test-system)))

(use-package sly
  :ensure t
  :config
  (progn
    (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
    (add-hook 'sly-mode-hook 'my-sly-mode-hook)
    (add-hook 'sly-mrepl-mode-hook 'turn-on-smartparens-strict-mode)
    (add-hook 'sly-mrepl-mode-hook 'my-sly-mrepl-mode-hook)

    (setq sly-lisp-implementations '((sbcl ("shell" "lisp" "sbcl"))
                                     (ccl ("shell" "lisp" "ccl"))))))


;;; ebnf
(use-package ebnf-mode
  :config (progn
            (push '("\\.ebnf$" . ebnf-mode) auto-mode-alist)))

;; markdown-toc
(use-package markdown-toc
  :ensure t)
