;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(common-lisp
     emacs-lisp
     racket
     (org :variables
          org-agenda-files '("~/org")
          org-default-notes-file "~/org/gxeneralaj-notoj.org"
          org-archive-location "%s-arhxivo::"
          org-todo-keywords '((sequence "TODO" "INPROGRESS""DONE" "CANCELLED"))
          org-options-keywords '("author: ASTN Group, Inc."
                                 "creator: t"
                                 "timestamp: t"
                                 "email: rommel.martinez@astn-group.com")
          org-html-head (concat "<style>" (file-string (spacemacs-path "fkd/org.css")) "</style>")
          org-tag-alist '(("hejmo" . "h")
                          ("financoj" . "f")
                          ("laboro" . "l")
                          ("sportoj" . "s")
                          ("videoludado" . "v"))
          org-babel-load-languages '((lisp . t)
                                     (emacs-lisp . t)
                                     (shell . t)
                                     (dot . t)
                                     (python . t)
                                     (ditaa . t)
                                     (plantuml . t))
          org-confirm-babel-evaluate nil
          org-ditaa-jar-path "~/hejmo/dat/ditaa/ditaa.jar"
          org-plantuml-jar-path "~/hejmo/dat/plantuml/plantuml.jar"
          org-latex-listings 'minted
          org-latex-pdf-process
          '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "bibtex %b"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")
          org-image-actual-width nil
          org-startup-indented t)
     ;; (auto-completion :variables auto-completion-enable-snippets-in-popup t)
     (scheme :variables scheme-implementations '(guile))
     (latex :variables latex-enable-auto-fill t latex-build-command "LaTeX")
     (spell-checking :variables spell-checking-enable-by-default nil ispell-program-name "aspell")
     (git :variables git-magit-status-fullscreen t)
     (plantuml :variables plantuml-jar-path "~/hejmo/dat/plantuml/plantuml.jar" plantuml-indent-level 2)
     (python :variables python-shell-interpreter "/usr/bin/python3")
     (version-control :variables git-gutter:hide-gutter nil)
     (ranger :variables
             ranger-override-dired 'ranger
             ranger-enter-with-minus 'ranger
             ranger-preview-file nil
             ranger-show-literal nil
             ranger-parent-depth 2
             ranger-show-hidden t
             ranger-cleanup-on-disable t)
     (templates :variables templates-private-directory "~/.emacs.d/private/templates")
     ivy
     html
     bibtex
     markdown
     shell
     tmux
     systemd
     docker
     yaml
     graphviz
     csv
     multiple-cursors
     syntax-checking
     treemacs
     ;; neotree
     ;; spacemacs-purpose
     spacemacs-visual
     nixos
     nginx
     themes-megapack
     vimscript
     sql)
   dotspacemacs-additional-packages '()
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  (setq-default
   dotspacemacs-enable-emacs-pdumper nil
   dotspacemacs-emacs-pdumper-executable-file "emacs"
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-gc-cons '(100000000 0.1)
   dotspacemacs-read-process-output-max (* 1024 1024)
   dotspacemacs-use-spacelpa nil
   dotspacemacs-verify-spacelpa-archives t
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory 'emacs-version
   dotspacemacs-editing-style 'vim
   dotspacemacs-startup-buffer-show-version t
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 5))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-show-startup-list-numbers t
   dotspacemacs-startup-buffer-multi-digit-delay 0.4
   dotspacemacs-new-empty-buffer-major-mode 'text-mode
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-scratch-buffer-persistent t
   dotspacemacs-scratch-buffer-unkillable t
   dotspacemacs-initial-scratch-message nil
   dotspacemacs-themes '(gruvbox-dark-hard default)
   dotspacemacs-mode-line-theme '(spacemacs :separator-scale 1.5)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("CommitMono" :size 12.0 :weight normal :width normal)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")
   dotspacemacs-distinguish-gui-tab t
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil ;persp
   dotspacemacs-auto-generate-layout-names nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 10
   dotspacemacs-enable-paste-transient-state nil ; cu?
   dotspacemacs-which-key-delay 0.5
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup t
   dotspacemacs-undecorated-at-startup nil
   dotspacemacs-active-transparency 100
   dotspacemacs-inactive-transparency 100
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-scroll-bar-while-scrolling nil
   dotspacemacs-line-numbers t
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-activate-smartparens-mode t
   dotspacemacs-smart-closing-parenthesis t
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-enable-server t
   dotspacemacs-server-socket-dir nil
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")
   dotspacemacs-frame-title-format "%a"
   dotspacemacs-icon-title-format nil
   dotspacemacs-show-trailing-whitespace t
   dotspacemacs-whitespace-cleanup nil
   dotspacemacs-use-clean-aindent-mode t
   dotspacemacs-use-SPC-as-y nil
   dotspacemacs-swap-number-row nil
   dotspacemacs-zone-out-when-idle nil
   dotspacemacs-pretty-docs nil
   dotspacemacs-home-shorten-agenda-source nil
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first.")

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump.")

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (setup-frames)
  (setup-ui)
  (setup-variables)
  (setup-evil-variables)
  (setup-libraries)
  (setup-hooks)
  (setup-keys)
  (setup-purpose))
