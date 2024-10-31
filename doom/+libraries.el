;;;; $DOOMDIR/libraries.el -*- lexical-binding: t; -*-


;;; ĉefaferoj

(after! org
  (setq org-directory "~/org/"
        org-agenda-files '("~/org")
        org-archive-location "%s-arhxivo::"
        org-todo-keywords '((sequence "TODO" "DONE"))
        org-html-head (concat "<style>" (file-string (my-doom-path "org.css")) "</style>")
        org-babel-load-languages '((lisp . t)
                                   (emacs-lisp . t)
                                   (shell . t)
                                   (dot . t)
                                   (python . t)
                                   (ditaa . t)
                                   (plantuml . t))
        org-confirm-babel-evaluate nil
        org-ditaa-jar-path "~/Documents/Private/ditaa/ditaa.jar"
        org-plantuml-jar-path plantuml-jar-path
        org-latex-src-block-backend 'minted
        org-latex-pdf-process
        '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq org-startup-indented t
        org-image-actual-width nil
        org-image-actual-width (truncate (* (display-pixel-width) 0.8))
        org-startup-with-inline-images t
        org-fontify-quote-and-verse-blocks nil
        org-fontify-whole-heading-line nil
        org-hide-leading-stars nil
        org-export-with-toc nil
        org-export-with-author nil
        org-export-with-creator nil
        org-export-with-email nil
        org-export-default-language "eo"
        org-html-postamble nil
        org-startup-folded 'overview)
  (setq +org-capture-notes-file "n.org"
        +org-capture-todo-file "f.org")
  (setq org-capture-templates
        '(("n" "notoj" entry (file+headline "n.org" "📥")
           "* %T %?" :prepend t)
          ("a" "agendo" entry (file+headline "a.org" "📥")
           "* TODO %?" :prepend t)
          ("k" "kalendaro" entry (file+headline "k.org" "📥")
           "* %?" :prepend t)))
  (setq deft-directory "~/org"
        deft-extensions '("org" "txt" "md")
        deft-recursive nil)
  (add-hook 'org-mode-hook 'org-modern-mode)
  (setq org-modern-fold-stars
        '(("▶" . "▼") ("▷" . "▽") ("▸" . "▾") ("▹" . "▿")))
  (map! :localleader
        :map org-mode-map
        :n "b K" 'org-table-move-row-up
        :n "b J" 'org-table-move-row
        :n "b H" 'org-table-move-column-left
        :n "b L" 'org-table-move-column-right)
  (setq shr-max-image-proportion 0.8))

(after! sly
  (setq sly-lisp-implementations '((lispworks ("lw") :coding-system utf-8-unix)
                                   (sbcl ("sbcl") :coding-system utf-8-unix))
        sly-complete-symbol-function 'sly-flex-completions)
  (add-hook 'sly-mrepl-mode-hook 'my-sly-mrepl-mode-hook)
  (map! :map sly-mrepl-mode-map
        :n "<up>" 'sly-mrepl-previous-input-or-button
        :n "<down>" 'sly-mrepl-next-input-or-button
        :i "<up>" 'sly-mrepl-previous-input-or-button
        :i "<down>" 'sly-mrepl-next-input-or-button
        :i "<tab>" 'sly-mrepl-indent-and-complete-symbol
        :i "TAB" 'sly-mrepl-indent-and-complete-symbol)
  (map! :localleader
        :map sly-mode-map
        :desc "Switch to REPL" :nv "o" 'my-switch-to-sly-mrepl-window)
  (map! :map sly-mrepl-mode-map
        :i "<tab>" 'company-complete
        :i "TAB" 'company-complete))

(after! persp-mode
  (setq persp-save-dir "~/Developer/etc/workspaces/"))

(after! magit
  (defun magit-fullscreen (orig-fun &rest args)
    (window-configuration-to-register :magit-fullscreen)
    (apply orig-fun args)
    (delete-other-windows))

  (advice-add 'magit-status :around #'magit-fullscreen)

  (defun magit-quit-session ()
    "Restore previous window configuration and cleanup buffers."
    (interactive)
    (mu-kill-buffers "^\\*magit")
    (jump-to-register :magit-fullscreen))

  (defun mu-kill-buffers (regexp)
    "Kill buffers matching REGEXP without asking for confirmation."
    (interactive "sKill buffers matching this regular expression: ")
    (cl-letf (((symbol-function 'kill-buffer-ask)
               (lambda (buffer) (kill-buffer buffer))))
      (kill-matching-buffers regexp)))
  (map! :map magit-status-mode-map
        :n "q" 'magit-quit-session))

(defun my-sly-mrepl-mode-hook ()
  (smartparens-mode -1)
  (define-key sly-mrepl-mode-map (kbd "<tab>") 'company-complete)
  (define-key sly-mrepl-mode-map (kbd "TAB") 'company-complete))

(after! smartparens
  (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'sly-mrepl-mode-hook 'my-sly-mrepl-mode-hook))

(after! plantuml-mode
  (setq plantuml-jar-path "~/Documents/Private/plantuml/plantuml.jar"
        plantuml-indent-level 2))

(use-package! page-break-lines
  :config
  (global-page-break-lines-mode 1))

(after! avy
  (setq avy-all-windows t
        avy-keys '(97 111 101 117  105 100  104 116 110 115)))

(after! vimish-fold
  (vimish-fold-global-mode 1))

(after! company
  (setq company-idle-delay nil))

(after! vterm
  (add-to-list 'vterm-eval-cmds '("dired" dired))
  (setq vterm-max-scrollback 1000000)
  (map! :map vterm-mode-map
        :i "<tab>" 'vterm-send-tab
        :i "TAB"   'vterm-send-tab))

(after! vterm-toggle
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3))))
(after! asm
  (setq comment-start "/"))

(after! popup
  (set-popup-rules!
    '(("^ \\*" :slot -1)
      ("^\\*" :select t)
      ("^\\*Completions" :slot -1 :ttl 0)
      ("^\\*\\(?:scratch\\|Messages\\)" :ttl t)
      ("^\\*Help" :slot -1 :size 0.25 :select t)
      ("^\\*sly" :slot -1 :select t :size 0.33 :side right)
      ("^\\*sly-db" :slot -1 :select t :size 0.33 :side bottom)
      ("^\\*vterm" :slot -1 :select t :size 0.5 :side bottom)
      ("^\\*doom:" :size 0.35 :select t :modeline t :quit t :ttl t))))

(after! ox-pandoc
  (setq org-pandoc-options '((standalone . t) (self-contained . t))))

(after! treemacs
  (map! :map treemacs-mode-map
        :g "S-<left>" 'other-window-1
        :g "S-<right>" 'other-window
        :g "S-<up>" 'swap-up
        :g "S-<down>" 'swap-down))

(after! dired
  (map! :map dired-mode-map
        :n "=" 'indent-marked-files))

(after! backup-each-save
  (add-hook 'after-save-hook 'backup-each-save))

(after! ox-spectacle
  (setq ox-spectacle-scripts
        (list (ef "~/Developer/src-ext/spectacle/react.production.min.js")
              (ef "~/Developer/src-ext/spectacle/react-dom.production.min.js")
              (ef "~/Developer/src-ext/spectacle/react-is.production.min.js")
              (ef "~/Developer/src-ext/spectacle/prop-types.min.js")
              (ef "~/Developer/src-ext/spectacle/spectacle.min.js")
              (ef "~/Developer/src-ext/spectacle/htm"))))
