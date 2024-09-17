# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# malgrandaĵoj

funs=(
  dusb "d /mnt/usb"
  dmtp  "d /mnt/mtp"
  diso "d /mnt/iso"
  db0  "d /mnt/b0"
  db1  "d /mnt/b1"
  dnfs  "d /mnt/nfs"
  dssh  "d /mnt/ssh"
); def_funs

#———————————————————————————————————————————————————————————————————————————————
# funkcioj

function mountp {
  if mount | egrep -q "^$1"; then
    return 0
  else
    return 1
  fi
}

function muser {
  sudo mount -o uid=$(id -u) $@
}

function mvfat {
  muser -t vfat $@
}

function mount_usb {
  local index=${2:-0}
  local id=usb${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -e $1 ]]; then
    return 1
  else
    muser -t vfat $1 $mnt \
      || muser -t exfat $1 $mnt \
      || sudo lowntfs-3g -o uid=$(id -u) $1 $mnt \
      || mount -t hfsplus -o force,rw $1 $mnt \
      || mount $1 $mnt
  fi
}

function umount_usb {
  local index=${1:-0}
  local id=usb${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function mount_eusb {
  local index=${2:-0}
  local id=eusb${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -e $1 ]]; then
    return 1
  else
    mount_encrypted $1 $id $mnt
  fi
}

function umount_eusb {
  local index=${2:-0}
  local id=eusb${index}
  local mnt=/mnt/$id

  umount_encrypted $id
}

function mount_iso {
  local index=${2:-0}
  local id=iso${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -f $1 ]]; then
    return 1
  else
    sudo mount -o loop,ro $@ $mnt
  fi
}

function umount_iso {
  local index=${1:-0}
  local id=iso${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function loop_device {
  index=$(sudo losetup -a | sed -n -e 's/\(\/dev\/loop\)\(.\):.*/\2/;$p')

  if [[ -n "$index" ]]; then
    echo /dev/loop$((index+1))
  else
    echo /dev/loop0
  fi
}

function mount_elo {
  local index=${2:-0}
  local id=elo${index}
  local mnt=/mnt/$id
  local loop=$(loop_device)

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -f $1 ]]; then
    return 1
  else
    sudo losetup $loop $1
    mount_encrypted $loop $id $mnt
  fi
}

function umount_elo {
  local index=${1:-0}
  local id=elo${index}
  local mnt=/mnt/$id
  local loop=/dev/loop${index}

  umount_encrypted $id
  sudo losetup -d $loop
}

function mount_arc {
  local index=${2:-0}
  local id=arc${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if [[ ! -f $1 ]]; then
    return 1
  else
    archivemount $@ $mnt
  fi
}

function umount_arc {
  local index=${1:-0}
  local id=arc${index}
  local mnt=/mnt/$id

  umount $mnt
}

function mount_smb {
  local index=${3:-0}
  local id=smb${index}
  local mnt=/mnt/$id
  local share=${1}
  local username=${2:-$USER}

  if [[ ! -d ${mnt}/${share} ]]; then
    sudo mkdir -p ${mnt}/${share}
  fi

  sudo mount.cifs -o username=${username} //${share} ${mnt}/${share}
}

function umount_smb {
  local index=${2:-0}
  local id=smb${index}
  local mnt=/mnt/$id
  local share=${1}

  sudo umount ${mnt}/${share}
}

function mount_ssh {
  local dir=/mnt/ssh

  sshfs -o reconnect -C $@
}

function umount_ssh {
  local dir=/mnt/ssh

  fusermount -u $dir/$1
}

function mount_encrypted {
  local dev=$1
  local name=$2
  local mnt=$3

  if (( ! $#3 )); then
    return 1
  else
    if ! mountp /dev/mapper/${name}; then
      if [[ ! -d ${mnt} ]]; then sudo mkdir -p ${mnt}; fi
      if [[ -e ${dev} ]]; then
        sudo cryptsetup luksOpen ${dev} ${name} && \
          sudo mount /dev/mapper/${name} ${mnt}
      else
        return 1
      fi
    else
      return 1
    fi
  fi
}

function umount_encrypted {
  local name=$1

  if mountp /dev/mapper/${name}; then
    sudo umount /dev/mapper/${name}
  fi

  sudo cryptsetup luksClose ${name}
}

function mount_luks {
  if mount | egrep -q "^/dev/mapper/${1}"; then
    return 0
  else
    mount_encrypted /dev/disk/by-uuid/$2 $1 /mnt/$1
  fi
}

function mount_nfs {
  local index=${2:-0}
  local id=nfs${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  if ! mountp $1; then
    sudo mount.nfs -o nolock $1 $mnt
  else
    return 0
  fi

}

function umount_nfs {
  local index=${1:-0}
  local id=nfs${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}


function mount_mtp {
  local index=${2:-0}
  local id=mtp${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  mtp-detect
  sleep 10
  jmtpfs $mnt
}

function umount_mtp {
  local index=${1:-0}
  local id=mtp${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function mount_drive {
  local index=${1:-0}
  local id=drive${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  google-drive-ocamlfuse $mnt
}

function umount_drive {
  local index=${1:-0}
  local id=drive${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

function mount_s3 {
  local index=${2:-0}
  local id=s3${index}
  local mnt=/mnt/$id

  [[ ! -d $mnt ]] && mkdir -p $mnt

  s3fs $1 $mnt
}

function umount_s3 {
  local index=${1:-0}
  local id=s3${index}
  local mnt=/mnt/$id

  sudo umount $mnt
}

#———————————————————————————————————————————————————————————————————————————————
# ĉeffunkcioj

function mnt {
  local op=

  if (( ! $# )); then
    =mount
  else
    if [[ -e "$1" ]]; then
      sudo =mount "$@"
    else
      op=$1
      shift

      case $op in
        (b0) mount_luks b0 ef481397-bdec-4c10-b4e8-ac11682bed59 ;;
        (b1) mount_luks b1 4c65ec09-d9d6-4c64-92cc-ecb42139cb99 ;;
        (elo) mount_elo ${HOME}/Developer/dat/elo/kesto.elo ;;
        (usb) mount_usb $@ ;;
        (eusb) mount_eusb $@ ;;
        (iso) mount_iso $@ ;;
        (nfs) mount_nfs $@ ;;
        (mtp) mount_mtp $@ ;;
        (ssh) mount_ssh $@ ;;
        (drive) mount_drive $@ ;;
        (s3) mount_s3 $@ ;;
        (smb) mount_smb $@ ;;
      esac
    fi
  fi
}

function umnt {
  local op=

  if (( ! $# )); then
    page $0
  else
    if [[ -e "$1" ]]; then
      sudo =umount "$@"
    else
      op=$1
      shift

      case $op in
        (b0) umount_encrypted "${op}" ;;
        (b1) umount_encrypted "${op}" ;;
        (elo) umount_elo ${2:-0} ;;
        (usb) umount_usb ${2:-0} ;;
        (usbe) umount_usbe ${2:-0} ;;
        (iso) umount_iso ;;
        (nfs) umount_nfs ${2:-0} ;;
        (mtp) umount_mtp ${2:-0} ;;
        (ssh) umount_ssh $@ ;;
        (drive) umount_drive ;;
        (s3) umount_s3 ;;
      esac
    fi
  fi
}
