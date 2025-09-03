;;; Auto-hide compilation buffer
;;; http://emacswiki.org/emacs/ModeCompile
(setq compilation-exit-message-function
      (lambda (status code msg)
        (when (and (eq status 'exit) (zerop code))
          (bury-buffer)
          (delete-window (get-buffer-window (get-buffer "*compilation*"))))
        (cons msg code)))

(provide 'compile-hide)
