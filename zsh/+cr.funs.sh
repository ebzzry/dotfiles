#!/usr/bin/env -S zsh -f

#———————————————————————————————————————————————————————————————————————————————
# mediaj variabloj

CHROOT=/home/chrt/ubuntu

#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function crmount {
  for i in proc sys tmp home dev mnt; do
    if [[ ! -d $1/$i ]]; then
      mkdir -p $1/$i
    fi

    sudo mount --bind /$i $1/$i
  done

  sudo mount --bind /dev/pts $1/dev/pts
}

function crumount {
  for i (proc sys tmp home dev mnt) {
    sudo umount -fl $1/$i
  }
}

function crm {
  crmount $1
}

function cru {
  crumount $CHROOT 2> /dev/null
}

function crch {
  sudo chroot ${@}
}

function crr {
  if ! mount | grep -q $1; then
    crm $1
  fi

  crch $1 ${argv[2,-1]}
}

function crs {
  crr $1 /usr/bin/sudo -i -u $USER ${argv[2,-1]}
}

function cre {
  if [[ -e $CHROOT ]]; then
    crs $CHROOT ${@}
  fi
}

function cr {
  if (( ! $#@ )); then
    cr ${${SHELL:t}:-sh}
  else
    cre zsh -c "cd \"$PWD\"; exec $*"
  fi
}
