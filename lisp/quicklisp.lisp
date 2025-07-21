;;;; -*- mode: lisp -*-

(add-to-registry "quicklisp/quicklisp/")

#-quicklisp
(let ((file (home-path "quicklisp/setup.lisp")))
  (when (probe-file file)
    (load file)))

#+(and quicklisp clisp abcl)
(ql:quickload :asdf)
