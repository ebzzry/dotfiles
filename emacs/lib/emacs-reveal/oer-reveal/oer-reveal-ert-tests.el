;;; oer-reveal-ert-tests.el --- Tests for oer-reveal  -*- lexical-binding: t; -*-
;; SPDX-License-Identifier: GPL-3.0-or-later
;; SPDX-FileCopyrightText: 2019-2021 Jens Lechtenbörger

;;; Commentary:
;; Run tests interactively or as follows (probably with adjusted paths)
;; in batch mode:
;; emacs --batch -L ~/src/org-mode/testing -l org-test.el -L ../org-re-reveal -L . -l ert -l oer-reveal-ert-tests.el -f ert-run-tests-batch-and-exit

;;; Code:
(require 'oer-reveal)

;;; Test plugin functionality.
(ert-deftest parse-external-plugins ()
  "Test parsing of external plugin configuration."
  (let* ((tmp-file (make-temp-file "ert"))
         ;; Test case uses old plugin format.
         (oer-reveal-plugin-config
          '(("reveal.js-plugins"
             (:oer-reveal-audio-slideshow-dependency :oer-reveal-anything-dependency)
             (:oer-reveal-audio-slideshow-config :oer-reveal-anything-config))))
         (test-cases `((nil . nil)
                       ("nil" . nil)
                       ("()" . nil)
                       ("((p1 . \"one\"))" . ((p1 . "one")))
                       (((p1 . "one")) . ((p1 . "one")))
                       ("((p1 . \"one\") (p2 . \"two\"))" . ((p1 . "one") (p2 . "two")))
                       (((p1 . "one") (p2 . "two")) . ((p1 . "one") (p2 . "two")))
                       (,tmp-file . ((dummy . "one") (dummy . "two"))))))
    (unwind-protect
        (progn
          (write-region "one\ntwo" nil tmp-file)
          (dolist (test-case test-cases nil)
            (should (equal (oer-reveal--plugin-dependencies
                            `(:oer-reveal-plugins ()
                              :reveal-external-plugins ,(car test-case)
                              :oer-reveal-audio-slideshow-dependency "d1"
                              :oer-reveal-anything-dependency "d2"
                              :oer-reveal-audio-slideshow-config "c1"
                              :oer-reveal-anything-config "c2"))
                           (cdr test-case)))
            (should (equal (oer-reveal--plugin-dependencies
                            `(:oer-reveal-plugins ("reveal.js-plugins")
                              :reveal-external-plugins ,(car test-case)
                              :oer-reveal-audio-slideshow-dependency "d1"
                              :oer-reveal-anything-dependency "d2"
                              :oer-reveal-audio-slideshow-config "c1"
                              :oer-reveal-anything-config "c2"))
                           (append (cdr test-case)
                                   '((dummy . "d1") (dummy . "d2")))))
            (let ((oer-reveal-plugin-config '(("rp1" ("dp1" "dp2")))))
              (should (equal (oer-reveal--plugin-dependencies
                              `(:oer-reveal-plugins ("rp1")
                                :reveal-external-plugins ,(car test-case)))
                             (append (cdr test-case)
                                     '((dummy . "dp1") (dummy . "dp2"))))))))
      (delete-file tmp-file))))

(ert-deftest parse-init-script ()
  "Test parsing of external plugin configuration."
  (should (equal (oer-reveal--plugin-config
                  '(:oer-reveal-plugins ()
                    :reveal-init-script nil
                    :oer-reveal-audio-slideshow-dependency "d1"
                    :oer-reveal-anything-dependency "d2"
                    :oer-reveal-audio-slideshow-config "c1"
                    :oer-reveal-anything-config "c2"))
                   nil))
  (should (equal (oer-reveal--plugin-config
                  '(:oer-reveal-plugins ()
                    :reveal-init-script "init"
                    :oer-reveal-audio-slideshow-dependency "d1"
                    :oer-reveal-anything-dependency "d2"
                    :oer-reveal-audio-slideshow-config "c1"
                    :oer-reveal-anything-config "c2"))
                 (format oer-reveal-plugin-config-fmt "init")))
  (should (equal (oer-reveal--plugin-config
                  '(:oer-reveal-plugins ("reveal.js-plugins")
                    :reveal-init-script nil
                    :oer-reveal-audio-slideshow-dependency "d1"
                    :oer-reveal-anything-dependency "d2"
                    :oer-reveal-audio-slideshow-config "c1"
                    :oer-reveal-anything-config "c2"))
                 (concat
                  (format oer-reveal-plugin-config-fmt "c1")
                  (format oer-reveal-plugin-config-fmt "c2"))))
  (should (equal (oer-reveal--plugin-config
                  '(:oer-reveal-plugins ("reveal.js-plugins")
                    :reveal-init-script "c0"
                    :oer-reveal-audio-slideshow-dependency "d1"
                    :oer-reveal-anything-dependency "d2"
                    :oer-reveal-audio-slideshow-config "c1"
                    :oer-reveal-anything-config "c2"))
                 (concat
                  (format oer-reveal-plugin-config-fmt "c0")
                  (format oer-reveal-plugin-config-fmt "c1")
                  (format oer-reveal-plugin-config-fmt "c2")))))

;;; Test alternate type links, including parsing of GitLab URLs
(ert-deftest test-gitlab-urls ()
  "Test parsing of GitLab URLs."
  (should
   (equal (oer-reveal--parse-git-url "git@gitlab.com:oer/oer-reveal.git")
          (cons "https://gitlab.com/oer/oer-reveal"
                "https://oer.gitlab.io/oer-reveal")))
  (should
   (equal (oer-reveal--parse-git-url "git@gitlab.com:oer/oer-reveal")
          (cons "https://gitlab.com/oer/oer-reveal"
                "https://oer.gitlab.io/oer-reveal")))
  (should
   (equal (oer-reveal--parse-git-url "git@gitlab.com:oer/test/oer-reveal.git")
          (cons "https://gitlab.com/oer/test/oer-reveal"
                "https://oer.gitlab.io/test/oer-reveal")))
  (should
   (equal (oer-reveal--parse-git-url "https://gitlab.com/oer/oer-reveal.git")
          (cons "https://gitlab.com/oer/oer-reveal"
                "https://oer.gitlab.io/oer-reveal")))
  (should
   (equal (oer-reveal--parse-git-url "https://gitlab.com/oer/test/oer-reveal")
          (cons "https://gitlab.com/oer/test/oer-reveal"
                "https://oer.gitlab.io/test/oer-reveal")))
  (should
   (equal (oer-reveal--parse-git-url "https://gitlab.com/oer/test/oer-reveal.git")
          (cons "https://gitlab.com/oer/test/oer-reveal"
                "https://oer.gitlab.io/test/oer-reveal")))
  (should
   (equal (oer-reveal--parse-git-url "https://gitlab-ci-token:[MASKED]@gitlab.com/oer/test/oer-reveal.git")
          (cons "https://gitlab.com/oer/test/oer-reveal"
                "https://oer.gitlab.io/test/oer-reveal")))
  ;; Special treatment for GitLab Pages themselves.
  (should
   (equal (oer-reveal--parse-git-url "https://gitlab-ci-token:[MASKED]@gitlab.com/oer/oer.gitlab.io.git")
          (cons "https://gitlab.com/oer/oer.gitlab.io"
                "https://oer.gitlab.io/"))))

(ert-deftest test-alternate-types ()
  "Test generation of alternate type information."
  ;; Default value for oer-reveal-alternate-types, with link titles.
  (should (equal (oer-reveal-add-alternate-types
                  '("org" "pdf") "git" "example.org/" "presentation")
                 "#+HTML_HEAD: <link rel=\"alternate\" type=\"text/org\" href=\"git/blob/master/presentation.org\" title=\"Org mode source code of this OER HTML presentation with reveal.js\"/>
#+HTML_HEAD: <link rel=\"alternate\" type=\"application/pdf\" href=\"presentation.pdf\" title=\"PDF version of this OER HTML presentation with reveal.js\"/>
#+TITLE: @@latex:\\footnote{This PDF document is an inferior version of an \\href{example.org/presentation.html}{OER HTML presentation with reveal.js}; \\href{git}{free/libre Org mode source repository}.}@@
"))

  ;; Different wording for HTML documents.
  (should (equal (oer-reveal-add-alternate-types
                  '("org" "pdf") "git" "example.org/" "presentation" 'html)
                 "#+HTML_HEAD: <link rel=\"alternate\" type=\"text/org\" href=\"git/blob/master/presentation.org\" title=\"Org mode source code of this OER HTML page\"/>
#+HTML_HEAD: <link rel=\"alternate\" type=\"application/pdf\" href=\"presentation.pdf\" title=\"PDF version of this OER HTML page\"/>
#+TITLE: @@latex:\\footnote{This PDF document is an inferior version of an \\href{example.org/presentation.html}{OER HTML page}; \\href{git}{free/libre Org mode source repository}.}@@
"))

  ;; Links without title attribute.
  (let ((oer-reveal-with-alternate-types '("org" "pdf"))
        (oer-reveal-alternate-type-config
         '(("org" "text/org" "")
           ("pdf" "application/pdf" ""))))
    (should (equal (oer-reveal-add-alternate-types
                    '("org") "git" "example.org/" "presentation")
                   "#+HTML_HEAD: <link rel=\"alternate\" type=\"text/org\" href=\"git/blob/master/presentation.org\"/>
"))
    (should (equal (oer-reveal-add-alternate-types
                    '("pdf") "git" "example.org/" "foo/presentation")
                   "#+HTML_HEAD: <link rel=\"alternate\" type=\"application/pdf\" href=\"presentation.pdf\"/>
#+TITLE: @@latex:\\footnote{This PDF document is an inferior version of an \\href{example.org/foo/presentation.html}{OER HTML presentation with reveal.js}; \\href{git}{free/libre Org mode source repository}.}@@
"))))

;;; Test license attribution
(ert-deftest test-attribute-author ()
  "Tests for author attribution."
  (should
   (equal (oer-reveal--attribute-author
           "The Author" "https://example.org/" "Copyright (C) 2019" 'org)
          "Copyright (C) 2019 [[https://example.org/][The Author]]"))
  (should
   (equal (oer-reveal--attribute-author
           "The Author" "https://example.org/" "Copyright (C) 2019" 'html)
          "Copyright (C) 2019 <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/\" property=\"cc:attributionName\">The Author</a>"))
  (should
   (equal (oer-reveal--attribute-author
           "The Author" nil "Copyright (C) 2019" 'org)
          "Copyright (C) 2019 The Author"))
  (should
   (equal (oer-reveal--attribute-author
           "The Author" nil "Copyright (C) 2019" 'html)
          "Copyright (C) 2019 <span property=\"cc:attributionName\">The Author</span>"))
  (should
   (equal (oer-reveal--attribute-author
           "The Author" "https://example.org/"
           oer-reveal--default-copyright 'org)
          (concat oer-reveal--default-copyright
                  " [[https://example.org/][The Author]]")))
  (should
   (equal (oer-reveal--attribute-author
           "The Author" "https://example.org/"
           oer-reveal--default-copyright 'html)
          (concat oer-reveal--default-copyright
                  " <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/\" property=\"cc:attributionName\">The Author</a>")))
  (should
   (equal (oer-reveal--attribute-author
           nil nil "Copyright (C) 2019 The Author" 'org)
          "Copyright (C) 2019 The Author"))
  (should
   (equal (oer-reveal--attribute-author
           nil nil "Copyright (C) 2019 The Author" 'html)
          "Copyright (C) 2019 The Author"))
  (should
   (equal (oer-reveal--attribute-author
           nil nil oer-reveal--default-copyright 'org)
          ""))
  (should
   (equal (oer-reveal--attribute-author
           nil nil oer-reveal--default-copyright 'html)
          "")))

(defvar oer-metadata "((filename . \"./figures/doesnotexist.png\")
 (licenseurl . \"https://creativecommons.org/publicdomain/zero/1.0/\")
 (licensetext . \"CC0 1.0\")
 (dc:source . \"https://example.org/\")
 (sourcetext . \"Sample source\")
 (cc:attributionName . \"Jens Lechtenbörger\")
 (cc:attributionURL . \"https://gitlab.com/lechten\"))")
(defvar oer-metadata-gif "((filename . \"./figures/doesnotexist.gif\")
 (licenseurl . \"https://creativecommons.org/publicdomain/zero/1.0/\")
 (licensetext . \"CC0 1.0\")
 (dc:source . \"https://example.org/\")
 (sourcetext . \"Sample source\")
 (cc:attributionName . \"Jens Lechtenbörger\")
 (dcmitype . \"Image\"))")
(defvar oer-metadata-external "((filename . \"https://drawings.jvns.ca/drawings/process.svg\")
 (copyright . \"© 2016 Julia Evans, all rights reserved\")
 (permit . \"Displayed here with personal permission.\")
 (dc:source . \"https://drawings.jvns.ca/process/\")
 (sourcetext . \"julia's drawings\")
 (dc:title . \"What's in a process?\"))")
(ert-deftest test-meta-license-info ()
  "Tests for RDFa license information from figure meta data."
  (let ((meta (make-temp-file "oer.meta"))
        (meta-external (make-temp-file "oer-external.meta"))
        (meta-gif (make-temp-file "oer-gif.meta"))
        (oer-reveal-copy-dir-suffix "")
        (oer-reveal-rdf-typeof nil) ; No LearningResource
        (oer-reveal-rdf-caption-property "") ; No meta-data
        (oer-reveal-rdf-figure-typeof ""))
    (with-temp-file meta (insert oer-metadata))
    (with-temp-file meta-external (insert oer-metadata-external))
    (with-temp-file meta-gif (insert oer-metadata-gif))
    (let ((result
           (oer-reveal--attribution-strings meta))
          (result-external
           (oer-reveal--attribution-strings meta-external))
          (result-gif
           (oer-reveal--attribution-strings meta-gif))
          (result-short
           (oer-reveal--attribution-strings meta nil nil nil t))
          (result-full
           (oer-reveal--attribution-strings meta "A caption" "50vh" "figure fragment appear" nil nil "data-fragment-index=\"1\"")))
      (should (equal (car result)
                     "<div about=\"./figures/doesnotexist.png\" typeof=\"dcmitype:StillImage\" class=\"figure\"><p><img data-src=\"./figures/doesnotexist.png\" alt=\"Figure\" /></p><p></p><p>&ldquo;<span property=\"dcterms:title\">Figure</span>&rdquo; by <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://gitlab.com/lechten\" property=\"cc:attributionName\">Jens Lechtenbörger</a> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a>; from <a rel=\"dcterms:source\" href=\"https://example.org/\">Sample source</a></p></div>"))
      (should (equal (car result-external)
                     "<div about=\"https://drawings.jvns.ca/drawings/process.svg\" typeof=\"dcmitype:StillImage\" class=\"figure\"><p><img data-src=\"https://drawings.jvns.ca/drawings/process.svg\" alt=\"What's in a process?\" /></p><p></p><p>&ldquo;<span property=\"dcterms:title\">What's in a process?</span>&rdquo; © 2016 Julia Evans, all rights reserved; from <a rel=\"dcterms:source\" href=\"https://drawings.jvns.ca/process/\">julia's drawings</a>. Displayed here with personal permission.</p></div>"))
      (should (equal (car result-gif)
                     "<div about=\"./figures/doesnotexist.gif\" typeof=\"dcmitype:Image\" class=\"figure\"><p><img data-src=\"./figures/doesnotexist.gif\" alt=\"Figure\" /></p><p></p><p>&ldquo;<span property=\"dcterms:title\">Figure</span>&rdquo; by <span property=\"cc:attributionName\">Jens Lechtenbörger</span> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a>; from <a rel=\"dcterms:source\" href=\"https://example.org/\">Sample source</a></p></div>"))
      (should (equal (car result-short)
                     "<div about=\"./figures/doesnotexist.png\" typeof=\"dcmitype:StillImage\" class=\"figure\"><p><img data-src=\"./figures/doesnotexist.png\" alt=\"Figure\" /></p><p></p><p><a rel=\"dcterms:source\" href=\"https://example.org/\">Figure</a> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a></p></div>"))
      (should (equal (car result-full)
                     "<div about=\"./figures/doesnotexist.png\" typeof=\"dcmitype:StillImage\" class=\"figure fragment appear\" data-fragment-index=\"1\"><p><img data-src=\"./figures/doesnotexist.png\" alt=\"Figure\" style=\"max-height:50vh\" /></p><p>A caption</p><p style=\"max-width:50vh\">&ldquo;<span property=\"dcterms:title\">Figure</span>&rdquo; by <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://gitlab.com/lechten\" property=\"cc:attributionName\">Jens Lechtenbörger</a> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a>; from <a rel=\"dcterms:source\" href=\"https://example.org/\">Sample source</a></p></div>")))
    (delete-file meta)
    (delete-file meta-external)
    (delete-file meta-gif)))

(ert-deftest test-meta-schema-org ()
  "More tests for RDFa license information on figures."
  (let ((meta (make-temp-file "oer.meta"))
        (oer-reveal-copy-dir-suffix ""))
    (with-temp-file meta (insert oer-metadata))
    (let ((result
           (oer-reveal--attribution-strings meta "A caption"))
          (result-short
           (oer-reveal--attribution-strings meta nil nil nil t))
          (result-full
           (oer-reveal--attribution-strings meta "A caption" "50vh" "figure fragment appear" nil nil "data-fragment-index=\"1\"")))
      (should (equal (car result)
                     "<div about=\"./figures/doesnotexist.png\" typeof=\"schema:ImageObject schema:LearningResource dcmitype:StillImage\" class=\"figure\"><p><img data-src=\"./figures/doesnotexist.png\" alt=\"Figure\" /></p><p property=\"schema:caption\">A caption</p><p>&ldquo;<span property=\"dcterms:title\">Figure</span>&rdquo; by <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://gitlab.com/lechten\" property=\"cc:attributionName\">Jens Lechtenbörger</a> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a>; from <a rel=\"dcterms:source\" href=\"https://example.org/\">Sample source</a></p></div>"))
      (should (equal (car result-short)
                     "<div about=\"./figures/doesnotexist.png\" typeof=\"schema:ImageObject schema:LearningResource dcmitype:StillImage\" class=\"figure\"><p><img data-src=\"./figures/doesnotexist.png\" alt=\"Figure\" /></p><p></p><p><a rel=\"dcterms:source\" href=\"https://example.org/\">Figure</a> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a></p></div>"))
      (should (equal (car result-full)
                     "<div about=\"./figures/doesnotexist.png\" typeof=\"schema:ImageObject schema:LearningResource dcmitype:StillImage\" class=\"figure fragment appear\" data-fragment-index=\"1\"><p><img data-src=\"./figures/doesnotexist.png\" alt=\"Figure\" style=\"max-height:50vh\" /></p><p property=\"schema:caption\">A caption</p><p style=\"max-width:50vh\">&ldquo;<span property=\"dcterms:title\">Figure</span>&rdquo; by <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://gitlab.com/lechten\" property=\"cc:attributionName\">Jens Lechtenbörger</a> under <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">CC0 1.0</a>; from <a rel=\"dcterms:source\" href=\"https://example.org/\">Sample source</a></p></div>")))
    (delete-file meta)))

;;; Following function copied from org-mode/testing/lisp/test-ox.el.
;; Copyright (C) 2012-2016, 2019  Nicolas Goaziou
(defmacro org-test-with-parsed-data (data &rest body)
  "Execute body with parsed data available.
DATA is a string containing the data to be parsed.  BODY is the
body to execute.  Parse tree is available under the `tree'
variable, and communication channel under `info'."
  (declare (debug (form body)) (indent 1))
  `(org-test-with-temp-text ,data
     (org-export--delete-comment-trees)
     (let* ((tree (org-element-parse-buffer))
	    (info (org-combine-plists
		   (org-export--get-export-attributes)
		   (org-export-get-environment))))
       (org-export--prune-tree tree info)
       (org-export--remove-uninterpreted-data tree info)
       (let ((info (org-combine-plists
		    info (org-export--collect-tree-properties tree info))))
	 ,@body))))

(ert-deftest test-spdx-license-info ()
  "Tests for RDFa license information from SPDX headers."
  (let ((oer-reveal-copy-dir-suffix "")
        (oer-reveal-warning-delay nil)
        (oer-reveal-rdf-typeof nil) ; Test created before variable existed.
        (oer-reveal-rdf-prefixes "prefix=\"dc: http://purl.org/dc/elements/1.1/ dcterms: http://purl.org/dc/terms/ dcmitype: http://purl.org/dc/dcmitype/ cc: http://creativecommons.org/ns#\""))

    ;; Header with URL and single license.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n")
          (now "2019-12-27 Fri 19:19"))
      (should
       (equal (concat "<div class=\"rdfa-license\" about=\"test.html\" prefix=\"dc: http://purl.org/dc/elements/1.1/ dcterms: http://purl.org/dc/terms/ dcmitype: http://purl.org/dc/dcmitype/ cc: http://creativecommons.org/ns#\" typeof=\"dcmitype:InteractiveResource\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p>"
                      "<p class=\"date\">Created: <span property=\"dcterms:created\">"
                      now "</span></p></div>"
                      "\n" (oer-reveal--translate "en" 'legalese))
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html now "test.html" t t t))))
      (should
       (equal (concat "Except where otherwise noted, the work “A test”, © 2019 \\href{https://lechten.gitlab.io/#me}{Jens Lechtenbörger}, is published under the \\href{https://creativecommons.org/licenses/by-sa/4.0/}{Creative Commons license CC BY-SA 4.0}."
                      "\n\nCreated: " now)
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf now "dummy")))))

    ;; From now on, use empty string for German legalese (avoids display of
    ;; legalese).
    (setcdr (assoc 'legalese (assoc "de" oer-reveal-dictionaries)) "")

    ;; Different language and license, no prefix, no date, no legalese (empty string).
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>\n#+SPDX-License-Identifier: CC0-1.0\n#+LANGUAGE: de-de"))
      (should
       (equal "<div class=\"rdfa-license\" about=\"test.html\" typeof=\"dcmitype:InteractiveResource\"><p>Soweit nicht anders angegeben unterliegt das Werk „<span property=\"dcterms:title\">A test</span>“, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, der <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">Creative-Commons-Lizenz CC0 1.0</a>.</p></div>"
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html nil "test.html" nil t t))))
      (should
       (equal "Soweit nicht anders angegeben unterliegt das Werk „A test“, © 2019 \\href{https://lechten.gitlab.io/#me}{Jens Lechtenbörger}, der \\href{https://creativecommons.org/publicdomain/zero/1.0/}{Creative-Commons-Lizenz CC0 1.0}."
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf nil "dummy")))))

    ;; Multiple licenses, no typeof, no date, no legalese.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n#+SPDX-License-Identifier: CC0-1.0\n"))
      (should
       (equal "<div class=\"rdfa-license\" about=\"test.html\" prefix=\"dc: http://purl.org/dc/elements/1.1/ dcterms: http://purl.org/dc/terms/ dcmitype: http://purl.org/dc/dcmitype/ cc: http://creativecommons.org/ns#\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a> and the <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">Creative Commons license CC0 1.0</a>.</p></div>"
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html nil "test.html" t))))
      (should
       (equal "Except where otherwise noted, the work “A test”, © 2019 \\href{https://lechten.gitlab.io/#me}{Jens Lechtenbörger}, is published under the \\href{https://creativecommons.org/licenses/by-sa/4.0/}{Creative Commons license CC BY-SA 4.0} and the \\href{https://creativecommons.org/publicdomain/zero/1.0/}{Creative Commons license CC0 1.0}."
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf nil "dummy")))))

    ;; Multiple licenses with one (to be removed) duplicate.
    ;; Same output as previous case.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n#+SPDX-License-Identifier: CC0-1.0\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n"))
      (should
       (equal "<div class=\"rdfa-license\" about=\"test.html\" prefix=\"dc: http://purl.org/dc/elements/1.1/ dcterms: http://purl.org/dc/terms/ dcmitype: http://purl.org/dc/dcmitype/ cc: http://creativecommons.org/ns#\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a> and the <a rel=\"license\" href=\"https://creativecommons.org/publicdomain/zero/1.0/\">Creative Commons license CC0 1.0</a>.</p></div>"
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html nil "test.html" t))))
      (should
       (equal "Except where otherwise noted, the work “A test”, © 2019 \\href{https://lechten.gitlab.io/#me}{Jens Lechtenbörger}, is published under the \\href{https://creativecommons.org/licenses/by-sa/4.0/}{Creative Commons license CC BY-SA 4.0} and the \\href{https://creativecommons.org/publicdomain/zero/1.0/}{Creative Commons license CC0 1.0}."
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf nil "dummy")))))

    ;; Header with e-mail address instead of HTTP URI, with single license.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <mail@example.org>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n"))
      (should
       (equal "Except where otherwise noted, the work “A test”, © 2019 Jens Lechtenbörger, is published under the \\href{https://creativecommons.org/licenses/by-sa/4.0/}{Creative Commons license CC BY-SA 4.0}."
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf nil "dummy")))))

    ;; Header without URL/e-mail address, with single license, neither prefix nor typeof.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n"))
      (should
       (equal "<div class=\"rdfa-license\" about=\"test.html\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <span property=\"cc:attributionName\">Jens Lechtenbörger</span></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p></div>"
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html nil "test.html")))))

    ;; Multiple authors with URLs and single license.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Alice <https://example.org/#alice>\n#+SPDX-FileCopyrightText: 2017-2019 Bob <https://example.org/#bob>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n")
          (now "2019-12-27 Fri 19:19"))
      (should
       (equal "<div class=\"rdfa-license\" about=\"test.html\" prefix=\"dc: http://purl.org/dc/elements/1.1/ dcterms: http://purl.org/dc/terms/ dcmitype: http://purl.org/dc/dcmitype/ cc: http://creativecommons.org/ns#\" typeof=\"dcmitype:InteractiveResource\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#bob\" property=\"cc:attributionName\">Bob</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#alice\" property=\"cc:attributionName\">Alice</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p></div>"
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html nil "test.html" t t))))
      (should
       (equal (concat "Except where otherwise noted, the work “A test”, © 2017-2019 \\href{https://example.org/#bob}{Bob} and © 2019 \\href{https://example.org/#alice}{Alice}, is published under the \\href{https://creativecommons.org/licenses/by-sa/4.0/}{Creative Commons license CC BY-SA 4.0}."
                      "\n\nCreated: " now)
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf now "dummy")))))

    ;; Previous case but with subtitle.
    (let ((header "#+TITLE: A test:\n#+SUBTITLE: With subtitle\n#+SPDX-FileCopyrightText: 2019 Alice <https://example.org/#alice>\n#+SPDX-FileCopyrightText: 2017-2019 Bob <https://example.org/#bob>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n")
          (now "2019-12-27 Fri 19:19"))
      (should
       (equal "<div class=\"rdfa-license\" about=\"test.html\" prefix=\"dc: http://purl.org/dc/elements/1.1/ dcterms: http://purl.org/dc/terms/ dcmitype: http://purl.org/dc/dcmitype/ cc: http://creativecommons.org/ns#\" typeof=\"dcmitype:InteractiveResource\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test: With subtitle</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#bob\" property=\"cc:attributionName\">Bob</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#alice\" property=\"cc:attributionName\">Alice</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p></div>"
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html nil "test.html" t t))))
      (should
       (equal (concat "Except where otherwise noted, the work “A test: With subtitle”, © 2017-2019 \\href{https://example.org/#bob}{Bob} and © 2019 \\href{https://example.org/#alice}{Alice}, is published under the \\href{https://creativecommons.org/licenses/by-sa/4.0/}{Creative Commons license CC BY-SA 4.0}."
                      "\n\nCreated: " now)
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'pdf now "dummy")))))

    ;; Unknown license.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <mail@example.org>\n#+SPDX-License-Identifier: CC-BY-SA-42\n"))
      (should-error
       (org-test-with-parsed-data
        header
        (oer-reveal-license-to-fmt 'pdf nil "dummy"))))

    ;; Missing license.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <mail@example.org>\n#+SPDX-Nonsense: CC-BY-SA-42\n"))
      (should-error
       (org-test-with-parsed-data
        header
        (oer-reveal-license-to-fmt 'html nil "dummy"))))

    ;; Missing copyright years.
    (let ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: Jens Lechtenbörger <mail@example.org>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n"))
      (should-error
       (org-test-with-parsed-data
        header
        (oer-reveal-license-to-fmt 'pdf t "dummy")))
      (should-error
       (org-test-with-parsed-data
        header
        (oer-reveal-license-to-fmt 'html t "dummy"))))))

(ert-deftest test-rdf-typeof ()
  "Tests for RDFa typeof information."
  (let ((oer-reveal-copy-dir-suffix "")
        (oer-reveal-warning-delay nil))

    ;; Header with URL and single license.
    (let* ((header "#+TITLE: A test\n#+SPDX-FileCopyrightText: 2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>\n#+SPDX-License-Identifier: CC-BY-SA-4.0\n")
           (typeof '("dcmitype:InteractiveResource" "schema:LearningResource"))
           (header-typeof (concat header
                                  (concat "#+OER_REVEAL_RDF_TYPEOF: "
                                          (prin1-to-string typeof)
                                          "\n")))
           (now "2019-12-27 Fri 19:19"))
      ;; Default settings for typeof.
      (should
       (equal (concat "<div class=\"rdfa-license\" about=\"test.html\" "
                      oer-reveal-rdf-prefixes
                      " typeof=\""
                      (string-join oer-reveal-rdf-typeof " ")
                      "\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p>"
                      "<p class=\"date\">Created: <span property=\"dcterms:created\">"
                      now "</span></p></div>"
                      "\n" (oer-reveal--translate "en" 'legalese))
	      (org-test-with-parsed-data
               header
	       (oer-reveal-license-to-fmt 'html now "test.html" t t t))))
      ;; Use custom typeof.
      (should
       (equal (concat "<div class=\"rdfa-license\" about=\"test.html\" "
                      oer-reveal-rdf-prefixes
                      " typeof=\"" (string-join typeof " ")
                      "\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p>"
                      "<p class=\"date\">Created: <span property=\"dcterms:created\">"
                      now "</span></p></div>"
                      "\n" (oer-reveal--translate "en" 'legalese))
	      (org-test-with-parsed-data
               header-typeof
	       (oer-reveal-license-to-fmt 'html now "test.html" t t t))))
      ;; Create typeof for text document (instead of default presentation).
      (should
       (equal (concat "<div class=\"rdfa-license\" about=\"test.html\" "
                      oer-reveal-rdf-prefixes
                      " typeof=\""
                      (string-join (cons "schema:TextDigitalDocument" typeof) " ")
                      "\"><p>Except where otherwise noted, the work “<span property=\"dcterms:title\">A test</span>”, <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>, is published under the <a rel=\"license\" href=\"https://creativecommons.org/licenses/by-sa/4.0/\">Creative Commons license CC BY-SA 4.0</a>.</p>"
                      "<p class=\"date\">Created: <span property=\"dcterms:created\">"
                      now "</span></p></div>"
                      "\n" (oer-reveal--translate "en" 'legalese))
	      (org-test-with-parsed-data
               header-typeof
	       (oer-reveal-license-to-fmt 'html now "test.html" t t t t)))))))


;;; Test helper functions.
(ert-deftest test-copy-dir-suffix ()
  (should-not (oer-reveal--copy-for-export "http://example.org/fig.png"))
  (should-not (oer-reveal--copy-for-export "https://example.org/fig.png"))
  (let* ((dir1 "test-copy-dir-suffix1")
         (dir2 "./test-copy-dir-suffix2")
         (dir3 ".test-copy-dir-suffix3")
         (dir4 "./.test-copy-dir-suffix4")
         (dir5 "test-copy-dir-suffix5/dir")
         (dirs `(,dir1 ,dir2 ,dir3 ,dir4 ,dir5))
         (simple-dirs `(,dir1 ,dir2 ,dir3 ,dir4))
         (file "file")
         (contents "Moin"))
    (unwind-protect
        (progn
          (dolist (dir dirs)
            (make-directory dir t)
            (let ((filename (concat (file-name-as-directory dir) file)))
              (append-to-file contents nil filename)
              (oer-reveal--copy-for-export filename)))
          (dolist (dir simple-dirs)
            (let ((target (concat (file-name-as-directory
                                   (concat dir oer-reveal-copy-dir-suffix))
                                  file)))
              (should (equal contents (oer-reveal--file-as-string target)))))
          (should (equal contents (oer-reveal--file-as-string
                                   (concat "test-copy-dir-suffix5"
                                           oer-reveal-copy-dir-suffix
                                           "/dir/" file)))))
      (dolist (dir dirs)
        (when (file-readable-p dir)
          (delete-directory dir t))
        (when (file-readable-p (concat dir oer-reveal-copy-dir-suffix))
          (delete-directory (concat dir oer-reveal-copy-dir-suffix) t)))
      (when (file-readable-p "test-copy-dir-suffix5")
        (delete-directory "test-copy-dir-suffix5" t))
      (when (file-readable-p (concat "test-copy-dir-suffix5"
                                     oer-reveal-copy-dir-suffix))
        (delete-directory (concat "test-copy-dir-suffix5"
                                  oer-reveal-copy-dir-suffix)
                          t)))))

(ert-deftest test-explode-range ()
  (should (equal (oer-reveal--explode-range "1") '(1)))
  (should (equal (oer-reveal--explode-range "1-3") '(1 2 3)))
  (should-error (oer-reveal--explode-range "1-2-3"))
  (should-error (oer-reveal--explode-range "3-1")))

(ert-deftest test-merge-years-with-merge ()
  (let ((oer-reveal-use-year-ranges-p t))
    (should (equal (oer-reveal--merge-years '()) ""))
    (should (equal (oer-reveal--merge-years '("2020")) "2020"))
    (should (equal (oer-reveal--merge-years '("2020" "2020")) "2020"))
    (should (equal (oer-reveal--merge-years '("2020" "2018")) "2018, 2020"))
    (should (equal (oer-reveal--merge-years '("2019" "2020")) "2019-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019" "2020" "2018")) "2018-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019" "2020" "2018" "2019")) "2018-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2018")) "2018-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2018" "2019")) "2018-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2018-2019")) "2018-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2017")) "2017, 2019-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2014" "2015" "2019-2020" "2017"))
                   "2014-2015, 2017, 2019-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2014-2015" "2019-2020" "2017"))
                   "2014-2015, 2017, 2019-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2016" "2014-2015" "2019-2020" "2017"))
                   "2014-2017, 2019-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2018" "2016" "2014-2015" "2019-2020" "2017"))
                   "2014-2020"))
    (should (equal (oer-reveal--merge-years
                    '("2018" "2016" "2014-2023" "2019-2020" "2017"))
                   "2014-2023"))))

(ert-deftest test-merge-years-without-merge ()
  (let (oer-reveal-use-year-ranges-p)
    (should (equal (oer-reveal--merge-years '("2020")) "2020"))
    (should (equal (oer-reveal--merge-years '("2020" "2020")) "2020"))
    (should (equal (oer-reveal--merge-years '("2020" "2018")) "2018, 2020"))
    (should (equal (oer-reveal--merge-years '("2019" "2020")) "2019, 2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019" "2020" "2018")) "2018, 2019, 2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019" "2020" "2018" "2019")) "2018, 2019, 2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2018")) "2018, 2019, 2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2018" "2019")) "2018, 2019, 2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2018-2019")) "2018, 2019, 2020"))
    (should (equal (oer-reveal--merge-years
                    '("2019-2020" "2017")) "2017, 2019, 2020"))))

(ert-deftest test-aggregate-creators ()
  (let ((jl-single "2020 Jens Lechtenbörger <https://lechten.gitlab.io/#me>")
        (jl-error "2020 Jens Lechtenbörger <https://lechten.gitlab.io/#42>")
        (jl-part "2020 Jens Lechtenbörger")
        (jl-range "2017-2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>"))
    (should-error (oer-reveal--aggregate-creators (list jl-single jl-error)))
    (should
     (equal (gethash "Jens Lechtenbörger"
                     (oer-reveal--aggregate-creators (list jl-single)))
            (cons (list "2020") "https://lechten.gitlab.io/#me")))
    (should
     (equal (gethash "Jens Lechtenbörger"
                     (oer-reveal--aggregate-creators (list jl-part)))
            (cons (list "2020") nil)))
    (should
     (equal (gethash "Jens Lechtenbörger"
                     (oer-reveal--aggregate-creators (list jl-single jl-part)))
            (cons (list "2020" "2020") "https://lechten.gitlab.io/#me")))
    (should
     (equal (gethash "Jens Lechtenbörger"
                     (oer-reveal--aggregate-creators (list jl-part jl-single)))
            (cons (list "2020" "2020") "https://lechten.gitlab.io/#me")))
    (should
     (equal (gethash "Jens Lechtenbörger"
                     (oer-reveal--aggregate-creators (list jl-range)))
            (cons (list "2017-2019") "https://lechten.gitlab.io/#me")))
    (should
     (equal (gethash "Jens Lechtenbörger"
                     (oer-reveal--aggregate-creators (list jl-single jl-range)))
            (cons (list "2017-2019" "2020") "https://lechten.gitlab.io/#me")))))

(ert-deftest test-convert-creators ()
  (let ((jl-single "2020 Jens Lechtenbörger <https://lechten.gitlab.io/#me>")
        (jl-part "2020 Jens Lechtenbörger")
        (jl-old "2000 Jens Lechtenbörger")
        (jl-range "2017-2019 Jens Lechtenbörger <https://lechten.gitlab.io/#me>")
        (jl-split "2017-2018, 2020 Jens Lechtenbörger <https://lechten.gitlab.io/#me>")
        (alice "2019 Alice <https://example.org/#alice>")
        (bob "2017-2019 Bob <https://example.org/#bob>"))
    (should
     (equal (oer-reveal--convert-creators (list jl-single) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))
    (should
     (equal (oer-reveal--convert-creators (list jl-split) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2018, 2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))
    (should
     (equal (oer-reveal--convert-creators
             (list jl-single jl-part) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))
    (should
     (equal (oer-reveal--convert-creators
             (list jl-part jl-range) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))
    (should
     (equal (oer-reveal--convert-creators
             (list jl-single jl-range) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))
    (should
     (equal (oer-reveal--convert-creators
             (list jl-single jl-range jl-old) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2000, 2017-2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))

    ;; Two authors.  Sorted by date.
    (should
     (equal (oer-reveal--convert-creators
             (list alice jl-single) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#alice\" property=\"cc:attributionName\">Alice</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))

    ;; Two authors with same years, sorted by name.
    (should
     (equal (oer-reveal--convert-creators
             (list jl-range bob) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#bob\" property=\"cc:attributionName\">Bob</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span>"))

    ;; Two authors, one with merged entries, sorted by years.
    (should
     (equal (oer-reveal--convert-creators
             (list jl-range bob jl-old) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2000, 2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#bob\" property=\"cc:attributionName\">Bob</a></span>"))

    ;; More authors.
    (should
     (equal (oer-reveal--convert-creators
             (list jl-range alice jl-single jl-part bob jl-old) 'html " and ")
            "<span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2000, 2017-2020</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://lechten.gitlab.io/#me\" property=\"cc:attributionName\">Jens Lechtenbörger</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2017-2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#bob\" property=\"cc:attributionName\">Bob</a></span> and <span property=\"dc:rights\">© <span property=\"dcterms:dateCopyrighted\">2019</span> <a rel=\"cc:attributionURL dcterms:creator\" href=\"https://example.org/#alice\" property=\"cc:attributionName\">Alice</a></span>"))
    ))

(ert-deftest check-years ()
  (with-temp-buffer
    (let (oer-reveal-spdx-author)
      ;; Buffers without SPDX headers are current.
      (should (oer-reveal--copyright-is-current-p))
      (insert "Some random text.\n")
      (should (oer-reveal--copyright-is-current-p))

      ;; Tests with SPDX header.
      (insert "# SPDX-FileCopyrightText: 2019 Alice <alice@example.org>\n")
      (should (oer-reveal--copyright-is-current-p "2019"))
      (should-not (oer-reveal--copyright-is-current-p "2020"))

      ;; This test was created in 2020.  So, 2019 is not current.
      (should-not (oer-reveal--copyright-is-current-p))

      (insert "# SPDX-FileCopyrightText: 2020 Bob <bob@example.org>\n")
      (should (oer-reveal--copyright-is-current-p "2020"))

      ;; Look for specific authors.
      (let ((oer-reveal-spdx-author "Alice"))
        (should (oer-reveal--copyright-is-current-p "2019"))
        (should-not (oer-reveal--copyright-is-current-p "2020")))
      (let ((oer-reveal-spdx-author "Charlie"))
        (should-not (oer-reveal--copyright-is-current-p "2019"))
        (should-not (oer-reveal--copyright-is-current-p "2020"))))))

(ert-deftest check-figure-path ()
  (let ((metaname "figures/meta/foo.meta")
        (uri "https://example.com/foo.png")
        (figpath1 "./figures/meta/foo.png")
        (figpath2a "figures/meta/foo.png")
        (figpath2b "foo.png"))
    (should (equal uri (oer-reveal--figure-path uri metaname)))
    (should (equal figpath1 (oer-reveal--figure-path figpath1 metaname)))
    (should (equal figpath2a (oer-reveal--figure-path figpath2a metaname)))
    (should (equal figpath2a (oer-reveal--figure-path figpath2b metaname)))
    (let ((oer-reveal-figures-dir ""))
      (should (equal figpath2b (oer-reveal--figure-path figpath2b metaname))))))

(ert-deftest check-concat-props ()
  (let ((p0 (list))
        (p1 (list 't1 "test1"))
        (p2 (list 't2 "test2"))
        (p3 (list 't1 "test1" 't2 "test2")))
    (should (equal (oer-reveal--concat-props 't1 't2 p0) ""))
    (should (equal (oer-reveal--concat-props 't1 't2 p0 "\n") ""))
    (should (equal (oer-reveal--concat-props 't1 't2 p1) "test1"))
    (should (equal (oer-reveal--concat-props 't1 't2 p1 "\n") "test1"))
    (should (equal (oer-reveal--concat-props 't2 't1 p1) "test1"))
    (should (equal (oer-reveal--concat-props 't2 't1 p1 "\n") "test1"))
    (should (equal (oer-reveal--concat-props 't1 't2 p2) "test2"))
    (should (equal (oer-reveal--concat-props 't1 't2 p2 "\n") "test2"))
    (should (equal (oer-reveal--concat-props 't1 't2 p3) "test1test2"))
    (should (equal (oer-reveal--concat-props 't1 't2 p3 "\n") "test1\ntest2"))
    (should (equal (oer-reveal--concat-props 't2 't1 p3) "test2test1"))
    (should (equal (oer-reveal--concat-props 't2 't1 p3 "\n") "test2\ntest1"))))
;;; oer-reveal-ert-tests.el ends here
