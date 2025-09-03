;;;; $DOOMDIR/shortcuts.el -*- lexical-binding: t; -*-


;;; ziŝo

(def-find ezinit (zsh-path ".zshenv"))
(def-find ezmainfuns (zsh-path "+main.funs.sh"))
(def-find ezmainvars (zsh-path "+main.vars.sh"))
(def-find ezmainkeys (zsh-path "+main.keys.sh"))
(def-find ezmainmisc (zsh-path "+main.misc.sh"))
(def-find ezmainopts (zsh-path "+main.opts.sh"))
(def-find ezmainpost (zsh-path "+main.post.sh"))
(def-find ezappsfuns (zsh-path "+apps.funs.sh"))
(def-find ezappsvars (zsh-path "+apps.vars.sh"))
(def-find ezappspost (zsh-path "+apps.post.sh"))
(def-find ezchrootfuns (zsh-path "+chroot.funs.sh"))
(def-find ezmntfuns (zsh-path "+mnt.funs.sh"))
(def-find ezbackupsfuns (zsh-path "+backups.funs.sh"))
(def-find ezmachfuns (zsh-path "+mach.funs.sh"))
(def-find ezmachvars (zsh-path "+mach.vars.sh"))
(def-find ezprivfuns (zsh-path "+priv.funs.sh"))
(def-find ezlibsfuns (zsh-path "+libs.funs.sh"))
(def-find ezhistory (getenv "HISTFILE"))


;;; baŝo

(def-find ebinit (ef "~/.bashrc"))


;;; doom

(def-find edinit (my-doom-path "init.el"))
(def-find edconfig (my-doom-path "config.el"))
(def-find edpackages (my-doom-path "packages.el"))
(def-find eddefinitions (my-doom-path "+definitions.el"))
(def-find edlibraries (my-doom-path "+libraries.el"))
(def-find edsettings (my-doom-path "+settings.el"))
(def-find edshortcuts (my-doom-path "+shortcuts.el"))
(def-find edoverrides (my-doom-path "+overrides.el"))
(def-find edkeys (my-doom-path "+keys.el"))
(def-find edworkspaces (cc persp-save-dir "_workspaces"))


;;; lispo

(def-find elmain "~/Developer/etc/lisp/main.lisp")
(def-find elcommon "~/Developer/etc/lisp/common.lisp")
(def-find ellw "~/Developer/etc/lisp/lispworks.lisp")
(def-find elsbcl "~/Developer/etc/lisp/sbcl.lisp")


;;; stumpo

(def-find dstumpo "~/Developer/etc/stumpo/")
(def-find esokomuno (stumpwm-path "komuno.lisp"))
(def-find esocxefagordo (stumpwm-path "cxefagordo.lisp"))
(def-find esokomandoj (stumpwm-path "komandoj.lisp"))
(def-find esoklavoj (stumpwm-path "klavoj.lisp"))
(def-find esotranspasoj (stumpwm-path "transpasoj.lisp"))
(def-find esogrupoj (stumpwm-path "grupoj.lisp"))
(def-find esopostsxargo (stumpwm-path "postsxargo.lisp"))
(def-find esopelilo (stumpwm-path "pelilo.lisp"))


;;; nix

(def-find enixconf "~/.config/nix/nix.conf")
(def-find enixflake "~/etc/dev/flake.nix")
(def-find enixos "/sudo::/etc/nixos/configuration.nix")
(def-find enixdarwin "~/.config/nix-darwin/flake.nix")


;;; agorddosieroj

(def-find exsession "~/.xsession")
(def-find etmux "~/.tmux.conf")
(def-find esource-registry.conf "~/.config/common-lisp/source-registry.conf")
(def-find esource-registry.conf.d "~/.config/common-lisp/source-registry.conf.d")
(def-find egit "~/.gitconfig")
(def-find exmodmap "~/.Xmodmap")
(def-find exresources "~/.Xresources")
(def-find etouchegg "~/.config/touchegg/touchegg.conf")
(def-find essh "~/.ssh/config")
(def-find eirssi "~/.irssi/config")
(def-find ertorrent "~/.rtorrent.rc")
(def-find exmonad "~/.xmonad/xmonad.hs")
(def-find exbindkeys "~/.xbindkeysrc")
(def-find edevilspie2 "~/.config/devilspie2/devilspie2.lua")
(def-find eocaml "~/.ocamlinit")


;;; dosierujoj

(def-find ettt "~/Developer/src/ttt/ebzzry.github.io")
(def-find ettteo "~/Developer/src/ttt/ebzzry.github.io/fkd/eo")
(def-find ettten "~/Developer/src/ttt/ebzzry.github.io/fkd/en")
(def-find escripts "~/Developer/src/lispo/scripts/")


;;; haskelo

(def-find estack "~/.stack/config.yaml")


;;; qutebrowser

(def-find eqb "~/.qutebrowser/config.py")
(def-find eqbconfig "~/.qutebrowser/+main.config.py")
(def-find eqbkeys "~/.qutebrowser/+main.keys.py")
(def-find eqbsearch "~/.qutebrowser/+main.search.py")


;;; nyxt

(def-find enyxt "~/.config/nyxt/init.lisp")
(def-find engeneral "~/.config/nyxt/general.lisp")
(def-find enkeys "~/.config/nyxt/keys.lisp")
(def-find encommands "~/.config/nyxt/commands.lisp")
(def-find ensearch "~/.config/nyxt/search.lisp")
(def-find eninterface "~/.config/nyxt/interface.lisp")


;;; xdg

(def-find exdg "~/.config/user-dirs.dirs")


;;; gtk

(def-find egtk2 "~/.gtkrc-2.0")
(def-find egtk3 "~/.config/gtk-3.0/settings.ini")


;;; xcompose

(def-find excompose "~/Developer/etc/xcompose/.XCompose")
(def-find excsistemo "~/Developer/etc/xcompose/sistemo.xcompose")
(def-find exekstrajxoj "~/Developer/etc/xcompose/ekstrajxoj.xcompose")
(def-find excemogxioj "~/Developer/etc/xcompose/emogxioj.xcompose")


;;; openbox

(def-find eobrc "~/.config/openbox/rc.xml")
(def-find eobmenu "~/.config/openbox/menu.xml")


;;; fontconfig

(def-find efontconfig "~/.config/fontconfig/fonts.conf")


;;; bookmarks

(def-find ebookmarks "~/.emacs.d/.cache/bookmarks")
