;;; cl-lookup-ppcre.el --- View various documentation on Common Lisp

;; Copyright (C) 2004 Yuji 'bmonkey' Minejima <ggb01164@nifty.ne.jp>

;; Author: Yuji Minejima <ggb01164@nifty.ne.jp>
;; $Revision: 1.1 $
;; Keywords: local, lisp

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:



;;; Change Log:



;;; Code:
(require 'cl-lookup)

(defvar cl-lookup-ppcre-root "http://www.weitz.de/cl-ppcre/")

(mapc #'(lambda (entry)
          (destructuring-bind (name path) entry
            (let ((symbol (intern (downcase name) cl-lookup-obarray)))
              (if (boundp symbol)
                  (pushnew path (symbol-value symbol) :test #'equal)
                  (set symbol `(,path))))))
      '(("cl-ppcre" (cl-lookup-ppcre-root ""))
        ("cl-ppcre:create-scanner" (cl-lookup-ppcre-root "#create-scanner"))
        ("cl-ppcre:create-scanner" (cl-lookup-ppcre-root "#create-scanner2"))
        ("cl-ppcre:parse-tree-synonym" (cl-lookup-ppcre-root "#parse-tree-synonym"))
        ("cl-ppcre:define-parse-tree-synonym"
         (cl-lookup-ppcre-root "#define-parse-tree-synonym"))
        ("cl-ppcre:scan" (cl-lookup-ppcre-root "#scan"))
        ("cl-ppcre:scan-to-strings" (cl-lookup-ppcre-root "#scan-to-strings"))
        ("cl-ppcre:register-groups-bind"
         (cl-lookup-ppcre-root "#register-groups-bind"))
        ("cl-ppcre:do-scans" (cl-lookup-ppcre-root "#do-scans"))
        ("cl-ppcre:do-matches" (cl-lookup-ppcre-root "#do-matches"))
        ("cl-ppcre:do-matches-as-strings"
         (cl-lookup-ppcre-root "#do-matches-as-strings"))
        ("cl-ppcre:do-register-groups" (cl-lookup-ppcre-root "#do-register-groups"))
        ("cl-ppcre:all-matches" (cl-lookup-ppcre-root "#all-matches"))
        ("cl-ppcre:all-matches-as-strings"
         (cl-lookup-ppcre-root "#all-matches-as-strings"))
        ("cl-ppcre:split" (cl-lookup-ppcre-root "#split"))
        ("cl-ppcre:regex-replace" (cl-lookup-ppcre-root "#regex-replace"))
        ("cl-ppcre:regex-replace-all" (cl-lookup-ppcre-root "#regex-replace-all"))
        ("cl-ppcre:regex-apropos" (cl-lookup-ppcre-root "#regex-apropos"))
        ("cl-ppcre:regex-apropos-list" (cl-lookup-ppcre-root "#regex-apropos-list"))
        ("cl-ppcre:regex-char-code-limit"
         (cl-lookup-ppcre-root "#regex-char-code-limit"))
        ("cl-ppcre:use-bmh-matchers" (cl-lookup-ppcre-root "#use-bmh-matchers"))
        ("cl-ppcre:*allow-quoting*" (cl-lookup-ppcre-root "#*allow-quoting*"))
        ("cl-ppcre:quote-meta-chars" (cl-lookup-ppcre-root "#quote-meta-chars"))
        ("cl-ppcre:ppcre-error" (cl-lookup-ppcre-root "#ppcre-error"))
        ("cl-ppcre:ppcre-invocation-error"
         (cl-lookup-ppcre-root "#ppcre-invocation-error"))
        ("cl-ppcre:ppcre-syntax-error" (cl-lookup-ppcre-root "#ppcre-syntax-error"))
        ("cl-ppcre:ppcre-syntax-error-string"
         (cl-lookup-ppcre-root "#ppcre-syntax-error-string"))
        ("cl-ppcre:ppcre-syntax-error-pos"
         (cl-lookup-ppcre-root "#ppcre-syntax-error-pos"))
        ))

(provide 'cl-lookup-ppcre)

;;; cl-lookup-ppcre.el ends here
