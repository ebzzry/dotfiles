;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-
;;; ĝeneralaj
(bind-keys
 :map global-map
 ("C-." . set-mark-command)
 ("C-d" . delete-dwim)
 ("C-;" . kill-current-buffer)
 ("C-w" . kill-region)

 ("M-z" . zap-to-char)
 ("M-/" . repeat)

 ("M-o" . just-one-space)
 ("M-i" . insert-char)
 ("M-q" . fill-region-or-paragraph)
 ("M-Q" . fill-buffer)
 ("M-(" . insert-parens)

 ("M-p" . backward-line)
 ("M-n" . forward-line)

 ("C-'" . mark-line-forward)
 ("M-'" . mark-line-backward)
 ("C-\\" . kill-whole-line)

 ("C-r" . isearch-backward)
 ("C-s" . isearch-forward)
 ("C-M-r" . isearch-backward-regexp)
 ("C-M-s" . isearch-forward-regexp)

 ("M-<backspace>" . backward-kill-word)
 ("C-<backspace>" . backward-kill-word)

 ("M-$" . replace-string)
 ("M-%" . replace-regexp)
 ("C-c M-$" . query-replace)
 ("C-c M-%" . query-replace-regexp)

 ("C-h C-c" . describe-key-briefly)
 ("C-h C-f" . describe-function)
 ("C-h C-w" . where-is)

 ("C-M-<space>" . mark-sexp)
 ("C-M-SPC" . mark-sexp)
 ("C-M-;" . kill-comment)

 ("S-<return>" . newline-no-indent)
 ("C-M-j" . newline-no-indent)

 ("C-c ^" . delete-to-bol)
 ("C-c $" . delete-to-eol)
 ("C-c ," . mark-to-bol)
 ("C-c ." . mark-to-eol)

 ("C-(" . insert-left-paren)
 ("C-)" . insert-right-paren)

 ("C-x f" . ido-find-file)
 ("C-x ." . find-file-at-point)
 ("C-x W" . window-toggle-split-direction)
 ("C-x b" . ido-switch-buffer)
 ("C-x x" . exchange-point-and-mark)
 ("C-x t" . revert-buffer)

 ("C-x O" . other-window-1)
 ("C-x o" . other-window)

 ("<up>" . swap-up)
 ("<down>" . swap-down)
 ("<left>" . other-window-1)
 ("<right>" . other-window)

 ("C-x (" . beginning-of-defun)
 ("C-x )" . end-of-defun)

 ("C-x 5 O" . other-frame-1)
 ("C-x 5 o" . other-frame)

 ("C-x 2" . split-window-vertically)
 ("C-x 3" . split-window-horizontally)
 ("C-x \"" . split-window-below)
 ("C-x %" . split-window-right)

 ("C-x B" . scratch-buffer)

 ("C-x g" . magit-status)
 ("C-x M-g" . magit-dispatch)
 ("C-x M-f" . magit-find-file)

 ("C-x C-k" . kill-current-buffer)
 ("C-x C-z" . find-alternate-file-buffer)
 ("C-x C-M-c" . save-buffers-kill-emacs)
 ("C-x C-x" . exchange-point-and-mark)
 ("C-x M-x" . compile-all)

 ("C-x C-l" . linum-mode)
 ("C-x C-u" . ignore)

 ("C-x C-h" . hide-region-hide)
 ("C-x C-u" . hide-region-unhide)
 ("C-x \\" . delete-horizontal-space)
 ("C-x M-h" . halt)
 ("C-x C-j" . switch-to-cider-scratch-buffer)
 ("C-x C-d" . ido-dired)
 ("C-x M-d" . duplicate-frame)
 ("C-x C-b" . switch-to-other-buffer)
 ("C-x C-p" . delete-indentation)
 ("C-x C-n" . delete-indentation-1)

 ("C-x y" . yank-clipboard)
 ("C-x Y" . yank-clipboard-erase)
 ("C-x C-y" . yank-primary)

 ("C-x z" . zoom-window-zoom)

 ("C-x \\" . mark-line-backward)
 ("C-x /" . mark-line-forward)

 ("C-x ," . insert-lambda)

 ("C-x ^" . enlarge-window)
 ("C-x _" . shrink-window)

 ("C-x {" . shrink-window-horizontally)
 ("C-x }" . enlarge-window-horizontally)

 ("C-x <up>" . buf-move-up)
 ("C-x <down>" . buf-move-down)
 ("C-x <left>" . buf-move-left)
 ("C-x <right>" . buf-move-right)

 ("C-x %" . read-only-mode)

 ("C-c _" . insert-quotation-dash)
 ("C-c \\"  . insert-auto-lambda)
 ("C-c d"   . insert-eo-date)
 ("C-c C-d" . insert-eo-date)
 ("C-c C-\\" . delete-line)
 ("C-c C-c" . hippie-expand)
 ("C-c C-i" . complete-symbol)

 ("M-c" . capitalize-dwim)
 ("M-u" . upcase-dwim)
 ("M-l" . downcase-dwim)
 ("M-C" . backward-capitalize-word)
 ("M-U" . backward-upcase-word)
 ("M-L" . backward-downcase-word)

 ("M-g SPC" . go-to-column)
 ("M-g `" . insert-backticks)
 ("M-g =" . insert-equals)
 ("M-g -" . insert-hyphens)
 ("M-g a" . insert-anchor)

 ("‘" . self-insert-command)
 ("“" . self-insert-command)
 ("«" . self-insert-command)
 ("`" . self-insert-command)

 ("M-;" . my-comment-dwim))

;;; emakso
(bind-keys
 :map emacs-lisp-mode-map
 ("C-x C-r" . eval-region)
 (";" . sp-comment))

;;; dired
(bind-keys
 :map dired-mode-map
 ("C-x w" . wdired-change-to-wdired-mode)
 ("TAB"   . indent-marked-lines)
 ("* f"   . dired-mark-files))

;;; helpo
(bind-keys
 :map help-map
 ("a" . apropos))

;;; duoj
(bind-keys
 :map smartparens-mode-map
 ("C-d" . delete-dwim)

 ("C-M-a" . sp-beginning-of-sexp)
 ("C-M-e" . sp-end-of-sexp)

 ("C-M-f" . sp-forward-sexp)
 ("C-M-b" . sp-backward-sexp)

 ("C-M-n" . sp-next-sexp)
 ("C-M-p" . sp-previous-sexp)

 ("C-S-f" . sp-forward-symbol)
 ("C-S-b" . sp-backward-symbol)

 ("M-O x" . sp-up-sexp)
 ("M-O r" . sp-down-sexp)
 ("M-O t" . sp-backward-up-sexp)
 ("M-O v" . sp-backward-down-sexp)

 ("<up>" . swap-up)
 ("<down>" . swap-down)
 ("<left>" . other-window-1)
 ("<right>" . other-window)

 ("C-<right>" . sp-forward-slurp-sexp)
 ("M-<right>" . sp-forward-barf-sexp)
 ("C-<left>"  . sp-backward-slurp-sexp)
 ("M-<left>"  . sp-backward-barf-sexp)

 ("C-x >" . sp-forward-slurp-sexp)
 ("C-x ]" . sp-forward-barf-sexp)
 ("C-x <" . sp-backward-slurp-sexp)
 ("C-x [" . sp-backward-barf-sexp)

 ;; GUI
 ("C-<down>" . sp-down-sexp)
 ("C-<up>"   . sp-up-sexp)
 ("M-<down>" . sp-backward-down-sexp)
 ("M-<up>"   . sp-backward-up-sexp)

 ;; CLI
 ("↓" . sp-down-sexp)
 ("↑" . sp-up-sexp)
 ("→" . sp-backward-down-sexp)
 ("←" . sp-backward-up-sexp)

 ("<kp-down>"  . sp-down-sexp)
 ("<kp-up>"    . sp-up-sexp)
 ("<kp-left>"  . sp-backward-down-sexp)
 ("<kp-right>" . sp-backward-up-sexp)

 ("C-M-t" . sp-transpose-sexp)
 ("C-M-k" . sp-kill-sexp)
 ("C-k"   . sp-kill-hybrid-sexp)
 ("M-k"   . sp-backward-kill-sexp)
 ("C-M-w" . sp-copy-sexp)

 ("C-M-d" . delete-sexp)

 ("M-<backspace>" . backward-kill-word)
 ("C-<backspace>" . sp-backward-kill-word)
 ([remap sp-backward-kill-word] . backward-kill-word)

 ("M-[" . sp-backward-unwrap-sexp)
 ("M-]" . sp-unwrap-sexp)

 ("C--" . text-scale-adjust)
 ("C-=" . text-scale-adjust)
 ("C-0" . text-scale-adjust)

 ("C-x C-t" . sp-transpose-hybrid-sexp)

 ("C-c ("  . wrap-with-parens)
 ("C-c ["  . wrap-with-brackets)
 ("C-c {"  . wrap-with-braces)
 ("C-c '"  . wrap-with-single-quotes)
 ("C-c \"" . wrap-with-double-quotes)

 ("'" . insert-quote)
 ("`" . insert-backquote)

 ("*" . self-insert-command)
 ("_" . self-insert-command))

;;; programada reĝimo
(bind-keys
 :map prog-mode-map
 ("M-(" . insert-parens)
 ("*"   . self-insert-command)
 ("+"   . self-insert-command))

(require 'cl-lib)
(message (string-join
          (cl-loop for hex from #x61 to #x7a
                   for char from ?a to ?z
                   collect (format "\"0x%X-0x100000\":{\"Text\":\"[1;P%c\", \"Action\":10}" hex char))
          ",\n"))


(cl-loop for char from ?a to ?z
         do (define-key input-decode-map (format "\e[1;P%c" char) (kbd (format "s-%c" char))))

