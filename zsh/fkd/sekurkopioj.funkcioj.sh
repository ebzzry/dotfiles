# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function backup {
  local dir=/mnt/"${1}"/home

  mnt "${1}" && (
    s rz -v --delete --delete-excluded \
      --exclude "chrt" \
      --exclude "lost+found" \
      /home/ $dir
  )
}

#———————————————————————————————————————————————————————————————————————————————
# ĉeffunkcioj

function t {
  local dato=$(date +"%Y%m%d%H%M")

  if (( ! $# )); then
    page $0
  else
    for target in $@; do
      case $target in
        (b0|b1) backup "${target}" ;;
        (la-vulpo)
          rz -v -n --delete \
             --exclude fkd/bin \
             --exclude fkd/lispo/scripts/scripts \
             --exclude fkd/lispo/pelo/pelo \
             --exclude fkd/lispo/barf/barf \
             $HOME/hejmo $HOME/Desktop $HOME/Downloads $HOME/Documents \
             la-vulpo:
          ;;
        (mycloud)
          rz -v --delete \
             /Volumes/ebzzry/ \
             /Volumes/la-azeno-1a/MyCloud/ebzzry/
          ;;
        z|zsh)
          xz -z -c $HOME/.zhistory > $HOME/hejmo/dat/zsh/${dato}.zhistory.xz
          ;;
        b|bookmarks|legosignoj)
          xz -z -c $HOME/.emacs.d/.cache/bookmarks > $HOME/hejmo/dat/emacs/${dato}.bookmarks.xz
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
