# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function set_emulation {
  emulate -R zsh
}

function create_env {
  export ZHOME="${HOME}/Developer/etc/zsh"
  export ZSRC="${ZHOME}/src"
  export ZLIB="${ZHOME}/lib"
}

function load_components {
  for component (
      main.pre
      main.funs
      main.vars
      mach.funs
      mach.vars
      apps.funs
      apps.vars
      apps.post
      main.keys
      main.misc
      backups.funs
      main.opts
      chroot.funs
      mnt.funs
      priv.funs
      main.post
    ) {
    local p="${ZHOME}/src/+${component}.sh"
    [[ -f "${p}" ]] && source "${p}"
  }
}

#———————————————————————————————————————————————————————————————————————————————
# ĉeffunkcioj

function main {
  set_emulation
  create_env
  load_components
}

main $@
