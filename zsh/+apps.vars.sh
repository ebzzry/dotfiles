# -*- mode: sh -*-

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
  ${HOME}/.emacs.d/bin
  /Library/TeX/texbin
  /usr/local/mysql/bin
)

fpath=(
  ${ZSH_FNS}
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

#———————————————————————————————————————————————————————————————————————————————
# mediaj variabloj

export EDITOR="vi"
export VISUAL="${EDITOR}"
export HISTFILE="${HOME}/.zhistory"
export SAVEHIST=1000000
export HISTSIZE="${SAVEHIST}"
export DIRSTACKSIZE=1000
export WORDCHARS="${WORDCHARS:s,/,,:s/-//:s/_//:s/.//}"
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
