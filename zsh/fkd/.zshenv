# -*- mode: sh; coding: utf-8 -*-


#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function set_emulation {
  emulate -R zsh
}

function create_env {
  export ZHOME="$HOME/hejmo/ktp/zsh"
  export ZSRC="$ZHOME/fkd"
  export ZLIB="$ZHOME/bib"
}

function load_files {
  for modulo (
      bazaferoj.sxargo

      bazaferoj.funkcioj
      bazaferoj.variabloj

      masxinoj.funkcioj
      masxinoj.variabloj

      aplikajxoj.funkcioj
      aplikajxoj.variabloj
      aplikajxoj.poste

      bazaferoj.klavoj
      bazaferoj.miksajxo

      sekurkopioj.funkcioj

      bazaferoj.opcioj

      radiksxangxado.funkcioj
      surmetoj.funkcioj

      privataj.funkcioj

      bazaferoj.poste

      #bibliotekoj.funkcioj
    ) if [[ -f "$ZHOME/fkd/${modulo}.sh" ]]; then
    source "$ZHOME/fkd/${modulo}.sh"
  fi
}

#———————————————————————————————————————————————————————————————————————————————
# ĉeffunkcioj

function main {
  set_emulation
  create_env
  load_files
}

main $@
