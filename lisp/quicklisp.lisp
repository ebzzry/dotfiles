;;;; -*- mode: lisp; syntax: common-lisp; base: 10; encoding: utf-8 -*-

(add-to-registry "quicklisp/quicklisp/")

#-quicklisp
(let ((file (home-path "quicklisp/setup.lisp")))
  (when (probe-file file)
    (load file)))

#+(and quicklisp clisp abcl)
(ql:quickload :asdf)

(defun l (&rest args)
  "Because it’s faster to type

(l :bordeaux-threads)

than

, load-sys RET bordeaux-threads

or

(ql:quickload :bordeaux-threads)
"
  (apply #'ql:quickload args))
