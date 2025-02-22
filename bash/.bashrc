# -*- mode: sh; coding: utf-8 -*-

#--------------------------------------------------------------------------------
# mediaj variabloj

OS=$(uname)
PATH=$PATH:$HOME/bin:$HOME/.node/bin:/usr/local/bin
PS1="\e[1;36m\u\e[1;0m \e[1;37m\h\e[1;31m \e[1;32m\w\e[1;0m\n\e[1;32m\e[1m> \e[1;0m"
PROMPT_COMMAND="history -a"

#--------------------------------------------------------------------------------
# opcioj

shopt -s nocasematch

#--------------------------------------------------------------------------------
# alinomoj

case "${OS}" in
Darwin)
  alias l="ls -GFAtr"
  alias la="ls -GFAtrl"
  ;;
*)
  alias l="ls --color=auto -Atr"
  alias la="ls --color=auto -A"
  ;;
esac

alias d="cd"
alias ll="l -l"
alias lk="la -l"
alias v="less"
alias tm="tmux"
alias sc="screen"
alias rm!="rm -rf"
alias s="sudo"
alias dk="docker"
alias dkc="docker-compose"
alias q="exit"

alias status="sudo systemctl status"
alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias reload="sudo systemctl reload"

#-------------------------------------------------------------------------------
# funkcioj

function sagent {
  ssh-agent $SHELL "$@"
}

function sadd {
  ssh-add "$@"
}

function x {
  exit
}
