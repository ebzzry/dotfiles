# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Serĉdosierindikoj
#---------------------------------------------------------------------------------------------------

path=(
  $path
  $HOME/bin
  $HOME/.local/bin
  $HOME/.node/bin
)


#---------------------------------------------------------------------------------------------------
# Mediaj variabloj
#---------------------------------------------------------------------------------------------------

export EDITOR="e"
export VISUAL="$EDITOR"
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=1000000
export HISTSIZE=$SAVEHIST
export DIRSTACKSIZE=1000
export WORDCHARS="${WORDCHARS:s,/,,:s/-//:s/_//:s/.//}"
export FPATH=$FPATH:$ZHOME/bib:$HOME/.nix-profile/share/zsh/site-functions/
export PAGER="less"
export LESS="RfcmMib-1"
export LESSKEY=$HOME/.less
export LESSCHARSET="utf-8"
# export LSOPTS=
export LSCOLORS=ExFxBxDxCxegedabagacad
export XMODIFIERS="@im=none"
export BROWSER=
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export BINDIR=$HOME/bin
export NIX_REMOTE=daemon
export LOCALE_ARCHIVE=$(readlink ~/.nix-profile/lib/locale)/locale-archive
export CC=gcc
export QT_QPA_PLATFORMTHEME="gtk2"
export PYTHONIOENCODING=UTF-8
