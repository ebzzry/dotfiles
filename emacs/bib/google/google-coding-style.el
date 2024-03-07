;;; google-coding-style.el --- make writing style-guide-compliant code simpler

;;; There are some optional features in here as well:
;;;
;;; If you want the RETURN key to go to the next line and space over
;;; to the right place, add this to your .emacs right after the load-file:
;;;
;;;    (add-hook 'c-mode-common-hook 'google-make-newline-indent)
;;;
;;; If you want to highlight lines that exceed 80 characters:
;;;
;;;    (dolist (hook '(c++-mode-hook python-mode-hook))
;;;      (add-hook hook '(lambda () (font-lock-set-up-width-warning 80))))

;;; Code:

(require 'cl)


;;;; Language-independent coding style

(defun font-lock-set-up-width-warning (width)
  "Make text beyond column WIDTH appear in `font-lock-warning-face'.

To activate this command automatically for C++, Java, and Python, add
this code to your \"~/.emacs\" file:

    (dolist (hook '(c++-mode-hook python-mode-hook))
      (add-hook hook '(lambda () (font-lock-set-up-width-warning 80))))"
  (require 'font-lock)
  (font-lock-mode 1)
  (make-local-variable 'font-lock-keywords)
  (font-lock-add-keywords
   nil
   `((,(format "^.\\{%d\\}\\(.+\\)" width)
      1 font-lock-warning-face t))))

(defun google-coding-style/end-of-code-on-line-p (&optional point)
  "True iff there is no \"real\" code (not comment or whitespace) after POINT.

POINT defaults to (point). Returns true iff there is no more non-comment
non-whitespace code before end of line, false otherwise."
  (save-excursion
    (and point (goto-char point))
    (let ((eol (point-at-eol)))
      (while (forward-comment 1))  ;; Skip over comments and whitespace
      (or (> (point) eol) (= (point) (point-max))))))


;;;; Javadoc-style documentation

(defun google-coding-style/in-doc-brackets-p ()
  "Return whether the point is in a Javadoc-style bracketed expression.

This allows e.g. {@link ClassName} to not be broken across lines
when running \\[fill-paragraph]."
  (save-excursion
    (condition-case err
        (progn
          (backward-up-list)
          (looking-at "{@"))
      (scan-error))))

(defun google-coding-style/set-doc-style ()
  "Configures `fill-paragraph' to respect Javadoc-style tags.

This means that running \\[fill-paragraph] within a comment won't
merge doc tags (e.g. @param) into the previous line and won't
break up bracketed expressions (e.g. {@link ClassName}) among
multiple lines."
  ;; These are unbound in Emacs 21. They're bound for xemacs (at least some
  ;; versions), but the format of the paragraph variables is different, so we
  ;; avoid that anyway.
  (when (and (not (xemacs-p))
             (fboundp 'c-setup-paragraph-variables)
             (boundp 'c-paragraph-start))
    (setq c-paragraph-start
          (concat "\\(" (or c-paragraph-start "") "\\|[ \t]*\*[ \t]*@\\)"))
    ;; This is unbound in Xemacs
    (when (boundp 'fill-nobreak-predicate)
      (make-local-variable 'fill-nobreak-predicate)
      (add-to-list 'fill-nobreak-predicate
                   'google-coding-style/in-doc-brackets-p))
    (let ((c-buffer-is-cc-mode t))
      (c-setup-paragraph-variables))))



;;;; Python (python-mode)
(require 'python-custom)

(defun google3-coding-style/indent-continued-expression ()
  "Modify Python indentation to match the Google style guide.
See http://www.corp.google.com/eng/doc/pyguide.xml#Indentation.

Use `python-continuation-offset' instead of `python-indent' in the
case of a continued expression, eg

  function(
      arg_indented_four_spaces)

Note that in the case of doubly-nested multi-line parenthesized
expressions, Google mandates that the second nested
expression be indented relative to the first, as so:

  function('string' % (
               'format indented relative to first arg'))"

  (flet-missing
      ((python-nav-forward-sexp (&optional arg)
                                (with-syntax-table python-space-backslash-table
                                  (let ((parse-sexp-ignore-comments t))
                                    (forward-sexp arg))))
       (python-info-continuation-line-p ()
                                        (python-continuation-line-p)))
    (save-excursion
      (beginning-of-line)
      (let* ((syntax (syntax-ppss))
             (open-start (cadr syntax))
             (in-string-or-comment (syntax-ppss-context syntax))
             (point (point)))
        (block nil
          (when in-string-or-comment (return))
          (unless (python-info-continuation-line-p) (return))
          ;; Find out if there is some stuff inside the paren before this line.
          (goto-char (1+ open-start))
          (condition-case ()
              (progn
                (python-nav-forward-sexp 1)
                (python-nav-forward-sexp -1))
            (error nil))
          (let ((point-at-first-sexp (point)))
            (when (< point-at-first-sexp point)
              ;; There is.
              (if (prog2 (back-to-indentation)
                      (= (point) point-at-first-sexp))
                  ;; Below an already indented line; mimic its indentation
                  (return (current-indentation))
                (return))))  ;; Defer to normal indent code.
          (goto-char (1+ open-start))
          (if (eolp)
              (+ (current-indentation) python-continuation-offset)
            (current-indentation)))))))

(add-to-list 'python-indent-line-functions
             'google3-coding-style/indent-continued-expression)

(defun google-set-python-style ()
  (interactive)
  (setq py-indent-offset 2) ; For the third_party python-mode.el

  ;; For GNU Emacs' python.el
  (setq python-indent 2)
  (setq python-continuation-offset 4)
  (when (fboundp 'python-calculate-indentation)
    (ad-activate 'python-calculate-indentation)))

(add-hook 'python-mode-hook 'google-set-python-style)


;;;; Perl (perl-mode)

;; Let's make perl work properly by default, by mflaster@google.com.
;; Never use tabs, and indent by 2 properly.
(defun google-set-perl-style ()
  (interactive)
  (make-local-variable 'perl-indent-level)
  (setq perl-indent-level 2)
  (make-local-variable 'perl-continued-statement-offset)
  (setq perl-continued-statement-offset 2)
  (make-local-variable 'perl-continued-brace-offset)
  (setq perl-continued-brace-offset -2)
  (make-local-variable 'perl-label-offset)
  (setq perl-label-offset -2)
  (setq indent-tabs-mode nil))

(add-hook 'perl-mode-hook 'google-set-perl-style)


;;;; Shell (sh-mode)

;; Shell can be consistent too
(defun google-set-sh-style ()
  (interactive)
  (make-local-variable 'sh-basic-offset)
  (setq sh-basic-offset 2)
  (setq indent-tabs-mode nil))

(add-hook 'sh-mode-hook 'google-set-sh-style)


;;;; cc-mode (c-mode, C++, Java, etc.)

(setq auto-mode-alist
      (cons '("\\.[ch]$" . c++-mode) auto-mode-alist)) ; .c,.h files in C++ mode

;; For some reason 1) c-backward-syntactic-ws is a macro and 2)  under Emacs 22
;; bytecode cannot call (unexpanded) macros at run time:
(eval-when-compile (require 'cc-defs))

;; Wrapper function needed for Emacs 21 and XEmacs (Emacs 22 offers the more
;; elegant solution of composing a list of lineup functions or quantities with
;; operators such as "add")
(defun google-c-lineup-expression-plus-4 (langelem)
  "Indent to the beginning of the current C expression plus 4 spaces.

This implements title \"Function Declarations and Definitions\" of the Google
C++ Style Guide for the case where the previous line ends with an open
parenthese.

\"Current C expression\", as per the Google Style Guide and as clarified by
subsequent discussions (eg
http://g/emacs-users/browse_thread/thread/698f6854244be09c/4c9f2d5874c6fd9f),
means the whole expression regardless of the number of nested parentheses, but
excluding non-expression material such as \"if(\" and \"for(\" control
structures.

Suitable for inclusion in `c-offsets-alist'."
  (save-excursion
    (back-to-indentation)
    ;; Go to beginning of *previous* line:
    (c-backward-syntactic-ws)
    (back-to-indentation)
    (cond
     ;; We are making a reasonable assumption that if there is a control
     ;; structure to indent past, it has to be at the beginning of the line.
     ((looking-at "\\(\\(if\\|for\\|while\\)\\s *(\\)")
      (goto-char (match-end 1)))
     ;; For constructor initializer lists, the reference point for line-up is
     ;; the token after the initial colon.
     ((looking-at ":\\s *")
      (goto-char (match-end 0))))
    (vector (+ 4 (current-column)))))

(defun google-java-lineup-expression-plus-4 (langelem)
  "Indent to the beginning of the current conditional expression plus 4 spaces.

Similar to google-c-lineup-expression-plus-4 but applies the java indent rules.
This is used for the Java coding style.

Suitable for inclusion in `c-offsets-alist'."
  (save-excursion
    (back-to-indentation)
    ;; Go to beginning of *previous* line:
    (c-backward-syntactic-ws)
    (back-to-indentation)
    (cond
     ;; We are making a reasonable assumption that if there is a control
     ;; structure to indent past, it has to be at the beginning of the line.
     ((looking-at "\\(\\(if\\|for\\|while\\)\\s *(\\)")
      ;; As per https://groups.google.com/a/google.com/forum/?fromgroups=#!topic/java-style/I1xvaXpwr24
      ;; we go to the start of the match in Java mode instead of the end of
      ;; the match like we do in C mode.
      (goto-char (match-beginning 1)))
     ;; For constructor initializer lists, the reference point for line-up is
     ;; the token after the initial colon.
     ((looking-at ":\\s *")
      (goto-char (match-end 0))))
    (vector (+ 4 (current-column)))))


(defun google-java-lineup-conditional-expression-plus-4 (langelem)
  "Indent to the beginning of the current conditional expression plus 4 spaces.

Similar to `google-c-lineup-expression-plus-4' but only applies to conditional
expressions.  This is used for the Java coding style.

Suitable for inclusion in `c-offsets-alist'."
  (save-excursion
    (back-to-indentation)
    ;; Go to the start of the 2nd syntactic element
    (goto-char (c-langelem-2nd-pos c-syntactic-element))
    (back-to-indentation)
    (cond
     ;; We are making a reasonable assumption that if there is a control
     ;; structure to indent past, it has to be at the beginning of the line.
     ((looking-at "\\(\\(if\\|for\\|while\\)\\s *(\\)")
      ;; As per https://groups.google.com/a/google.com/forum/?fromgroups=#!topic/java-style/I1xvaXpwr24
      ;; we go to the start of the match in Java mode instead of the end of
      ;; the match like we do in C mode.
      (goto-char (match-beginning 1))
      (vector (+ 4 (current-column))))
     ;; If it isn't a control statement we fall through to the next indent
     ;; rule by returning nil
     (t
      nil))))

(defconst google-c-style
  `((c-recognize-knr-p . nil)
    (c-enable-xemacs-performance-kludge-p . t) ; speed up indentation in XEmacs
    (c-basic-offset . 2)
    (indent-tabs-mode . nil)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist . ((defun-open after)
                               (defun-close before after)
                               (class-open after)
                               (class-close before after)
                               (inexpr-class-open after)
                               (inexpr-class-close before)
                               (namespace-open after)
                               (inline-open after)
                               (inline-close before after)
                               (block-open after)
                               (block-close . c-snug-do-while)
                               (extern-lang-open after)
                               (extern-lang-close after)
                               (statement-case-open after)
                               (substatement-open after)))
    (c-hanging-colons-alist . ((case-label)
                               (label after)
                               (access-label after)
                               (member-init-intro before)
                               (inher-intro)))
    (c-hanging-semi&comma-criteria
     . (c-semi&comma-no-newlines-for-oneline-inliners
        c-semi&comma-inside-parenlist
        c-semi&comma-no-newlines-before-nonblanks))
    (c-indent-comments-syntactically-p . t)
    (comment-column . 40)
    (c-indent-comment-alist . ((other . (space . 2))))
    (c-cleanup-list . (brace-else-brace
                       brace-elseif-brace
                       brace-catch-brace
                       empty-defun-braces
                       defun-close-semi
                       list-close-comma
                       scope-operator))
    (c-offsets-alist . ((arglist-intro google-c-lineup-expression-plus-4)
                        (func-decl-cont . ++)
                        (member-init-intro . ++)
                        (inher-intro . ++)
                        (comment-intro . 0)
                        (arglist-close . c-lineup-arglist)
                        (topmost-intro . 0)
                        (block-open . 0)
                        (inline-open . 0)
                        (substatement-open . 0)
                        (statement-cont
                         .
                         (,(when (fboundp 'c-no-indent-after-java-annotations)
                             'c-no-indent-after-java-annotations)
                          ,(when (fboundp 'c-lineup-assignments)
                             'c-lineup-assignments)
                          ++))
                        (label . /)
                        (case-label . +)
                        (statement-case-open . +)
                        (statement-case-intro . +) ; case w/o {
                        (access-label . /)
                        (innamespace . 0)
                        (inextern-lang . 0))))
  "Google C/C++ Programming Style.")

(defconst google-java-style
  `("Google" (c-offsets-alist
              (arglist-cont-nonempty google-java-lineup-conditional-expression-plus-4 ++)
              (arglist-intro google-java-lineup-expression-plus-4)))
  "Google Java Programming Style.")

(defun google-set-c-style ()
  (interactive)
  (make-local-variable 'c-tab-always-indent)
  (setq c-tab-always-indent t)
  (google-coding-style/set-doc-style)
  (c-add-style "Google" google-c-style t))

(defun google-set-java-style ()
  (interactive)
  (c-add-style "Google-Java" google-java-style t))

(defun google-make-newline-indent ()
  (interactive)
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map [ret] 'newline-and-indent))

(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'java-mode-hook 'google-set-java-style)

;; C++11-related additions.
(if (featurep 'font-lock)
  (font-lock-add-keywords 'c++-mode
    ;; `NULL' is treated as a constant, so do similarly for `nullptr'.
    '(("\\<nullptr\\>" . font-lock-constant-face)
      ("\\<constexpr\\>" . font-lock-keyword-face))))




;;;; General utility functions

(defun google-coding-style/point-at-bol (&optional point)
  "Return the point at the beginning of the line of POINT, default (point)."
  (save-excursion (and point (goto-char point)) (point-at-bol)))

(defun google-coding-style/last-indent (&optional point)
  "Return the position of the last indent before POINT (default current point).

The last indent is the closest nonblank character that is both before POINT
and first on its line.

If no such character can be found, returns nil."
  (save-excursion
    (and point (goto-char point))
    (let ((start-point (point)) return-value)
      (while (not (or return-value (eq (point) (point-min))))
        (back-to-indentation)
        (if (and (not (looking-at "\\s *$"))
                 (< (point) start-point))
            (setq return-value (point))
          (end-of-line 0)))
      return-value)))

(defun google-coding-style/point-after-eoc (&optional point)
  "Return the point after end-of-code on the line of POINT.

Code is defined as non-whitespace, non-comment; returns the point after the last
character of code on the line of POINT, which defaults to (point).  Returns nil
if the line contains no code.

For instance, in this line (assuming C++ syntax table):

  blah blah() /* some */ /* useless */ /// comments
             ^ point returned is here.

This assumes that the current mode's syntax table is set up to recognize
comments, otherwise they will be treated as code too."
  (save-excursion
    (and point (goto-char point))
    (let ((point-bol (point-at-bol)))
      ;; With inline comments, the newline is the terminator, therefore
      ;; (point-at-eol) is *inside* the comment.  To let (forward-comment -1) do
      ;; the right thing, go to start of next line:
      (beginning-of-line 2)
      (while (forward-comment -1))
      (and (> (point) point-bol) (point)))))

(defun google-coding-style/column-indent (point &optional offset)
  "Return the column number for POINT, plus OFFSET.

This is an auxiliary function for all syntax hooks that expect a column number.
OFFSET's default value is zero."
  (save-excursion (goto-char point) (+ (or offset 0) (current-column))))

(provide 'google-coding-style)
;;; google-coding-style.el ends here
