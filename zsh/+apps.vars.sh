#!/usr/bin/env -S zsh -f
# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# dosierserĉindikoj

path=(
  $path
  ${HOME}/bin
  ${HOME}/.cargo/bin
  ${HOME}/.local/bin
  ${HOME}/.node/bin
  ${HOME}/.roswell/bin
  ${HOME}/go/bin
  /Library/TeX/texbin
  ${HOME}/Library/Python/3.8/bin
  ${HOME}/.emacs.d/bin
)

fpath=(
  $fpath
  /opt/homebrew/share/zsh/site-functions
)

#———————————————————————————————————————————————————————————————————————————————
# mediaj variabloj

export EDITOR="vi"
export VISUAL="$EDITOR"
export HISTFILE="${HOME}/.zhistory"
export SAVEHIST=1000000
export HISTSIZE=$SAVEHIST
export DIRSTACKSIZE=1000
export WORDCHARS="${WORDCHARS:s,/,,:s/-//:s/_//:s/.//}"
export FPATH=$FPATH:${ZHOME}/lib:${HOME}/.nix-profile/share/zsh/site-functions/
export PAGER="less"
export LESS="RfcmMib-1"
export LESSKEY=${HOME}/.less
export LESSCHARSET="utf-8"
export LSCOLORS=ExFxBxDxCxegedabagacad
export XMODIFIERS="@im=none"
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export BINDIR=${HOME}/bin
export NIX_REMOTE=daemon
export LOCALE_ARCHIVE=$(readlink ~/.nix-profile/lib/locale)/locale-archive
export CC=gcc
export QT_QPA_PLATFORMTHEME="gtk2"
export PYTHONIOENCODING=UTF-8
export XDG_DATA_DIRS=${XDG_DATA_DIRS}:/var/lib/flatpak/exports/share:${HOME}/.local/share/flatpak/exports/share
