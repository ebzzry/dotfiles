;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

(defun make-obsolete (obsolete-name current-name &optional when)
  "Make the byte-compiler warn that function OBSOLETE-NAME is obsolete.
OBSOLETE-NAME should be a function name or macro name (a symbol).

The warning will say that CURRENT-NAME should be used instead.
If CURRENT-NAME is a string, that is the `use instead' message
\(it should end with a period, and not start with a capital).
WHEN should be a string indicating when the function
was first made obsolete, for example a date or a release number."
  (declare (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when) "23.1"))
  (put obsolete-name 'byte-obsolete-info
       ;; The second entry used to hold the `byte-compile' handler, but
       ;; is not used any more nowadays.
       (purecopy (list current-name nil when)))
  obsolete-name)

(defmacro define-obsolete-function-alias (obsolete-name current-name
                                                        &optional when docstring)
  "Set OBSOLETE-NAME's function definition to CURRENT-NAME and mark it obsolete.

\(define-obsolete-function-alias \\='old-fun \\='new-fun \"22.1\" \"old-fun's doc.\")

is equivalent to the following two lines of code:

\(defalias \\='old-fun \\='new-fun \"old-fun's doc.\")
\(make-obsolete \\='old-fun \\='new-fun \"22.1\")

WHEN should be a string indicating when the function was first
made obsolete, for example a date or a release number.

See the docstrings of `defalias' and `make-obsolete' for more details."
  (declare (doc-string 4)
           (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional docstring) "23.1"))
  `(progn
     (defalias ,obsolete-name ,current-name ,docstring)
     (make-obsolete ,obsolete-name ,current-name ,when)))

(defun make-obsolete-variable (obsolete-name current-name &optional when access-type)
  "Make the byte-compiler warn that OBSOLETE-NAME is obsolete.
The warning will say that CURRENT-NAME should be used instead.
If CURRENT-NAME is a string, that is the `use instead' message.
WHEN should be a string indicating when the variable
was first made obsolete, for example a date or a release number.
ACCESS-TYPE if non-nil should specify the kind of access that will trigger
  obsolescence warnings; it can be either `get' or `set'."
  (declare (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional access-type) "23.1"))
  (put obsolete-name 'byte-obsolete-variable
       (purecopy (list current-name access-type when)))
  obsolete-name)

(defmacro define-obsolete-variable-alias (obsolete-name current-name
						        &optional when docstring)
  "Make OBSOLETE-NAME a variable alias for CURRENT-NAME and mark it obsolete.
This uses `defvaralias' and `make-obsolete-variable' (which see).
See the Info node `(elisp)Variable Aliases' for more details.

If CURRENT-NAME is a defcustom or a defvar (more generally, any variable
where OBSOLETE-NAME may be set, e.g. in an init file, before the
alias is defined), then the define-obsolete-variable-alias
statement should be evaluated before the defcustom, if user
customizations are to be respected.  The simplest way to achieve
this is to place the alias statement before the defcustom (this
is not necessary for aliases that are autoloaded, or in files
dumped with Emacs).  This is so that any user customizations are
applied before the defcustom tries to initialize the
variable (this is due to the way `defvaralias' works).

WHEN should be a string indicating when the variable was first
made obsolete, for example a date or a release number.

For the benefit of Customize, if OBSOLETE-NAME has
any of the following properties, they are copied to
CURRENT-NAME, if it does not already have them:
`saved-value', `saved-variable-comment'."
  (declare (doc-string 4)
           (advertised-calling-convention
            ;; New code should always provide the `when' argument.
            (obsolete-name current-name when &optional docstring) "23.1"))
  `(progn
     (defvaralias ,obsolete-name ,current-name ,docstring)
     ;; See Bug#4706.
     (dolist (prop '(saved-value saved-variable-comment))
       (and (get ,obsolete-name prop)
            (null (get ,current-name prop))
            (put ,current-name prop (get ,obsolete-name prop))))
     (make-obsolete-variable ,obsolete-name ,current-name ,when)))

(eval-after-load "lisp-mode"
  '(progn
     (defun common-lisp-init-standard-indentation ()
       (let ((l '((block 1)
                  (case        (4 &rest (&whole 2 &rest 1)))
                  (ccase       (as case))
                  (ecase       (as case))
                  (typecase    (as case))
                  (etypecase   (as case))
                  (ctypecase   (as case))
                  (catch 1)
                  (cond        (&rest (&whole 2 &rest nil)))
                  ;; for DEFSTRUCT
                  (:constructor (4 &lambda))
                  (defvar      (4 2 2))
                  (defclass    (6 (&whole 4 &rest 1)
                                  (&whole 2 &rest 1)
                                  (&whole 2 &rest 1)))
                  (defconstant (as defvar))
                  (defcustom   (4 2 2 2))
                  (defparameter     (as defvar))
                  (defconst         (as defcustom))
                  (define-condition (as defclass))
                  (defn (as defclass))
                  (defn- (as defclass))
                  (define-modify-macro (4 &lambda &body))
                  (defsetf      lisp-indent-defsetf)
                  (defun       (4 &lambda &body))
                  (defgeneric  (4 &lambda &body))
                  (define-setf-method   (as defun))
                  (define-setf-expander (as defun))
                  (defmacro     (as defun))
                  (defsubst     (as defun))
                  (deftype      (as defun))
                  (defy         (as defun))
                  (defcommand   (as defun))
                  (defmethod   lisp-indent-defmethod)
                  (defpackage  (4 2))
                  (defstruct   ((&whole 4 &rest (&whole 2 &rest 1))
                                &rest (&whole 2 &rest 1)))
                  (destructuring-bind (&lambda 4 &body))
                  (do          lisp-indent-do)
                  (do*         (as do))
                  (dolist      ((&whole 4 2 1) &body))
                  (dotimes     (as dolist))
                  (eval-when   1)
                  (flet        ((&whole 4 &rest (&whole 1 4 &lambda &body)) &body))
                  (labels         (as flet))
                  (macrolet       (as flet))
                  (generic-flet   (as flet))
                  (generic-labels (as flet))
                  (handler-case (4 &rest (&whole 2 &lambda &body)))
                  (restart-case (as handler-case))
                  ;; single-else style (then and else equally indented)
                  (if          (&rest nil))
                  (if*         common-lisp-indent-if*)
                  (lambda      (&lambda &rest lisp-indent-function-lambda-hack))

                  (let         ((&whole 4 &rest (&whole 1 1 2)) &body))
                  (let*         (as let))
                  (let1         (as let))
                  (compiler-let (as let))
                  (handler-bind (as let))
                  (restart-bind (as let))
                  (locally 1)
                  (loop           lisp-indent-loop)
                  (:method        lisp-indent-defmethod) ; in `defgeneric'
                  (multiple-value-bind ((&whole 6 &rest 1) 4 &body))
                  (multiple-value-call (4 &body))
                  (multiple-value-prog1 1)
                  (multiple-value-setq (4 2))
                  (multiple-value-setf (as multiple-value-setq))
                  (named-lambda (4 &lambda &rest lisp-indent-function-lambda-hack))
                  (pprint-logical-block (4 2))
                  (print-unreadable-object ((&whole 4 1 &rest 1) &body))
                  ;; Combines the worst features of BLOCK, LET and TAGBODY
                  (prog        (&lambda &rest lisp-indent-tagbody))
                  (prog* (as prog))
                  (prog1 1)
                  (prog2 2)
                  (progn 0)
                  (progv (4 4 &body))
                  (return 0)
                  (return-from (nil &body))
                  (symbol-macrolet (as let))
                  (tagbody lisp-indent-tagbody)
                  (throw 1)
                  (unless 1)
                  (unwind-protect (5 &body))
                  (when 1)
                  (special-if (as when))
                  (sif (as when))
                  (with-accessors          (as multiple-value-bind))
                  (with-compilation-unit   ((&whole 4 &rest 1) &body))
                  (with-condition-restarts (as multiple-value-bind))
                  (with-output-to-string (4 2))
                  (with-slots            (as multiple-value-bind))
                  (with-standard-io-syntax (2))

                  (eval-always (as progn))
                  (when-let    (as let))
                  (when-let*   (as let))
                  (flet*       (as labels))

                  ;; marie/definitions
                  (def   (as defun))
                  (def-  (as defun))
                  (defm  (as defun))
                  (defm- (as defun))
                  (defv  (as defvar))
                  (defv- (as defvar))
                  (defp  (as defvar))
                  (defp- (as defvar))
                  (defk  (as defvar))
                  (defk- (as defvar))
                  (defc  (as defclass))
                  (defc- (as defclass))
                  (defg  (as defgeneric))
                  (defg- (as defgeneric))
                  (deft  (as defmethod))
                  (deft- (as defmethod))
                  (defmm (as define-modify-macro))
                  (defmm- (as define-modify-macro))
                  ;; marie kw
                  (λ           (as lambda))
                  (logical-and (&rest nil))
                  (logical-or  (&rest nil))
                  (land        (as logical-and))
                  (lor         (as logical-or))
                  (∧           (as logical-and))
                  (∨           (as logical-or))
                  (negation    (&rest nil))
                  (neg         (as negation))
                  (¬           (as negation)))))
         (dolist (el l)
           (let* ((name (car el))
                  (spec (cdr el))
                  (indentation
                   (if (symbolp spec)
                       (error "Old style indirect indentation spec: %s" el)
                     (when (cdr spec)
                       (error "Malformed indentation specification: %s" el))
                     (car spec))))
             (unless (symbolp name)
               (error "Cannot set Common Lisp indentation of a non-symbol: %s"
                      name))
             (put name 'common-lisp-indent-function indentation)))))
     (common-lisp-init-standard-indentation)

     (let-when-compile
         ((lisp-fdefs '("defmacro" "defun"))
          (lisp-vdefs '("defvar"
                        "defv-"
                        "defv"))
          (lisp-kw '("cond" "if" "while" "let" "let*" "let1" "progn" "prog1"
                     "prog2" "lambda" "unwind-protect" "condition-case"
                     "when" "unless" "with-output-to-string" "special-if" "sif"
                     "ignore-errors" "dotimes" "dolist" "declare"
                     "λ" "eval-always"
                     "logical-and" "land" "∧"
                     "logical-or" "lor" "∨"
                     "negation" "neg" "¬"))
          (lisp-errs '("warn" "error" "signal"))
          ;; Elisp constructs.  Now they are update dynamically
          ;; from obarray but they are also used for setting up
          ;; the keywords for Common Lisp.
          (el-fdefs '("defsubst" "cl-defsubst" "define-inline"
                      "define-advice" "defadvice" "defalias"
                      "define-derived-mode" "define-minor-mode"
                      "define-generic-mode" "define-global-minor-mode"
                      "define-globalized-minor-mode" "define-skeleton"
                      "define-widget" "ert-deftest"))
          (el-vdefs '("defconst" "defcustom" "defvaralias" "defvar-local"
                      "defface"))
          (el-tdefs '("defgroup" "deftheme"))
          (el-errs '("user-error"))
          ;; Common-Lisp constructs supported by EIEIO.  FIXME: namespace.
          (eieio-fdefs '("defgeneric" "defmethod" "defg-" "defg" "deft-" "deft"))
          (eieio-tdefs '("defclass" "defc" "defc-"))
          ;; Common-Lisp constructs supported by cl-lib.
          (cl-lib-fdefs '("defmacro" "defsubst" "defun" "defmethod" "defgeneric"
                          "def-" "def" "defm-" "defm" "defg-" "defg" "deft-" "deft" "defcommand"))
          (cl-lib-tdefs '("defstruct" "deftype" "defy"))
          (cl-lib-errs '("assert" "check-type"))
          ;; Common-Lisp constructs not supported by cl-lib.
          (cl-fdefs '("defsetf" "define-method-combination"
                      "define-condition" "defn" "defn-" "define-setf-expander"
                      ;; "define-function"??
                      "define-compiler-macro" "define-modify-macro" "defmm" "defmm-"))
          (cl-vdefs '("define-symbol-macro" "defsm" "defsm-" "defconstant" "defparameter"
                      "defk-" "defk" "defv-" "defv" "defp-" "defp"))
          (cl-tdefs '("defpackage" "defstruct" "deftype" "defy"))
          (cl-kw '("block" "break" "case" "ccase" "compiler-let" "ctypecase"
                   "declaim" "destructuring-bind" "do" "do*"
                   "ecase" "etypecase" "eval-when" "flet"
                   "flet*"
                   "go" "handler-case" "handler-bind" "in-package" ;; "inline"
                   "labels" "letf" "locally" "loop"
                   "macrolet" "multiple-value-bind" "multiple-value-prog1"
                   "proclaim" "prog" "prog*" "progv"
                   "restart-case" "restart-bind" "return" "return-from"
                   "symbol-macrolet" "tagbody" "the" "typecase"
                   "with-accessors" "with-compilation-unit"
                   "with-condition-restarts" "with-hash-table-iterator"
                   "with-input-from-string" "with-open-file"
                   "with-open-stream" "with-package-iterator"
                   "with-simple-restart" "with-slots" "with-standard-io-syntax"))
          (cl-errs '("abort" "cerror")))
       (let ((vdefs (eval-when-compile
                      (append lisp-vdefs el-vdefs cl-vdefs)))
             (tdefs (eval-when-compile
                      (append el-tdefs eieio-tdefs cl-tdefs cl-lib-tdefs
                              (mapcar (lambda (s) (concat "cl-" s)) cl-lib-tdefs))))
             ;; Elisp and Common Lisp definers.
             (el-defs-re (eval-when-compile
                           (regexp-opt (append lisp-fdefs lisp-vdefs
                                               el-fdefs el-vdefs el-tdefs
                                               (mapcar (lambda (s) (concat "cl-" s))
                                                       (append cl-lib-fdefs cl-lib-tdefs))
                                               eieio-fdefs eieio-tdefs)
                                       t)))
             (cl-defs-re (eval-when-compile
                           (regexp-opt (append lisp-fdefs lisp-vdefs
                                               cl-lib-fdefs cl-lib-tdefs
                                               eieio-fdefs eieio-tdefs
                                               cl-fdefs cl-vdefs cl-tdefs)
                                       t)))
             ;; Common Lisp keywords (Elisp keywords are handled dynamically).
             (cl-kws-re (eval-when-compile
                          (regexp-opt (append lisp-kw cl-kw) t)))
             ;; Elisp and Common Lisp "errors".
             (el-errs-re (eval-when-compile
                           (regexp-opt (append (mapcar (lambda (s) (concat "cl-" s))
                                                       cl-lib-errs)
                                               lisp-errs el-errs)
                                       t)))
             (cl-errs-re (eval-when-compile
                           (regexp-opt (append lisp-errs cl-lib-errs cl-errs) t))))
         (dolist (v vdefs)
           (put (intern v) 'lisp-define-type 'var))
         (dolist (v tdefs)
           (put (intern v) 'lisp-define-type 'type))

         (define-obsolete-variable-alias 'lisp-font-lock-keywords-1
           'lisp-el-font-lock-keywords-1 "24.4")
         (defconst lisp-el-font-lock-keywords-1
           `( ;; Definitions.
             (,(concat "(" el-defs-re "\\_>"
                       ;; Any whitespace and defined object.
                       "[ \t']*"
                       "\\(([ \t']*\\)?" ;; An opening paren.
                       "\\(\\(setf\\)[ \t]+" lisp-mode-symbol-regexp
                       "\\|" lisp-mode-symbol-regexp "\\)?")
              (1 font-lock-keyword-face)
              (3 (let ((type (get (intern-soft (match-string 1)) 'lisp-define-type)))
                   (cond ((eq type 'var) font-lock-variable-name-face)
                         ((eq type 'type) font-lock-type-face)
                         ;; If match-string 2 is non-nil, we encountered a
                         ;; form like (defalias (intern (concat s "-p"))),
                         ;; unless match-string 4 is also there.  Then its a
                         ;; defmethod with (setf foo) as name.
                         ((or (not (match-string 2)) ;; Normal defun.
                              (and (match-string 2)  ;; Setf method.
                                   (match-string 4)))
                          font-lock-function-name-face)))
                 nil t))
             ;; Emacs Lisp autoload cookies.  Supports the slightly different
             ;; forms used by mh-e, calendar, etc.
             ("^;;;###\\([-a-z]*autoload\\)" 1 font-lock-warning-face prepend))
           "Subdued level highlighting for Emacs Lisp mode.")

         (defconst lisp-cl-font-lock-keywords-1
           `( ;; Definitions.
             (,(concat "(" cl-defs-re "\\_>"
                       ;; Any whitespace and defined object.
                       "[ \t']*"
                       ;;"[ \t']*\\|([ \t'])*"
                       "\\(([ \t']*\\)?" ;; An opening paren.
                       "\\(\\(setf\\)[ \t]+" lisp-mode-symbol-regexp
                       "\\|" lisp-mode-symbol-regexp "\\)?")
              (1 font-lock-keyword-face)
              (3 (let ((type (get (intern-soft (match-string 1)) 'lisp-define-type)))
                   (cond ((eq type 'var) font-lock-variable-name-face)
                         ((eq type 'type) font-lock-type-face)
                         ((or (not (match-string 2)) ;; Normal defun.
                              (and (match-string 2)  ;; Setf function.
                                   (match-string 4)))
                          font-lock-function-name-face)))
                 nil t)))
           "Subdued level highlighting for Lisp modes.")

         (define-obsolete-variable-alias 'lisp-font-lock-keywords-2
           'lisp-el-font-lock-keywords-2 "24.4")
         (defconst lisp-el-font-lock-keywords-2
           (append
            lisp-el-font-lock-keywords-1
            `( ;; Regexp negated char group.
              ("\\[\\(\\^\\)" 1 font-lock-negation-char-face prepend)
              ;; Erroneous structures.
              (,(concat "(" el-errs-re "\\_>")
               (1 font-lock-warning-face))
              ;; Control structures.  Common Lisp forms.
              (lisp--el-match-keyword . 1)
              ;; Exit/Feature symbols as constants.
              (,(concat "(\\(catch\\|throw\\|featurep\\|provide\\|require\\)\\_>"
                        "[ \t']*\\(" lisp-mode-symbol-regexp "\\)?")
               (1 font-lock-keyword-face)
               (2 font-lock-constant-face nil t))
              ;; Words inside \\[] tend to be for `substitute-command-keys'.
              (,(concat "\\\\\\\\\\[\\(" lisp-mode-symbol-regexp "\\)\\]")
               (1 font-lock-constant-face prepend))
              ;; Ineffective backslashes (typically in need of doubling).
              ("\\(\\\\\\)\\([^\"\\]\\)"
               (1 (elisp--font-lock-backslash) prepend))
              ;; Words inside ‘’ and `' tend to be symbol names.
              (,(concat "[`‘]\\(\\(?:\\sw\\|\\s_\\|\\\\.\\)"
                        lisp-mode-symbol-regexp "\\)['’]")
               (1 font-lock-constant-face prepend))
              ;; Constant values.
              (,(concat "\\_<:" lisp-mode-symbol-regexp "\\_>")
               (0 font-lock-builtin-face))
              ;; ELisp and CLisp `&' keywords as types.
              (,(concat "\\_<\\&" lisp-mode-symbol-regexp "\\_>")
               . font-lock-type-face)
              ;; ELisp regexp grouping constructs
              (,(lambda (bound)
                  (catch 'found
                    ;; The following loop is needed to continue searching after matches
                    ;; that do not occur in strings.  The associated regexp matches one
                    ;; of `\\\\' `\\(' `\\(?:' `\\|' `\\)'.  `\\\\' has been included to
                    ;; avoid highlighting, for example, `\\(' in `\\\\('.
                    (while (re-search-forward "\\(\\\\\\\\\\)\\(?:\\(\\\\\\\\\\)\\|\\((\\(?:\\?[0-9]*:\\)?\\|[|)]\\)\\)" bound t)
                      (unless (match-beginning 2)
                        (let ((face (get-text-property (1- (point)) 'face)))
                          (when (or (and (listp face)
                                         (memq 'font-lock-string-face face))
                                    (eq 'font-lock-string-face face))
                            (throw 'found t)))))))
               (1 'font-lock-regexp-grouping-backslash prepend)
               (3 'font-lock-regexp-grouping-construct prepend))
              ;; This is too general -- rms.
              ;; A user complained that he has functions whose names start with `do'
              ;; and that they get the wrong color.
              ;; ;; CL `with-' and `do-' constructs
              ;;("(\\(\\(do-\\|with-\\)\\(\\s_\\|\\w\\)*\\)" 1 font-lock-keyword-face)
              (lisp--match-hidden-arg
               (0 '(face font-lock-warning-face
                    help-echo "Hidden behind deeper element; move to another line?")))
              ))
           "Gaudy level highlighting for Emacs Lisp mode.")

         (defconst lisp-cl-font-lock-keywords-2
           (append
            lisp-cl-font-lock-keywords-1
            `( ;; Regexp negated char group.
              ("\\[\\(\\^\\)" 1 font-lock-negation-char-face prepend)
              ;; Control structures.  Common Lisp forms.
              (,(concat "(" cl-kws-re "\\_>") . 1)
              ;; Exit/Feature symbols as constants.
              (,(concat "(\\(catch\\|throw\\|provide\\|require\\)\\_>"
                        "[ \t']*\\(" lisp-mode-symbol-regexp "\\)?")
               (1 font-lock-keyword-face)
               (2 font-lock-constant-face nil t))
              ;; Erroneous structures.
              (,(concat "(" cl-errs-re "\\_>")
               (1 font-lock-warning-face))
              ;; Words inside ‘’ and `' tend to be symbol names.
              (,(concat "[`‘]\\(\\(?:\\sw\\|\\s_\\|\\\\.\\)"
                        lisp-mode-symbol-regexp "\\)['’]")
               (1 font-lock-constant-face prepend))
              ;; Constant values.
              (,(concat "\\_<:" lisp-mode-symbol-regexp "\\_>")
               (0 font-lock-builtin-face))
              ;; ELisp and CLisp `&' keywords as types.
              (,(concat "\\_<\\&" lisp-mode-symbol-regexp "\\_>")
               . font-lock-type-face)
              ;; This is too general -- rms.
              ;; A user complained that he has functions whose names start with `do'
              ;; and that they get the wrong color.
              ;; ;; CL `with-' and `do-' constructs
              ;;("(\\(\\(do-\\|with-\\)\\(\\s_\\|\\w\\)*\\)" 1 font-lock-keyword-face)
              (lisp--match-hidden-arg
               (0 '(face font-lock-warning-face
                    help-echo "Hidden behind deeper element; move to another line?")))
              ))
           "Gaudy level highlighting for Lisp modes.")))))
