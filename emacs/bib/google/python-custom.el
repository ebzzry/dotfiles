;; Copyright 2012 Google Inc. All Rights Reserved.
;; Author: domq@google.com (Dominique Quatravaux)
;;
;; Make some of the behavior in python.el overridable in a modular fashion.

(require 'cl)
(require 'advice)

(defvar python-indent-line-functions nil
  "List of supplemental functions to compute the Python indentation at point.

Each of these functions should return nil (meaning \"I don't know how to
indent\"), an integer, or a list of integers (meaning to cycle through these
options upon pressing TAB again).  The functions are tried in turn until one
returns non-nil; if all of them return nil, defer to the original
implementation.")

;; Emacs 23
(defadvice python-calculate-indentation
  (around override-indent-computation activate)
  "Honor the `python-indent-line-functions' variable."
  (let ((custom-indent (some 'funcall python-indent-line-functions)))
    (if custom-indent
        (progn
          (setq python-indent-list (if (listp custom-indent) custom-indent
                                       (list custom-indent)))
          (setq python-indent-list-length (length python-indent-list))
          (setq ad-return-value (car python-indent-list)))
      ad-do-it)))

;; Emacs >= 24.2
(defadvice python-indent-calculate-levels
  (around override-indent-computation activate)
  "Honor the `python-indent-line-functions' variable."
  (let ((custom-indent (some 'funcall python-indent-line-functions)))
    (if custom-indent
        (progn
          (setq python-indent-levels (if (listp custom-indent) custom-indent
                                         (list custom-indent)))
          (setq python-indent-current-level (1- (length python-indent-levels)))
          (setq ad-return-value python-indent-current-level))
      ad-do-it)))

(defadvice python-indent-calculate-indentation
  (around override-indent-computation activate)
  "Honor the `python-indent-line-functions' variable."
  (let ((custom-indent (some 'funcall python-indent-line-functions)))
    (if custom-indent
        (progn
          (setq python-indent-levels (if (listp custom-indent) custom-indent
                                         (list custom-indent)))
          (setq python-indent-current-level (1- (length python-indent-levels)))
          (setq ad-return-value python-indent-current-level))
      ad-do-it)))

(provide 'python-custom)
