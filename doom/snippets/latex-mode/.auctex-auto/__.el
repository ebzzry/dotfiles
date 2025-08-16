;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "__"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "") ("fontenc" "T1") ("inputenc" "utf8") ("microtype" "")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "geometry"
    "fontenc"
    "inputenc"
    "microtype"))
 :latex)

