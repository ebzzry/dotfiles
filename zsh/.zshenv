#!/usr/bin/env -S zsh -f

#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function set_emulation {
  emulate -R zsh
}

function create_env {
  export ZSH_HOME="${HOME}/etc/zsh"
  export ZSH_FNS="${HOME}/etc/zsh-fns"
}

function load_components {
  for component (
      main.pre
      main.vars
      main.funs
      main.opts

      mach.funs
      mach.vars

      apps.funs
      git.funs
      apps.vars

      main.keys
      main.misc
      priv.funs

      k.funs
      cr.funs
      mnt.funs

      main.post
      apps.post
    ) {
    local file="${ZSH_HOME}/+${component}.sh"
    if [[ -f "${file}" ]]; then
      source "${file}"
    fi
  }
}

#———————————————————————————————————————————————————————————————————————————————
# ĉeffunkcioj

function main {
  set_emulation
  set_emulation
  create_env
  load_components
}

main ${@}
