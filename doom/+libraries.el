;;;; $DOOMDIR/libraries.el -*- lexical-binding: t; -*-

;;; ĉefaferoj

(after! org
  (setq org-directory "~/org/"
        org-agenda-files '("~/org")
        org-default-notes-file "~/org/a.org"
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
        org-ditaa-jar-path "~/Developer/dat/ditaa/ditaa.jar"
        org-plantuml-jar-path plantuml-jar-path
        org-latex-src-block-backend 'minted
        org-latex-pdf-process
        '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq org-startup-indented t
        org-image-actual-width nil
        org-startup-with-inline-images t
        org-fontify-quote-and-verse-blocks nil
        org-fontify-whole-heading-line nil
        org-hide-leading-stars nil
        org-export-with-toc t
        org-export-with-author t
        org-export-with-email t
        org-export-with-creator nil
        org-export-default-language "en"
        org-html-postamble nil
        org-startup-folded 'overview)
  (setq +org-capture-notes-file "n.org"
        +org-capture-todo-file "f.org")
  (setq org-capture-templates
        '(("n" "notoj" entry (file+headline "n.org" "T")
           "* %T %?" :prepend t)
          ("a" "agendo" entry (file+headline "a.org" "T")
           "* TODO %?" :prepend t)
          ("k" "kalendaro" entry (file+headline "k.org" "T")
           "* %?" :prepend t)))
  (setq deft-directory "~/org"
        deft-extensions '("org" "txt" "md")
        deft-recursive nil)
  (add-hook 'org-mode-hook 'org-modern-mode)
  (add-hook 'org-mode-hook 'toc-org-mode)
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
  (setq sly-lisp-implementations '((lispworks ("lispworks") :coding-system utf-8-unix)
                                   (sbcl ("sbcl") :coding-system utf-8-unix)
                                   (sbcl-shell ("sbsh") :coding-system utf-8-unix))
        sly-complete-symbol-function 'sly-flex-completions
        sly-command-switch-to-existing-lisp 'ask)
  (add-hook 'sly-mrepl-mode-hook 'my-sly-mrepl-mode-hook))

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
  (smartparens-mode -1))

(after! smartparens
  (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'sly-mrepl-mode-hook 'my-sly-mrepl-mode-hook))

(after! plantuml-mode
  (setq plantuml-jar-path "~/Developer/dat/plantuml/plantuml.jar"
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
      ("^\\*vterm\*" :slot -1 :select t :size 0.5 :side bottom)
      ("^\\*sly-mrepl\*" :slot -1 :select t :size 0.5 :side bottom)
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
  (push 'backup-each-save after-save-hook))

(defun my-org-capture-hook ()
  (let ((frame (select-frame-by-name "org-capture")))
    (delete-frame frame t)))

(add-hook 'org-capture-after-finalize-hook 'my-org-capture-hook)

(defcmd make-org-capture-frame ()
  "Create a new frame and run org-capture."
  (make-frame '((name . "org-capture")
                (width . 80)
                (height . 16)
                (top . 400)
                (left . 300)))
  (select-frame-by-name "org-capture")
  (my-org-capture))

(after! apheleia
  (setq apheleia-formatters (unassoc 'shfmt apheleia-formatters))
  (push '(shfmt "shfmt" "-filename" filepath "-ln" "bash" "-i" "2" "-")
        apheleia-formatters))

(setq haskell-stylish-on-save t)
