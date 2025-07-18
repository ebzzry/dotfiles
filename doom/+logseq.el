;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;  BACK UP YOUR LOGSEQ DIR BEFORE RUNNING THIS!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Copyright (C) Aug 4 2022, William R. Burdick Jr.
;;
;; LICENSE
;; This code is dual-licensed with MIT and GPL licenses.
;; Take your pick and abide by whichever license appeals to you.
;;
;; logseq compatibility
;; put ids and titles at the tops of non-journal files
;; change fuzzy links from [[PAGE]] to [[id:2324234234][PAGE]]
;; also change file links to id links, provided that the links
;; expand to file names that have ids in the roam database.
;;
;; NOTE: this currently only converts fuzzy links.
;; If you have the setting :org-mode/insert-file-link? true in your Logseq config,
;; it won't convert the resulting links.
;;

(require 'f)

;; Your logseq directory should be inside your org-roam directory,
;; put the directory you use here
(defvar my-logseq-folder (f-expand (f-join org-roam-directory "ebzzry")))
;; (defvar my-logseq-folder "~/roam/")

;; You probably don't need to change these values
(defvar my-logseq-pages (f-expand (f-join my-logseq-folder "pages")))
(defvar my-logseq-journals (f-expand (f-join my-logseq-folder "journals")))
;;(defvar my-rich-text-types [bold italic subscript link strike-through superscript underline inline-src-block footnote-reference inline-babel-call entity])
(defvar my-rich-text-types '(bold italic subscript link strike-through superscript underline inline-src-block))
;; ignore files matching my-logseq-exclude-pattern
;; example: (defvar my-logseq-exclude-pattern (string "^" my-logseq-folder "/bak/.*$"))
(defvar my-logseq-exclude-pattern "^$")

(defun my-textify (headline)
  (save-excursion
    (apply 'concat (flatten-list
                    (my-textify-all (org-element-property :title headline))))))

(defun my-textify-all (nodes) (mapcar 'my-subtextify nodes))

(defun my-with-length (str) (cons (length str) str))

(defun my-subtextify (node)
  (cond ((not node) "")
        ((stringp node) (substring-no-properties node))
        ((member (org-element-type node) my-rich-text-types)
         (list (my-textify-all (cddr node))
               (if (> (org-element-property :post-blank node))
                   (make-string (org-element-property :post-blank node) ?\s)
                 "")))
        (t "")))

(defun my-logseq-journal-p (file) (string-match-p (concat "^" my-logseq-journals) file))

(defun my-ensure-file-id (file)
  "Visit an existing file, ensure it has an id, return whether the a new buffer was created"
  (setq file (f-expand file))
  (if (my-logseq-journal-p file)
      `(nil . nil)
    (let* ((buf (get-file-buffer file))
           (was-modified (buffer-modified-p buf))
           (new-buf nil)
           has-data
           org
           changed
           sec-end)
      (when (not buf)
        (setq buf (find-file-noselect file))
        (setq new-buf t))
      (set-buffer buf)
      (setq org (org-element-parse-buffer))
      (setq has-data (cddr org))
      (goto-char 1)
      (when (not (and (eq 'section (org-element-type (nth 2 org))) (org-roam-id-at-point)))
        ;; this file has no file id
        (setq changed t)
        (when (eq 'headline (org-element-type (nth 2 org)))
          ;; if there's no section before the first headline, add one
          (insert "\n")
          (goto-char 1))
        (org-id-get-create)
        (setq org (org-element-parse-buffer)))
      (when (nth 3 org)
        (when (not (org-collect-keywords ["title"]))
          ;; no title -- ensure there's a blank line at the section end
          (setq changed t)
          (setq sec-end (org-element-property :end (nth 2 org)))
          (goto-char (1- sec-end))
          (when (and (not (equal "\n\n" (buffer-substring-no-properties (- sec-end 2) sec-end))))
            (insert "\n")
            (goto-char (1- (point)))
            (setq org (org-element-parse-buffer)))
          ;; copy the first headline to the title
          (insert (format "#+title: %s" (string-trim (my-textify (nth 3 org)))))))
      ;; ensure org-roam knows about the new id and/or title
      (when changed (save-buffer))
      (cons new-buf buf))))

(defun my-convert-logseq-file (buf)
  "convert fuzzy and file:../pages logseq links in the file to id links"
  (save-excursion
    (let* (changed
           link)
      (set-buffer buf)
      (goto-char 1)
      (while (search-forward "[[" nil t)
        (setq link (org-element-context))
        (setq newlink (my-reformat-link link))
        (when newlink
          (setq changed t)
          (goto-char (org-element-property :begin link))
          (delete-region (org-element-property :begin link) (org-element-property :end link))
          ;; note, this format string is reall =[[%s][%s]]= but =%= is a markup char so one's hidden
          (insert newlink)))
      ;; ensure org-roam knows about the changed links
      (when changed (save-buffer)))))

(defun my-reformat-link (link)
  (let (filename
        id
        linktext
        newlink)
    (when (eq 'link (org-element-type link))
      (when (equal "fuzzy" (org-element-property :type link))
        (setq filename (f-expand (f-join my-logseq-pages
                                         (concat (org-element-property :path link) ".org"))))
        (setq linktext (org-element-property :raw-link link)))
      (when (equal "file" (org-element-property :type link))
        (setq filename (f-expand (org-element-property :path link)))
        (if (org-element-property :contents-begin link)
            (setq linktext (buffer-substring-no-properties
                            (org-element-property :contents-begin link)
                            (org-element-property :contents-end link)))
          (setq linktext (buffer-substring-no-properties
                          (+ (org-element-property :begin link) 2)
                          (- (org-element-property :end link) 2)))))
      (when (and filename (f-exists-p filename))
        (setq id (caar (org-roam-db-query [:select id :from nodes :where (like file $s1)]
                                          filename)))
        (when id
          (setq newlink (format "[[id:%s][%s]]%s"
                                id
                                linktext
                                (if (> (org-element-property :post-blank link))
                                    (make-string (org-element-property :post-blank link) ?\s)
                                  "")))
          (when (not (equal newlink
                            (buffer-substring-no-properties
                             (org-element-property :begin link)
                             (org-element-property :end link))))
            newlink))))))

(defun my-roam-file-modified-p (file-path)
  (and (not (string-match-p my-logseq-exclude-pattern file-path))
       (let ((content-hash (org-roam-db--file-hash file-path))
             (db-hash (caar (org-roam-db-query [:select hash :from files
                                                :where (= file $s1)] file-path))))
         (not (string= content-hash db-hash)))))

(defun my-modified-logseq-files ()
  (emacsql-with-transaction (org-roam-db)
    (seq-filter 'my-roam-file-modified-p
                (org-roam--list-files my-logseq-folder))))

(defun my-check-logseq ()
  (interactive)
  (let (created
        files
        bufs
        unmodified
        cur
        bad
        buf)
    (setq files (org-roam--list-files my-logseq-folder))
    ;; make sure all the files have file ids
    (dolist (file-path files)
      (setq file-path (f-expand file-path))
      (setq cur (my-ensure-file-id file-path))
      (setq buf (cdr cur))
      (push buf bufs)
      (when (and (not (my-logseq-journal-p file-path)) (not buf))
        (push file-path bad))
      (when (not (buffer-modified-p buf))
        (push buf unmodified))
      (when (car cur)
        (push buf created)))
    ;; patch fuzzy links
    (mapc 'my-convert-logseq-file (seq-filter 'identity bufs))
    (dolist (buf unmodified)
      (when (buffer-modified-p buf)
        (save-buffer unmodified)))
    (mapc 'kill-buffer created)
    (when bad
      (message "Bad items: %s" bad))
    nil))
