(defvar emacs-configuration-directory
  "~/.emacs.d/")

(defvar elscreen-save-file
  (concat emacs-configuration-directory ".elscreen"))

(defun elscreen-store ()
  "Store the elscreen tab configuration."
  (interactive)
  (if (desktop-save emacs-configuration-directory)
      (with-temp-file elscreen-save-file
        (insert (prin1-to-string (elscreen-get-screen-to-name-alist))))))

(defun elscreen-restore ()
  "Restore the elscreen tab configuration."
  (interactive)
  (let ((screens (reverse
                  (read
                   (with-temp-buffer
                     (insert-file-contents elscreen-save-file)
                     (buffer-string))))))
    (while screens
      (setq screen (car (car screens)))
      (setq buffers (split-string (cdr (car screens)) ":"))
      (if (eq screen 0)
          (switch-to-buffer (car buffers))
          (elscreen-find-and-goto-by-buffer (car buffers) t t))
      (while (cdr buffers)
        (switch-to-buffer-other-window (car (cdr buffers)))
        (setq buffers (cdr buffers)))
      (setq screens (cdr screens)))))

(provide 'elscreen-save)
