;;;; -*- mode: lisp -*-

(define-configuration (input-buffer)
    ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

(define-configuration (prompt-buffer)
    ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

(define-configuration browser
    ((theme theme:+dark-theme+)))

;; (in-package #:nyxt-user)

;; (load-after-system :slynk (nyxt-init-file "slynk.lisp"))
;; (nyxt::load-lisp (nyxt-init-file "general.lisp"))
;; (nyxt::load-lisp (nyxt-init-file "keys.lisp"))
;; (nyxt::load-lisp (nyxt-init-file "commands.lisp"))
;; (nyxt::load-lisp (nyxt-init-file "search.lisp"))
;; (nyxt::load-lisp (nyxt-init-file "interface.lisp"))
