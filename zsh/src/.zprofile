# -*- mode: sh -*-

function load_components {
  for component (
      bazaferoj.variabloj
      aplikajxoj.variabloj
    ) [[ -f "${ZHOME}/src/${component}.sh" ]] && source "${ZHOME}/src/${component}.sh"
}

function main {
  load_components
}

main $@
