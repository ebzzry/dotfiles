#!/usr/bin/env -S zsh -f

#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function _k {
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

function k {
  local d=$(date +"%Y%m%d%H%M%S")
  local source=

  case $HOST in
  la-orka) dest=file:///Volumes/mycloud/$USER/la-orka ;;
  la-lorxu) dest=file:///mnt/mycloud/$USER/la-lorxu ;;
  *) source= ;;
  esac

  if ((!$#)); then
    page $0
  else
    for target in ${@}; do
      case $target in
      b0 | b1)
        _k "${target}"
        ;;
      la-lorxu | l)
        rz -v --delete \
          ${HOME}/{Desktop,Developer,Documents,Downloads,Music,Pictures} \
          --exclude vix/vix \
          --exclude miera/miera \
          --exclude "${HOME}/.cache/duplicity" \
          la-lorxu:
        ;;
      mycloud | m)
        duplicity --encrypt-key D3266144A7E25ACED810C26A43ED4CC742C8E019 \
          backup ${HOME} ${dest}
        ;;
      zsh | z)
        xz -z -c ${HOME}/.zhistory >${HOME}/dat/ziŝo/${d}.zhistory.xz
        ;;
      bookmarks | bm)
        xz -z -c ${HOME}/.emacs.d/.cache/bookmarks >${HOME}/dat/emacs/${d}.bookmarks.xz
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
