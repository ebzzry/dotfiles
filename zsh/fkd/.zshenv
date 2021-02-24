# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Funkcioj
#---------------------------------------------------------------------------------------------------

function set_emulation () {
  emulate -R zsh
}

function create_env () {
  export ZHOME="$HOME/hejmo/ktp/zisxo"
  export ZSRC="$ZHOME/fkd"
  export ZLIB="$ZHOME/lib"
}

function load_files () {
  for modulo (
      bazaferoj.sxargxo

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
    ) [[ -f $ZHOME/fkd/$modulo.sh ]] && source $ZHOME/fkd/$modulo.sh
}


#---------------------------------------------------------------------------------------------------
# Ĉefenirejo
#---------------------------------------------------------------------------------------------------

function main () {
  set_emulation
  create_env
  load_files
}

main $@
