;; $Id: scribble.el,v 1.47 2011/01/10 19:31:54 neilpair Exp $

(defconst scribble-mode-title   "Racket Scribble Emacs Mode")
(defconst scribble-mode-version "0.3")
(defconst scribble-mode-date    "2011-01-10")
(defconst scribble-mode-web     "http://www.neilvandyke.org/scribble-emacs/")

(defconst scribble-mode-legal-notices
  "Copyright (c) 2011 Neil Van Dyke.  This program is Free Software; you can
redistribute it and/or modify it under the terms of the GNU Lesser General
Public License as published by the Free Software Foundation; either version
3 of the License (LGPL 3), or (at your option) any later version. This
program is distributed in the hope that it will be useful, but without any
warranty; without even the implied warranty of merchantability or fitness
for a particular purpose.  See http://www.gnu.org/licenses/ for details.
For other licenses and consulting, please contact the author.")

;; Note: Changes to above info must be reflected in "scribble-emacs.scrbl"
;; and "info.rkt".

;;-------------------------------------------------------------------- Requires

(require 'eldoc)

;;---------------------------------------------------------------------- Custom

(defgroup scribble
  nil
  "Racket Scribble Emacs Mode"
  :group 'wp
  :prefix "scribble-")

(defface scribble-comment-face
  '((t :foreground "cyan"))
  "Face for Comments in Scribble mode."
  :group 'scribble)

(defface scribble-at-keyword-face
  '((t :weight bold :foreground "gray50"))
  "Face for `@'-and-name in Scribble mode."
  :group 'scribble)

(defface scribble-square-bracket-face
  '((t :weight bold :foreground "#c48080"))
  "Face for square brackets in Scribble mode."
  :group 'scribble)

(defface scribble-curly-brace-face
  '((t :weight bold :foreground "#c48080"))
  "Face for curly braces in Scribble mode."
  :group 'scribble)

(defface scribble-title-face
  '((t :family "DejaVu Serif" :height 2.0736 :slant italic))
  "Face for titles in Scribble mode."
  :group 'scribble)

(defface scribble-section-heading-face
  '((t :family "DejaVu Serif" :height 2.0736 :weight bold))
  "Face for section headings in Scribble mode."
  :group 'scribble)

(defface scribble-subsection-heading-face
  '((t :family "DejaVu Serif" :height 1.728 :weight bold))
  "Face for subsection headings in Scribble mode."
  :group 'scribble)

(defface scribble-subsubsection-heading-face
  '((t :family "DejaVu Serif" :height 1.44 :weight bold))
  "Face for subsubsection headings in Scribble mode."
  :group 'scribble)

(defface scribble-sub*section-heading-face
  '((t :family "DejaVu Serif" :height 1.2 :weight bold))
  "Face for deep-subsection headings in Scribble mode."
  :group 'scribble)

(defface scribble-bold-face
  '((t  :weight bold))
  "Face for @bold in Scribble mode."
  :group 'scribble)

(defface scribble-emph-face
  '((t  :slant italic))
  "Face for @emph in Scribble mode."
  :group 'scribble)

(defface scribble-tt-face
  '((t  :family "DejaVu Sans Mono"))
  "Face for @tt in Scribble mode."
  :group 'scribble)

(defface scribble-link-text-face
  '((t :underline t :foreground "blue"))
  "Face for link text in Scribble mode."
  :group 'scribble)

(defface scribble-planet-face
  '((t))
  "Face for @PLaneT in Scribble mode."
  :group 'scribble)

(defface scribble-racket-result-face
  '((t :foreground "blue3"))
  "Face for Racket results in Scribble mode."
  :group 'scribble)

(defface scribble-racket-value-face
  '((t :foreground "green2"))
  "Face for Racket values in Scribble mode."
  :group 'scribble)

(defface scribble-bnf-nonterm-face
  '((t :slant italic))
  "Face for @nonterm in Scribble mode."
  :group 'scribble)

(defface scribble-racket-litchar-face
  '((t :foreground "#aaaa00"
       :background "#f4f4f4"
       :slant      normal
       :weight     normal))
  "Face for @litchar in Scribble mode."
  :group 'scribble)

;; Quickref Faces:

;; (defface scribble-quickref-default-face
;;   '((t :family     "DejaVu Sans"
;;        :foreground "#000000"
;;        :background "#e8e8ff"
;;        :weight     normal
;;        :slant      normal))
;;   "Face for Quickref in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-meta-face
;;   '((t :inherit    scribble-quickref-default-face
;;        :foreground "#000000"))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-literal-face
;;   '((t :family     "DejaVu Sans Mono"
;;        :inherit    scribble-quickref-default-face
;;        :foreground "red4"
;;        :weight     bold))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-value-face
;;   '((t :family     "DejaVu Sans Mono"
;;        :inherit    scribble-quickref-default-face
;;        :foreground "green4"))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-at-face
;;   '((t :inherit    scribble-quickref-literal-face))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-keyword-face
;;   '((t :family     "DejaVu Sans"
;;        :inherit    scribble-quickref-literal-face))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-form-name-face
;;   '((t :inherit scribble-quickref-default-face
;;        :foreground "blue4"
;;        :weight  bold))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-type-face
;;   '((t :inherit    scribble-quickref-default-face
;;        :foreground "blue")) ;!!!
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; (defface scribble-quickref-arg-face
;;   '((t :inherit    scribble-quickref-default-face
;;        :slant      italic
;;        :foreground "blue2"))
;;   "Face for Quickref !!! in Scribble mode."
;;   :group 'scribble)

;; ElDoc Faces:

(defface scribble-eldoc-default-face
  '((t :family     "DejaVu Sans"
       :foreground "#000000"
       :background "#fffff0"
       :weight     normal
       :slant      normal))
  "Face for ElDoc in Scribble mode."
  :group 'scribble)

(defface scribble-eldoc-literal-face
  '((t :inherit    scribble-eldoc-default-face))
  "Face for ElDoc literals in Scribble mode."
  :group 'scribble)

(defface scribble-eldoc-meta-face
  '((t :inherit    scribble-eldoc-default-face
       :foreground "#4040ff"))
  "Face for ElDoc metasyntactic symbols in Scribble mode."
  :group 'scribble)

(defface scribble-eldoc-nonterminal-face
  '((t :inherit scribble-eldoc-default-face
       :slant   italic))
  "Face for ElDoc nonterminals in Scribble mode."
  :group 'scribble)

;;---------------------------------------------------- Customization Procedures

(defun scribble-customize ()
  (interactive)
  (customize-group 'scribble))

;; TODO: Implement making any non-face changes take effect.

;;-------------------------------------------------------------- Scribble Forms

(defsubst scribble-get-form-name (form) (aref form 0))
(defsubst scribble-get-form-args (form) (aref form 1))
(defsubst scribble-get-form-type (form) (aref form 2))
(defsubst scribble-get-form-face (form) (aref form 3))

;; TODO: Maybe make types be strings.

(defsubst scribble-get-formarg-kind    (arg) (aref arg 0))
(defsubst scribble-get-formarg-name    (arg) (aref arg 1))
(defsubst scribble-get-formarg-type    (arg) (aref arg 2))
(defsubst scribble-get-formarg-default (arg) (aref arg 3))

;; Note: The information is from Racket 5.0.2 Scribble documentation.

(defconst scribble-style-form-type
  '(or/c style? f string? symbol? (listof symbol?)))

(defconst scribble-optional-style-form-arg
  `[k style ,scribble-style-form-type "#f"])

(defconst scribble-optional-underline?-form-arg
  `[k underline? any/c "#t"])

(defconst scribble-optional-tag-form-arg
  `[k tag (or/c false/c string? (listof string?)) "#f"])

(defconst scribble-heading-form-args
  `(,scribble-optional-tag-form-arg
    [k tag-prefix (or/c false/c string? module-path?) "#f"]
    ,scribble-optional-style-form-arg))

;; TODO: Support more than just "scribble/base".

(defconst scribble-base-forms
  `(
    ;; scribble/base
    ;; file:///usr/local/racket-5.0.2/share/racket/doc/scribble/base.html

    [title (,@scribble-heading-form-args
            [k version (or/c string? false/c) "#f"]
            [p -       pre-content?           -]
            ...)
           title-decl?
           scribble-title-face]
    [section       (,@scribble-heading-form-args
                    [p - pre-content? -]
                    ...)
                   part-start?
                   scribble-section-heading-face]
    [subsection    (,@scribble-heading-form-args
                    [p - pre-content? -]
                    ...)
                   part-start?
                   scribble-subsection-heading-face]
    [subsubsection (,@scribble-heading-form-args
                    [p - pre-content? -]
                    ...)
                   part-start?
                   scribble-subsubsection-heading-face]
    [sub*section   (,@scribble-heading-form-args
                    [p - pre-content? -]
                    ...)
                   part-start?
                   scribble-sub*section-heading-face]
    [author ([p - content? -])
            block?
            nil]
    [author+email ([p author     elem    -]
                   [p email      string? -]
                   [k obfuscate? any/c   "#f"])
                  element?
                  nil]
    [para (,scribble-optional-style-form-arg
           [p - pre-content? -]
           ...)
          paragraph?
          nil]
    [nested (,scribble-optional-style-form-arg
             [p - pre-flow? -]
             ...)
            nested-flow?
            nil]
    [centered ([p - pre-flow? -]
               ...)
              nested-flow?
              nil]
    [margin-note ([p - pre-flow? -]
                  ...)
                 block?
                 nil]
    [margin-note* ([p - pre-content? -]
                   ...)
                  element?
                  nil]
    [itemlist ([p - item? -]
               ...
               ,scribble-optional-style-form-arg)
              itemization?
              nil]
    [item ([p - pre-flow? -]
           ...)
          item?
          nil]
    [tabular ([p cells (listof (listof (or/c block? content? 'cont))) -]
              ,scribble-optional-style-form-arg)
             table?
             nil]
    [verbatim ([p indent exact-nonnegative-integer? "0"]
               [p -      string?                    -]
               ...)
              block?
              nil]
    [elem ([p - pre-content? -]
           ...
           ,scribble-optional-style-form-arg)
          element?
          nil]
    [italic ([p - pre-content? -]
             ...)
            element?
            nil]
    [code ([p - pre-content? -]
             ...)
            element?
            nil]
    [codeblock ([p - pre-content? -]
             ...)
            element?
            nil]
    [bold ([p - pre-content? -]
           ...)
          element?
          scribble-bold-face]
    [tt ([p - pre-content? -]
         ...) 
        element?
        scribble-tt-face]
    [subscript ([p - pre-content? -]
                ...) 
               element?
               nil]
    [superscript ([p - pre-content? -]
                  ...) 
                 element?
                 nil]
    [smaller ([p - pre-content? -]
              ...) 
             element?
             nil]
    [larger ([p - pre-content? -]
             ...) 
            element?
            nil]
    [emph ([p - pre-content? -]
           ...) 
          element?
          scribble-emph-face]
    [linebreak ()
               element?
               nil]
    [hspace ([p - exact-nonnegative-integer? -])
            element?
            nil]
    [literal ([p - string? -]
              ...) 
             element?
             nil]
    [image
     ([p path     (or/c path-string? (cons/c 'collects (listof bytes?))) -]
      [k scale    real?                "1.0"]
      [k suffixes (listof (rx "^[.]")) "null"]
      [p -        pre-content?         -]
      ...)
     element?
     nil]
    [hyperlink ([p url string?      -]
                [p -   pre-content? -]
                ...
                ,scribble-optional-underline?-form-arg
                [k style
                   (or/c style? string? symbol? false/c)
                   "(if underline? #f \"plainlink\")"])
               element?
               scribble-link-text-face]
    [url ([p dest string? -])
         element?
         nil]
    [secref ([p tag          string                          -]
             [k doc          (or/c module-path? false/c)     "#f"]
             [k tag-prefixes (or/c (listof string?) false/c) "#f"]
             ,scribble-optional-underline?-form-arg)
            element?
            scribble-link-text-face]
    [seclink ([p tag          string?                         -]
              [k doc          (or/c module-path? false/c)     "#f"]
              [k tag-prefixes (or/c (listof string?) false/c) "#f"]
              ,scribble-optional-underline?-form-arg
              [p -            pre-content?                    -]
              ...)
             element?
             scribble-link-text-face]
    [other-doc ([p module-path module-path? -]
                ,scribble-optional-underline?-form-arg)
               element?
               nil]
    [elemtag ([p t (or/c tag? string?) -]
              [p - pre-content?        -]
              ...)
             element?
             nil]
    [elemref ([p t (or/c tag? string?) -]
              [p - pre-content?        -]
              ...
              ,scribble-optional-underline?-form-arg)
             element?
             nil]
    [index ([p words (or/c string? (listof string?)) -]
            [p -     pre-content?                    -]
            ...)
           index-element?
           nil]
    [index* ([p words         (listof string?) -]
             [p word-contents (listof list?)   -]
             [p -             pre-content?     -]
             ...)
            index-element?
            nil]
    [as-index ([p - pre-content? -]
               ...)
              index-element?
              nil]
    [section-index ([p word string? -]
                    ...)
                   part-index-decl?
                   nil]
    [index-section ([k tag (or/c false/c string?) "\"doc-index\""]
                    ,scribble-optional-tag-form-arg)
                   part?
                   nil]
    [table-of-contents ()
                       delayed-block?
                       nil]
    [local-table-of-contents (,scribble-optional-style-form-arg)
                             delayed-block?
                             nil]))

(defconst scribble-manual-forms
  `(

    [racketblock  ([p - datum? -] ...) any/c nil]
    [RACKETBLOCK  ([p - datum? -] ...) any/c nil]
    [racketblock0 ([p - datum? -] ...) any/c nil]
    [RACKETBLOCK0 ([p - datum? -] ...) any/c nil]

    [racketresultblock  ([p - datum? -] ...) any/c nil]
    [RACKETRESULTBLOCK  ([p - datum? -] ...) any/c nil]
    [racketresultblock0 ([p - datum? -] ...) any/c nil]
    [RACKETRESULTBLOCK0 ([p - datum? -] ...) any/c nil]

    [racketinput ([p - datum? -] ...) any/c nil]
    [RACKETINPUT ([p - datum? -] ...) any/c nil]
    
    [racketmod ([k file string? "#f"]
                [p -    datum?  -]
                ...)
               any/c
               nil]

    [racket ([p - datum? -] ...) any/c nil]
    [RACKET ([p - datum? -] ...) any/c nil]

    ;; TODO: For "racketresult" and "racketid", maybe override body faces.
    [racketresult ([p - datum? -] ...) any/c scribble-racket-result-face]
    [racketid     ([p - datum? -] ...) any/c nil]

    [racketmodlink ([p - datum?            -]
                    [p - pre-content-expr? -]
                    ...)
                   any/c
                   nil]

    [litchar ([p - string? -] ...) element? scribble-racket-litchar-face]

    [racketfont        ([p - pre-content? -] ...) element? nil]
    [racketvalfont     ([p - pre-content? -] ...) element? scribble-racket-value-face]
    [racketresultfont  ([p - pre-content? -] ...) element? scribble-racket-result-face]
    [racketidfont      ([p - pre-content? -] ...) element? nil]
    [racketvarfont     ([p - pre-content? -] ...) element? nil]
    [racketkeywordfont ([p - pre-content? -] ...) element? nil]
    [racketparenfont   ([p - pre-content? -] ...) element? nil]
    [racketmetafont    ([p - pre-content? -] ...) element? nil]
    [racketerror       ([p - pre-content? -] ...) element? nil]
    [racketmodfont     ([p - pre-content? -] ...) element? nil]
    [racketoutputfont  ([p - pre-content? -] ...) element? nil]
    ;; TODO: Define faces for some of the above?

    ;; TODO: We could use overlays to make "@procedure" content have
    ;; "#<procedure:" and ">".
    [procedure         ([p - pre-content? -] ...) element? nil]

    [var  ([p - datum? -] ...) element? nil]
    [svar ([p - datum? -] ...) element? nil]
    
    ;; TODO: Possibly add support for all the "scheme" backword-compatibility
    ;; identifiers.

    ;; TODO: !!! CONTINUE ADDING AFTER
    ;; file:///usr/local/racket-5.0.2/share/racket/doc/scribble/scribble_manual_code.html

    ))

(defconst scribble-bnf-forms
  `([BNF ([p - (cons element? (listof element?)) -] ...) table? nil]

    [nonterm   ([p - pre-content? -] ...) element? scribble-bnf-nonterm-face]
    [BNF-seq   ([p - element?     -] ...) element? nil]
    [BNF-group ([p - pre-content? -] ...) element? nil]

    [optional   ([p - pre-content? -] ...) element? nil]
    [kleenestar ([p - pre-content? -] ...) element? nil]
    [kleeneplus ([p - pre-content? -] ...) element? nil]

    [kleenerange ([p n any/c        -]
                  [p m any/c        -]
                  [p - pre-content? -]
                  ...)
                 element?
                 nil]

    [BNF-alt ([p - element? -] ...) element? nil]
    [BNF-etc ([p - string? -]) void scribble-comment-face]))

(defconst scribble-forms
  `(,@scribble-base-forms
    ,@scribble-manual-forms
    ,@scribble-bnf-forms))

(defconst scribble-name-string-to-form-hash
  (let ((ht (make-hash-table :test 'equal)))
    (mapc (lambda (form)
            (puthash (symbol-name (scribble-get-form-name form)) form ht))
          scribble-forms)
    ht))

(defun scribble-minus-to-nil (x)
  (if (eq x '-) nil x))

(defun scribble-form-type-to-racket (type)
  ;; TODO: translate true, false, rx, quote.  Or convert types to strings.
  (format "%s" type))

;;---------------------------------------------------------------- Syntax Table

(defvar scribble-mode-syntax-table
  (let ((st (make-syntax-table)))
    
    (modify-syntax-entry ?   " " st)
    (modify-syntax-entry ?\t " " st)
    (modify-syntax-entry ?\f " " st)
    (modify-syntax-entry ?\n ">" st)
    
    (modify-syntax-entry ?\" "." st)
    
    (modify-syntax-entry ?\@ "_ 1" st)
    (modify-syntax-entry ?\# "_ 1" st)
    (modify-syntax-entry ?\: "_ 1" st)
    (modify-syntax-entry ?\; ". 2" st)
    
    (modify-syntax-entry ?\( "()" st)
    (modify-syntax-entry ?\) ")(" st)
    (modify-syntax-entry ?\[ "(]" st)
    (modify-syntax-entry ?\] ")[" st)
    (modify-syntax-entry ?\{ "(}" st)
    (modify-syntax-entry ?\} "){" st)
    
    st))

;;------------------------------------------------------------- Forms Reference

;; (defun scribble-forms-reference ()
;;   (interactive)
;;   (scribble-buffer-display
;;    "*Scribble Forms Reference*"
;;    (function
;;     (lambda ()
;;       (mapc (lambda (form)
;;               (insert (scribble-form-quickref-text form) "\n\n"))
;;             scribble-forms)))))

;;------------------------------------------------------------------- Mode Menu

(defvar scribble-mode-menu
  (let ((km (make-sparse-keymap "Scribble")))

    (define-key km [scribble-about]
      '(menu-item "About Scribble Emacs Mode..." scribble-about
                  :help "See information about Scribble Emacs mode"))

    (define-key km [scribble-browse-mode-web]
      '(menu-item "Browse Scribble Emacs Mode Web..." scribble-browse-mode-web
                  :help "Browse Web pages for Scribble Emacs mode"))

    ;; TODO: Browse/search scribble docs.

    (define-key km [scribble-separator-2]
      `(menu-item "--"))

    ;; TODO: Experiment with this.  Use local variable "scribble-modules" to
    ;; specify in files, and update it programmatically from this interface.
    ;; Can also have operation that scans "#lang" and "@(require" to determine
    ;; or update this variable.  Unfortunately can't use "-*-" line because
    ;; Emacs currently (GNU 23.2) doesn't support it occuring after the "#lang"
    ;; line.
    (define-key km [scribble-forms-bnf]
      '(menu-item "scribble/bnf" nil
                  :enable nil
                  :button (:toggle . t)
                  :help "!!!"))
    (define-key km [scribble-forms-manual]
      '(menu-item "scribble/manual" nil
                  :enable nil
                  :button (:toggle . nil)
                  :help "!!!"))
    (define-key km [scribble-forms-base]
      '(menu-item "scribble/base" nil
                  :enable nil
                  :button (:toggle . t)
                  :help "!!!"))

    ;; (define-key km [scribble-forms-reference]
    ;;   '(menu-item "Forms Reference..." scribble-forms-reference
    ;;               :help "Show a reference of Scribble forms"))

    (define-key km [scribble-separator-1]
      `(menu-item "--"))

    (define-key km [scribble-customize]
      '(menu-item "Customize..." scribble-customize
                  :help "Set Emacs customization options for Scribble"))
    ;; TODO: Perhaps wrapping "completion-at-point" with another procedure
    ;; that does "call-interactively" will work.
    ;;
    ;; (define-key km [scribble-completion-at-point]
    ;;   `(menu-item "Completion at Point" 'completion-at-point))

    km))

;;---------------------------------------------------------------------- Keymap

(defvar scribble-mode-map 
  (let ((km (make-sparse-keymap)))
    (define-key km (kbd "M-TAB") 'completion-at-point)
    (define-key km [menu-bar Scribble] (cons "Scribble" scribble-mode-menu))
    km))

;;------------------------------------------------------------------- Font-Lock

;; TODO: Should probably switch to using something other than font-lock, like
;; handwritten fuzzy parser.

(defvar scribble-font-lock-keywords
  `(
     ,@(mapcar (lambda (face-to-namerxs-pair)
                 (let ((face (car face-to-namerxs-pair)))
                   `(,(concat "\\("     ; < 1 at-name
                              "@"
                              (let ((names (cdr face-to-namerxs-pair)))
                                (if (cdr names)
                                    (regexp-opt names)
                                  (car names)))
                              "\\)"       ; > 1 at-name
                              "\\b"
                              "\\(?:"     ; < opt-squares
                              "\\(\\[\\)" ; = 2 open-square
                              "[^]]*"     ;
                              "\\(\\]\\)" ; = 3 close-square
                              "\\)?"      ; > opt-squares
                              "\\(?:"     ; < opt-curlies
                              "\\({\\)"   ; ; = 4 open-curly
                              (if face "\\(" "")
                              "[^}]*"   ;
                              (if face "\\)" "")
                              "\\(}\\)" ; = 5,6 close-curly
                              "\\)?"    ; > opt-curlies
                              )
                     (1 'scribble-at-keyword-face)
                     (2 'scribble-square-bracket-face nil t)
                     (3 'scribble-square-bracket-face nil t)
                     (4 'scribble-curly-brace-face    nil t)
                     ,@(if face
                           `((5 (quote ,face) nil t))
                         '())
                     (,(if face 6 5) 'scribble-curly-brace-face nil t))))
               (let ((face-to-namerxs-alist '()))
                 (mapc (lambda (form)
                         (let* ((namerx (regexp-quote
                                         (symbol-name (scribble-get-form-name
                                                       form))))
                                (face (scribble-get-form-face form))
                                (pair (assq face face-to-namerxs-alist)))
                           (if pair
                               (setcdr pair (cons namerx (cdr pair)))
                             (setq face-to-namerxs-alist
                                   `((,face . (,namerx))
                                     ,@face-to-namerxs-alist)))))
                       scribble-forms)
                 face-to-namerxs-alist))
    
    ("\\(@\\)\\(PLaneT\\)"
     (1 'scribble-at-keyword-face)
     (2 'scribble-planet-face))
    
    ;; TODO: Is this right?
    ;;
    ;; ("\\(@\\)@"
    ;;  (1 'scribble-at-keyword-face))
    
    ("\\(@#reader\\)[ ]+\\([^\r\n]+\\)"
     (1 'scribble-at-keyword-face)
     (2 'scribble-at-keyword-face))
    
    ("\\`\\(#lang\\)[ ]+\\([^\r\n]+\\)"
     (1 'scribble-at-keyword-face)
     (2 'scribble-at-keyword-face))))

(defvar scribble-font-lock-defaults
  `(scribble-font-lock-keywords nil))

;;----------------------------------------------------------------------- Imenu

(defvar scribble-imenu-generic-expression
  '((nil
     "@\\(?:sub\\(?:sub\\)?\\)?section\\(?:\\[[^]]*\\]\\)?{\\([^}]*\\)"
     1)))

;; TODO: Use one of the lower-level ways of doing this.

;;------------------------------------------------------------------ Characters

(defconst scribble-right-arrow-char 8594)

;;-------------------------------------------------------------------- Quickref

;; TODO: !!! this needs work since eldoc was forked out of this.
;; 
;; (defun scribble-form-type-to-quickref (type)
;;   (propertize (scribble-form-type-to-racket type)
;;               'face 'scribble-quickref-type-face))
;; 
;; (defconst scribble-quickref-dotdotdot 
;;   (propertize "..." 'face 'scribble-quickref-meta-face))
;; 
;; (defconst scribble-quickref-space
;;   (propertize " " 'face 'scribble-quickref-default-face))
;; 
;; (defconst scribble-quickref-open-paren
;;   (propertize "(" 'face 'scribble-quickref-literal-face))
;; 
;; (defconst scribble-quickref-close-paren
;;   (propertize ")" 'face 'scribble-quickref-literal-face))
;; 
;; (defconst scribble-quickref-open-optional
;;   (propertize "[" 'face 'scribble-quickref-meta-face))
;; 
;; (defconst scribble-quickref-close-optional
;;   (propertize "]" 'face 'scribble-quickref-meta-face))
;; 
;; (defconst scribble-quickref-space-colon-space
;;   (concat scribble-quickref-space
;;           (propertize ":" 'face 'scribble-quickref-meta-face)
;;           scribble-quickref-space))
;; 
;; (defconst scribble-quickref-space-equal-space
;;   (concat scribble-quickref-space
;;           (propertize "=" 'face 'scribble-quickref-meta-face)
;;           scribble-quickref-space))
;; 
;; (defun scribble-form-arg-to-quickref (arg)
;;   (if (eq arg '...)
;;       scribble-quickref-dotdotdot
;;     (let* ((fmt      '())
;;            (kind     (scribble-get-formarg-kind arg))
;;            (name     (scribble-minus-to-nil
;;                       (scribble-get-formarg-name arg)))
;;            (type     (scribble-get-formarg-type arg))
;;            (default  (scribble-minus-to-nil
;;                       (scribble-get-formarg-default arg)))
;;            (name-str (if name (symbol-name name) nil))
;;            (type-str (scribble-form-type-to-racket type))
;;            (type-ps  (propertize type-str
;;                                  'face 'scribble-quickref-type-face)))
;;       (cond ((eq kind 'p)
;;              (setq fmt
;;                    (if name-str
;;                        `(,type-ps
;;                          ,scribble-quickref-space-colon-space
;;                          ,(propertize name-str 
;;                                       'face
;;                                       'scribble-quickref-arg-face))
;;                      `(,type-ps))))
;;             ((eq kind 'k)
;;              (or name-str
;;                  (error "formarg kind k must have name in %s" arg))
;;              (setq fmt
;;                    `(,type-ps
;;                      ,scribble-quickref-space-colon-space
;;                      ,(propertize (concat "#:" name-str)
;;                                   'face 'scribble-quickref-keyword-face))))
;;             (t (error "invalid formarg kind in %s" arg)))
;;       (apply 'concat
;;              (if default
;;                  (reverse
;;                   `(,(propertize default 'face 'scribble-quickref-value-face)
;;                     ,scribble-quickref-space-equal-space
;;                     ,@fmt))
;;                (reverse fmt))))))
;; 
;; (defun scribble-form-quickref-text (form)
;;   ;; TODO: !!! working on this
;;   (let* ((at (propertize "@" 'face 'scribble-quickref-at-face))
;;          (space-arrow-space
;;           (concat scribble-quickref-space
;;                   (propertize (string scribble-right-arrow-char)
;;                               'face
;;                               'scribble-quickref-meta-face)
;;                   scribble-quickref-space)))
;;   (apply
;;    'concat
;;    `(,at
;;      ,(propertize (symbol-name (scribble-get-form-name form))
;;                   'face 'scribble-quickref-form-name-face)
;;      ,@(let ((args (scribble-get-form-args form)))
;;          (if args
;;              (let ((fmt '()))
;;                (mapc (lambda (arg)
;;                        (setq fmt `(,(scribble-form-arg-to-quickref arg)
;;                                    ,scribble-quickref-space
;;                                    ,@fmt)))
;;                      args)
;;                (reverse fmt))
;;            '()))
;;      ,closeparen-space-arrow-space
;;      ,(scribble-form-type-to-quickref (scribble-get-form-type form))))))

;;------------------------------------------------------------------------ ElDoc

(defconst scribble-eldoc-dotdotdot 
  (propertize "..." 'face 'scribble-eldoc-meta-face))

(defconst scribble-eldoc-space
  (propertize " " 'face 'scribble-eldoc-default-face))

(defconst scribble-eldoc-open-paren
  (propertize "(" 'face 'scribble-eldoc-literal-face))

(defconst scribble-eldoc-close-paren
  (propertize ")" 'face 'scribble-eldoc-literal-face))

(defconst scribble-eldoc-open-optional
  (propertize "[" 'face 'scribble-eldoc-meta-face))

(defconst scribble-eldoc-close-optional
  (propertize "]" 'face 'scribble-eldoc-meta-face))

(defconst scribble-eldoc-closeparen-space-arrow-space
  (concat scribble-eldoc-close-paren
          scribble-eldoc-space
          (propertize (string scribble-right-arrow-char)
                      'face
                      'scribble-eldoc-meta-face)
          scribble-eldoc-space))

(defun scribble-form-arg-to-eldoc (arg)
  (if (eq arg '...)
      scribble-eldoc-dotdotdot
    (let* ((kind     (scribble-get-formarg-kind arg))
           (name     (scribble-minus-to-nil (scribble-get-formarg-name arg)))
           (name-str (if name (symbol-name name) nil))
           (id-ps
            (cond ((eq kind 'p)
                   (propertize (or name-str
                                   (scribble-form-type-to-racket
                                    (scribble-get-formarg-type arg)))
                               'face
                               'scribble-eldoc-nonterminal-face))
                  ((eq kind 'k)
                   (propertize
                    (concat "#:"
                            (or name-str
                                (error "formarg kind k must have name in %s"
                                       arg)))
                    'face 'scribble-eldoc-literal-face))
                  (t (error "invalid formarg kind in %s" arg)))))
      (if (eq '- (scribble-get-formarg-default arg))
          id-ps
        (concat scribble-eldoc-open-optional
                id-ps
                scribble-eldoc-close-optional)))))

(defun scribble-make-form-eldoc-message (form)
  (apply
   'concat
   `(,scribble-eldoc-open-paren
     ,(propertize (symbol-name (scribble-get-form-name form))
                  'face 'scribble-eldoc-literal-face)
     ,@(let ((args (scribble-get-form-args form)))
         (if args
             (let ((fmt '()))
               (mapc (lambda (arg)
                       (setq fmt `(,(scribble-form-arg-to-eldoc arg)
                                   ,scribble-eldoc-space
                                   ,@fmt)))
                     args)
               (reverse fmt))
           '()))
     ,scribble-eldoc-closeparen-space-arrow-space
     ,(propertize (scribble-form-type-to-racket (scribble-get-form-type form))
                  'face
                  'scribble-eldoc-nonterminal-face))))

(defconst scribble-name-to-eldoc-message-hash
  (let ((ht (make-hash-table :test 'equal)))
    (mapc (lambda (form)
            (puthash (symbol-name (scribble-get-form-name form))
                     (scribble-make-form-eldoc-message form)
                     ht))
          scribble-forms)
    ht))

(defun scribble-get-form-eldoc-message (form)
  (scribble-make-form-eldoc-message form))

(defun scribble-eldoc-documentation-function ()
  ;; TODO: Implement this properly, figuring out which form we're in.  Might
  ;; wait until we implement better fontification, using the same parsing
  ;; mechanism.
  ;;
  ;; TODO: !!! Maybe look for "@"-name under point, and if that fails, then
  ;; up-sexp, and then look for an @-name to left of point (or left-sexp if
  ;; there is a square-bracket to left of point.
  (let ((word (let ((c (char-after (point))))
                (and c
                     (memq (char-syntax c) '(?w ?_))
                     (current-word)))))
    (and (> (length word) 0)
         (equal ?@ (aref word 0))
         (gethash (substring word 1)
                  scribble-name-to-eldoc-message-hash
                  nil))))

;;------------------------------------------------------------------ Completion

(defun scribble-build-completion-table ()
  (sort (let ((kw-seen-hash (make-hash-table :test 'eq))
              (result       '("Felleisen")))
          (mapc (lambda (form)
                  (setq result (cons (symbol-name (scribble-get-form-name form))
                                     result))
                  (mapc (lambda (arg)
                          (and (vectorp arg)
                               (eq 'k (scribble-get-formarg-kind arg))
                               (let ((sym (scribble-get-formarg-name arg)))
                                 (or (gethash sym kw-seen-hash)
                                     (progn (puthash sym t kw-seen-hash)
                                            (setq result
                                                  (cons (concat
                                                         "#:"
                                                         (symbol-name sym))
                                                        result)))))))
                        (scribble-get-form-args form)))
                scribble-forms)
          result)
        'string<))

(defconst scribble-completion-table (scribble-build-completion-table))

(defconst scribble-completion-at-point-tail 
  (list scribble-completion-table
        ;; :annotation-function 'scribble-completion-annotate-function
        ))

(defun scribble-completion-at-point-function ()
  (let* ((end (point))
         (start (let ((c (char-before end)))
                  (if (and c (memq (char-syntax c) '(?w ?_)))
                      (save-excursion
                        (backward-sexp 1)
                        (and (eq ?\@ (char-after (point)))
                             (forward-char 1))
                        (point))
                    end))))
    `(,start ,end ,@scribble-completion-at-point-tail)))

;;-------------------------------------------------------------- Buffer Display

(defun scribble-buffer-display (name proc)
  (save-excursion
    (set-buffer (get-buffer-create name))
    (toggle-read-only 0)
    (buffer-disable-undo)
    (goto-char (point-min))
    (delete-region (point-min) (point-max))
    (funcall proc)
    (buffer-enable-undo)
    (set-buffer-modified-p nil)
    (toggle-read-only 1)
    (goto-char (point-min))
    ;; TODO: Maybe make "q" restore window config.
    (local-set-key "q" 'scribble-quit-buffer-display)
    (pop-to-buffer (current-buffer))
    (message "Press \"q\" to quit the \"%s\" buffer." name)))

(defun scribble-quit-buffer-display ()
  (interactive)
  (let ((buf (current-buffer)))
    (condition-case nil
        (delete-window)
      (error nil))
    (kill-buffer buf)))

;;---------------------------------------------------------------- Web Browsing

(defun scribble-browse-mode-web ()
  (interactive)
  (browse-url scribble-mode-web))

;; TODO: Add browsing to Scribble documentation.  First try to find URLs to
;; their existing documentation (based "~/.racket" and on dir of "racket"
;; command).  Fall back to public Web version.

;;----------------------------------------------------------------------- About

(defun scribble-about ()
  (interactive)
  (scribble-buffer-display
   "*About Scribble Mode*"
   (function 
    (lambda ()
      (insert (propertize scribble-mode-title 'face 'bold)
              "\n\n"
              "Version "
              (propertize scribble-mode-version 'face 'bold)
              "\n\n"
              (propertize scribble-mode-web 'face 'bold)
              "\n\n"
              scribble-mode-legal-notices
              "\n")))))

;;--------------------------------------------------------------- Mode Function

;;;###autoload
(defun scribble-mode ()
  "!!! `\[COMMAND]', `\{KEYMAP}', and `\<KEYMAP>'"
  (interactive)

  (kill-all-local-variables)

  (use-local-map scribble-mode-map)

  (set-syntax-table scribble-mode-syntax-table)
  
  (setq fill-column 79)

  ;; Comments:
  (set (make-local-variable 'comment-start)      "@;")
  (set (make-local-variable 'comment-end)        "")
  (set (make-local-variable 'comment-padding)    1)
  (set (make-local-variable 'comment-multi-line) nil)
  (set (make-local-variable 'comment-start-skip)
       "\\(\\(^\\|[^\\\\\n]\\)\\(\\\\\\\\\\)*\\);+ *")

  ;; TODO: comment-indent-function

  ;; TODO: indent-line-function 

  ;; TODO: abbrev

  ;; Font-Lock:
  (set (make-local-variable 'font-lock-defaults) scribble-font-lock-defaults)

  ;; Imenu:
  (set (make-local-variable 'imenu-generic-expression)
       scribble-imenu-generic-expression)
  (set (make-local-variable 'imenu-case-fold-search) nil)
  (imenu-add-to-menubar "Imenu")
  
  ;; ElDoc:
  (set (make-local-variable 'eldoc-documentation-function)
       'scribble-eldoc-documentation-function)
  (turn-on-eldoc-mode)

  ;; Completion:
  (set (make-local-variable 'completion-at-point-functions)
       (list 'scribble-completion-at-point-function))

  ;; Mode Identification:
  (setq mode-name "Scribble")
  (setq major-mode 'scribble-mode)

  ;; Hooks:
  (run-mode-hooks 'scribble-mode-hook))

;;------------------------------------------------------------------- Auto-Mode

;;;###autoload
(mapc (lambda (pair)
        (or (assoc (car pair) auto-mode-alist)
            (push pair auto-mode-alist)))
      '(("\\.scrbl\\'" . scribble-mode)))

;;--------------------------------------------------------------------- Provide

(provide 'scribble)

;;; scribble.el ends here
