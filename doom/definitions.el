;;;; $DOOMDIR/definitions.el -*- lexical-binding: t; -*-


;;; alinomoj

(defvar alias-table
  '((yes-or-no-p . y-or-n-p)
    (ef  . expand-file-name)
    (rb  . revert-buffer)
    (cc  . concat)
    (bb  . bury-buffer)
    (bm  . buffer-menu)
    (ro  . read-only-mode)
    (ow  . overwrite-mode)
    (rs  . replace-string)
    (rr  . replace-regexp)
    (qr  . query-replace)
    (qrr . query-replace-regexp)
    (af  . auto-fill-mode)
    (ci  . call-interactively)
    (dc  . delete-char)
    (dr  . delete-region)
    (ib  . ispell-buffer)
    (id  . ispell-change-dictionary)
    (ap  . find-file-at-point)
    (tl  . transpose-lines)
    (rf  . rename-file)
    (fa  . find-alternate-file)
    (tr  . table-recognize)
    (tu  . table-unrecognize)
    (tir . table-insert-row)
    (tdr . table-delete-row)
    (dcr . downcase-region)
    (ucr . upcase-region)
    (ccr . capitalize-region)
    (bod . beginning-of-defun)
    (eod . end-of-defun)

    (pi  . package-install)
    (pl  . package-list-packages)
    (pr  . package-refresh-contents)

    (s   . slime)
    (clhs . hyperspec-lookup)))

(defmacro alias (alias fun)
  `(defalias ',alias ',fun))

(defun def-aliases (table)
  "Define the aliases."
  (cl-loop for (key . val) in table do
           (defalias key val)))

(def-aliases alias-table)


;;; helpiloj

(defmacro def-interactive (name &rest body)
  "Define a interactive function"
  `(defun ,name () (interactive) ,@body))

(defmacro def-find (name path)
  "Define an interactive function for finding files."
  `(def-interactive ,name (find-file (ef ,path))))

(defmacro def-view (name path)
  "Define an interactive function for viewing files."
  `(def-interactive ,name (view-file (ef ,path))))

(defmacro def-switch (name buffer)
  "Define an interactive function for switching to a buffer."
  `(def-interactive ,name (switch-to-buffer ,buffer)))

(defmacro def-find-html (name path)
  "Define an interactive function for finding HTML files."
  `(def-interactive ,name (w3m-find-file (ef ,path))))

(defun other-window-1 (&optional arg)
  "Switch to other window, backwards."
  (interactive "p")
  (other-window (- arg)))

(defun swap-windows (direction)
  "Swap windows to direction"
  (interactive)
  (let ((win-list (window-list)))
    (when (>= (length win-list) 2)
      (let* ((window-1 (cl-first win-list))
             (window-2 (cl-ecase direction
                         ((up left) (cl-first (last win-list)))
                         ((down right) (cl-second win-list))))
             (buffer-1 (window-buffer window-1))
             (buffer-2 (window-buffer window-2))
             (start-1 (window-start window-1))
             (start-2 (window-start window-2))
             (point-1 (window-point window-1))
             (point-2 (window-point window-2)))
        (set-window-buffer window-1 buffer-2)
        (set-window-buffer window-2 buffer-1)
        (set-window-start window-1 start-2)
        (set-window-start window-2 start-1)
        (set-window-point window-1 point-1)
        (set-window-point window-2 point-2)
        (other-window (cl-ecase direction
                        ((up) -1)
                        ((down) 1)))))))

(defun swap-up ()
  "Swap windows up"
  (interactive)
  (swap-windows 'up))

(defun swap-down ()
  "Swap windows down"
  (interactive)
  (swap-windows 'down))

(defun go-to-column (column)
  "Move to a column inserting spaces as necessary"
  (interactive "nColumn: ")
  (move-to-column column t))

(defun insert-until-last (string)
  "Insert string until column"
  (let* ((end (save-excursion
                (previous-line)
                (end-of-line)
                (current-column)))
         (count (if (not (zerop (current-column)))
                    (- end (current-column))
                  end)))
    (dotimes (c count)
      (insert string))))

(defun insert-equals (&optional arg)
  "Insert equals until the same column number as last line"
  (interactive)
  (insert-until-last "="))

(defun insert-backticks (&optional arg)
  "Insert three backticks for Markdown use"
  (interactive)
  (if (region-active-p)
      (when (> (region-end) (region-beginning))
        (save-excursion (goto-char (region-beginning))
                        (insert "```\n"))
        (save-excursion (goto-char (region-end))
                        (insert "```"))
        (deactivate-mark))
    (progn
      (insert "``````")
      (backward-char 3))))

(defun insert-hyphens (&optional arg)
  "Insert hyphens until the same column number as last line"
  (interactive)
  (insert-until-last "-"))

(defun insert-anchor (&optional arg)
  (interactive "p")
  (insert "<a name=\"\"></a>")
  (backward-char 6))

(defun zsh-path (path)
  (let ((dir (ef "~/hejmo/ktp/zsh/")))
    (concat dir path)))

(defun spacemacs-path (path)
  (let ((dir (ef "~/hejmo/ktp/spacemacs/")))
    (concat dir path)))

(defun stumpwm-path (path)
  (let ((dir (ef "~/hejmo/fkd/lisp/stumpo/")))
    (concat dir path)))

(defun my-doom-path (path)
  (let ((dir (ef "~/hejmo/ktp/doom/")))
    (concat dir path)))


;;; funkcioj

(defun paths (path)
  "Return all regular files under PATH."
  (directory-files (expand-file-name path) t "[^.|..]"))

(defun directories (path)
  "Return all directories under PATH."
  (remove nil
          (mapcar (lambda (path)
                    (when (file-directory-p path)
                      (file-name-as-directory path)))
                  (paths path))))

(defun add-to-load-path (paths)
  "Add PATHS to load-path."
  (dolist (path paths)
    (add-to-list 'load-path path)))

(defun refresh-paths ()
  "Re-read the load path searching for new files and directories."
  (interactive)
  (add-to-load-path (append (directories (doom-home))
                            (directory-files (doom-path "bib/") t "[^.|..]"))))

;; (refresh-paths)

(defun file-string (file)
  "File to string function"
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(defun insert-comment-line ()
  "Insert an appropriate separator for the current major mode."
  (interactive)
  (let ((lisp-separator "
;;; ")
        (etc-separator "#———————————————————————————————————————————————————————————————————————————————
# "))
    (beginning-of-line)
    (open-line 1)
    (cl-case major-mode
      (lisp-mode (insert lisp-separator))
      (emacs-lisp-mode (insert lisp-separator))
      (t (insert etc-separator)))))

(defun comment-yank ()
  "Copy the region and comment it out."
  (interactive)
  (when (region-active-p)
    (let ((end (region-end)))
      (exchange-point-and-mark)
      (ci 'copy-region-as-kill)
      (ci 'comment-dwim)
      (next-line 1))))

(defun switch-theme (theme)
  "Show a completing prompt for changing the theme."
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapcar 'symbol-name (custom-available-themes))))))
  (mapcar #'disable-theme custom-enabled-themes)
  (load-theme theme t))

(defun mark-thing (start end &optional arg)
  "Mark from point to anywhere"
  (interactive "p")
  (if (not mark-active)
      (progn
        (funcall start)
        (push-mark)
        (setq mark-active t)))
  (funcall end arg))

(defun mark-line (&optional arg)
  "Mark the current line."
  (interactive "p")
  (mark-thing 'beginning-of-line 'end-of-line))

(defun mark-line-forward (&optional arg)
  "Mark the current line then move forward."
  (interactive "p")
  (mark-thing 'beginning-of-line 'forward-line))

(defun mark-line-backward (&optional arg)
  "Mark the current line then move backward."
  (interactive "p")
  (cond ((and (region-active-p)
              (= (current-column) 0))
         (previous-line arg))
        ((and (not (region-active-p))
              (= (current-column) 0))
         (mark-thing 'point 'previous-line))
        (t (mark-thing 'end-of-line 'beginning-of-line))))

(defun mark-to-bol (&optional arg)
  "Create a region from point to beginning of line"
  (interactive "p")
  (mark-thing 'point 'beginning-of-line))

(defun mark-to-eol (&optional arg)
  "Create a region from point to end of line"
  (interactive "p")
  (mark-thing 'point 'end-of-line))

(defun mark-defun-backward (&optional arg)
  "Mark the previous function definition."
  (interactive "p")
  (mark-defun (- arg)))

(defun mark-defun-forward (&optional arg)
  "Mark the next function definition."
  (interactive "p")
  (ci 'mark-defun)
  (ci 'exchange-point-and-mark))

(defun indent-dwim (&optional args)
  "Indent, do what I mean."
  (interactive "p")
  (if (region-active-p)
      (call-interactively 'indent-region)
    (save-excursion
      (mark-line)
      (call-interactively 'indent-region))))

(defun copy-function (&optional args)
  "Put the current function definition to the kill ring."
  (interactive "p")
  (save-excursion
    (ci 'mark-defun)
    (ci 'copy-region-as-kill)))

(defun delete-function (&optional args)
  "Delete the current function definition without appending to the kill ring."
  (interactive "p")
  (save-excursion
    (ci 'mark-defun)
    (ci 'delete-region)))

(defun delete-dwim (&optional arg)
  "Delete, do what I mean."
  (interactive "p")
  (if (region-active-p)
      (progn
        (delete-region (region-beginning) (region-end))
        (deactivate-mark t))
    (delete-char arg)))

(defun change-sexp (&optional args)
  "Like SP-KILL-SEXP but go to insert mode afterwards."
  (interactive "p")
  (sp-kill-sexp (or args 1))
  (call-interactively 'evil-insert))

(defun backward-change-sexp (&optional args)
  "Like SP-BACKWARD-KILL-SEXP but go to insert mode afterwards."
  (interactive "p")
  (sp-backward-kill-sexp (or args 1))
  (call-interactively 'evil-insert))

(defun elisp-eval-dwim (&optional args)
  "Eval the current or region."
  (interactive "p")
  (if (region-active-p)
      (call-interactively 'eval-region)
    (call-interactively 'eval-defun)))

(defun find-version-file ()
  "Find the file `version.sexp' in the current directory."
  (interactive)
  (let* ((directory (file-name-directory buffer-file-name))
         (version-file (concat directory "version.sexp")))
    (find-file version-file)))

(defun open-directory ()
  "Open the current directory in the file manager."
  (interactive)
  (shell-command "o"))

(defun save-windows (&optional args)
  "Save the window configuration."
  (interactive "p")
  (call-interactively 'burly-bookmark-windows))

(defun restore-windows (&optional arg)
  "Restore the windown configuration."
  (interactive "p")
  (call-interactively 'burly-open-bookmark))


;;; agordoj

(defun setup-frames ()
  "Setup frame properties."
  ;; (add-to-list 'default-frame-alist '(fullscreen . maximized))
  )

(defun setup-ui ()
  "Setup UI options."
  (set-modes '((menu-bar-mode . -1)
               (tool-bar-mode . -1)
               (line-number-mode . 1)
               (scroll-bar-mode . -1)
               (column-number-mode . 1)
               (transient-mark-mode . 1)
               (size-indication-mode . 1)))
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1))

  (unless window-system
    (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
    (global-set-key (kbd "<mouse-5>") 'scroll-up-line)))

(defun system-select (darwin other)
  "Return DARWIN if the current system is Darwin, otherwise return OTHER."
  (if (string= system-type 'darwin) darwin other))

(defun setup-variables ()
  "Setup Emacs-wide variables."
  (setq user-full-name "Rommel Martínez"
        user-mail-address "rommel.martinez@astn-group.com"
        user-login-name (getenv "USER")
        inferior-lisp-program (system-select "/usr/local/bin/lw" "sbcl")
        insert-directory-program (system-select "/opt/homebrew/bin/gls" "ls")
        case-fold-search nil
        vc-follow-symlinks t
        undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))
        make-backup-files t
        backup-directory-alist `((".*" . "~/hejmo/dtp/.backups.d/"))
        auto-save-file-name-transforms `((".*" "~/hejmo/dtp/.backups.d/" t))
        native-comp-async-report-warnings-errors nil
        warning-minimum-level :error
        enable-local-variables :safe
        ls-lisp-use-insert-directory-program t
        large-file-warning-threshold nil)
  (setq-default fill-column 80
                display-line-numbers-width 4)
  (setq doom-theme 'doom-gruvbox
        doom-leader-key "SPC"
        doom-localleader-key "SPC m"
        display-line-numbers-type t
        org-directory "~/org/"
        evil-move-cursor-back t
        auto-save-default t
        confirm-kill-emacs nil
        bookmark-file (my-doom-path "bookmarks")
        grep-program "ggrep")
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8))

(defun set-modes (modes)
  "Loop over modes to set specific values."
  (cl-loop for (key . val) in modes do
           (when (fboundp key)
             (funcall key val))))

(defun clear-buffer ()
  "Clear the current buffer according to the major mode."
  (interactive)
  (cl-case major-mode
    (slime-repl-mode (ci 'slime-repl-clear-buffer))
    (sly-repl-mode (ci 'sly-repl-clear-buffer))))

(defun clear-output ()
  "Clear the output according to the major mode."
  (interactive)
  (cl-case major-mode
    (slime-repl-mode (ci 'slime-repl-clear-output))
    (sly-repl-mode (ci 'sly-repl-clear-output))))

(defun format-date (format)
  "Return a date string according to FORMAT."
  (let ((system-time-locale "eo.utf8"))
    (insert (format-time-string format))))

(defun insert-date-and-time ()
  "Insert the current date."
  (interactive)
  (format-date "%Y-%m-%d %H:%M:%S"))

(defun insert-date ()
  "Insert the current date, only"
  (interactive)
  (format-date "%Y-%m-%d"))

(defun insert-day-and-date ()
  "Insert the current day and date."
  (interactive)
  (format-date "%a %Y-%m-%d"))

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

(defvar avoid-window-regexp "^[0-9]$")

(defun my-other-window (&optional arg)
  "Similar to `other-window', but try to avoid windows whose buffers
match `avoid-window-regexp'"
  (interactive)
  (let* ((window-list (delq (selected-window)
                            (if (and arg (< arg 0))
                                (reverse (window-list))
                              (window-list))))
         (filtered-window-list
          (cl-remove-if
           (lambda (w)
             (string-match-p avoid-window-regexp
                             (buffer-name (window-buffer w))))
           window-list)))
    (if filtered-window-list
        (select-window (car filtered-window-list))
      (and window-list
           (select-window (car window-list))))))

(defun my-other-window-1 ()
  "Like `my-other-window' but go backwards."
  (interactive)
  (my-other-window -1))

(defun save-all-buffers ()
  (interactive)
  (save-some-buffers t))

(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))

;;(+macos--open-with reveal-in-finder "Forklift" default-directory)
;;(+macos--open-with reveal-project-in-finder "Forklift" (or (doom-project-root) default-directory))

(defun setup-doom ()
  (set-file-template! "/*-en\\.org$" :trigger "__-en.org" :mode 'org-mode)
  (set-file-template! "/*-eo\\.org$" :trigger "__-eo.org" :mode 'org-mode)
  (set-file-template! "/*-fr\\.org$" :trigger "__-fr.org" :mode 'org-mode)
  (set-file-template! "\\.asd$" :trigger "__.asd" :mode 'lisp-mode)
  (set-file-template! "\\-tests.asd$" :trigger "__tests.asd" :mode 'lisp-mode)
  (set-file-template! "\\.lisp$" :trigger "__.lisp" :mode 'lisp-mode))

(defun setup-modes ()
  (add-to-list 'auto-mode-alist '("\\.vos\\'" . lisp-mode)))

(defun setup-doom-colors ()
  (set-face-foreground #'mode-line "#FFFFFF")
  (set-face-background #'mode-line "#3E9326")
  (set-face-background #'mode-line-inactive "#1D1D1D"))

(add-hook 'emacs-startup-hook 'setup-doom-colors)

(defun copy-region-to-clipboard ()
  "Put the region to the system clipboard."
  (interactive)
  (shell-command-on-region (region-beginning)
                           (region-end)
                           "pbcopy"))

(defun copy-function-to-clipboard ()
  "Put the function to the system clibboard."
  (interactive)
  (save-excursion
    (ci 'mark-defun-backward)
    (ci 'copy-region-to-clipboard)))

;;; See https://stackoverflow.com/questions/2551632/how-to-format-all-files-under-a-dir-in-emacs
(defun indent-marked-files ()
  "Indent the marked files in a dired bufffer."
  (interactive)
  (dolist (file (dired-get-marked-files))
    (find-file file)
    (indent-region (point-min) (point-max))
    (save-buffer)))


;;; top-level

(setup-ui)
(setup-variables)
(setup-doom)
(setup-modes)
