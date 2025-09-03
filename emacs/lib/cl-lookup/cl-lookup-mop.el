;;; cl-lookup-mop.el --- View various documentation on Common Lisp

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

(defvar cl-lookup-mop-root "http://www.lisp.org/mop/")

(mapc #'(lambda (entry)
          (destructuring-bind (name path) entry
            (let ((symbol (intern (downcase name) cl-lookup-obarray)))
              (if (boundp symbol)
                  (pushnew path (symbol-value symbol) :test #'equal)
                  (set symbol `(,path))))))
      '(("mop" (cl-lookup-mop-root "index.html"))
          
         ("add-dependent" (cl-lookup-mop-root "dictionary.html#add-dependent"))
         ("add-direct-method"
          (cl-lookup-mop-root "dictionary.html#add-direct-method"))
         ("add-direct-subclass"
          (cl-lookup-mop-root "dictionary.html#add-direct-subclass"))
         ("add-method" (cl-lookup-mop-root "dictionary.html#add-method"))
         ("allocate-instance"
          (cl-lookup-mop-root "dictionary.html#allocate-instance"))

         ("class-... " (cl-lookup-mop-root "dictionary.html#class-"))
         ("class-default-initargs"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-direct-default-initargs"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-direct-slots"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-direct-subclasses"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-direct-superclasses"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-finalized-p"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-name" (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-precedence-list"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-prototype"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("class-slots"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))

          
         ("compute-applicable-methods"
          (cl-lookup-mop-root "dictionary.html#compute-applicable-methods"))
         ("compute-applicable-methods-using-classes"
          (cl-lookup-mop-root
           "dictionary.html#compute-applicable-methods-using-classes"))
         ("compute-class-precedence-list"
          (cl-lookup-mop-root "dictionary.html#compute-class-precedence-list"))
         ("compute-default-initargs"
          (cl-lookup-mop-root "dictionary.html#compute-default-initargs"))
         ("compute-discriminating-function"
          (cl-lookup-mop-root "dictionary.html#compute-discriminating-function"))
         ("compute-effective-method"
          (cl-lookup-mop-root "dictionary.html#compute-effective-method"))
         ("compute-effective-slot-definition"
          (cl-lookup-mop-root
           "dictionary.html#compute-effective-slot-definition"))
         ("compute-slots" (cl-lookup-mop-root "dictionary.html#compute-slots"))
         ("direct-slot-definition-class"
          (cl-lookup-mop-root "dictionary.html#direct-slot-definition-class"))
         ("effective-slot-definition-class"
          (cl-lookup-mop-root "dictionary.html#effective-slot-definition-class"))
         ("ensure-class" (cl-lookup-mop-root "dictionary.html#ensure-class"))
         ("ensure-class-using-class"
          (cl-lookup-mop-root "dictionary.html#ensure-class-using-class"))
         ("ensure-generic-function"
          (cl-lookup-mop-root "dictionary.html#ensure-generic-function"))
         ("ensure-generic-function-using-class"
          (cl-lookup-mop-root
           "dictionary.html#ensure-generic-function-using-class"))
         ("eql-specializer-object"
          (cl-lookup-mop-root "dictionary.html#eql-specializer-object"))
         ("extract-lambda-list"
          (cl-lookup-mop-root "dictionary.html#extract-lambda-list"))
         ("extract-specializer-names"
          (cl-lookup-mop-root "dictionary.html#extract-specializer-names"))
         ("finalize-inheritance"
          (cl-lookup-mop-root "dictionary.html#finalize-inheritance"))
         ("find-method-combination"
          (cl-lookup-mop-root "dictionary.html#find-method-combination"))
         ("funcallable-standard-instance-access"
          (cl-lookup-mop-root
           "dictionary.html#funcallable-standard-instance-access"))

         ("generic-function-..."
          (cl-lookup-mop-root "dictionary.html#generic-function-"))
         ("generic-function-argument-precedence-order"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("generic-function-declarations"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("generic-function-lambda-list"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("generic-function-method-class"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("generic-function-method-combination"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("generic-function-methods"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("generic-function-name"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
          
         ("Initialization of Class Metaobjects"
          (cl-lookup-mop-root "dictionary.html#class-mo-init"))
         ("Initialization of Generic Function Metaobjects"
          (cl-lookup-mop-root "dictionary.html#gf-mo-init"))
         ("Initialization of Method Metaobjects"
          (cl-lookup-mop-root "dictionary.html#Initialization"))
         ("Initialization of Slot Definition Metaobjects"
          (cl-lookup-mop-root "dictionary.html#Initialization"))

         ("intern-eql-specializer"
          (cl-lookup-mop-root "dictionary.html#intern-eql-specializer"))
         ("make-instance" (cl-lookup-mop-root "dictionary.html#make-instance"))
         ("make-method-lambda"
          (cl-lookup-mop-root "dictionary.html#make-method-lambda"))
         ("map-dependents" (cl-lookup-mop-root "dictionary.html#map-dependents"))

         ("method-..." (cl-lookup-mop-root "dictionary.html#method-"))
         ("method-function"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
         ("method-generic-function"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
         ("method-lambda-list"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
         ("method-specializers"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
         ("method-qualifiers"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
         ("accessor-method-slot-definition"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
          
         ("Readers for Class Metaobjects"
          (cl-lookup-mop-root "dictionary.html#class-mo-readers"))
         ("Readers for Generic Function Metaobjects"
          (cl-lookup-mop-root "dictionary.html#gf-mo-readers"))
         ("Readers for Method Metaobjects"
          (cl-lookup-mop-root "dictionary.html#method-mo-readers"))
         ("Readers for Slot Definition Metaobjects"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
          
         ("reader-method-class"
          (cl-lookup-mop-root "dictionary.html#reader-method-class"))
         ("remove-dependent"
          (cl-lookup-mop-root "dictionary.html#remove-dependent"))
         ("remove-direct-method"
          (cl-lookup-mop-root "dictionary.html#remove-direct-method"))
         ("remove-direct-subclass"
          (cl-lookup-mop-root "dictionary.html#remove-direct-subclass"))
         ("remove-method" (cl-lookup-mop-root "dictionary.html#remove-method"))
         ("set-funcallable-instance-function"
          (cl-lookup-mop-root "dictionary.html#set-funcallable-instance-function"))
         ("(setf class-name)"
          (cl-lookup-mop-root "dictionary.html#(setf class-name)"))
         ("(setf generic-function-name)"
          (cl-lookup-mop-root "dictionary.html#(setf generic-function-name)"))
         ("(setf slot-value-using-class)"
          (cl-lookup-mop-root "dictionary.html#(setf slot-value-using-class)"))
         ("slot-boundp-using-class"
          (cl-lookup-mop-root "dictionary.html#slot-boundp-using-class"))

         ("slot-definition-..."
          (cl-lookup-mop-root "dictionary.html#slot-definition-"))
         ("slot-definition-allocation"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-initargs"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-initform"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-initfunction"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-location"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-name"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-readers"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-writers"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
         ("slot-definition-type"
          (cl-lookup-mop-root "dictionary.html#slotd-mo-readers"))
          
         ("slot-makunbound-using-class"
          (cl-lookup-mop-root "dictionary.html#slot-makunbound-using-class"))
         ("slot-value-using-class"
          (cl-lookup-mop-root "dictionary.html#slot-value-using-class"))
         ("specializer-direct-generic-functions"
          (cl-lookup-mop-root "dictionary.html#specializer-direct-generic-functions"))
         ("specializer-direct-methods"
          (cl-lookup-mop-root "dictionary.html#specializer-direct-methods"))
         ("standard-instance-access"
          (cl-lookup-mop-root "dictionary.html#standard-instance-access"))
         ("update-dependent"
          (cl-lookup-mop-root "dictionary.html#update-dependent"))
         ("validate-superclass"
          (cl-lookup-mop-root "dictionary.html#validate-superclass"))
         ("writer-method-class"
          (cl-lookup-mop-root "dictionary.html#writer-method-class"))))


(provide 'cl-lookup-mop)

;;; cl-lookup-mop.el ends here
