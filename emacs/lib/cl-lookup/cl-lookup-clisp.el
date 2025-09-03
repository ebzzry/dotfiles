;;; cl-lookup-clisp.el --- View various documentation on Common Lisp

;; Copyright (C) 2004 Yuji 'bmonkey' Minejima <ggb01164@nifty.ne.jp>

;; Author: Yuji Minejima <ggb01164@nifty.ne.jp>
;; $Revision: 1.2 $
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

(defvar cl-lookup-clisp-root "http://clisp.cons.org/")

(mapc #'(lambda (entry)
          (destructuring-bind (name path) entry
            (let ((symbol (intern (downcase name) cl-lookup-obarray)))
              (if (boundp symbol)
                  (pushnew path (symbol-value symbol) :test #'equal)
                  (set symbol `(,path))))))
      '(("ext:cd" (cl-lookup-clisp-root "impnotes.html#cd"))
        ("ext:fcase" (cl-lookup-clisp-root "impnotes.html#fcase"))
        ("ext:xor" (cl-lookup-clisp-root "impnotes.html#xor"))
        ("ext:symbol-macro-expand" (cl-lookup-clisp-root "impnotes.html#symbol-mex"))
        ("ext:muffle-cerrors" (cl-lookup-clisp-root "impnotes.html#muffle-cerrors"))
        ("ext:appease-cerrors"
         (cl-lookup-clisp-root "impnotes.html#appease-cerrors"))
        ("ext:exit-on-error" (cl-lookup-clisp-root "impnotes.html#exit-on-error"))
        ("ext:with-restarts" (cl-lookup-clisp-root "impnotes.html#with-restarts"))
        ("ext:without-package-lock"
         (cl-lookup-clisp-root "impnotes.html#without-pack-lock"))
        ("ext:re-export" (cl-lookup-clisp-root "impnotes.html#re-export"))
        ("ext:without-floating-point-underflow"
         (cl-lookup-clisp-root "impnotes.html#no-underflow"))
        ("ext:!" (cl-lookup-clisp-root "impnotes.html#int-func-ext"))
        ("ext:exquo" (cl-lookup-clisp-root "impnotes.html#int-func-ext"))
        ("ext:xgcd" (cl-lookup-clisp-root "impnotes.html#int-func-ext"))
        ("ext:char-font-limit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-bits-limit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-control-bit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-meta-bit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-super-bit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-hyper-bit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-font" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-bits" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:make-char" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-bit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:set-char-bit" (cl-lookup-clisp-root "impnotes.html#bit-table"))
        ("ext:char-width" (cl-lookup-clisp-root "impnotes.html#char-width"))
        ("ext:mapcap" (cl-lookup-clisp-root "impnotes.html#mapcap"))
        ("ext:maplap" (cl-lookup-clisp-root "impnotes.html#maplap"))
        ("ext:string-width" (cl-lookup-clisp-root "impnotes.html#string-width"))
        ("ext:doseq" (cl-lookup-clisp-root "impnotes.html#doseq"))
        ("ext:define-hash-table-test" (cl-lookup-clisp-root "impnotes.html#defhash"))
        ("ext:dohash" (cl-lookup-clisp-root "impnotes.html#dohash"))
        ("ext:the-environment" (cl-lookup-clisp-root "impnotes.html#the-env"))
        ("ext:eval-env" (cl-lookup-clisp-root "impnotes.html#eval-env"))
        ("ext:special-variable-p" (cl-lookup-clisp-root "impnotes.html#spe-var-p"))
        ("ext:package-lock" (cl-lookup-clisp-root "impnotes.html#pack-lock-f"))
        ("ext:string-width" (cl-lookup-clisp-root "impnotes.html#string-width"))
        ("ext:probe-directory" (cl-lookup-clisp-root "impnotes.html#probe-dir"))
        ("ext:make-stream" (cl-lookup-clisp-root "impnotes.html#make-stream"))
        ("ext:read-byte-sequence" (cl-lookup-clisp-root "impnotes.html#rd-by-seq"))
        ("ext:read-char-sequence" (cl-lookup-clisp-root "impnotes.html#rd-ch-seq"))
        ("ext:write-byte-sequence" (cl-lookup-clisp-root "impnotes.html#wr-by-seq"))
        ("ext:write-char-sequence" (cl-lookup-clisp-root "impnotes.html#wr-ch-seq"))
        ("ext:read-char-will-hang-p" (cl-lookup-clisp-root "impnotes.html#rcwhp"))
        ("ext:read-byte-lookahead" (cl-lookup-clisp-root "impnotes.html#rbla"))
        ("ext:read-byte-will-hang-p" (cl-lookup-clisp-root "impnotes.html#rbwhp"))
        ("ext:read-byte-no-hang" (cl-lookup-clisp-root "impnotes.html#rbnh"))
        ("ext:make-buffered-input-stream"
         (cl-lookup-clisp-root "impnotes.html#stream-buffer"))
        ("ext:make-buffered-output-stream"
         (cl-lookup-clisp-root "impnotes.html#stream-buffer"))
        ("ext:uncompile" (cl-lookup-clisp-root "impnotes.html#uncompile"))
        ("ext:clhs" (cl-lookup-clisp-root "impnotes.html#browser"))
        ("ext:*trace-values*" (cl-lookup-clisp-root "impnotes.html#trace-val"))
        ("ext:gc" (cl-lookup-clisp-root "impnotes.html#gc-func"))
        ("ext:dribble-stream" (cl-lookup-clisp-root "impnotes.html#drist"))
        ("ext:dribble-stream-p" (cl-lookup-clisp-root "impnotes.html#drist-p"))
        ("ext:dribble-stream-source" (cl-lookup-clisp-root "impnotes.html#drist-so"))
        ("ext:dribble-stream-target" (cl-lookup-clisp-root "impnotes.html#drist-ta"))
        ("ext:make-dribble-stream" (cl-lookup-clisp-root "impnotes.html#mk-drist"))
        ("ext:dribble-toggle" (cl-lookup-clisp-root "impnotes.html#dri-toggle"))
        ("ext:ARGV" (cl-lookup-clisp-root "impnotes.html#argv"))
        ("ext:saveinitmem" (cl-lookup-clisp-root "impnotes.html#image"))
        ("ext:exit" (cl-lookup-clisp-root "impnotes.html#quit"))
        ("ext:make-encoding" (cl-lookup-clisp-root "impnotes.html#make-encoding"))
        ("ext:encoding-charset" (cl-lookup-clisp-root "impnotes.html#enc-charset"))
        ("ext:*default-file-encoding*"
         (cl-lookup-clisp-root "impnotes.html#def-file-enc"))
        ("ext:finalize" (cl-lookup-clisp-root "impnotes.html#final"))
        ("ext:break-level" (cl-lookup-clisp-root "impnotes.html#break-level"))
        ("ext:step-level" (cl-lookup-clisp-root "impnotes.html#step-level"))
        ("ext:prompt-new-package"
         (cl-lookup-clisp-root "impnotes.html#prompt-new-package"))
        ("ext:package-short-name"
         (cl-lookup-clisp-root "impnotes.html#package-short-name"))
        ("ext:*command-index*" (cl-lookup-clisp-root "impnotes.html#command-index"))
        ("ext:ethe" (cl-lookup-clisp-root "impnotes.html#ethe"))
        ("ext:letf" (cl-lookup-clisp-root "impnotes.html#letf"))
        ("ext:letf*" (cl-lookup-clisp-root "impnotes.html#letf"))
        ("ext:with-collect" (cl-lookup-clisp-root "impnotes.html#with-collect"))
        ("ext:with-gensyms" (cl-lookup-clisp-root "impnotes.html#with-gensyms"))
        ("ext:remove-plist" (cl-lookup-clisp-root "impnotes.html#remove-plist"))
        ("ext:with-html-output"
         (cl-lookup-clisp-root "impnotes.html#html-http-output"))
        ("ext:with-http-output"
         (cl-lookup-clisp-root "impnotes.html#html-http-output"))
        ("ext:expand-form" (cl-lookup-clisp-root "impnotes.html#code-walk"))
        ("ext:module-info" (cl-lookup-clisp-root "impnotes.html#modinfo"))

        ("custom:*suppress-check-redefinition*"
         (cl-lookup-clisp-root "impnotes.html#suppress-check-redef"))
        ("custom:*warn-on-floating-point-contagion*"
         (cl-lookup-clisp-root "impnotes.html#warn-fpc"))
        ("custom:*default-float-format*"
         (cl-lookup-clisp-root "impnotes.html#default-float-format"))
        ("custom:*sequence-count-ansi*"
         (cl-lookup-clisp-root "impnotes.html#count-ansi"))
        ("custom:*coerce-fixnum-char-ansi*"
         (cl-lookup-clisp-root "impnotes.html#fixnum-char-ansi"))
        ("custom:*parse-namestring-ansi*"
         (cl-lookup-clisp-root "impnotes.html#path-des"))
        ("custom:*print-closure*" (cl-lookup-clisp-root "impnotes.html#pr-closure"))
        ("custom:*print-rpars*" (cl-lookup-clisp-root "impnotes.html#pr-rpars"))
        ("custom:*print-indent-lists*"
         (cl-lookup-clisp-root "impnotes.html#pr-indent"))
        ("custom:*pprint-first-newline*"
         (cl-lookup-clisp-root "impnotes.html#ppr-first-newline"))
        ("custom:*load-paths*" (cl-lookup-clisp-root "impnotes.html#load-paths"))
        ("custom:*trace-indent*" (cl-lookup-clisp-root "impnotes.html#trace-indent"))
        ("custom:*default-time-zone*"
         (cl-lookup-clisp-root "impnotes.html#default-tz"))
        ("custom:*default-file-encoding*"
         (cl-lookup-clisp-root "impnotes.html#def-file-enc"))
        ("custom:*pathname-encoding*"
         (cl-lookup-clisp-root "impnotes.html#path-enc"))
        ("custom:*terminal-encoding*"
         (cl-lookup-clisp-root "impnotes.html#term-enc"))
        ("custom:*misc-encoding*"
         (cl-lookup-clisp-root "impnotes.html#misc-enc"))
        ("custom:*foreign-encoding*"
         (cl-lookup-clisp-root "impnotes.html#foreign-enc"))
        ("custom:*prompt-start*" (cl-lookup-clisp-root "impnotes.html#prompt-start"))
        ("custom:*prompt-break*" (cl-lookup-clisp-root "impnotes.html#prompt-break"))
        ("custom:*prompt-body*" (cl-lookup-clisp-root "impnotes.html#prompt-body"))
        ("custom:*prompt-finish*"
         (cl-lookup-clisp-root "impnotes.html#prompt-finish"))
        ("custom:*ansi*" (cl-lookup-clisp-root "impnotes.html#ansi"))
        ("custom:*apropos-do-more*" (cl-lookup-clisp-root "impnotes.html#apropos"))
        ("custom:*apropos-matcher*" (cl-lookup-clisp-root "impnotes.html#apropos"))
        ("custom:*browser*" (cl-lookup-clisp-root "impnotes.html#browser"))
        ("custom:*browsers*" (cl-lookup-clisp-root "impnotes.html#browser"))
        ("custom:*compile-warnings*"
         (cl-lookup-clisp-root "impnotes.html#compilefile"))
        ("custom:*compiled-file-types*"
         (cl-lookup-clisp-root "impnotes.html#loadfile"))
        ("custom:*current-language*" (cl-lookup-clisp-root "impnotes.html#language"))
        ("custom:*device-prefix*"
         (cl-lookup-clisp-root "impnotes.html#device-prefix"))
        ("custom:*editor*" (cl-lookup-clisp-root "impnotes.html#ed"))
        ("custom:*floating-point-contagion-ansi*"
         (cl-lookup-clisp-root "impnotes.html#flocont"))
        ("custom:*load-compiling*" (cl-lookup-clisp-root "impnotes.html#loadfile"))
        ("custom:*load-echo*" (cl-lookup-clisp-root "impnotes.html#loadfile"))
        ("custom:*load-logical-pathname-translations-database*"
         (cl-lookup-clisp-root "impnotes.html#load-lpt"))
        ("custom:*load-obsolete-action*"
         (cl-lookup-clisp-root "impnotes.html#loadfile"))
        ("custom:*merge-pathnames-ansi*"
         (cl-lookup-clisp-root "impnotes.html#pathmerge"))
        ("custom:*parse-namestring-dot-file*"
         (cl-lookup-clisp-root "impnotes.html#name-type-split"))
        ("custom:*pprint-first-newline*"
         (cl-lookup-clisp-root "impnotes.html#ppr-first-newline"))
        ("custom:*print-pathnames-ansi*"
         (cl-lookup-clisp-root "impnotes.html#pathprint"))
        ("custom:*prompt-step*" (cl-lookup-clisp-root "impnotes.html#prompt-step"))
        ("custom:*source-file-types*"
         (cl-lookup-clisp-root "impnotes.html#loadfile"))
        ("custom:*system-package-list*"
         (cl-lookup-clisp-root "impnotes.html#pack-lock"))

        ("i18n:gettext" (cl-lookup-clisp-root "impnotes.html#gettext"))
        ("i18n:ngettext" (cl-lookup-clisp-root "impnotes.html#ngettext"))
        ("i18n:textdomain" (cl-lookup-clisp-root "impnotes.html#textdomain"))
        ("i18n:textdomaindir" (cl-lookup-clisp-root "impnotes.html#textdomaindir"))
        ("i18n:deflanguage" (cl-lookup-clisp-root "impnotes.html#deflang"))
        ("i18n:definternational" (cl-lookup-clisp-root "impnotes.html#def-i-l"))
        ("i18n:deflocalized" (cl-lookup-clisp-root "impnotes.html#defloc"))
        ("i18n:localized" (cl-lookup-clisp-root "impnotes.html#localized"))

        ("gray:fundamental-stream" (cl-lookup-clisp-root "impnotes.html#fu-st"))
        ("gray:fundamental-input-stream"
         (cl-lookup-clisp-root "impnotes.html#fu-st-in"))
        ("gray:fundamental-output-stream"
         (cl-lookup-clisp-root "impnotes.html#fu-st-out"))
        ("gray:fundamental-character-stream"
         (cl-lookup-clisp-root "impnotes.html#fu-st-char"))
        ("gray:fundamental-binary-stream"
         (cl-lookup-clisp-root "impnotes.html#fu-st-bin"))
        ("gray:stream-read-char" (cl-lookup-clisp-root "impnotes.html#st-rc"))
        ("gray:stream-unread-char" (cl-lookup-clisp-root "impnotes.html#st-uc"))
        ("gray:stream-read-char-no-hang"
         (cl-lookup-clisp-root "impnotes.html#st-rcnh"))
        ("gray:stream-write-char" (cl-lookup-clisp-root "impnotes.html#st-wc"))
        ("gray:stream-line-column" (cl-lookup-clisp-root "impnotes.html#st-lc"))
        ("gray:stream-read-byte" (cl-lookup-clisp-root "impnotes.html#st-rb"))
        ("gray:stream-read-byte-lookahead"
         (cl-lookup-clisp-root "impnotes.html#st-rbla"))

        ("screen:make-window" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:with-window" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:*window*" (cl-lookup-clisp-root "impnotes.html#scr-win"))
        ("screen:window-size" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:window-cursor-position"
         (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:set-window-cursor-position"
         (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:clear-window" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:clear-window-to-eot" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:clear-window-to-eol" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:delete-window-line" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:insert-window-line" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:highlight-on" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:highlight-off" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:window-cursor-on" (cl-lookup-clisp-root "impnotes.html#screen"))
        ("screen:window-cursor-off" (cl-lookup-clisp-root "impnotes.html#screen"))

        ("sys::dynload-modules" (cl-lookup-clisp-root "impnotes.html#mod-dynload"))

        ("ldap:dir-key-open" (cl-lookup-clisp-root "impnotes.html#dir-key-open"))
        ("ldap:dir-key-close" (cl-lookup-clisp-root "impnotes.html#dir-key-close"))
        ("ldap:with-dir-key-open"
         (cl-lookup-clisp-root "impnotes.html#with-dir-key-open"))
        ("ldap:with-dir-key-search"
         (cl-lookup-clisp-root "impnotes.html#with-dir-key-search"))

        ("clos:no-primary-method" (cl-lookup-clisp-root "impnotes.html#no-prim"))
        ("clos:method-call-error"
         (cl-lookup-clisp-root "impnotes.html#meth-call-err"))
        ("clos:method-call-type-error"
         (cl-lookup-clisp-root "impnotes.html#meth-call-type-err"))
        ("clos:class-prototype" (cl-lookup-clisp-root "impnotes.html#class-proto"))
        ("clos:generic-flet" (cl-lookup-clisp-root "impnotes.html#gen-flet"))
        ("clos:generic-labels" (cl-lookup-clisp-root "impnotes.html#gen-labels"))
        ("clos:class-finalized-p" (cl-lookup-clisp-root "impnotes.html#class-fin-p"))
        ("clos:finalize-inheritance"
         (cl-lookup-clisp-root "impnotes.html#fin-inher"))

        ("clisp(1)" (cl-lookup-clisp-root "clisp.html"))
        ("clisp" (cl-lookup-clisp-root "impnotes.html"))
        ("clisp:[introduction]" (cl-lookup-clisp-root "impnotes.html#intro"))
        ("clisp:[syntax]" (cl-lookup-clisp-root "impnotes.html#syntax"))
        ("clisp:[evaluation and compilation]"
         (cl-lookup-clisp-root "impnotes.html#eval"))
        ("clisp:[types and classes]"
         (cl-lookup-clisp-root "impnotes.html#types-classes"))
        ("clisp:[data and control flow]" (cl-lookup-clisp-root "impnotes.html#data"))
        ("clisp:[iteration]" (cl-lookup-clisp-root "impnotes.html#iteration"))
        ("clisp:[objects]" (cl-lookup-clisp-root "impnotes.html#objects"))
        ("clisp:[structures]" (cl-lookup-clisp-root "impnotes.html#structures"))
        ("clisp:[conditions]" (cl-lookup-clisp-root "impnotes.html#conditions"))
        ("clisp:[symbols]" (cl-lookup-clisp-root "impnotes.html#symbols"))
        ("clisp:[packages]" (cl-lookup-clisp-root "impnotes.html#packages"))
        ("clisp:[numbers]" (cl-lookup-clisp-root "impnotes.html#numbers"))
        ("clisp:[characters]" (cl-lookup-clisp-root "impnotes.html#characters"))
        ("clisp:[conses]" (cl-lookup-clisp-root "impnotes.html#conses"))
        ("clisp:[arrays]" (cl-lookup-clisp-root "impnotes.html#arrays"))
        ("clisp:[strings]" (cl-lookup-clisp-root "impnotes.html#strings"))
        ("clisp:[sequences]" (cl-lookup-clisp-root "impnotes.html#sequences"))
        ("clisp:[hash tables]" (cl-lookup-clisp-root "impnotes.html#hash"))
        ("clisp:[filenames]" (cl-lookup-clisp-root "impnotes.html#filenames"))
        ("clisp:[files]" (cl-lookup-clisp-root "impnotes.html#files"))
        ("clisp:[streams]" (cl-lookup-clisp-root "impnotes.html#streams"))
        ("clisp:[printer]" (cl-lookup-clisp-root "impnotes.html#printer"))
        ("clisp:[reader]" (cl-lookup-clisp-root "impnotes.html#reader"))
        ("clisp:[system construction]" (cl-lookup-clisp-root "impnotes.html#system"))
        ("clisp:[environment]" (cl-lookup-clisp-root "impnotes.html#environment"))
        ("clisp:[extensions]" (cl-lookup-clisp-root "impnotes.html#extensions"))

        ("clisp:clos" (cl-lookup-clisp-root "impnotes.html#imppack"))
        ("clisp:system" (cl-lookup-clisp-root "impnotes.html#sys-pac"))
        ("clisp:ext" (cl-lookup-clisp-root "impnotes.html#ext-pac"))
        ("clisp:ffi" (cl-lookup-clisp-root "impnotes.html#dffi"))
        ("clisp:charset" (cl-lookup-clisp-root "impnotes.html#encoding"))
        ("clisp:ldap" (cl-lookup-clisp-root "impnotes.html#dir-key"))
        ("clisp:posix" (cl-lookup-clisp-root "impnotes.html#syscalls"))
        ("clisp:socket" (cl-lookup-clisp-root "impnotes.html#socket"))
        ("clisp:gstream" (cl-lookup-clisp-root "impnotes.html#gstream"))
        ("clisp:gray" (cl-lookup-clisp-root "impnotes.html#gray"))
        ("clisp:i18n" (cl-lookup-clisp-root "impnotes.html#i18n"))
        ("clisp:custom" (cl-lookup-clisp-root "impnotes.html#customize"))
        ("clisp:screen" (cl-lookup-clisp-root "impnotes.html#screen"))
        
        ("clos:" (cl-lookup-clisp-root "impnotes.html#imppack"))
        ("system:" (cl-lookup-clisp-root "impnotes.html#sys-pac"))
        ("ext:" (cl-lookup-clisp-root "impnotes.html#ext-pac"))
        ("ffi:" (cl-lookup-clisp-root "impnotes.html#dffi"))
        ("charset:" (cl-lookup-clisp-root "impnotes.html#encoding"))
        ("ldap:" (cl-lookup-clisp-root "impnotes.html#dir-key"))
        ("posix:" (cl-lookup-clisp-root "impnotes.html#syscalls"))
        ("socket:" (cl-lookup-clisp-root "impnotes.html#socket"))
        ("gstream:" (cl-lookup-clisp-root "impnotes.html#gstream"))
        ("gray:" (cl-lookup-clisp-root "impnotes.html#gray"))
        ("i18n:" (cl-lookup-clisp-root "impnotes.html#i18n"))
        ("custom:" (cl-lookup-clisp-root "impnotes.html#customize"))
        ("screen:" (cl-lookup-clisp-root "impnotes.html#screen"))
        
        ("clisp:constantp" (cl-lookup-clisp-root "impnotes.html#constantp"))
        ("clisp:eval-when" (cl-lookup-clisp-root "impnotes.html#eval-when"))
        ("clisp:eq" (cl-lookup-clisp-root "impnotes.html#eq"))
        ("clisp:symbol-function" (cl-lookup-clisp-root "impnotes.html#sym-fun"))
        ("clisp:setf" (cl-lookup-clisp-root "impnotes.html#setf"))
        ("clisp:function" (cl-lookup-clisp-root "impnotes.html#func"))
        ("clisp:define-symbol-macro"
         (cl-lookup-clisp-root "impnotes.html#def-sym-mac"))
        ("clisp:lambda" (cl-lookup-clisp-root "impnotes.html#lambda"))
        ("clisp:defun" (cl-lookup-clisp-root "impnotes.html#defun"))
        ("clisp:defmacro" (cl-lookup-clisp-root "impnotes.html#defun"))
        ("clisp:make-package" (cl-lookup-clisp-root "impnotes.html#make-pack"))
        ("clisp:expt" (cl-lookup-clisp-root "impnotes.html#expt"))
        ("clisp:log" (cl-lookup-clisp-root "impnotes.html#log"))
        ("clisp:pi" (cl-lookup-clisp-root "impnotes.html#pi"))
        ("clisp:floating-point-invalid-operation"
         (cl-lookup-clisp-root "impnotes.html#float-invalid-op"))
        ("clisp:floating-point-inexact"
         (cl-lookup-clisp-root "impnotes.html#float-inexact"))
        ("clisp:nreverse" (cl-lookup-clisp-root "impnotes.html#nreverse-nreconc"))
        ("clisp:nreconc" (cl-lookup-clisp-root "impnotes.html#nreverse-nreconc"))
        ("clisp:remove" (cl-lookup-clisp-root "impnotes.html#rem-del"))
        ("clisp:delete" (cl-lookup-clisp-root "impnotes.html#rem-del"))
        ("clisp:sort" (cl-lookup-clisp-root "impnotes.html#sorting"))
        ("clisp:stable-sort" (cl-lookup-clisp-root "impnotes.html#sorting"))
        ("clisp:make-hash-table" (cl-lookup-clisp-root "impnotes.html#make-hash"))
        ("clisp:hash-table-test" (cl-lookup-clisp-root "impnotes.html#ht-test"))
        ("clisp:translate-pathname"
         (cl-lookup-clisp-root "impnotes.html#translate-pathname"))
        ("clisp:parse-namestring" (cl-lookup-clisp-root "impnotes.html#parsename"))
        ("clisp:merge-pathnames" (cl-lookup-clisp-root "impnotes.html#pathmerge"))
        ("clisp:load-logical-pathname-translations"
         (cl-lookup-clisp-root "impnotes.html#load-lpt"))
        ("clisp:coerce" (cl-lookup-clisp-root "impnotes.html#fixnum-char-ansi"))
        ("clisp:function-lambda-expression"
         (cl-lookup-clisp-root "impnotes.html#fle"))
        ("clisp:lambda-list-keywords" (cl-lookup-clisp-root "impnotes.html#lambda"))
        ("clisp:call-arguments-limit" (cl-lookup-clisp-root "impnotes.html#lambda"))
        ("clisp:multiple-values-limit" (cl-lookup-clisp-root "impnotes.html#lambda"))
        ("clisp:lambda-parameters-limit"
         (cl-lookup-clisp-root "impnotes.html#lambda"))
        ("clisp:most-positive-fixnum"
         (cl-lookup-clisp-root "impnotes.html#fixnum-lim-table"))
        ("clisp:most-negative-fixnum"
         (cl-lookup-clisp-root "impnotes.html#fixnum-lim-table"))
        ("clisp:array-rank-limit"
         (cl-lookup-clisp-root "impnotes.html#array-limit-table"))
        ("clisp:array-dimension-limit"
         (cl-lookup-clisp-root "impnotes.html#array-limit-table"))
        ("clisp:array-total-size-limit"
         (cl-lookup-clisp-root "impnotes.html#array-limit-table"))
        ("clisp:pathname" (cl-lookup-clisp-root "impnotes.html#path-des"))
        ("clisp:pathname-match-p" (cl-lookup-clisp-root "impnotes.html#path-des"))
        ("clisp:translate-pathname"
         (cl-lookup-clisp-root "impnotes.html#translate-pathname"))
        ("clisp:parse-namestring" (cl-lookup-clisp-root "impnotes.html#parsename"))
        ("clisp:merge-pathnames" (cl-lookup-clisp-root "impnotes.html#pathmerge"))
        ("clisp:load-logical-pathname-translations"
         (cl-lookup-clisp-root "impnotes.html#load-lpt"))
        ("clisp:rename-file" (cl-lookup-clisp-root "impnotes.html#file-dict"))
        ("clisp:probe-file" (cl-lookup-clisp-root "impnotes.html#file-dict"))
        ("clisp:file-author" (cl-lookup-clisp-root "impnotes.html#file-dict"))
        ("clisp:delete-file" (cl-lookup-clisp-root "impnotes.html#del-file"))
        ("clisp:directory" (cl-lookup-clisp-root "impnotes.html#dir"))
        ("clisp:stream-element-type"
         (cl-lookup-clisp-root "impnotes.html#stream-eltype"))
        ("clisp:write-sequence" (cl-lookup-clisp-root "impnotes.html#write-seq"))
        ("clisp:file-position" (cl-lookup-clisp-root "impnotes.html#file-pos"))
        ("clisp:open" (cl-lookup-clisp-root "impnotes.html#open"))
        ("clisp:close" (cl-lookup-clisp-root "impnotes.html#close"))
        ("clisp:open-stream-p" (cl-lookup-clisp-root "impnotes.html#open-stream-p"))
        ("clisp:broadcast-stream"
         (cl-lookup-clisp-root "impnotes.html#broadcast-stream"))
        ("clisp:format" (cl-lookup-clisp-root "impnotes.html#format"))
        ("clisp:readtable-case" (cl-lookup-clisp-root "impnotes.html#rt-case"))
        ("clisp:compile-file" (cl-lookup-clisp-root "impnotes.html#compilefile"))
        ("clisp:compile-file-pathname"
         (cl-lookup-clisp-root "impnotes.html#compile-file-path"))
        ("clisp:require" (cl-lookup-clisp-root "impnotes.html#require"))
        ("clisp:load" (cl-lookup-clisp-root "impnotes.html#loadfile"))
        ("clisp:*features*" (cl-lookup-clisp-root "impnotes.html#features"))
        ("clisp:disassemble" (cl-lookup-clisp-root "impnotes.html#disassemble"))
        ("clisp:documentation" (cl-lookup-clisp-root "impnotes.html#documentation"))
        ("clisp:trace" (cl-lookup-clisp-root "impnotes.html#trace"))
        ("clisp:inspect" (cl-lookup-clisp-root "impnotes.html#inspect"))
        ("clisp:room" (cl-lookup-clisp-root "impnotes.html#room"))
        ("clisp:time" (cl-lookup-clisp-root "impnotes.html#time"))
        ("clisp:ed" (cl-lookup-clisp-root "impnotes.html#ed"))
        ("clisp:apropos" (cl-lookup-clisp-root "impnotes.html#apropos"))
        ("clisp:dribble" (cl-lookup-clisp-root "impnotes.html#dribble"))
        ("clisp:lisp-implementation-version"
         (cl-lookup-clisp-root "impnotes.html#version"))
        ("clisp:gettext" (cl-lookup-clisp-root "impnotes.html#ggettext"))
        ))

(provide 'cl-lookup-clisp)

;;; cl-lookup-clisp.el ends here
