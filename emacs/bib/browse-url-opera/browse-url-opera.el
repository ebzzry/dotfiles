;;;; mode: emacs-lisp; coding: utf-8

(defcustom browse-url-opera-program
  (let ((candidates '("opera" "opera-browser")))
    (while (and candidates (not (executable-find (car candidates))))
      (setq candidates (cdr candidates)))
    (or (car candidates) "opera"))
  "The name by which to invoke Opera."
  :type 'string
  :version "0.1"
  :group 'browse-url)

(defcustom browse-url-opera-arguments nil
  "A list of strings to pass to Opera as arguments."
  :type '(repeat (string :tag "Argument"))
  :version "24.1"
  :group 'browse-url)


(defun browse-url-opera (url &optional _new-window)
  "Ask the Opera WWW browser to load URL.
Default to the URL around or before point.  The strings in
variable `browse-url-opera-arguments' are also passed to
Opera.
The optional argument NEW-WINDOW is not used."
  (interactive (browse-url-interactive-arg "URL: "))
  (setq url (browse-url-encode-url url))
  (let* ((process-environment (browse-url-process-environment)))
    (apply 'start-process
	   (concat "opera " url) nil
	   browse-url-opera-program
	   (append
	    browse-url-opera-arguments
	    (list url)))))

(provide 'browse-url-opera)
