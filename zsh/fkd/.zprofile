# -*- mode: sh -*-

function load_files {
  for modulo (
      bazaferoj.variabloj
      aplikajxoj.variabloj
    ) [[ -f "$ZHOME/fkd/${modulo}.sh" ]] && source "$ZHOME/fkd/${modulo}.sh"
}

function main {
  load_files
}

main $@
