# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Enirejfunkcio
#---------------------------------------------------------------------------------------------------

function backup () {
  local dir=/mnt/"${1}"/home

  m "${1}" && (
    s rz -v --delete --delete-excluded \
            --exclude "chrt/ubuntu/proc/" \
            --exclude "chrt/ubuntu/sys/" \
            --exclude "chrt/ubuntu/tmp/" \
            --exclude "chrt/ubuntu/home/" \
            --exclude "chrt/ubuntu/dev/" \
            --exclude "lost+found" \
            /home/ $dir
  )
}

function t () {
  local dato=$(date +"%Y%m%d%H%M")

  if (( ! $# )); then
    page $0
  else
    for target in $@; do
        case $target in
          b0|b1|b2) backup "${target}" ;;
          pando)
            rz! -v --delete \
                --exclude ".baf/" \
                --exclude ".zhistory" \
                --exclude ".Xauthority" \
                --exclude ".Xmodmap" \
                --exclude ".ssh" \
                --exclude ".xmonad" \
                --exclude ".tmux/resurrect" \
                --exclude ".wine" \
                --exclude ".cache" \
                --exclude ".slime" \
                --exclude ".opera" \
                --exclude ".ViberPC" \
                --exclude ".local/share/Steam" \
                --exclude ".local/share/Skullgirls/SaveData" \
                --exclude ".steam*" \
                --exclude ".vagrant.d" \
                --exclude ".hushlogin" \
                --exclude "hejmo/fkd/lispo/scripts/scripts" \
                --exclude "hejmo/fkd/lispo/baf/baf" \
                --exclude "hejmo/dat/iso" \
                /home/ebzzry/ pando.local:/home/ebzzry

            rz! -v --delete \
                --exclude "hejmo/fil/ludoj" \
                --exclude "hejmo/fil/fiziktauxgeco" \
                --exclude "hejmo/fil/filmoj" \
                --exclude "hejmo/dok/dentkuracado" \
                --exclude "hejmo/ludoj" \
                --exclude "hejmo/fkd/lispo/scripts/scripts" \
                --exclude "hejmo/fkd/lispo/baf/baf" \
                /home/pub/ pando.local:/home/pub
            ;;

          pegasus)
            rz -v --delete \
               --exclude out \
               --exclude streams \
               --exclude app/miki \
               --exclude node_modules \
               $HOME/hejmo/dat/mimix/fkd \
               pegasus.local:hejmo/dat/mimix

            rz -v --delete \
               $HOME/e/releases/streams \
               pegasus.local:e/releases

            rz -v --delete \
               --exclude .bin/gitstatus \
               --exclude arhxivo \
               $HOME/hejmo/ktp \
               $HOME/hejmo/fkd \
               pegasus.local:hejmo

            ;;

          mimix-windows)
            rz! -v --delete \
                $HOME/common-lisp/ mimix-windows:common-lisp
            ;;

          z|zisxo)
            local dest_dir=$HOME/hejmo/dat/zisxo/historio
            local dest_file=$dest_dir/.zhistory.${dato}.xz
            xz -z -c $HOME/.zhistory > $dest_file
            ln -sf $dest_file $dest_dir/latest
            ;;

          docjem)
            sue docjem rsync -avz \
                --exclude ".nix*" \
                --exclude ".ssh" \
                --exclude ".Trash" \
                --exclude "Library/" \
                --exclude "MobileSync/" \
                --exclude "Music/" \
                --exclude "Containers/" \
                --exclude "Desktop/DENTAL BOOKS" \
                --delete-excluded \
                pegasus.local: ~docjem
            ;;
        esac
    done
  fi
}
