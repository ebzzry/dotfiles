;;; cl-lookup.el --- View various documentation on Common Lisp

;; Copyright (C) 2004 Yuji 'bmonkey' Minejima <ggb01164@nifty.ne.jp>

;; Author: Yuji Minejima <ggb01164@nifty.ne.jp>
;; $Revision: 1.7 $
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

;; This package provides the `cl-lookup' command with which you can look up
;; various entries relating to Common Lisp in various sources.
;; This package requires hyperspec.el package to work.
;; This package is the successor of hyperspec-addon.el package and supercedes it.
;;
;; You can add your custom entries by writing a definition file.
;; See the existing definition files (e.g. cl-lookup-mop.el, cl-lookup-ppcre.el)
;; to learn how to do this.
;;
;;
;; To use this package, add the following code to your .emacs file, changing
;; relevant part to suit your needs.
;; (add-to-list 'load-path "/PATH/TO/CL-LOOKUP-DIR/")
;; (autoload 'cl-lookup "cl-lookup"
;;  "View the documentation on ENTRY from the Common Lisp HyperSpec, et al.")
;; (global-set-key [(control ?,) ?h] 'cl-lookup)
;; (setq cl-lookup-categories
;;       ;; Comment out category lines you don't want (like "cl-lookup-clisp" in
;;       ;; this example). Add your custom category file name as a string, which
;;       ;; then will be automatically loaded.
;;       '(:hyperspec-index           ; e.g. "", "spec" "CLHS"
;;         :hyperspec-chapters        ; e.g. [index], [syntax]
;;         :format-control-characters ; e.g. "~C: Character", "~%: Newline"
;;         :reader-macro-characters   ; e.g. "(", "#'", "#b", "#+"
;;         :loop                      ; e.g. loop:with, loop:collect
;;         :arguments                 ; e.g. :test, :key, :eof-error-p
;;         :concepts                  ; e.g. "lambda lists:", "character names:"
;;         "cl-lookup-glossary"       ; e.g. {absolute}, {binding}
;;         "cl-lookup-mop"            ; e.g. add-dependent, ensure-class
;;
;;         ;; implementation specific categories
;;         ;; "cl-lookup-clisp"          ; e.g. ext:cd
;;
;;         ;; library categories
;;         "cl-lookup-ppcre"          ; e.g. cl-ppcre:parse-tree-synonym
;;         ))
;; After adding the above lines to .emacs file, restart Emacs and do
;; the following to byte-compile the files,
;; `C-u 0 M-x byte-recompile-directory <RET> /PATH/TO/CL-LOOKUP-DIR/' .
;; Then, restart Emacs again to make the byte compiled code get loaded.
;;
;;
;; You might want to use mcomplete.el with this package which enhances the
;; minibuffer completion facility. With mcomplete.el, you can search through the
;; entries with a substring.
;; Suppose you want to know something about `environment',
;; You enter `M-x cl-lookup <RET> env'.
;; At this point, You notice [No match] mark.
;; Then you enter `C-n', and the [Substring match] mark appears for a short time.
;; At this point the minibuffer looks like the following,
;; > Look up Common Lisp info: env-!-[ironment]<&environment,[environment], ...>
;; You enter `<TAB> <TAB>' and get a completion list like the following.
;; >Possible completions are:
;; > &environment                       [environment]
;; > {compilation environment}          {dynamic environment}
;; > {environment object}               {environment parameter}
;; > {environment}                      {evaluation environment}
;; > {global environment}               {lexical environment}
;; > {non-null lexical environment}     {null lexical environment}
;; > {run-time environment}             {startup environment}
;;
;; If you feel pressing `C-n' to change the matching mode is tiresome and
;; want to customize mcomplete.el to make the substring match mode enabled from
;; the start for the `cl-lookup' command, just add the following code in your
;; .emacs file.
;; (put 'cl-lookup
;;      'mcomplete-mode
;;      '(:method-set (mcomplete-substr-method mcomplete-prefix-method)
;;        :exhibit-start-chars 1))
;; You can find the latest mcomplete.el here.
;; http://homepage1.nifty.com/bmonkey/emacs/elisp/mcomplete.el


;;; Change Log:



;;; Code:
(eval-and-compile
 (require 'cl)
 (require 'hyperspec))

(defvar cl-lookup-categories
  '(:hyperspec-index           ; e.g. "", "spec" "CLHS"
    :hyperspec-chapters        ; e.g. [index], [syntax]
    :format-control-characters ; e.g. "~C: Character", "~%: Newline"
    :reader-macro-characters   ; e.g. "(", "#'", "#b", "#+"
    :loop                      ; e.g. loop:with, loop:collect
    :arguments                 ; e.g. :test, :key, :eof-error-p
    :concepts                  ; e.g. "lambda lists:", "character names:"
    "cl-lookup-glossary"       ; e.g. {absolute}, {binding}
    "cl-lookup-mop"            ; e.g. add-dependent, ensure-class
    
    ;; implementation specific categories
    "cl-lookup-clisp"          ; e.g. ext:cd

    ;; library categories
    "cl-lookup-ppcre"          ; e.g. cl-ppcre:parse-tree-synonym
    ))

(defun cl-lookup-translate (path-component)
  (etypecase path-component
    (string path-component)
    (symbol (symbol-value path-component))))

(defconst cl-lookup-obarray (copy-sequence common-lisp-hyperspec-symbols))

(defvar cl-lookup-history nil "History of entries looked up in cl-lookup.")

(defun cl-lookup-browse (path)
  (let ((url (etypecase path
               (string (concat common-lisp-hyperspec-root "Body/" path))
               (cons (apply #'concat (mapcar #'cl-lookup-translate path))))))
    (browse-url url)))

(defun cl-lookup-default-entry ()
  (let ((symbol-at-point (thing-at-point 'symbol)))
    (when (and symbol-at-point
               (intern-soft (downcase symbol-at-point) cl-lookup-obarray))
      symbol-at-point)))

(defun cl-lookup (entry)
  "View the documentation on ENTRY from the Common Lisp HyperSpec, et al."
  (interactive (list (let ((default (cl-lookup-default-entry)))
                       (completing-read
                        (concat "Look up Common Lisp info"
                                (when default (format " (%s)" default))
                                ": ")
                        cl-lookup-obarray #'boundp t nil
                        'cl-lookup-history default))))
  (let* ((symbol (intern-soft (downcase entry) cl-lookup-obarray))
         (paths (if (and symbol (boundp symbol))
                    (symbol-value symbol)
                    (error "cl-lookup internal error: the path of %s is not defined"
                           name))))
    (loop for (path . rest) on paths
          do (cl-lookup-browse path)
          if rest do (sleep-for 1.5))))

;; build cl-lookup-obarray
(mapc #'(lambda (spec)
          (destructuring-bind (category . entries) spec
            (when (member category cl-lookup-categories)
              (dolist (entry entries)
                (destructuring-bind (name path) entry
                  (let ((symbol (intern (downcase name) cl-lookup-obarray)))
                    (if (boundp symbol)
                        (pushnew path (symbol-value symbol) :test #'equal)
                        (set symbol `(,path)))))))))
      '((:hyperspec-index
         ("" "../Front/index.htm")
         ("spec" "../Front/index.htm")
         ("clhs" "../Front/index.htm"))

        (:hyperspec-chapters
         ("[index]" "../Front/Contents.htm")
         ("[introduction]" "01_.htm")
         ("[syntax]" "02_.htm")
         ("[evaluation and compilation]" "03_.htm")
         ("[types and classes]" "04_.htm")
         ("[data and control flow]" "05_.htm")
         ("[iteration]" "06_.htm")
         ("[objects]" "07_.htm")
         ("[structures]" "08_.htm")
         ("[conditions]" "09_.htm")
         ("[symbols]" "10_.htm")
         ("[packages]" "11_.htm")
         ("[numbers]" "12_.htm")
         ("[characters]" "13_.htm")
         ("[conses]" "14_.htm")
         ("[arrays]" "15_.htm")
         ("[strings]" "16_.htm")
         ("[sequences]" "17_.htm")
         ("[hash tables]" "18_.htm")
         ("[filenames]" "19_.htm")
         ("[files]" "20_.htm")
         ("[streams]" "21_.htm")
         ("[printer]" "22_.htm")
         ("[reader]" "23_.htm")
         ("[system construction]" "24_.htm")
         ("[environment]" "25_.htm")
         ("[glossary]" "26_.htm"))

        (:format-control-characters
         ("~C: Character" "22_caa.htm")
         ("~%: Newline" "22_cab.htm")
         ("~&: Freshline" "22_cac.htm")
         ("~|: Page" "22_cad.htm")
         ("~~: Tilde" "22_cae.htm")
         ("~R: Radix" "22_cba.htm")
         ("~D: Decimal" "22_cbb.htm")
         ("~B: Binary" "22_cbc.htm")
         ("~O: Octal" "22_cbd.htm")
         ("~X: Hexadecimal" "22_cbe.htm")
         ("~F: Fixed-Format Floating-Point" "22_cca.htm")
         ("~E: Exponential Floating-Point" "22_ccb.htm")
         ("~G: General Floating-Point" "22_ccc.htm")
         ("~$: Monetary Floating-Point" "22_ccd.htm")
         ("~A: Aesthetic" "22_cda.htm")
         ("~S: Standard" "22_cdb.htm")
         ("~W: Write" "22_cdc.htm")
         ("~_: Conditional Newline" "22_cea.htm")
         ("~<: Logical Block" "22_ceb.htm")
         ("~I: Indent" "22_cec.htm")
         ("~/: Call Function" "22_ced.htm")
         ("~T: Tabulate" "22_cfa.htm")
         ("~<: Justification" "22_cfb.htm")
         ("~>: End of Justification" "22_cfc.htm")
         ("~*: Go-To" "22_cga.htm")
         ("~[: Conditional Expression" "22_cgb.htm")
         ("~]: End of Conditional Expression" "22_cgc.htm")
         ("~{: Iteration" "22_cgd.htm")
         ("~}: End of Iteration" "22_cge.htm")
         ("~?: Recursive Processing" "22_cgf.htm")
         ("~(: Case Conversion" "22_cha.htm")
         ("~): End of Case Conversion" "22_chb.htm")
         ("~P: Plural" "22_chc.htm")
         ("~;: Clause Separator" "22_cia.htm")
         ("~^: Escape Upward" "22_cib.htm")
         ("~NEWLINE: Ignored Newline" "22_cic.htm"))

        (:reader-macro-characters
         ("(" "02_da.htm")
         (")" "02_db.htm")
         ("'" "02_dc.htm")
         (";" "02_dd.htm")
         ("\"" "02_de.htm")
         ("`" "02_df.htm")
         ("," "02_dg.htm")
         ("#" "02_dh.htm")
         ("#\\" "02_dha.htm")
         ("#'" "02_dhb.htm")
         ("#(" "02_dhc.htm")
         ("#*" "02_dhd.htm")
         ("#:" "02_dhe.htm")
         ("#." "02_dhf.htm")
         ("#b" "02_dhg.htm")
         ("#o" "02_dhh.htm")
         ("#x" "02_dhi.htm")
         ("#r" "02_dhj.htm")
         ("#c" "02_dhk.htm")
         ("#a" "02_dhl.htm")
         ("#s" "02_dhm.htm")
         ("#p" "02_dhn.htm")
         ("#=" "02_dho.htm")
         ("##" "02_dhp.htm")
         ("#+" "02_dhq.htm")
         ("#-" "02_dhr.htm")
         ("#|" "02_dhs.htm")
         ("#<" "02_dht.htm"))

        (:loop
         ("loop:with" "06_abb.htm")
         ("loop:for-as" "06_aba.htm")
         ("loop:for-as-arithmetic" "06_abaa.htm")
         ("loop:for-as-in-list" "06_abab.htm")
         ("loop:for-as-on-list" "06_abac.htm")
         ("loop:for-as-equals-then" "06_abad.htm")
         ("loop:for-as-across" "06_abae.htm")
         ("loop:for-as-hash" "06_abaf.htm")
         ("loop:for-as-package" "06_abag.htm")
            
         ("loop:collect" "06_ac.htm")
         ("loop:append" "06_ac.htm")
         ("loop:nconc" "06_ac.htm")
         ("loop:count" "06_ac.htm")
         ("loop:maximize" "06_ac.htm")
         ("loop:minimize" "06_ac.htm")
         ("loop:sum" "06_ac.htm")

         ("loop:repeat" "06_ad.htm")
         ("loop:always" "06_ad.htm")
         ("loop:never" "06_ad.htm")
         ("loop:thereis" "06_ad.htm")
         ("loop:while" "06_ad.htm")
         ("loop:until" "06_ad.htm")

         ("loop:do" "06_ae.htm")
         ("loop:return" "06_ae.htm")

         ("loop:if" "06_af.htm")
         ("loop:when" "06_af.htm")
         ("loop:unless" "06_af.htm")
         ("loop:else" "06_af.htm")
         ("loop:it" "06_af.htm")
         ("loop:end" "06_af.htm")

         ("loop:named" "06_aga.htm")

         ("loop:initially" "06_agb.htm")
         ("loop:finally" "06_agb.htm"))
            
        (:arguments
         (":test" "17_ba.htm")
         (":test-not" "17_ba.htm")
         (":key" "17_bb.htm")

         (":eof-error-p" "23_aca.htm")
         (":recursive-p" "23_acb.htm")

         (":case" "19_bbab.htm")

         ("&allow-other-keys" "03_dada.htm")
         (":allow-other-keys" "03_dada.htm"))

        (:concepts
         ("formatted output" "22_c.htm")
         ("lambda lists" "03_d.htm")
         ("modified BNF syntax" "01_dab.htm")
         ("character names" "13_ag.htm")
         ("standardized packages" "11_ab.htm")
         ("the common-lisp package" "11_aba.htm")
         ("the common-lisp-user package" "11_aba.htm")
         ("the keyword package" "11_abc.htm")
         )
        ))

(provide 'cl-lookup)
(dolist (category cl-lookup-categories) (when (stringp category) (load category)))

;;; cl-lookup.el ends here
