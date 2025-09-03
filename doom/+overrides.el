;;;; $DOOMDIR/overrides.el -*- lexical-binding: t; -*-


;;; common lisp

(eval-after-load "lisp-mode"
  '(progn
     (def common-lisp-init-standard-indentation ()
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
                  (def       (4 &lambda &body))
                  (defgeneric  (4 &lambda &body))
                  (define-setf-method   (as defun))
                  (define-setf-expander (as defun))
                  (defmacro     (as defun))
                  (defsubst     (as defun))
                  (deftype      (as defun))
                  (defy         (as defun))
                  (defcommand   (as defun))
                  (defcmd       (as defun))
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
                  (nif         (as if))
                  (if*         common-lisp-indent-if*)
                  (lambda      (&lambda &rest lisp-indent-function-lambda-hack))
                  (λ (as lambda))

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
                  (mvb (as multiple-value-bind))
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

                  ;; misc
                  (defcommand   (as defun))

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
                  (λ     (as lambda))
                  (ω     (as when))
                  (φ     (as progn))
                  (logical-and    (&rest nil))
                  (logical-or     (&rest nil))
                  (land  (as logical-and))
                  (lor   (as logical-or))
                  (∧     (as logical-and))
                  (∨     (as logical-or))
                  (∧¬    (&rest nil))
                  (¬∧    (&rest nil))
                  (∨¬    (&rest nil))
                  (¬∨    (&rest nil))
                  (¬¬    (&rest nil))
                  (negation     (&rest nil))
                  (neg   (as negation))
                  (¬     (as negation)))))
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
         ((lisp-fdefs '("defmacro" "defun" "def" "defcommand"))
          (lisp-vdefs '("defvar"
                        "defv-"
                        "defv"))
          (lisp-kw '("cond" "if" "nif" "while" "let" "let*" "let1" "progn" "prog1"
                     "prog2" "lambda" "unwind-protect" "condition-case"
                     "when" "unless" "with-output-to-string" "special-if" "sif"
                     "ignore-errors" "dotimes" "dolist" "declare"
                     "eval-always"
                     "λ" "ω" "φ"
                     "logical-and" "land" "∧" "∧¬" "¬∧"
                     "logical-or" "lor" "∨" "∨¬" "¬∨"
                     "negation" "neg" "¬" "¬¬"))
          (lisp-errs '("warn" "error" "signal"))
          ;; Elisp constructs.  Now they are update dynamically
          ;; from obarray but they are also used for setting up
          ;; the keywords for Common Lisp.
          (el-fdefs '("defsubst" "cl-defsubst" "define-inline"
                      "define-advice" "defadvice" "defalias"
                      "define-derived-mode" "define-minor-mode"
                      "define-generic-mode" "define-global-minor-mode"
                      "define-globalized-minor-mode" "define-skeleton"
                      "define-widget" "ert-deftest"
                      "defcmd"))
          (el-vdefs '("defconst" "defcustom" "defvaralias" "defvar-local"
                      "defface"))
          (el-tdefs '("defgroup" "deftheme"))
          (el-errs '("user-error"))
          ;; Common-Lisp constructs supported by EIEIO.  FIXME: namespace.
          (eieio-fdefs '("defgeneric" "defmethod" "defg-" "defg" "deft-" "deft"))
          (eieio-tdefs '("defclass" "defc" "defc-"))
          ;; Common-Lisp constructs supported by cl-lib.
          (cl-lib-fdefs '("defmacro" "defsubst" "defun" "defmethod" "defgeneric"
                          "def-" "def" "defm-" "defm" "defg-" "defg" "deft-" "deft" "defcommand" "defcmd"))
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

(put 'defcmd 'lisp-indent-function 'defun)


;;; persp

(when (require 'persp-mode nil 'noerror)
  (cl-defun persp-save-to-file-by-names
      (&optional (fname persp-auto-save-fname) (phash *persp-hash*) names
                 (keep-others t) (called-interactively-p (called-interactively-p 'any)))
    (interactive)
    (unless names
      (setq names
            (persp-read-persp
             "to save" 'reverse (safe-persp-name (get-current-persp))
             t nil nil nil nil 'push)))
    (when (or (not fname) called-interactively-p)
      (setq fname (read-file-name
                   (format "Save a subset of perspectives%s to a file: " names)
                   persp-save-dir)))
    (when names
      (unless keep-others
        (setq keep-others
              (if (and (file-exists-p fname)
                       (yes-or-no-p "Keep other perspectives in the file?"))
                  'yes 'no)))
      (let ((temphash (make-hash-table :test 'equal :size 10))
            (persp-nil-wconf persp-nil-wconf)
            (persp-nil-parameters (copy-tree persp-nil-parameters))
            (persp-nil-hidden persp-nil-hidden)
            bufferlist-diff)
        (when (or (eq keep-others 'yes) (eq keep-others t))
          (let ((bufferlist-pre
                 (mapcar (lambda (b) (cons b (persp--buffer-in-persps b)))
                         (funcall persp-buffer-list-function))))
            (persp-load-state-from-file
             fname temphash (cons :not (regexp-opt names)))
            (setq bufferlist-diff
                  (cl-delete-if (lambda (bcons)
                                  (when bcons
                                    (cl-destructuring-bind (buf . buf-persps) bcons
                                      (when buf
                                        (persp--buffer-in-persps-set buf buf-persps)
                                        t))))
                                (funcall persp-buffer-list-function)
                                :key (lambda (b) (assq b bufferlist-pre))))))
        (mapc (lambda (p)
                (persp-add p temphash)
                (when (and p persp-auto-save-persps-to-their-file)
                  (set-persp-parameter 'persp-file fname p)))
              (mapcar (lambda (pn) (persp-get-by-name pn phash)) names))
        (persp-save-state-to-file fname temphash nil)
        (mapc #'kill-buffer bufferlist-diff)))))


;;; workspaces

(def +workspace/switch-to (index)
  "Switch to a workspace at a given INDEX. A negative number will start from the
end of the workspace list."
  (interactive
   (list (or current-prefix-arg
             (completing-read "Switch to workspace: " (+workspace-list-names)))))
  (when (and (stringp index)
             (string-match-p "^[0-9]+$" index))
    (setq index (string-to-number index)))
  (condition-case-unless-debug ex
      (let ((names (+workspace-list-names)))
        (cond ((numberp index)
               (let ((dest (nth index names)))
                 (unless dest
                   (error "No workspace at #%s" (1+ index)))
                 (+workspace-switch dest)))
              ((stringp index)
               (+workspace-switch index t))
              (t
               (error "Not a valid index: %s" index)))
        (+workspace/display))
    ('error (+workspace-error (cadr ex) t))))


;;; elisp

(let-when-compile
    ((lisp-fdefs '("defmacro" "defun" "def" "defm"))
     (lisp-vdefs '("defvar" "defv"))
     (lisp-kw '("cond" "if" "while" "let" "let*" "progn" "prog1"
                "prog2" "lambda" "unwind-protect" "condition-case"
                "when" "unless" "with-output-to-string" "handler-bind"
                "ignore-errors" "dotimes" "dolist" "declare"))
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
                 "defface" "define-error"))
     (el-tdefs '("defgroup" "deftheme"))
     (el-errs '("user-error"))
     ;; Common-Lisp constructs supported by EIEIO.  FIXME: namespace.
     (eieio-fdefs '("defgeneric" "defmethod"))
     (eieio-tdefs '("defclass"))
     ;; Common-Lisp constructs supported by cl-lib.
     (cl-lib-fdefs '("defmacro" "defsubst" "defun" "defmethod" "defgeneric"))
     (cl-lib-tdefs '("defstruct" "deftype"))
     (cl-lib-errs '("assert" "check-type"))
     ;; Common-Lisp constructs not supported by cl-lib.
     (cl-fdefs '("defsetf" "define-method-combination"
                 "define-condition" "define-setf-expander"
                 ;; "define-function"??
                 "define-compiler-macro" "define-modify-macro"))
     (cl-vdefs '("define-symbol-macro" "defconstant" "defparameter"))
     (cl-tdefs '("defpackage" "defstruct" "deftype"))
     (cl-kw '("block" "break" "case" "ccase" "compiler-let" "ctypecase"
              "declaim" "destructuring-bind" "do" "do*"
              "ecase" "etypecase" "eval-when" "flet" "flet*"
              "go" "handler-case" "in-package" ;; "inline"
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
                  "\\(\\(setf\\)[ \t]+" (rx lisp-mode-symbol)
                  "\\|" (rx lisp-mode-symbol) "\\)?")
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
        (,lisp-mode-autoload-regexp (3 font-lock-warning-face prepend)
                                    (2 font-lock-function-name-face prepend t)))
      "Subdued level highlighting for Emacs Lisp mode.")

    (defconst lisp-cl-font-lock-keywords-1
      `( ;; Definitions.
        (,(concat "(" cl-defs-re "\\_>"
                  ;; Any whitespace and defined object.
                  "[ \t']*"
                  "\\(([ \t']*\\)?" ;; An opening paren.
                  "\\(\\(setf\\)[ \t]+" (rx lisp-mode-symbol)
                  "\\|" (rx lisp-mode-symbol) "\\)?")
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
                   "[ \t']*\\(" (rx lisp-mode-symbol) "\\)?")
          (1 font-lock-keyword-face)
          (2 font-lock-constant-face nil t))
         ;; Words inside \\[], \\<>, \\{} or \\`' tend to be for
         ;; `substitute-command-keys'.
         (,(rx "\\\\" (or (seq "[" (group-n 1 lisp-mode-symbol) "]")
                          (seq "`" (group-n 1
                                     ;; allow multiple words, e.g. "C-x a"
                                     lisp-mode-symbol (* " " lisp-mode-symbol))
                               "'")))
          (1 font-lock-constant-face prepend))
         (,(rx "\\\\" (or (seq "<" (group-n 1 lisp-mode-symbol) ">")
                          (seq "{" (group-n 1 lisp-mode-symbol) "}")))
          (1 font-lock-variable-name-face prepend))
         ;; Ineffective backslashes (typically in need of doubling).
         ("\\(\\\\\\)\\([^\"\\]\\)"
          (1 (elisp--font-lock-backslash) prepend))
         ;; Words inside ‘’, '' and `' tend to be symbol names.
         (,(concat "[`‘']\\(" (rx lisp-mode-symbol) "\\)['’]")
          (1 font-lock-constant-face prepend))
         ;; \\= tends to be an escape in doc strings.
         (,(rx "\\\\=")
          (0 font-lock-builtin-face prepend))
         ;; Constant values.
         (,(lambda (bound) (lisp-mode--search-key ":" bound))
          (0 font-lock-builtin-face))
         ;; ELisp and CLisp `&' keywords as types.
         (,(lambda (bound) (lisp-mode--search-key "&" bound))
          (0 font-lock-type-face))
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
         (lisp--match-hidden-arg
          (0 '(face font-lock-warning-face
               help-echo "Easy to misread; consider moving the element to the next line")
             prepend))
         (lisp--match-confusable-symbol-character
          0 '(face font-lock-warning-face
              help-echo "Confusable character"))
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
                   "[ \t']*\\(" (rx lisp-mode-symbol) "\\)?")
          (1 font-lock-keyword-face)
          (2 font-lock-constant-face nil t))
         ;; Erroneous structures.
         (,(concat "(" cl-errs-re "\\_>")
          (1 font-lock-warning-face))
         ;; Words inside ‘’ and `' tend to be symbol names.
         (,(concat "[`‘]\\(" (rx lisp-mode-symbol) "\\)['’]")
          (1 font-lock-constant-face prepend))
         ;; Uninterned symbols, e.g., (defpackage #:my-package ...)
         ;; must come before keywords below to have effect
         (,(concat "#:" (rx lisp-mode-symbol) "") 0 font-lock-builtin-face)
         ;; Constant values.
         (,(lambda (bound) (lisp-mode--search-key ":" bound))
          (0 font-lock-builtin-face))
         ;; ELisp and CLisp `&' keywords as types.
         (,(lambda (bound) (lisp-mode--search-key "&" bound))
          (0 font-lock-type-face))
         ;; ELisp regexp grouping constructs
         ;; This is too general -- rms.
         ;; A user complained that he has functions whose names start with `do'
         ;; and that they get the wrong color.
         ;; That user has violated the https://www.cliki.net/Naming+conventions:
         ;; CL (but not EL!) `with-' (context) and `do-' (iteration)
         (,(concat "(\\(\\(do-\\|with-\\)" (rx lisp-mode-symbol) "\\)")
          (1 font-lock-keyword-face))
         (lisp--match-hidden-arg
          (0 '(face font-lock-warning-face
               help-echo "Easy to misread; consider moving the element to the next line")
             prepend))
         ))
      "Gaudy level highlighting for Lisp modes.")))

(put 'def 'lisp-indent-function 2)
(put 'defm 'lisp-indent-function 2)
(put 'defv 'lisp-indent-function 2)
(put 'defv  'doc-string-elt 3)


;;; sh-mode

(setq sh-other-keywords
      '((bash sh-append bourne
         "bye" "logout" "select")

        ;; The next entry is only used for defining the others
        (bourne sh-append sh
                "def" "function")

        (csh sh-append shell
             "breaksw" "default" "end" "endif" "endsw" "foreach" "goto"
             "if" "logout" "onintr" "repeat" "switch" "then" "while")

        (es "break" "catch" "exec" "exit" "fn" "for" "forever" "fork" "if"
            "return" "throw" "while")

        (ksh88 sh-append bourne
               "select")

        (rc "break" "case" "exec" "exit" "fn" "for" "if" "in" "return" "switch"
            "while")

        (sh sh-append shell
            "done" "esac" "fi" "for" "in" "return")

        ;; The next entry is only used for defining the others
        (shell "break" "case" "continue" "exec" "exit")

        (zsh sh-append bash
             "select" "foreach")))

(setq sh-builtins
      '((bash sh-append posix
         "." "alias" "bg" "bind" "builtin" "caller" "compgen" "complete"
         "declare" "dirs" "disown" "enable" "fc" "fg" "help" "history"
         "jobs" "kill" "let" "local" "popd" "printf" "pushd" "shopt"
         "source" "suspend" "typeset" "unalias"
         ;; bash4
         "mapfile" "readarray" "coproc")

        ;; The next entry is only used for defining the others
        (bourne sh-append shell
                "eval" "export" "getopts" "newgrp" "pwd" "read" "readonly"
                "times" "ulimit")

        (csh sh-append shell
             "alias" "chdir" "glob" "history" "limit" "nice" "nohup" "rehash"
             "setenv" "source" "time" "unalias" "unhash")

        (dtksh sh-append wksh)

        (es "access" "apids" "cd" "echo" "eval" "false" "let" "limit" "local"
            "newpgrp" "result" "time" "umask" "var" "vars" "wait" "whatis")

        (jsh sh-append sh
             "bg" "fg" "jobs" "kill" "stop" "suspend")

        (jcsh sh-append csh
              "bg" "fg" "jobs" "kill" "notify" "stop" "suspend")

        (ksh88 sh-append bourne
               "alias" "bg" "false" "fc" "fg" "jobs" "kill" "let" "print" "time"
               "typeset" "unalias" "whence")

        (oash sh-append sh
              "checkwin" "dateline" "error" "form" "menu" "newwin" "oadeinit"
              "oaed" "oahelp" "oainit" "pp" "ppfile" "scan" "scrollok" "wattr"
              "wclear" "werase" "win" "wmclose" "wmmessage" "wmopen" "wmove"
              "wmtitle" "wrefresh")

        (pdksh sh-append ksh88
               "bind")

        (posix sh-append sh
               "command")

        (rc "builtin" "cd" "echo" "eval" "limit" "newpgrp" "shift" "umask" "wait"
            "whatis")

        (sh sh-append bourne
            "hash" "test" "type")

        ;; The next entry is only used for defining the others
        (shell "cd" "echo" "eval" "set" "shift" "umask" "unset" "wait")

        (wksh sh-append ksh88)

        (zsh sh-append ksh88
             "autoload" "always"
             "bindkey" "builtin" "chdir" "compctl" "declare" "dirs"
             "disable" "disown" "echotc" "enable" "functions" "getln" "hash"
             "history" "integer" "limit" "local" "log" "popd" "pushd" "r"
             "readonly" "rehash" "sched" "setopt" "source" "suspend" "true"
             "ttyctl" "type" "unfunction" "unhash" "unlimit" "unsetopt" "vared"
             "which")))


;;; browse-url
