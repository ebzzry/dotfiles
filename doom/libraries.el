;;; ../hejmo/ktp/doom/libraries.el -*- lexical-binding: t; -*-


;;; main

(defun setup-libraries ()
  "Install third party libraries."
  (use-package! sly
    :config
    (setq sly-lisp-implementations
          '((lispworks ("lw") :coding-system utf-8-unix))))

  (use-package! plantuml-mode
    :config
    (setq plantuml-jar-path "~/hejmo/dat/plantuml/plantuml.jar"
          plantuml-indent-level 2))

  (use-package! page-break-lines
    :config
    (global-page-break-lines-mode 1))

  (use-package! org
    :config
    (setq org-agenda-files '("~/org")
          org-archive-location "%s-arhxivo::"
          org-todo-keywords '((sequence "TODO" "INPROGRESS""DONE" "CANCELLED"))
                                        ;org-html-head (concat "<style>" (file-string (doom-path "org.css")) "</style>")
          org-babel-load-languages '((lisp . t)
                                     (emacs-lisp . t)
                                     (shell . t)
                                     (dot . t)
                                     (python . t)
                                     (ditaa . t)
                                     (plantuml . t))
          org-confirm-babel-evaluate nil
          org-ditaa-jar-path "~/hejmo/dat/ditaa/ditaa.jar"
          org-plantuml-jar-path plantuml-jar-path
          org-latex-src-block-backend 'minted
          org-latex-pdf-process
          '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "bibtex %b"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")
          org-image-actual-width nil
          org-startup-indented t))

  (after! org
    (require 'ox-reveal)
    (setq org-reveal-root (concat "file://" (ef "~/hejmo/dat/reveal.js")))
    (add-to-list 'org-latex-packages-alist
                 '("newfloat" "minted")))

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
        (kill-matching-buffers regexp))))

  (after! smartparens
    (add-hook 'lisp-mode-hook 'turn-on-smartparens-strict-mode)
    (add-hook 'emacs-lisp-mode-hook 'turn-on-smartparens-strict-mode)
    (add-hook 'sly-mrepl-mode-hook 'turn-off-smartparens-mode)
    (add-hook 'sly-mrepl-mode-hook #'(lambda () (interactive) (company-mode -1)))))


;;; top-level

(setup-libraries)
