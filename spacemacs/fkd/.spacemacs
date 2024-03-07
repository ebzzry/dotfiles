;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-


;;; funkcioj

(defun spacemacs-home ()
  "Return the absolute path to the Spacemacs home."
  (expand-file-name "~/hejmo/ktp/spacemacs/"))

(defun spacemacs-path (path)
  "Return a path relative to the Spacemacs home."
  (let ((dir (spacemacs-home)))
    (concat dir path)))

(defun make-spacemacs-path (x y)
  "Return a path relative to X and Y in the Spacemacs home."
  (spacemacs-path (concat x "/" y)))

(defun spacemacs-path-src (path)
  "Return a path relative to the src path of Spacemacs and PATH."
  (make-spacemacs-path "fkd" path))

(defun spacemacs-path-lib (path)
  "Return a path relative to the lib path of Spacemacs and PATH."
  (make-spacemacs-path "bib" path))

(defun load-modules ()
  "Load the user modules."
  (dolist (file '(gxeneralajxoj
                  bibliotekoj
                  klavkombinoj
                  sxparvojoj
                  transpasoj
                  spacemacs))
    (load (spacemacs-path-src (prin1-to-string file)))))

(load-modules)


;;; spacemacs

(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(connection-local-criteria-alist
   '(((:application eshell)
      eshell-connection-default-profile)
     ((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "la-orcino")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((eshell-connection-default-profile
      (eshell-path-env-list))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(custom-safe-themes 'nil)
 '(package-selected-packages
   '(backup-each-save yatemplate timu-macos-theme org-bullets org-make-toc neotree writegood-mode sqlite3 sql-indent nyan-mode dactyl-mode vimrc-mode autothemer good-scroll nginx-mode auto-complete company yasnippet bnf-mode ebnf-mode revert-buffer-all xclip slime-theme 0x0 zonokai-emacs zenburn-theme zen-and-art-theme yasnippet-snippets yapfify yaml-mode xterm-color ws-butler writeroom-mode winum white-sand-theme which-key wgrep web-mode web-beautify vterm volatile-highlights vim-powerline vi-tilde-fringe uuidgen use-package unkillable-scratch undo-tree underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme treemacs-projectile treemacs-persp treemacs-magit treemacs-icons-dired treemacs-evil toxi-theme toc-org terminal-here term-cursor tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit systemd symon symbol-overlay sunny-day-theme sublime-themes subatomic256-theme subatomic-theme string-edit sphinx-doc spacemacs-whitespace-cleanup spacemacs-purpose-popwin spaceline-all-the-icons spacegray-theme space-doc soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smex smeargle slime-company slim-mode shell-pop seti-theme scss-mode sass-mode reverse-theme restart-emacs request rebecca-theme ranger rainbow-delimiters railscasts-theme racket-mode quickrun pytest pylookup pyenv-mode pydoc py-isort purple-haze-theme pug-mode professional-theme prettier-js popwin poetry plantuml-mode planet-theme pippel pipenv pip-requirements phoenix-dark-pink-theme phoenix-dark-mono-theme persistent-scratch pcre2el password-generator paradox overseer orgit-forge organic-green-theme org-superstar org-rich-yank org-ref org-projectile org-present org-pomodoro org-mime org-download org-contrib org-cliplink open-junk-file omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme nose noctilux-theme nix-mode naquadah-theme nameless mustang-theme multi-term multi-line monokai-theme monokai-pro-theme monochrome-theme molokai-theme moe-theme modus-themes mmm-mode minimal-theme material-theme markdown-toc majapahit-theme madhat2r-theme lush-theme lorem-ipsum live-py-mode link-hint light-soap-theme kaolin-themes journalctl-mode jbeans-theme jazz-theme ivy-yasnippet ivy-xref ivy-purpose ivy-hydra ivy-bibtex ivy-avy ir-black-theme inspector inkpot-theme info+ indent-guide importmagic impatient-mode hybrid-mode hungry-delete holy-mode hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt heroku-theme hemisu-theme help-fns+ helm-make hc-zenburn-theme gruvbox-theme gruber-darker-theme graphviz-dot-mode grandshell-theme gotham-theme google-translate golden-ratio gnuplot gitignore-templates git-timemachine git-modes git-messenger git-link git-gutter-fringe gh-md geiser-guile gandalf-theme fuzzy font-lock+ flyspell-correct-ivy flycheck-pos-tip flycheck-package flycheck-elsa flx-ido flatui-theme flatland-theme fancy-battery eziam-theme eyebrowse expand-region exotica-theme evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-textobj-line evil-tex evil-surround evil-org evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-evilified-state evil-escape evil-ediff evil-easymotion evil-collection evil-cleverparens evil-args evil-anzu eval-sexp-fu espresso-theme eshell-z eshell-prompt-extras esh-help emr emmet-mode elisp-slime-nav elisp-def editorconfig dumb-jump drag-stuff dracula-theme dotenv-mode doom-themes dockerfile-mode docker-tramp docker django-theme dired-quick-sort diminish devdocs define-word darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme cython-mode cyberpunk-theme csv-mode counsel-projectile counsel-css company-web company-reftex company-nixos-options company-math company-auctex company-anaconda common-lisp-snippets column-enforce-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized code-cells clues-theme clean-aindent-mode chocolate-theme cherry-blossom-theme centered-cursor-mode busybee-theme bubbleberry-theme browse-at-remote blacken birds-of-paradise-plus-theme badwolf-theme auto-yasnippet auto-highlight-symbol auto-dictionary auto-compile apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes aggressive-indent afternoon-theme ace-link ac-ispell))
 '(safe-local-variable-values
   '((package . rune-dom)
     (Package . FLEXI-STREAMS)
     (Package . HUNCHENTOOT)
     (Syntax . COMMON-LISP)
     (Package . CXML)
     (Package . FXML)
     (Syntax . Common-Lisp)
     (package . fxml.rune-dom)
     (readtable . runes)
     (external-format . utf-8)
     (Package . CL-USER)
     (Syntax . ANSI-Common-Lisp)
     (Base . 10)
     (Package . FIVEAM)
     (Syntax . Ansi-Common-Lisp)
     (encoding . utf-8)))
 '(warning-suppress-types '(((evil-collection)) ((evil-collection)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil))))
 '(highlight-parentheses-highlight ((nil (:weight ultra-bold))) t))
)
