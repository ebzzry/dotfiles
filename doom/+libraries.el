;;;; $DOOMDIR/libraries.el -*- lexical-binding: t; -*-


;;; ĉefaferoj

(after! org
  (map! :map org-mode-map
        :i "<tab>" 'org-cycle
        :i "TAB"   'org-cycle)
  (setq org-directory "~/org/"
        org-attach-id-dir "data/"
        org-default-notes-file "~/org/a.org"
        org-agenda-files '("~/org/")
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
  (setq shr-max-image-proportion 0.8)

  (load-library "ox-reveal"))

(after! sly
  (setq sly-lisp-implementations '((lispworks ("lispworks") :coding-system utf-8-unix)
                                   (sbcl ("sbcl") :coding-system utf-8-unix)
                                   (sbcl-shell ("sbsh") :coding-system utf-8-unix))
        sly-complete-symbol-function 'sly-flex-completions
        sly-command-switch-to-existing-lisp 'ask)

  (def my-sly-mrepl-mode-hook ()
    (smartparens-mode -1))
  (add-hook 'sly-mrepl-mode-hook 'my-sly-mrepl-mode-hook)

  (push 'sly-repl-ansi-color sly-contribs)

  (def my-sly-db-hook ()
    (window-configuration-to-register :my-sly-db-register))
  (add-hook 'sly-db-hook 'my-sly-db-hook)

  (def my-sly-db-quit ()
    (interactive)
    (ci 'sly-db-quit)
    (jump-to-register :my-sly-db-register))

  (map! :map sly-db-mode-map
        :n "Q" 'my-sly-db-quit))

(after! persp-mode
  (setq persp-save-dir "~/etc/workspaces/"))

(after! magit
  (def magit-fullscreen (orig-fun &rest args)
    (window-configuration-to-register :magit-fullscreen)
    (apply orig-fun args)
    (delete-other-windows))

  (advice-add 'magit-status :around #'magit-fullscreen)

  (def magit-quit-session ()
    "Restore previous window configuration and cleanup buffers."
    (interactive)
    (mu-kill-buffers "^\\*magit")
    (jump-to-register :magit-fullscreen))

  (def mu-kill-buffers (regexp)
    "Kill buffers matching REGEXP without asking for confirmation."
    (interactive "sKill buffers matching this regular expression: ")
    (cl-letf (((symbol-function 'kill-buffer-ask)
               (lambda (buffer) (kill-buffer buffer))))
      (kill-matching-buffers regexp)))

  (map! :map magit-status-mode-map
        :n "q" 'magit-quit-session))

(after! smartparens
  (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode))

(after! plantuml-mode
  (setq plantuml-jar-path "~/dat/plantuml/plantuml.jar"
        plantuml-indent-level 2))

(use-package! page-break-lines
  :config (global-page-break-lines-mode 1))

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
      ("^\\*doom:" :size 0.35 :select t :modeline t :quit t :ttl t)
      ("^\\*sly-mrepl\*" :slot -1 :select t :quit nil :size 0.33 :side right)
      ("^\\*sly-db\*" :slot -1 :select t :quit nil :size 0.33 :side bottom))))

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

(after! haskell
  (setq haskell-stylish-on-save t))

(after! org-roam
  (require 'org-roam-dailies)
  (setq org-roam-directory "~/roam/"
        org-roam-db-location "~/roam/roam.db"
        org-roam-dailies-directory "journals/"
        org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "${slug}.org" "#+title: ${title}")
           :unnarrowed t)))

  (defvar org-roam-slug-trim-chars
    '(;; Combining Diacritical Marks https://www.unicode.org/charts/PDF/U0300.pdf
      768 ; U+0300 COMBINING GRAVE ACCENT
      769 ; U+0301 COMBINING ACUTE ACCENT
      770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
      771 ; U+0303 COMBINING TILDE
      772 ; U+0304 COMBINING MACRON
      774 ; U+0306 COMBINING BREVE
      775 ; U+0307 COMBINING DOT ABOVE
      776 ; U+0308 COMBINING DIAERESIS
      777 ; U+0309 COMBINING HOOK ABOVE
      778 ; U+030A COMBINING RING ABOVE
      780 ; U+030C COMBINING CARON
      795 ; U+031B COMBINING HORN
      803 ; U+0323 COMBINING DOT BELOW
      804 ; U+0324 COMBINING DIAERESIS BELOW
      805 ; U+0325 COMBINING RING BELOW
      807 ; U+0327 COMBINING CEDILLA
      813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
      814 ; U+032E COMBINING BREVE BELOW
      816 ; U+0330 COMBINING TILDE BELOW
      817 ; U+0331 COMBINING MACRON BELOW
      )
    "Characters to trim from Unicode normalization for slug.

By default, the characters are specified to remove Diacritical
Marks from the Latin alphabet.")

  (cl-defmethod org-roam-node-slug ((node org-roam-node))
    (let ((title (org-roam-node-title node)))
      (cl-flet* ((nonspacing-mark-p (char)
                   (memq char org-roam-slug-trim-chars))
                 (strip-nonspacing-marks (s)
                   (ucs-normalize-NFC-string
                    (apply #'string (seq-remove #'nonspacing-mark-p
                                                (ucs-normalize-NFD-string s)))))
                 (cl-replace (title pair)
                   (replace-regexp-in-string (car pair) (cdr pair) title)))
        (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-")
                        ("--*" . "-")
                        ("^-" . "")
                        ("-$" . "")))
               (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
          (downcase slug))))))

(after! python
  (setq python-indent-guess-indent-offset t
        python-indent-guess-indent-offset-verbose nil))

(after! tex
  (setq TeX-view-program-selection
        '((output-pdf "open")
          (output-dvi "open")
          (output-pdf "open")
          (output-html "open"))))
