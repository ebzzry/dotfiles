# -*- mode: sh -*-

function load_files () {
  for modulo (
    bazaferoj.variabloj
    aplikajxoj.variabloj
  ) { . $ZHOME/fkd/$modulo.sh }
}

function main () {
  load_files
}

main $@
