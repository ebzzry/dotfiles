;;;; -*- mode: emacs-lisp; coding: utf-8; lexical-binding: t -*-

;;; ziŝo
(def-find ezisxo (zsh-path "sl/zf"))
(def-find ezbsx (zsh-path "sl/bsx"))
(def-find ezbk (zsh-path "sl/bk"))
(def-find ezbc (zsh-path "sl/bc"))
(def-find ezbf (zsh-path "sl/bf"))
(def-find ezbv (zsh-path "sl/bv"))
(def-find ezmf (zsh-path "sl/mf"))
(def-find ezmv (zsh-path "sl/mv"))
(def-find ezaf (zsh-path "sl/af"))
(def-find ezav (zsh-path "sl/av"))
(def-find ezbo (zsh-path "sl/bo"))
(def-find ezbm (zsh-path "sl/bm"))
(def-find ezbp (zsh-path "sl/bp"))
(def-find ezap (zsh-path "sl/ap"))
(def-find eztf (zsh-path "sl/tf"))
(def-find ezsf (zsh-path "sl/sf"))
(def-find ezsxf (zsh-path "sl/sxf"))
(def-find ezpf (zsh-path "sl/pf"))

;;; baŝo
(def-find ebasxo (ef "~/.bashrc"))

;;; emakso
(def-switch escratch "*scratch*")
(def-find eemacs (emacs-path "fkd/.emacs"))
(def-find eemakso (emacs-path "fkd/.emacs"))
(def-find eegxeneralaj (emacs-path "fkd/gxeneralaj.el"))
(def-find eeklavoj (emacs-path "fkd/klavoj.el"))
(def-find eebibliotekoj (emacs-path "fkd/bibliotekoj.el"))
(def-find eetranspasoj (emacs-path "fkd/transpasoj.el"))
(def-find eeagordoj (emacs-path "fkd/agordoj.el"))
(def-find eetrovi (emacs-path "fkd/trovi.el"))
(def-find eeprivataj (emacs-path "fkd/privataj.el"))

;;; stumpo
(def-find dstumpo "~/hejmo/fkd/lispo/stumpo/")
(def-find eskomuno (stumpwm-path "komuno.lisp"))
(def-find escxefagordo (stumpwm-path "cxefagordo.lisp"))
(def-find eskomandoj (stumpwm-path "komandoj.lisp"))
(def-find esklavoj (stumpwm-path "klavoj.lisp"))
(def-find estranspasoj (stumpwm-path "transpasoj.lisp"))
(def-find esgrupoj (stumpwm-path "grupoj.lisp"))
(def-find espostsxargo (stumpwm-path "postsxargo.lisp"))
(def-find espelilo (stumpwm-path "pelilo.lisp"))

;;; agorddosieroj
(def-find enixos "/sudo::/etc/nixos/configuration.nix")
(def-find exsession "~/.xsession")
(def-find etmux "~/.tmux.conf")
(def-find esbcl "~/.sbclrc")
(def-find esource-registry.conf "~/.config/common-lisp/source-registry.conf")
(def-find esource-registry.conf.d "~/.config/common-lisp/source-registry.conf.d")
(def-find egit "~/.gitconfig")
(def-find exmodmap "~/.Xmodmap")
(def-find exresources "~/.Xresources")
(def-find etouchegg "~/.config/touchegg/touchegg.conf")
(def-find essh "~/.ssh/config")
(def-find eirssi "~/.irssi/config")
(def-find egit "~/.gitconfig")
(def-find ertorrent "~/.rtorrent.rc")
(def-find exmonad "~/.xmonad/xmonad.hs")
(def-find exbindkeys "~/.xbindkeysrc")
(def-find edevilspie2 "~/.config/devilspie2/devilspie2.lua")
(def-find eocaml "~/.ocamlinit")

;;; dosierujoj
(def-find dttt "~/hejmo/fkd/ttt/ebzzry.github.io")
(def-find dttteo "~/hejmo/fkd/ttt/ebzzry.github.io/eo/fkd")
(def-find dttten "~/hejmo/fkd/ttt/ebzzry.github.io/en/fkd")
(def-find dscripts "~/hejmo/fkd/lispo/scripts/")
(def-find epripensoj "~/hejmo/fkd/ttt/ebzzry.github.io/eo/fkd/pripensoj.md")
(def-find ereflections "~/hejmo/fkd/ttt/ebzzry.github.io/en/fkd/reflections.md")
(def-find ecitajxoj "~/hejmo/fkd/ttt/ebzzry.github.io/eo/fkd/citajxoj.md")
(def-find equotes "~/hejmo/fkd/ttt/ebzzry.github.io/en/fkd/quotes.md")

;;; diversaj
(def-find egx "~/hejmo/dok/notoj/writeily/gxeneralaj.md")
(def-find eai "~/hejmo/dok/notoj/writeily/ai.md")

;;; haskelo
(def-find estack "~/.stack/config.yaml")

;;; qutebrowser
(def-find eqb "~/.config/qutebrowser/config.py")
(def-find eqbgxeneralaj "~/.config/qutebrowser/fkd/gxeneralaj.py")
(def-find eqbklavoj "~/.config/qutebrowser/fkd/klavoj.py")
(def-find eqbtiparoj "~/.config/qutebrowser/fkd/tiparoj.py")
(def-find eqbalinomoj "~/.config/qutebrowser/fkd/alinomoj.py")
(def-find eqbsercxiloj "~/.config/qutebrowser/fkd/sercxiloj.py")
(def-find eqbetoso "~/.config/qutebrowser/fkd/etoso.py")
(def-find eqbprivataj "~/.config/qutebrowser/fkd/privataj.py")

;;; xdg
(def-find exdg "~/.config/user-dirs.dirs")

;;; nixos
(def-find enixos "/sudo::/etc/nixos/configuration.nix")

;;; baf
(def-find ebaf "~/common-lisp/baf/baf.lisp")

;;; gtk
(def-find egtk2 "~/.gtkrc-2.0")
(def-find egtk3 "~/.config/gtk-3.0/settings.ini")

;; xcompose
(def-find excompose "~/hejmo/ktp/xcompose/.XCompose")
(def-find excsistemo "~/hejmo/ktp/xcompose/sistemo.xcompose")
(def-find exekstrajxoj "~/hejmo/ktp/xcompose/ekstrajxoj.xcompose")
(def-find excemogxioj "~/hejmo/ktp/xcompose/emogxioj.xcompose")

;;; writeily
(def-find dw "~/hejmo/dok/notoj/writeily/")

;;; skullgirls
(def-find ecerebella "/pub/dok/ludoj/sg2e/fkd/cerebella.md")
(def-find epainwheel "/pub/dok/ludoj/sg2e/fkd/painwheel.md")
(def-find esquigly "/pub/dok/ludoj/sg2e/fkd/squigly.md")
(def-find ebigband "/pub/dok/ludoj/sg2e/fkd/big-band.md")
(def-find eparasoul "/pub/dok/ludoj/sg2e/fkd/parasoul.md")
(def-find edouble "/pub/dok/ludoj/sg2e/fkd/double.md")
(def-find eeliza "/pub/dok/ludoj/sg2e/fkd/eliza.md")
(def-find erobofortune "/pub/dok/ludoj/sg2e/fkd/robo-fortune.md")

;;; nix-shell
(def-find enlisp "~/h/fkd/templates/nix-shell/lisp/default.nix")

;;; openbox
(def-find eobrc "~/.config/openbox/rc.xml")
(def-find eobmenu "~/.config/openbox/menu.xml")

;;; fontconfig
(def-find efontconfig "~/.config/fontconfig/fonts.conf")
