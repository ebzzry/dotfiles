#!/usr/bin/env -S zsh -f
# -*- mode: sh; coding: utf-8 -*-

function load_components {
  for component (
      main.vars
      apps.vars
    ) {
    local p="${ZSH_HOME}/+${component}.sh"
    [[ -f "${p}" ]] && source "${p}"
  }
}

function main {
  load_components
}

main ${@}
