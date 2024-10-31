;;;; -*- mode: lisp; encoding: utf-8 -*-
;;;; Init file for Clozure CL

(setf *compile-verbose* t
      *load-verbose* t
      ccl:*quit-on-eof* t
      setf ccl:*default-external-format* :utf-8
      ccl:*default-file-character-encoding* :utf-8
      ccl:*default-socket-character-encoding* :utf-8
      (pathname-encoding-name) :utf-8)
