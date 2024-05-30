;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-


;;; package

(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))


;;; pairs

(defmacro def-pairs (pairs)
  "Define functions for pairing. PAIRS is an alist of (NAME . STRING) conses,
where NAME is the function name that will be created and STRING is a
single-character string that marks the opening character.

  (def-pairs ((paren . \"(\")
              (bracket . \"[\"))

defines the functions WRAP-WITH-PAREN and WRAP-WITH-BRACKET,respectively."
  `(progn
     ,@(cl-loop for (key . val) in pairs
                collect
                `(defun ,(read (concat "wrap-with-" (prin1-to-string key) "s"))
                     (&optional arg)
                   (interactive "p")
                   (sp-wrap-with-pair ,val)))))

(def-pairs ((paren        . "(")
            (bracket      . "[")
            (brace        . "{")
            (single-quote . "'")
            (double-quote . "\"")))


(defun install-libraries ()
  "Setup additional libraries."
  (use-package ox-latex)
  (use-package ox-beamer)
  (use-package oc-biblatex)
  (use-package oc-csl)

  ;; (use-package emacs-reveal)
  ;; (use-package oer-reveal)
  (use-package org-re-reveal)

  (use-package page-break-lines)
  (use-package burly)
  (use-package multi-vterm
    :config
    (setq shell-default-shell 'multi-vterm))

  (use-package org-bullets
    :config (setq org-bullets-bullet-list '("■" "◆" "▲" "▶")))

  (use-package popwin
    :config
    (setq popwin:special-display-config
          '(("^\\*Flycheck.+\\*$" :regexp t :dedicated t :position bottom :width 0.3 :height 0.3 :stick t :noselect t)
            ("*Google Translate*" :dedicated t :position bottom :stick t :noselect t :height 0.4)
            ("^*WoMan.+*$" :regexp t :position bottom)
            ("*nosetests*" :dedicated t :position bottom :stick t :noselect nil)
            ("*grep*" :dedicated t :position bottom :stick t :noselect nil)
            ("*Fuzzy Completions*" :dedicated t :position bottom :stick t :noselect nil)
            ("*ert*" :dedicated t :position bottom :stick t :noselect nil)
            ("*undo-tree Diff*" :dedicated t :position bottom :stick t :noselect nil :height 0.3)
            ("*undo-tree*" :dedicated t :position right :stick t :noselect nil :width 60)
            ("*Async Shell Command*" :dedicated t :position bottom :stick t :noselect nil)
            ("*Shell Command Output*" :dedicated t :position bottom :stick t :noselect nil)
            (dap-server-log-mode :dedicated nil :position bottom :stick t :noselect t :height 0.4)
            (compilation-mode :dedicated nil :position bottom :stick t :noselect t :height 0.4)
            ("*Process List*" :dedicated t :position bottom :stick t :noselect nil :height 0.4)
            ("*Help*" :dedicated t :position bottom :stick t :noselect t :height 0.4)
            ("*quickrun*" :dedicated t :position bottom :stick t :noselect t :height 0.3))))

  (use-package yasnippet
    :config
    (yas-global-mode 1))

  (use-package backup-each-save))

(defun configure-libraries ()
  "Configure third party libraries."
  (add-to-list 'org-latex-packages-alist
               '("newfloat" "minted"))
  (add-to-list 'org-re-reveal-plugins 'audio-slideshow)
  (add-to-list 'org-re-reveal-plugin-config
               '(audio-slideshow "RevealAudioSlideshow" "plugin/audio-slideshow/plugin.js"))
  (global-page-break-lines-mode 1))

(defun setup-libraries ()
  "Install and configure internal and 3rd-party libraries."
  (install-libraries)
  (configure-libraries))


;;; reĝimoj

;;; sh
(defun my-sh-mode-hook ()
  (make-local-variable 'sh-basic-offset)
  (setq sh-basic-offset 2
        indent-tabs-mode nil))

;;; lisp
(defun slime-compile-dwim (&optional args)
  "Compile the current or region."
  (interactive "p")
  (if (region-active-p)
      (ci 'slime-compile-region)
    (ci 'slime-compile-defun)))

(defun slime-eval-dwim (&optional args)
  "Eval the current or region."
  (interactive "p")
  (if (region-active-p)
      (ci 'slime-eval-region)
    (ci 'slime-eval-defun)))

(defun my-lisp-mode-hook ()
  (setq lisp-indent-function 'common-lisp-indent-function)
  (setq common-lisp-style 'modern)
  (push '("\\.[cC][lL]$" . lisp-mode) auto-mode-alist)

  (spacemacs/set-leader-keys-for-major-mode 'lisp-mode
                                            "cd" 'slime-compile-dwim
                                            "ed" 'slime-eval-dwim
                                            "o" 'slime-switch-to-output-buffer
                                            "H" 'hyperspec-lookup))

;;; slime
(defun define-slime-repl-shortcuts ()
  (defslime-repl-shortcut nil ("restart" "R")
                          (:handler 'slime-restart-inferior-lisp)
                          (:one-liner "Restart *inferior-lisp* and reconnect SLIME."))

  (defslime-repl-shortcut nil ("reset" "RR")
                          (:handler '(lambda ()
                                       (interactive)
                                       (slime-repl-clear-buffer)
                                       (slime-restart-inferior-lisp)))
                          (:one-liner "Delete the output generated by the Lisp process."))

  (defslime-repl-shortcut slime-repl-load-system ("load" "L")
                          (:handler (lambda ()
                                      (interactive)
                                      (slime-oos (slime-read-system-name) 'load-op)))
                          (:one-liner "Compile (as needed) and load an ASDF system."))

  (defslime-repl-shortcut nil ("change-package" "!p" "in-package" "in" "I")
                          (:handler 'slime-repl-set-package)
                          (:one-liner "Change the current package."))

  (defslime-repl-shortcut slime-repl-reload-system ("reload" "RL")
                          (:handler 'slime-reload-system)
                          (:one-liner "Recompile and load an ASDF system."))


  (defslime-repl-shortcut slime-repl-test-system ("test" "T")
                          (:handler (lambda ()
                                      (interactive)
                                      (slime-oos (slime-read-system-name) 'test-op)))
                          (:one-liner "Compile (as needed) and test an ASDF system."))

  (defslime-repl-shortcut slime-repl-load/force-system ("force-load" "FL")
                          (:handler (lambda ()
                                      (interactive)
                                      (slime-oos (slime-read-system-name) 'load-op :force t)))
                          (:one-liner "Recompile and load an ASDF system."))

  (defslime-repl-shortcut slime-repl-test/force-system ("force-test" "FT")
                          (:handler (lambda ()
                                      (interactive)
                                      (slime-oos (slime-read-system-name) 'test-op :force t)))
                          (:one-liner "Recompile and test an ASDF system."))

  (defslime-repl-shortcut slime-repl-delete-system-fasls ("delete" "D")
                          (:handler 'slime-delete-system-fasls)
                          (:one-liner "Delete FASLs of an ASDF system."))

  (defslime-repl-shortcut nil ("clear" "C")
                          (:handler 'slime-repl-clear-buffer)
                          (:one-liner "Delete the output generated by the Lisp process."))

  (defslime-repl-shortcut slime-repl-quit ("quit" "Q")
                          (:handler (lambda ()
                                      (interactive)
                                      ;; `slime-quit-lisp' determines the connection to quit
                                      ;; on behalf of the REPL's `slime-buffer-connection'.
                                      (let ((repl-buffer (slime-output-buffer)))
                                        (slime-quit-lisp)
                                        (kill-buffer repl-buffer))))
                          (:one-liner "Quit the current Lisp.")))
(defun my-slime-repl-mode-hook ()
  (remove-hook 'slime-compilation-finished-hook 'slime-maybe-show-compilation-log)
  (define-slime-repl-shortcuts)

  (define-key slime-repl-mode-map (kbd "<up>") 'slime-repl-previous-input)
  (define-key slime-repl-mode-map (kbd "<down>") 'slime-repl-next-input))

(defun my-slime-mode-hook ()
  (define-key slime-xref-mode-map (kbd "n") nil)
  (define-key slime-xref-mode-map [remap next-line] nil)
  (define-key slime-xref-mode-map (kbd "p") nil)
  (define-key slime-xref-mode-map [remap previous-line] nil)
  
  (defun my-slime-show-xref ()
    "Display the source file of the cross-reference under the point in the same
window."
    (interactive)
    (let ((location (slime-xref-location-at-point)))
      (slime-goto-source-location location)
      (with-selected-window (display-buffer-same-window (current-buffer) nil)
        (goto-char (point))
        (recenter))))

  (define-key slime-xref-mode-map (kbd "RET") 'my-slime-show-xref)
  (define-key slime-xref-mode-map (kbd "SPC") nil)
  (define-key slime-xref-mode-map (kbd "v") nil))


;;; emacs lisp
(defun my-emacs-lisp-mode-hook ()
  (dolist (mode '(emacs-lisp-mode lisp-interaction-mode))
    (spacemacs/set-leader-keys-for-major-mode mode
                                              "ed" 'elisp-eval-dwim)))

;;; org
(defun my-org-mode-hook ()
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
                                            "hj" 'org-next-visible-heading)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode
                                            "hk" 'org-previous-visible-heading))

;;; calendar
(defun my-calendar-mode-hook ()
  (define-key calendar-mode-map "h" 'calendar-backward-day)
  (define-key calendar-mode-map "l" 'calendar-forward-day)
  (define-key calendar-mode-map "H" 'calendar-backward-week)
  (define-key calendar-mode-map "L" 'calendar-forward-week))

(defun setup-hooks ()
  "Setup the hooks for various modes."
  (add-hook 'shell-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'org-mode-hook 'turn-on-smartparens-strict-mode)
  (add-hook 'sh-mode-hook 'my-sh-mode-hook)
  (add-hook 'lisp-mode-hook 'my-lisp-mode-hook)

  (add-hook 'slime-repl-mode-hook 'my-slime-repl-mode-hook)
  (add-hook 'slime-mode-hook 'my-slime-mode-hook)

  (add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)
  (add-hook 'org-mode-hook 'my-org-mode-hook)
  (add-hook 'calendar-mode-hook 'my-calendar-mode-hook)

  (add-hook 'minibuffer-mode-hook 'turn-off-smartparens-mode))

(defun setup-purpose ()
  "Setup purpose mode."
  (setq purpose-user-mode-purposes
        '((term-mode . terminal)
          (shell-mode . terminal)
          (ansi-term-mode . terminal)
          (tuareg-mode . coding)
          (compilation-mode . messages)
          (slime-mode . coding)
          (slime-repl-mode . coding)))
  (purpose-compile-user-configuration))
