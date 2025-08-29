;;;; pelilo.lisp

(uiop:define-package :stumpo/pelilo
  (:nicknames :stumpo)
  (:use :uiop/common-lisp)
  (:use-reexport #:stumpo/komunajxoj
                 #:stumpo/cxefagordo
                 #:stumpo/komandoj
                 #:stumpo/klavkombinoj
                 #:stumpo/grupoj
                 #:stumpo/transpasoj
                 #:stumpo/postsxargo))

(provide "stumpo")
(provide "STUMPO")
