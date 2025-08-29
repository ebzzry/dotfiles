# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# sistemspecifaj funkcioj

def os_test {
  if [[ $OS == $1 ]]; then
    return 0
  else
    return 1
  fi
}

def arch_test {
  if [[ $ARCH == $1 ]]; then
    return 0
  else
    return 1
  fi
}

def linux_test {
  if os_test linux; then return 0; else return 1; fi
}

def linux_x86_test {
  if os_test linux && (arch_test i686 || arch_test i386); then
    return 0
  else
    return 1
  fi
}

def linux_nixos_test {
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

def linux_x86_64_test {
  if os_test linux && (arch_test x86_64); then
    return 0
  else
    return 1
  fi
}

def linux_pc_test {
  if linux_x86_test || linux_x86_64_test; then
    return 0
  else
    return 1
  fi
}

def freebsd_test {
  if os_test freebsd; then
    return 0
  else
    return 1
  fi
}

def darwin_test {
  if os_test darwin; then
    return 0
  else
    return 1
  fi
}

def bsd_test {
  if freebsd_test || darwin_test; then
    return 0
  else
    return 1
  fi
}

def unix_test {
  if os_test linux || os_test bsd; then
    return 0
  else
    return 1
  fi
}

freebsd_test && {
  def search {
    local type="$1"
    shift
    for i (${@}) make -C /usr/ports search \
      ${type}="${i}" display=name,path,info
  }

  def searchname { search name ${@} }
  def searchkey { search key ${@} }
}

def print_sum {
  local check_sum=

  for i in "${@}"; do
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

freebsd_test && {
  funs=(
    l "ls -tr $LSOPTS"
    la "ls $LSOPTS"
    ll "l -l"
    lk "la -l"
  ); def_funs
}

darwin_test || linux_pc_test && {
  funs=(
    l  "eza --no-quotes -s modified -Ah"
    ll "eza --no-quotes -s modified -AhlgO"
    la "eza --no-quotes  -s name -Ah"
    lk "eza --no-quotes -s name -AhlgO"
  ); def_funs
}

linux_test && {
  if uname -a | grep -iq synology_; then
    def sys { sudo initctl ${@} }
  else
    def sys { sudo systemctl ${@} }
    def list { sys list-units ${@} }
  fi

  def stop { sys stop ${@} }
  def start { sys start ${@} }
  def restart { sys restart ${@} }
  def status { sys status ${@} }
  def scat { sys cat ${@} }
  def logs { s journalctl -fu ${@} }
}

darwin_test && {
  def sys { sudo launchctl ${@} }
  def stop { sys stop ${@} }
  def start { sys start ${@} }
  def unload { sys unload ${@} }
  def load { sys load ${@} }
  def restart { rmap $1 stop start }
}

if linux_nixos_test; then
  def pg {
    pgrep -alfi ${@}
  }
else
  def pg {
    pgrep -alfi ${@}
  }
fi

linux_test && {
  def c {
    local sel=clipboard

    if [[ $# == 1 ]]; then
      if [[ -f "$1" ]]; then
        echo -n "$(fullpath $1)" | xclip -selection $sel
      else
        echo -n "${@}" | xclip -selection $sel
      fi
    else
      xclip -selection $sel "${@}"
    fi
  }

  def c! { xsel -ib < "$1" }
}

darwin_test && {
  def c {
    if [[ $# == 1 ]]; then
      if [[ -f "$1" ]]; then
        echo -n "$(fullpath $1)" | pbcopy
      else
        echo -n "${@}" | pbcopy
      fi
    else
      pbcopy "${@}"
    fi
  }

  def c! { pbcopy < "$1" }
}

def c@ { echo ${@} | c }
def c. { c "${PWD}" }
def c/ { c "${PWD}/$1" }

darwin_test && {
  def o {
    if [[ $# == 0 ]]; then
      =open -a Finder "${PWD}"
    elif [[ -d $1 ]] && [[ "${1:e}" != "app" ]]; then
      =open -a Finder "$1"
    else
      =open "${@}"
    fi
  }
}

linux_test && {
  def tex! {
    for file (${@:-*.tex}) { xelatex $file && evince ${file:r}.pdf }
  }
}

darwin_test && {
  def tex! {
    for file (${@:-*.tex}) { xelatex $file && open ${file:r}.pdf }
  }
}

linux_test && {
  def file {
    =file "${@}"
  }
}

darwin_test && {
  def file {
    =file -h "${@}"
  }
}
