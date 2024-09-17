# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# sistemspecifaj funkcioj

function os_test {
  if [[ $OS == $1 ]]; then
    return 0
  else
    return 1
  fi
}

function arch_test {
  if [[ $ARCH == $1 ]]; then
    return 0
  else
    return 1
  fi
}

function linux_test {
  if os_test linux; then return 0; else return 1; fi
}

function linux_x86_test {
  if os_test linux && (arch_test i686 || arch_test i386); then
    return 0
  else
    return 1
  fi
}

function linux_nixos_test {
  if linux_test; then
    if [[ -f /etc/nixos/configuration.nix  ]]; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

function linux_x86_64_test {
  if os_test linux && (arch_test x86_64); then
    return 0
  else
    return 1
  fi
}

function linux_pc_test {
  if linux_x86_test || linux_x86_64_test; then
    return 0
  else
    return 1
  fi
}

function freebsd_test {
  if os_test freebsd; then
    return 0
  else
    return 1
  fi
}

function darwin_test {
  if os_test darwin; then
    return 0
  else
    return 1
  fi
}

function bsd_test {
  if freebsd_test || darwin_test; then
    return 0
  else
    return 1
  fi
}

function unix_test {
  if os_test linux || os_test bsd; then
    return 0
  else
    return 1
  fi
}

freebsd_test && {
  function search {
    local type="$1"
    shift
    for i ($@) make -C /usr/ports search \
      ${type}="${i}" display=name,path,info
  }

  function searchname { search name $@ }
  function searchkey { search key $@ }
}

function print_sum {
  local check_sum=

  for i in "$@"; do
    if freebsd_test; then
      check_sum=$(md5 -r "$i" | awk '{print $1}')
    else
      check_sum=$($(hs tthsum sha256sum md5sum) "$i" | awk '{print $1}')
    fi

    print $check_sum[0,10]
  done
}

#———————————————————————————————————————————————————————————————————————————————
# diversaĵoj

linux_test && {
  export LSOPTS="-A -F --color"
}

freebsd_test || darwin_test && {
    export LSOPTS="-A -F -G"
  }

#———————————————————————————————————————————————————————————————————————————————
# malgrandaĵoj

linux_pc_test && {
  funs=(
    l "ls -tr $LSOPTS"
    la "ls $LSOPTS"
    ll "l -l"
    lk "la -l"
  ); def_funs
}

freebsd_test && {
  funs=(
    l "ls -tr $LSOPTS"
    la "ls $LSOPTS"
    ll "l -l"
    lk "la -l"
  ); def_funs
}

darwin_test && {
  funs=(
    l "eza -s modified -Ah"
    ll "eza -s modified -AhlO"
    la "eza -s name -Ah"
    lk "eza -s name -AhlO"
  ); def_funs
}

linux_test && {
  if uname -a | grep -iq synology_; then
    function sys { sudo initctl $@ }
  else
    function sys { sudo systemctl $@ }
    function list { sys list-units $@ }
  fi

  function stop { sys stop $@ }
  function start { sys start $@ }
  function restart { sys restart $@ }
  function status { sys status $@ }
  function scat { sys cat $@ }
  function logs { s journalctl -fu $@ }
}

darwin_test && {
  function sys { sudo launchctl $@ }
  function stop { sys stop $@ }
  function start { sys start $@ }
  function unload { sys unload $@ }
  function load { sys load $@ }
  function restart { rmap $1 stop start }
}

if linux_nixos_test; then
  function q {
    pgrep -alfi $@
  }
else
  function q {
    pgrep -alfi $@
  }
fi

linux_test && {
  function c {
    local sel=clipboard

    if [[ $# == 1 ]]; then
      if [[ -f "$1" ]]; then
        echo -n "$(fullpath $1)" | xclip -selection $sel
      else
        echo -n "$@" | xclip -selection $sel
      fi
    else
      xclip -selection $sel "$@"
    fi
  }

  function c@ { echo $@ | c }
  function c! { xsel -ib < "$1" }
  function c. { c "${PWD}" }
  function c/ { c "${PWD}/$1" }
}


darwin_test && {
  function c {
    if [[ $# == 1 ]]; then
      if [[ -f "$1" ]]; then
        echo -n "$(fullpath $1)" | pbcopy
      else
        echo -n "$@" | pbcopy
      fi
    else
      pbcopy "$@"
    fi
  }

  function c@ { echo $@ | c }
  function c! { pbcopy < "$1" }
  function c. { c "${PWD}" }
  function c/ { c "${PWD}/$1" }
}

darwin_test && {
  function o {
    if [[ $# == 0 ]]; then
      =open -a ForkLift "${PWD}"
    elif [[ -d $1 ]]; then
      =open -a ForkLift "$1"
    else
      =open "$@"
    fi
  }
}

linux_test && {
  function tex! {
    for file (${@:-*.tex}) { xelatex $file && evince ${file:r}.pdf }
  }
}

darwin_test && {
  function tex! {
    for file (${@:-*.tex}) { xelatex $file && open ${file:r}.pdf }
  }
}

linux_test && {
  function file {
    =file "$@"
  }
}

darwin_test && {
  function file {
    =file -h "$@"
  }
}

#———————————————————————————————————————————————————————————————————————————————

function rm! {
  if [[ "$1" == "${HOME}" || "$1" == "${HOME}/" || "$1" == "~" || "$1" == "~/" ]]; then
    return 1
  else
    =rm -rf $@
  fi
}
