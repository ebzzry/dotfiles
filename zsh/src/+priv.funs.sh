# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# ĉefaferoj

function copy {
  rz --exclude '.git*'\
    --exclude 'README.md' \
    --exclude 'LEGUMIN.md' \
    --exclude 'MINLEGU.md' \
    --exclude 'LICENSE.md' \
    --exclude 'PERMESILO.md' \
    --exclude '*~' \
    --exclude '*.o' \
    --exclude '*.hi' \
    --exclude '*.errors' \
    --exclude '*-x86_64-linux' \
    --exclude 'qsettings' \
    --exclude 'quickmarks' \
    --exclude 'bookmarks' \
    --delete-excluded $@
}

#———————————————————————————————————————————————————————————————————————————————
# enirejfunkcioj

function dotfiles! {
  local d="${HOME}/Developer/etc"

  ddotfiles rm! .git

  # tmux
  copy --exclude 'resurrect/' \
    --exclude 'plugins/' \
    ${d}/tmux/ tmux

  # ziŝo
  copy --exclude 'backups.funs.sh' \
    --exclude 'priv.funs.sh'  \
    ${d}/zsh/ zsh

  # lispo
  copy ${d}/lisp/ lisp

  # doom
  copy ${d}/doom/ doom

  # baŝo
  copy ${d}/bash/ bash

  # inputrc
  copy ${d}/readline/ readline

  # emakso
  copy --exclude 'privataj.el' \
    --exclude 'neuzitaj.el' \
    --exclude 'var/' \
    --exclude 'lib/google' \
    --exclude 'lib/framerd' \
    ${d}/emacs/ emacs

  # vim
  copy ${d}/vim/ vim

  # Xmodmap
  copy ${d}/xmodmap/*.xmap xmodmap

  # xresources
  copy ${d}/xresources/ xresources

  # xcompose
  copy ${d}/xcompose/ xcompose

  # xmonad
  copy ${d}/xmonad/ xmonad

  # nixpkgs
  copy ${d}/nixpkgs/nixpkgs/ nixpkgs

  # qutebrowser
  copy --exclude 'src/priv.main.py' \
    --exclude 'src/priv.search.py' \
    --exclude 'src/priv.keys.py' \
    --exclude 'autoconfig.yml' \
    --exclude 'qsettings' \
    --exclude 'bookmarks' \
    --exclude 'quickmarks' \
    ${d}/qutebrowser/qutebrowser/ qutebrowser

  # fontconfig
  copy ${d}/fontconfig/ fontconfig

  # nyxt
  copy ${d}/nyxt/ nyxt

  # iterm2
  copy --exclude 'makefile' \
    ${d}/iterm2/ iterm2

  git i '[top-level] re-initialize'
  git reao git@github.com:ebzzry/dotfiles.git
  git oo!
}

function mycloud {
  o smb://ebzzry@MyCloudEX2Ultra._smb._tcp.local/$@
}

function mc {
  mycloud ebzzry/Developer/$@
}

function tars! {
  tarsnap -vcHf $(date +"%Y%m%d%H%M")-zvw \
    --nodump \
    ~/org \
    ~/icloud/{Strongbox,Desktop} \
    ~/Developer/{etc,src} \
    ~/Pictures/Private \
    ~/Documents/Private \
    ~/Music/Private
}

#———————————————————————————————————————————————————————————————————————————————
# difinoj

funs=(
  # Valmiz
  dv "d ${HOME}/v"
  dvalmiz "dcl d valmiz"
  dmarie "dcl d marie"
  dmeria "dcl d meria"
  dveda "dcl d veda"
  dvera "dcl d vera"
  dvega "dcl d vega"
  dvela "dcl d vela"
  dvix "dcl d vix"

  ddoadm "dvalmiz d fkd/doadm"
  dvgadm "dvalmiz d fkd/vgadm"
  doadm "+ ddoadm ./doadm"
  vgadm "+ dvgadm ./vgadm"

  dicloud "d ${HOME}/icloud"

  ff "find_file"
  e "find_file"

  dworkspaces "d ${HOME}/Developer/etc/workspaces"
); def_funs
