#!/usr/bin/env -S zsh -f

def load_components {
  for component (
      main.vars
      apps.vars
    ) {
    local p="${ZSH_HOME}/+${component}.sh"
    [[ -f "${p}" ]] && source "${p}"
  }
}

def main {
  load_components
}

main ${@}
