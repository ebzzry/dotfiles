#!/bin/sh

export PATH="${PATH}:${HOME}/bin"

start_config() {
  xrdb -merge "${HOME}/.Xresources" &
  xmodmap "${HOME}/.Xmodmap" &
  xset r rate 250 &
}

start_apps() {
  xscreensaver -nosplash &
  xbindkeys &
}

start_wm() {
  exec sbcl --eval '(ql:quickload :stumpwm)' --eval '(stumpwm:stumpwm)'
}

main() {
  start_config
  start_apps
  start_wm
}

main "$@"
