;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

;;; aliases
(defvar alias-table
  '((yes-or-no-p . y-or-n-p)
    (ef  . expand-file-name)
    (rb  . revert-buffer)
    (cc  . concat)
    (bb . bury-buffer)
    (bm . buffer-menu)

    (ro . read-only-mode)
    (ow . overwrite-mode)

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

    (pi . package-install)
    (pl . package-list-packages)
    (pr . package-refresh-contents)

    (g . grep)

    (bod . beginning-of-defun)
    (eod . end-of-defun)

    (s . slime)
    (clean . ethan-wspace-clean-all)

    (bb . burly-bookmark-windows)
    (bo . burly-open-bookmark)))

(defmacro alias (alias fun)
  `(defalias ',alias ',fun))

(defun def-aliases (table)
  "Define the aliases."
  (cl-loop for (key . val) in table do
           (defalias key val)))

(def-aliases alias-table)

;;; variables
(defvar src-path (emacs-path "fkd/"))
(defvar lib-path (emacs-path "bib/"))
(defvar tmp-path (ef "~/hejmo/dtp/"))

;;; macros
(defmacro def-helpers (names)
  "Define helper functions to retrieve resources."
  `(progn
     ,@(cl-loop
        for name in names
        collect
        `(defun ,name (path)
           (expand-file-name
            (concat ,(eval (read (prin1-to-string name)))
                    path))))))

(def-helpers (src-path lib-path tmp-path))

(defmacro set-mode (val modes)
  "Loop over VAL and MODES to enable or disable a mode."
  `(progn
     ,@(cl-loop
        for mode in modes
        collect `(when (fboundp ',mode) (,mode ,val)))))

(defun set-modes (modes)
  "Loop over modes to set specific values."
  (cl-loop for (key . val) in modes do
           (when (fboundp key)
             (funcall key val))))

(defmacro save-switch-buffer (buffer &rest body)
  "Switch to another buffer, but preserve current buffer,
then evaluate BODY."
  `(let ((buffer-name ,buffer))
     (save-current-buffer
       (when (get-buffer buffer-name)
         (switch-to-buffer buffer-name)
         ,@body))))

(defmacro add-hooks (base modes)
  "Loop over BASE and MODES for ADD-HOOK invocation."
  `(progn
     ,@(cl-loop for mode in modes collect
                `(add-hook ',mode ',base))))

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

;;; functions
(defun other-window-1 (&optional arg)
  "Switch to other window, backwards."
  (interactive "p")
  (other-window (- arg)))

(defun other-frame-1 (&optional arg)
  "Switch to other frame, backwards."
  (interactive "p")
  (other-frame (- arg)))

(defun backward-line (&optional arg)
  "Move line backward"
  (interactive "p")
  (forward-line (- arg)))

(defun delete-sexp (&optional arg)
  "Delete a sexp forward."
  (interactive "p")
  (let ((opoint (point)))
    (forward-sexp (or arg 1))
    (delete-region opoint (point))))

(defun kill-current-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(defun backward-delete-char-or-region (&optional arg)
  "Delete the entire region if it is active; otherwise delete char
before point."
  (interactive "p")
  (if (region-active-p)
      (delete-region (region-beginning)
                     (region-end))
    (if (fboundp 'sp-backward-delete-char)
        (sp-backward-delete-char arg)
      (delete-backward-char arg))))

(defun delete-char-or-region (&optional arg)
  "Delete the entire region if it is active; otherwise delete char
after point."
  (interactive "p")
  (if (region-active-p)
      (delete-region (region-beginning)
                     (region-end))
    (if (fboundp 'sp-delete-char)
        (sp-delete-char arg)
      (delete-forward-char arg))))

(defun find-alternate-file-buffer (&optional arg)
  "Load the current buffer with same buffer."
  (interactive "p")
  (let ((file (buffer-file-name)))
    (when file
      (find-alternate-file (buffer-file-name)))))

(defun split-window-right-other-window ()
  "Split a window right-wise, then switch to it."
  (split-window-right)
  (other-window 1))

(defun switch-to-scratch-buffer ()
  "Switch to the scratch buffer."
  (switch-to-buffer "*scratch*"))

(defun find-files (pathnames)
  "Find multiple files."
  (let* ((paths (split-string pathnames))
         (len (length paths)))
    (cond
     ((null paths) (switch-to-scratch-buffer))
     ((> len 1) (dolist (path paths)
                  (find-file path))))
    nil))

(defun kill-buffer! (buffer)
  "Kill buffer without confirmation."
  (let ((query-functions kill-buffer-query-functions))
    (save-current-buffer
      (when (get-buffer buffer)
        (switch-to-buffer buffer)
        (setq kill-buffer-query-functions
              (remq 'process-kill-buffer-query-function
                    kill-buffer-query-functions))
        (let ((buffer-modified-p nil))
          (kill-buffer (current-buffer))
          (setq kill-buffer-query-functions query-functions))))))

(defun compile-file ()
  "Invoke compile"
  (interactive)
  (let ((command "make -k ")
        (name (file-name-base (buffer-file-name))))
    (save-buffer)
    (cl-case major-mode
      (markdown-mode (compile (concat "emem -Fis " (buffer-file-name))))
      (else (compile command)))))

(defun browse-html-file ()
  "Load the HTML file of buffer in browser"
  (interactive)
  (let* ((dir (file-name-directory (buffer-file-name)))
         (name (file-name-base (buffer-file-name)))
         (html-file (concat dir "/html/" name ".html")))
    (and (file-exists-p html-file)
         (browse-url html-file))))

(defun compile-all ()
  "Invoke compile"
  (interactive)
  (save-buffer)
  (compile "make -k"))

(defun switch-to-other-buffer ()
  "Switch to the other buffer without prompts."
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun x-available-p ()
  "Return true if Emacs is currently in X."
  (and window-system
       (> (length (getenv "DISPLAY")) 0)))

(defun xemacs-p ()
  "Stub to enable compatibility with XEmacs packages."
  nil)

(defun indent-defun ()
  "Indent the current function."
  (interactive)
  (save-excursion
    (ci 'mark-defun)
    (ci 'indent-region)))

(defun add-to-load-path (paths)
  "Add PATHS to load-path."
  (dolist (path paths)
    (add-to-list 'load-path path)))

(defun scratch-frame ()
  "Switch to a new frame with the *scratch* buffer."
  (interactive)
  (switch-to-buffer-other-frame "*scratch*"))

(defun scratch-buffer ()
  "Switch to the *scratch* buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun buffer-file-extension ()
  "Return extension name of the current buffer."
  (let ((file buffer-file-name))
    (if (stringp file)
        (file-name-extension file)
      ""
      (if (> (length file) 0)
          (file-name-extension file)
        ""))))

(defun paths (path)
  "Return all regular files under PATH."
  (directory-files (ef path) t "[^.|..]"))

(defun directories (path)
  "Return all directories under PATH."
  (remove nil
          (mapcar (lambda (path)
                    (when (file-directory-p path)
                      (file-name-as-directory path)))
                  (paths path))))

(defun refresh-paths ()
  "Re-read the load path searching for new files and directories."
  (interactive)
  (add-to-load-path (append (directories (emacs-home))
                            (directory-files lib-path t "[^.|..]"))))
(refresh-paths)

(defun buffer-parent-directory ()
  "Return the parent directory of current buffer."
  (file-name-nondirectory
   (directory-file-name
    (file-name-directory buffer-file-name))))

(defun buffer-parent-directory-z ()
  "Return the parent directory of current buffer, with a trailing slash."
  (file-name-as-directory
   (buffer-parent-directory)))

(defun window-count ()
  "Return the number of windows in the current frame."
  (length (window-list)))

(defun only-window-p ()
  "Return true if there is only one window in the current frame."
  (if (= (window-count) 1)
      t
    nil))

(defun my-switch-to-buffer (buffer)
  "Switch to BUFFER if it exists; otherwise, switch to the scratch
buffer."
  (if (get-buffer buffer)
      (switch-to-buffer buffer)
    (switch-to-buffer "*scratch*")))

(defun delete-indentation-1 (&optional arg)
  "Delete indentation backwards."
  (interactive "p")
  (delete-indentation (- arg)))

;;; settings
(setq user-full-name "Rommel MARTINEZ"
      user-mail-address "rommel.martinez@astn-group.com"
      user-login-name (getenv "USER")

      inhibit-startup-message t
      inhibit-splash-screen t
      scroll-step 1
      scroll-conservatively  101
      next-line-adds-newlines 1
      truncate-lines t
      use-dialog-box nil
      history-length t
      frame-title-format "%b - Emacs"

      enable-recursive-minibuffers nil
      lisp-indent-function 'common-lisp-indent-function

      display-time-day-and-date nil
      display-time-24hr-format t
      display-time-format "%H:%M"

      dired-use-ls-dired nil
      list-directory-brief-switches "-c"
      dired-recursive-deletes 'always

      auto-save-default t
      auto-save-list-file-prefix (tmp-path ".saves.d/.save-")

      undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))
      backup-directory-alist `((".*" . "~/h/dtp/.backups.d/"))
      auto-save-file-name-transforms `((".*" "~/h/dtp/.backups.d/" t))
      native-comp-async-report-warnings-errors nil

      browse-url-browser-function 'w3m-browse-url

      vc-follow-symlinks t

      custom-file (emacs-path "fkd/agordoj.el")
      delete-selection-mode 1
      ring-bell-function 'ignore

      font-lock-maximum-decoration t
      undo-outer-limit 30000000

      bookmark-default-file "~/.emacs.d/bookmarks"
      bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")

;;; default settings
(setq-default default-major-mode 'text-mode
              indent-tabs-mode nil
              fill-column 100)

;;; constants
(defconst initial-scratch-message nil "")
(defconst initial-major-mode 'text-mode)
(defconst default-major-mode 'text-mode)

;;; ui
(set-modes '((menu-bar-mode . -1)
             (tool-bar-mode . -1)
             (blink-cursor-mode . -1)
             (line-number-mode . 1)
             (scroll-bar-mode . -1)
             (column-number-mode . 1)
             (transient-mark-mode . 1)
             (size-indication-mode . 1)))

(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

;; compilation
(setq special-display-buffer-names
      `(("*compilation*" . ((name . "*compilation*")
                            ,@default-frame-alist
                            (left . (- 1))
                            (top . 0)))))

(setq compilation-exit-message-function
      (lambda (status code msg)
        (when (and (eq status 'exit) (zerop code))
          (bury-buffer)
          (delete-window (get-buffer-window (get-buffer "*compilation*"))))
        (cons msg code)))

;;; locale
(set-language-environment "Esperanto")

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;; hooks
(add-hook 'write-file-hooks 'time-stamp)

;;; savehist
(savehist-mode t)
(setq savehist-file "~/.emacs.d/savehist")

(defun save-desktop ()
  "Save the current desktop configuration."
  (interactive)
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))

(defun save-defaults ()
  "Save pre-defined configurations."
  (desktop-save desktop-dirname)
  (savehist-save)
  (bookmark-save))

(defun save-histories ()
  "Save input history of related buffers."
  (let ((buf (current-buffer)))
    (save-excursion
      (dolist (b (buffer-list))
        (switch-to-buffer b)
        (save-history)))
    (switch-to-buffer buf)))

(defun save ()
  "Save desktop, paths, and histories."
  (interactive)
  (refresh-paths)
  (save-desktop)
  (save-defaults)
  (save-histories)
  (message "Saved."))

(setq auto-save-timeout 30)

;;; tables ✚ +
(setq table-cell-horizontal-chars "—="
      table-cell-vertical-char ?\|
      table-cell-intersection-char ?\+)

;;; linum
;; (setq linum-format "%5d │ ")

;; (defun my-linum-mode-hook ()
;;   "Enable linum mode."
;;   (linum-mode t))

;; (add-hook 'find-file-hook 'my-linum-mode-hook)
(add-hook 'find-file-hook 'display-line-numbers-mode)

;;; misc
(defun insert-lambda ()
  "Insert a lambda symbol."
  (interactive)
  (let ((sym (make-char 'greek-iso8859-7 107)))
    (insert sym)))

;;; insert date
(defun format-date (format)
  "Return a date string according to FORMAT."
  (let ((system-time-locale "eo.utf8"))
    (insert (format-time-string format))))

(defun insert-en-date ()
  "Insert the current date."
  (interactive)
  (format-date "%Y-%m-%d %H:%M:%S %z"))

(defun insert-eo-date ()
  "Insert the current date and time in Esperanto."
  (interactive)
  (let* ((system-time-locale "eo.utf8")
         (start (format-time-string "la %-d-an de"))
         (month (downcase (format-time-string " %B ")))
         (end (format-time-string "%Y")))
    (insert (concat start month end))))

(defun insert-date-and-time ()
  "Insert the current date."
  (interactive)
  (format-date "%Y-%m-%d %H:%M:%S"))

(defun insert-date-only ()
  "Insert the current date, only"
  (interactive)
  (format-date "%Y-%m-%d"))

(defun newline-no-indent (&optional arg)
  "Simulate a newline, minus indentation."
  (interactive "p")
  (open-line arg)
  (next-line arg)
  (beginning-of-line arg))

(defun fill-region-or-paragraph ()
  "Fill a region if it is active; otherwise, fill the current paragraph."
  (interactive)
  (if (region-active-p)
      (ci 'fill-region)
    (fill-paragraph)))

(defun move-to-top (&optional arg)
  "Move point to top of window."
  (interactive "p")
  (move-to-window-line 0))

(defun move-to-center (&optional arg)
  "Move point to center of window."
  (interactive "p")
  (move-to-window-line nil))

(defun move-to-bottom (&optional arg)
  "Move point to bottom of window."
  (interactive "p")
  (move-to-window-line -1))

(defun adjust-to-top (&optional arg)
  "Adjust view to top of window."
  (interactive "p")
  (recenter 0))

(defun adjust-to-center (&optional arg)
  "Adjust view to center of window."
  (interactive "p")
  (ci 'recenter))

(defun adjust-to-bottom (&optional arg)
  "Adjust view to bottom of window."
  (interactive "p")
  (recenter -1))

(defun duplicate-frame (&optional arg)
  "Create a new frame with the current buffer."
  (interactive "p")
  (switch-to-buffer-other-frame (current-buffer)))

(defun backward-capitalize-word (&optional arg)
  "Capitalize word before point."
  (interactive "p")
  (capitalize-word (- arg))
  (backward-word arg))

(defun backward-downcase-word (&optional arg)
  "Downcase word before point."
  (interactive "p")
  (downcase-word (- arg))
  (backward-word arg))

(defun backward-upcase-word (&optional arg)
  "Upcase word before point."
  (interactive "p")
  (upcase-word (- arg))
  (backward-word arg))

(defun my-delete-char (&optional arg)
  "Delete character after point. This is to override sp-delete-char's
behavior."
  (interactive "p")
  (ci 'delete-char))

(defun my-backward-delete-char (&optional arg)
  "Delete character before point. This is to override sp-delete-char's
behavior."
  (interactive "p")
  (ci 'backward-delete-char))

(defun netrc-password (host user port)
  "Return the :secret token of a netrc file."
  (let* ((auth (auth-source-search :machine host
                                   :user user
                                   :port port
                                   :type 'netrc
                                   :max 1))
         (password (funcall (plist-get (nth 0 auth) :secret))))
    password))

(defun copy-to-bol ()
  "Copy the region from point to beginning of line."
  (interactive)
  (copy-region-as-kill
   (point)
   (save-excursion (beginning-of-line) (point))))

(defun copy-to-eol ()
  "Copy the region from point to end of line."
  (interactive)
  (copy-region-as-kill
   (point)
   (save-excursion (end-of-line) (point))))

(defun mark-thing (start end &optional arg)
  "Mark from point to anywhere"
  (interactive "p")
  (if (not mark-active)
      (progn
        (funcall start)
        (push-mark)
        (setq mark-active t)))
  (funcall end arg))

(defun mark-line-forward (&optional arg)
  "Mark the current line."
  (interactive "p")
  (mark-thing 'beginning-of-line 'forward-line))

(defun mark-line-backward (&optional arg)
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

(defun shell-command-status (arg)
  "Run a shell command, discarding its output, then return its exit status"
  (shell-command (concat arg " > /dev/null 2>&1")))

(defun shell-which (arg)
  "Return 0 if command is found in shell"
  (shell-command-status (concat "which " arg)))

(defun command-found (command)
  "Return true if command is found in shell"
  (if (zerop (shell-which command)) t nil))

(defun fill-buffer (&optional arg)
  "Fill the entire buffer."
  (interactive "p")
  (fill-region (point-min) (point-max)))

(defun delete-line (&optional arg)
  "Delete current line."
  (interactive "p")
  (let ((p (point))
        (start (save-excursion (beginning-of-line) (point)))
        (next-line-add-newlines nil)
        (end (save-excursion (forward-line) (point))))
    (delete-region start end)
    (goto-char p)))

(defun delete-to-bol (&optional arg)
  "Delete to beginning of line"
  (interactive "p")
  (delete-region (point) (save-excursion (beginning-of-line) (point))))

(defun delete-to-eol (&optional arg)
  "Delete to end of line"
  (interactive "p")
  (delete-region (point) (save-excursion (end-of-line) (point))))

(defun insert-left-paren (&optional arg)
  "Insert a left parenthesis"
  (interactive "p")
  (insert "("))

(defun insert-right-paren (&optional arg)
  "Insert a right parenthesis"
  (interactive "p")
  (insert ")"))

(defun insert-pair (left right)
  "Insert a pair of characters"
  (interactive "p")
  (if (region-active-p)
      (save-excursion
        (let ((start (region-beginning))
              (end (region-end)))
          (when (> start end)
            (exchange-point-and-mark))
          (goto-char end)
          (insert right)
          (goto-char start)
          (insert left)))
    (progn
      (insert left right)
      (backward-char))))

(defun insert-proper-single-quotes (&optional arg)
  "Insert a pair of proper single quotation marks"
  (interactive "p")
  (insert-pair "‘" "’"))

(defun insert-proper-double-quotes (&optional arg)
  "Insert a pair of proper double quotation marks"
  (interactive "p")
  (insert-pair "“" "”"))

(defun insert-proper-angle-quotes (&optional arg)
  "Insert a pair of proper angle quotation marks"
  (interactive "p")
  (insert-pair "«" "»"))

(defun insert-underscores (&optional arg)
  "Insert a pair of underscores"
  (interactive "p")
  (insert-pair "_" "_"))

(defun insert-parens (&optional arg)
  "Insert a pair of parentheses"
  (interactive "p")
  (insert-pair "(" ")"))

(defun insert-backquotes (&optional arg)
  "Insert a pair of backquotes"
  (interactive "p")
  (insert-pair "`" "`"))

;; hooks
(defun my-sh-mode-hook ()
  (make-local-variable 'sh-basic-offset)
  (setq sh-basic-offset 2
        indent-tabs-mode nil))

(add-hook 'sh-mode-hook 'my-sh-mode-hook)
(add-hook 'sh-mode-hook 'my-linum-mode-hook)

(add-hook 'shell-mode-hook 'turn-on-smartparens-strict-mode)

(defun yank-primary (&optional arg)
  (interactive)
  (insert (shell-command-to-string "xclip -selection primary -o")))

(defun yank-clipboard (&optional arg)
  (interactive)
  (insert (shell-command-to-string "xclip -selection clipboard -o")))

(defun www (&optional arg)
  "Preview the current Markdown buffer in w3m"
  (interactive)
  (let ((out "/tmp/www.html"))
    (with-temp-file out
      (shell-command (concat "emem -Ro - " (buffer-file-name)) (current-buffer))
      (w3m-find-file out))))

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

(defun delete-dwim (&optional arg)
  "Delete region if it is active; delete char otherwise"
  (interactive "p")
  (if (region-active-p)
      (progn
        (delete-region (region-beginning) (region-end))
        (deactivate-mark t))
    (delete-char arg)))

(defun ebzzry (&optional arg)
  "Load ebzzry.io"
  (interactive)
  (browse-url "ebzzry.io"))

(defun delete-indentation-1 (&optional arg)
  "Go up one indentation"
  (interactive "p")
  (delete-indentation (- arg)))

(defun insert-quotation-dash (&optional arg)
  "Insert a proper quotation dash"
  (interactive)
  (insert "―"))

(defun yank-clipboard-erase (&optional arg)
  "Clear region and then yank from the clipboard."
  (interactive)
  (delete-region (point-min) (point-max))
  (ci 'yank-clipboard))

(defun swap-windows (direction)
  "Swap windows to direction"
  (interactive)
  (let ((win-list (window-list)))
    (when (>= (length win-list) 2)
      (let* ((window-1 (first win-list))
             (window-2 (cl-ecase direction
                         ((up left) (first (last win-list)))
                         ((down right) (second win-list))))
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

;;; Frames and windows
(setq pop-up-windows t
      pop-up-frames nil)

;;; More pairs
(defun conditional-insert-char (before char-1 char-2)
  "Conditionally insert characters."
  (cond ((or (equal (char-after) char-1)
             (equal (char-after) char-2))
         (forward-char))
        ((equal (char-before) before)
         (insert-pair char-1 char-2))
        (t (insert char-1))))

(defun insert-stars (&optional arg)
  (interactive "p")
  (conditional-insert-char 32 42 42))

(defun insert-pluses (&optional arg)
  (interactive "p")
  (conditional-insert-char 32 43 43))

;;; ispell
(defun ibeo ()
  (interactive)
  (ispell-change-dictionary "eo")
  (call-interactively 'ispell-buffer))

(defun iben ()
  (interactive)
  (ispell-change-dictionary "en")
  (call-interactively 'ispell-buffer))

;;; smartparens
(defun insert-quote ()
  (interactive)
  (insert "'"))

(defun insert-backquote ()
  (interactive)
  (insert "`"))

;;; comments
(defun my-comment-dwim (&optional arg)
  (interactive "p")
  (cond ((< arg 0) (kill-comment nil))
        ((region-active-p) (call-interactively 'comment-dwim))
        (t (cl-case major-mode
             (lisp-mode (cond ((and (zerop (current-column))
                                    (= (point) 1))
                               (insert ";;;; "))
                              ((zerop (current-column))
                               (insert ";;; "))
                              (t (call-interactively 'comment-dwim))))
             (otherwise (call-interactively 'comment-dwim))))))

;;; See http://stackoverflow.com/questions/7410125
(defun set-region-writeable (begin end)
  "Removes the read-only text property from the marked region."
  (interactive "r")
  (let ((modified (buffer-modified-p))
        (inhibit-read-only t))
    (remove-text-properties begin end '(read-only t))
    (set-buffer-modified-p modified)))

;;; See https://stackoverflow.com/questions/2551632/how-to-format-all-files-under-a-dir-in-emacs
(defun indent-marked-files ()
  "Indent the marked files in a dired bufffer."
  (interactive)
  (dolist (file (dired-get-marked-files))
    (find-file file)
    (indent-region (point-min) (point-max))
    (save-buffer)))

(defun quit ()
  "Quit emacs."
  (interactive)
  (let ((current-prefix-arg '(1)))
    (call-interactively 'save-buffers-kill-emacs)))

(defun insert-name ()
  "Insert user full name."
  (interactive)
  (insert user-full-name))

(defun dired-mark-files ()
  "Mark all regular files in the current Dired buffer."
  (interactive)
  (call-interactively 'dired-unmark-all-marks)
  (call-interactively 'dired-mark-directories)
  (call-interactively 'dired-toggle-marks))

;;; makintoŝo
(when (featurep 'ns)
  (defun ns-raise-emacs ()
    "Raise Emacs."
    (ns-do-applescript "tell application \"Emacs\" to activate"))

  (defun ns-raise-emacs-with-frame (frame)
    "Raise Emacs and select the provided frame."
    (with-selected-frame frame
      (when (display-graphic-p)
        (ns-raise-emacs))))

  (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame)

  (when (display-graphic-p)
    (ns-raise-emacs)))

(when (equal system-type 'darwin)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))

  (setq mac-command-modifier 'command
        mac-option-modifier 'nil
        mac-escape-modifier 'nil))

(defun switch-theme (theme)
  "Show a completing prompt for changing the theme."
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapcar 'symbol-name (custom-available-themes))))))
  (mapcar #'disable-theme custom-enabled-themes)
  (load-theme theme t))
