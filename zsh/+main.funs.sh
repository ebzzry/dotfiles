# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# ĉefaferoj

def load {
  if [[ -e "$1" ]]; then source "$1"; fi
}

def bye {
  if (( ! $#BUFFER )); then
    exit
  else
    zle delete-char-or-list
  fi
}; zle -N bye

def defalias {
  eval "function $1 { $2 \${@} }"
}

def reset-terminal {
  =reset
}; zle -N reset-terminal

def error {
  if [[ "${OS}" == "Darwin" ]]; then
    echo "ERROR: ${@}" >&2
  else
    echo -e "\e[0;31m\e[1mERROR: \e[0;0m${@}" >&2
  fi

  return 1
}

def warning {
  if [[ "${OS}" == "Darwin" ]]; then
    echo "WARNING: ${@}" >&2
  else
    echo -e "\e[0;33mWARNING: \e[0;0m${@}" >&2
  fi

  return 1
}

def copy-region {
  zle kill-region
  zle yank
}; zle -N copy-region

def casedown {
  if [[ $# -eq 0 ]]; then
    while read i; do _casedown "${i}"; done
  else
    for i ("${@}") _casedown "${i}"
    fi
}

def caseup {
  if [[ $# -eq 0 ]]; then
    while read i; do _caseup "${i}"; done
  else
    for i ("${@}") _caseup "${i}"
    fi
}

def export_exists {
  for i (${argv[2,-1]}) {
    if wh $i; then
      export ${argv[1]}=$i
      break
    fi
  }
}

def extn {
  if [[ -z "${1:e}" ]]; then
    print "data"
  else
    print "${1:e}"
  fi
}

def op {
  case $1 in
    (l|ls)   print "command ls" ;;
    (m|mv)   print "command mv" ;;
    (m!|mv!) print "command mv -f";;
    (c|cp)   print "command cp -rpi" ;;
    (c!|cp!) print "command cp -rpf" ;;
    (*) return 1 ;;
  esac
}

autoload print_sum

def dosum {
  local op="$(op $argv[1])"
  for i ($argv[2,-1]) {
    case $argv[1] in
      (l|ls)
        [[ -f $i ]] && print $(print_sum $i) $i
        ;;
      (*)
        ${(s. .)op} -- "$i" "$(print_sum $i).$(extn $i)"
        ;;
    esac
  }
}

def print_date {
  print $(stat --format='%y' -- "$1" | sed 's/\(....-..-..\)\ \(..:..:..\..........\)\ \(\+..\)\(..\)/\1T\2\3:\4/')
}

def do_date {
  local op="$(op $argv[1])"
  for i ($argv[2,-1]) {
    case $argv[1] in
      (l|ls)
        [[ -f $i ]] && print $(print_date $i) $i
        ;;
      (*)
        ${(s. .)op} -- "$i" "$(print_date $i).$(extn $i)"
        ;;
    esac
  }
}

def do_back {
  local op="$(op $argv[1])"
  for i ($argv[2,-1]) {
    if [[ -e ${i}.sk ]]; then
      print $0: ${i}.sk already exists.
      return 1
    else
      ${(s. .)op} ${i} ${i}.sk
    fi
  }
}

def unsav {
  if [[ ${1:e} == "sav" ]]; then
    mv $1 ${1:r}
  fi
}

def unfn {
  if (( $#1 )); then
    which $1 | sed -e '1d;$d;s/	//g;s/\$\@/\"${@}\"/;s/\"\"\$\@\"\"/\"${@}\"/'
  fi
}

def exfun {
  if (( $#1 )); then
    which $1 | sed -e '1d;$d;s/	//g;s/\$\@//'
  fi
}

def shebang {
  case "$1" in
    (sh) sed -i -e '1i#!/usr/bin/env sh' "$2" ;;
    (zsh) sed -i -e '1i#!/usr/bin/env zsh' "$2" ;;
  esac
}

def mkbin {
  local dir=$1
  local type=$2

  for i (${argv[3,-1]}) {
    autoload $i

    if [[ ! -f $dir/$i ]]; then
      unfn $i >! $dir/$i
      chmod +x $dir/$i

      case $type in
        (sh) shebang sh $dir/$i ;;
        (zsh) shebang zsh $dir/$i ;;
      esac
    fi
  }
}

def zb {
  local dir=${HOME}/bin
  local bin=(fx frm! len leo @)

  (
    cd $dir
    for i ($bin) {
      [[ -f "$i" ]] && rm -f "$i"
    }
  )

  mkbin $dir zsh $bin
}

def functionp {
  local arg="$(which $1 | sed -n '1s/^\(.\).*/\1/p')"

  if [[ ! $arg[1] == "/" ]]; then
    return 0
  else
    return 1
  fi
}

def s2 {
  if functionp $1; then
    sudo zsh -c ${@}
    # s2 $(exfun $1) ${argv[2,-1]}
  else
    sudo ${@}
  fi
}

autoload service_command

def sdisable {
  for i ("${@}") {
    update-rc.d -f "$i" remove _
    update-rc.d "$i" stop 99 0 1 2 3 4 5 6 . _
  }
}

def senable {
  for i ("${@}") {
    update-rc.d "$1" defaults _
  }
}

def cf {
  if [[ $# -gt 1 ]]; then
    x="$1"; shift 1
    print "${@}" >| "$x"
  fi
}

def f_bins {
  local type="$argv[1]"
  for i ($argv[2,-1]) {
    if [[ -e "$i" ]]; then
      find "$i" -maxdepth 1 -type ${type} -iname '*bin*' | sort
    fi
  }
}

def f_dirs {
  if [[ -d $1 ]]; then
    find $1 -maxdepth 1 -type d
  fi
}

def cd! {
  [[ ! -d "${@}" ]] && mkdir -p "${@}"
  builtin cd ${@}
}

def cd/ {
  builtin cd "$(dirname $(fullpath $1))"
}

def cdx/ {
  if (( ! $#@ )); then
    builtin cd
  elif [[ -d $argv[1] ]]; then
    cd/ "$(fullpath $argv[1])"
    $argv[2,-1]
  else
    echo "$0: no such file or directory: $1"
  fi
}

def cdx {
  if (( ! $#@ )); then
    builtin cd
  elif [[ -d $argv[1] ]]; then
    builtin cd "$(fullpath $argv[1])"
    $argv[2,-1]
  elif [[ "$1" = -<-> ]]; then
    builtin cd $1 > /dev/null 2>&1
    $argv[2,-1]
  else
    echo "$0: no such file or directory: $1"
  fi
}

def cdx@ { (cdx "${@}") }

def cdx! {
  mkdir -p $argv[1]
  cdx "${@}"
}

def cdx@! { (cdx! "${@}") }

def xd { (cd ${@}) }

def mk_dir {
  [[ $# -eq 2 ]] && {
    eval "function d${1} { cdx $2 \${@} }"
  }
}

def mk_dirs {
  while [[ $# -ge 2 ]]; do
    mk_dir "$1" "$2"; shift 2
  done
}

def def_dirs {
  mk_dirs $dirs
  unset dirs
}

def def_cd {
  local x=

  ## dosierujoj
  for i ("$1" $(find $1 -maxdepth 1 -type d)) {
    if [[ "${1:t}" == "${i:t}" ]]; then
      x="${1:t}"
    else
      x="${1:t}${i:t}"
    fi

    for j (${x}) {
      mk_dir "${j:l}" "$i"
    }
  }
}

def def_cdx {
  for cd ($CDX) {
    if [[ -d "${cd}" ]]; then
      def_cd "${cd}"
    fi
    unset CDX
  }
}

#———————————————————————————————————————————————————————————————————————————————
# invitaj konstruiloj

def prompt_color { export PS1="$PS1_COLOR" RPS1= }
def prompt_plain { export PS1="$PS1_PLAIN" RPS1= }
def prompt_color_e { export PS1="$PS1_COLOR_E" RPS1= }

#———————————————————————————————————————————————————————————————————————————————
# alinomoj kaj difinoj

def def_real_alias {
  while [[ $# -ge 2 ]]; do
    alias "$1=$2"
    shift 2
  done
}

def def_real_aliases {
  def_real_alias $real_aliases
  unset real_aliases
}

def def_global_alias {
  while [[ $# -ge 1 ]]; do
    alias -g "$1"
    shift 1
  done
}

def def_global_aliases {
  def_global_alias $global_aliases
  unset global_aliases
}

def def_comp {
  while [[ $# -ge 2 ]]; do
    wh "${2}" && compdef "${1}"="${2}"
    # wh $2 && compdef "$1=$2"
    shift 2
  done
}

def def_comps {
  def_comp $comps
  unset $comps
}

def def_program_alias {
  while [[ $# -ge 1 ]]; do
    alias -s "$1"
    shift 1
  done
}

def def_program_aliases {
  def_program_alias $program_aliases
  unset program_aliases
}

def def_fun {
  while [[ $# -ge 2 ]]; do
    eval "function $1 { $2 \${@} }"
    shift 2
  done
}

def def_fun {
  while [[ $# -ge 2 ]]; do
    if [[ ${2[1]} == "+" ]]; then
      eval "function $1 { ( ${2[3,-1]} \${@}) }"
      shift 2
    else
      eval "function $1 { $2 \${@} }"
      shift 2
    fi
  done
}

def def_funs {
  def_fun $funs
  unset funs
}

def def_option { for i ("${@}") setopt $i }

def def_options { def_option $zsh_options; unset zsh_options }

def def_cat {
  while [[ $# -ge 2 ]]; do
    eval "function cat${1} { s cat $2 }"
    eval "function vi${1} { s vi $2 }"
    eval "function v${1} { s v $2 }"
    eval "function e${1} { e $2 }"
    shift 2
  done
}

def def_cats { def_cat $cats; unset cats }

def def_key {
  while [[ $# -ge 2 ]]; do
    bindkey "$1" "$2"
    shift 2
  done
}

def def_keys {
  def_key $keys
  unset keys
}

def def_out_key {
  while [[ $# -ge 2 ]]; do
    bindkey -s "$1" "$2"
    shift 2
  done
}

def def_out_keys {
  def_out_key $out_keys
  unset out_keys
}

def def_mk {
  eval "function ${argv[1]} {
            if [[ \$# -ge 2 ]]; then
                if [[ ! -e \${@: -1} ]]; then
                     mkdir -p \${@: -1}
                fi

                command ${argv[2,-1]} \${@}
            fi
        }"
}

def def_home_funs {
  if [[ -d ${HOME}/Developer && "`find ${HOME} -maxdepth 1 -type d -empty -name Developer`" != "${HOME}/Developer" ]] then
     for i (${HOME}/Developer/*(/)) {
       local base=`basename $i`
       if [[ -d $i ]]; then
         eval "function $base { cdx \${HOME}/Developer/$base \"\${@}\" }"
       fi
     }
     fi
}

#———————————————————————————————————————————————————————————————————————————————
# retkonektado

def hostmatch {
  [[ $# -eq 1 ]] &&
    cat /etc/hosts |
      sed -n "/^${1}./p" |
      awk '{print $1}'
}

def ip_addr_cidr {
  [[ $# -eq 1 ]] &&
    ip addr show $1 |
      grep 'inet ' |
      awk '{print $2}'
}

def subnet_24 {
  autoload ip_addr
  [[ $# -eq 1 ]] &&
    ip_addr $1 |
      awk -F "." '{$4=""; print $0}' |
      sed -e 's/\ /./g;s/\.$//'
}

def hosts_all {
  printf "%s.1-254\n" $1
}

def subnet {
  print $2 | cut -d . -f 1-$(($1/8))
}

#———————————————————————————————————————————————————————————————————————————————
# miksaĵo

def cpdate {
  for i ($2/*) {
    if [[ "`stat $i G Modify A '{print $1}'`" == "$1" ]]; then
      rz $i $3
    fi
  }
}

def fx {
  local result=

  if (( $#1 )); then
    result=$($FIND . -iname "*${argv[1]}*" -print0)

    if [[ $# -gt 1 ]]; then
      echo -n ${result} | $XARGS -I % -0 ${argv[2,-1]}
    else
      echo -n ${result} | $XARGS -I % -0 echo %
    fi
  else
    return 1
  fi
}

def frm! {
  fx ${@} rm -rvf %
}

def fdate {
  # fe 2014-02-14 2014-02-15 ...
  # find . -type f -newermt $1 ! -newermt $2 -exec ${argv[3,-1]} \;
  find . -type f -newermt $1 ! -newermt $2 -print0 | xargs -I % -0 -exec ${argv[3,-1]}
}

def ftoday {
  fdate yesterday today echo %
}

#function zm { z $1 && tex2png $1 && b ${i:r}.png }

# map command arg1 arg2
def map {
  for i in ${argv[2,-1]}; do "$1" "${i}"; done
}

# rmap arg command1 command2
def rmap {
  for i in ${argv[2,-1]}; do $i ${1}; done
}

def rmap {
  for cmd (${argv[2,-1]}) { ${(ps: :)${cmd}} ${1} }
}

def mapl {
  setopt local_traps

  trap 'return 1' HUP INT TERM ABRT

  while read i; do
    if [[ -n "$i" ]]; then
      ${argv[1,-2]} "$i"
    fi
  done < ${argv[-1]}
}

def rmapl {
  setopt local_traps

  local file=$1
  shift

  trap 'return 1' HUP INT TERM ABRT

  while read -r line; do
    if [[ -n "$line" ]]; then
      ${@} "$line"
    fi
  done < "$file"
}

def mapd {
  for i in ${argv[2,-1]}; do
    cdx@ $i $(echo ${argv[1]} | sed "s/\"//;s/\'//")
  done
}

def print_non_empty_lines {
  while read i; do
    if [[ -n "$i" ]]; then
      print $i
    fi
  done < "${@}"
}

def purge_files {
  for i ($(find $1 | sed 1d)) {
    rm -rf $i
  }
}

def sumcol {
  if [[ $# -eq 2 ]]; then
    cat "$2" | awk "{sum += \$$1} END {print sum}"
  fi
}

def lsfonts {
  identify -list font | grep Font | awk '{print $2}'
}

def printcat {
  for i ("${@}") {
    printf "$i: "
    cat $i }
}

def printcatdir {
  for i (`find "${@}" -type f`) {
    printcat $i
  }
}

def def_lib {
  if [[ -d $ZLIB ]]; then
    for i ($(find $ZLIB -type f \( ! -name '*__' \))) . $i
    fi
}

def def_opt {
  if [[ -d $ZOPT ]]; then
    for i ($(find $ZOPT -type f \( ! -name '*.ex' \))) source $i
    fi
}

def call_if_null {
  if [[ $# -eq 2 ]]; then
    print $2
  else
    print `$1`
  fi
}

def durh {
  echo $#
  if [[ $# -ge 2 ]]; then
    du "${argv[2,-1]}" | sort -rh | head -n "$1"
  fi
}

def subnet {
  echo $(default_network | sed -e 's|.0/.*||')$1
}

def def_bracket {
  eval "\
    function ${1}b {
        if (( \$#@ == 2 )); then
            $1 \$1 \$2\ \[\$1:r\].\$(extn \$1)
        else
            return 1
        fi
    }"
}; #map def_bracket cp mv

def time2seconds {
  local time=$1
  local hours=`echo $time | cut -d : -f 1`
  local minutes=`echo $time | cut -d : -f 2`
  local seconds=`echo $time | cut -d : -f 3`

  echo "($hours * 3600) + ($minutes * 60) + $seconds" | bc
}


def mkf {
  eval "function foo { ${@} }"
  echo foo
}

def mkshorts {
  for i (${@}) {
    for j (. @ /) {
      eval "function ${i}${j} { ${i} *(${j}) \"\${@}\" }"
    }
  }
}; mkshorts la ll lf lk l1 lr la ls

def mvpwd {
  local dot_name="`pwd`"
  local new_name="$(dirname $dot_name)/$1"

  mv "$dot_name" "$new_name" && cd "$new_name"
}

def rme! {
  for i (*.${1}) {
    rm $i
  }
}

def rex {
  for var (${@}) {
    read -s ${var}\?"$var: "
    echo ''
    export $var
  }
}

def chrootp {
  if [[ ! "`ls -id / | cut -d \  -f 1`" == 2 ]]; then
    return 0
  else
    return 1
  fi
}

def all_true {
  for i (${argv[2,-1]}) {
    if ! $1 $i; then
      return 1
    fi
  }
      return 0
}

def some_true {
  for i (${argv[2,-1]}) {
    if $1 $i; then
      return 0
    fi
  }
      return 1
}

def rm! {
  for entry in "$@"; do
    if [[ -d "${entry}" ]]; then
      fd -tf -x shred -fzun 10 --remove {} \; . "${entry}"
      command rm -rf "${entry}"
    else
      shred -fzun 10 --remove "${entry}"
    fi
  done
}

def wrap {
  local cmd=$1
  shift
  eval $cmd
  ${@}
  eval $cmd
}

def free! {
  wrap 'free -h' suc 'sync; echo 3 > /proc/sys/vm/drop_caches; s swapoff -a; s swapon -a'
}

def defown {
  eval "function $1 {
          s $2 \${argv[2,-1]}
          s chown -R \$1 \${argv[-1]}
        }"
}

defown raown 'rsync -avz'
defown cpown 'cp -af'
defown mvown 'mv -f'

def dls {
  if [[ $# == 0 ]]; then
    dirs -v
  else
    builtin cd -${1}
  fi
}

def touchx {
  if (( $#1 )); then
    touch $1
    chmod +x $1
  fi
}

def z! {
  dirs -lv | awk -F '\t' '{print $2}' | tac >! ${HOME}/.z
  exec zsh
}

def z+ {
  if [[ -f ${HOME}/.z ]]; then
    local pwd=$PWD

    while read -r line; do
      pushd "$line"
    done < ${HOME}/.z

    pushd $pwd
  fi
}

def mv+ {
  if [[ $# -eq 2 && -d $2 ]]; then
    mv! $1 $2
  else
    if [[ -d ${argv[-1]} ]]; then
      for file in ${argv[1,-2]}; do
        md ${argv[-1]}/${file:r}
        mv $file ${argv[-1]}/${file:r}
      done
    fi
  fi
}

def 0 {
  echo ${@} > /dev/null 2>&1
}

def % {
  echo ${@} > /dev/null 2>&1
}

def reset-xhci {
  (
    for xhci in /sys/bus/pci/drivers/?hci_hcd; do
      if ! cd ${xhci}; then
        error "Failed to change directory to ${xhci}. Aborting."
        return 1
      fi
      echo "Resetting devices from ${xhci}..."
      for i in ????:??:??.?; do
        suc "echo -n ${i} > unbind"
        suc "echo -n ${i} > bind"
      done
    done
  )
}

#———————————————————————————————————————————————————————————————————————————————
# malgrandaĵoj 1-a

def h { which ${@} }
def wh { h "${@}" > /dev/null 2>&1 }
def hr { fullpath "$(h ${@})" }
def hs { for i (${@}) { if wh $i; then print $i; break; fi } }

def modr {
  s find pub -type d -exec chmod go+rx {} \;
  s find pub -type f -exec chmod go+r {} \;
}

def cp {
  if [[ $# -eq 1 ]]; then
    command cp -ia "${1}" .
  else
    command cp -ia "${@}"
  fi
}

def mv {
  if [[ $# -eq 1 ]]; then
    command mv -i "${1}" .
  else
    command mv -i "${@}"
  fi
}

def un {
  for file in $(ls | grep -- -); do
    mv $file $(echo $file | tr -- '-' '_' | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  done
}

def hy {
  for file in $(ls | grep -- _); do
    mv $file $(echo $file | tr -- '_' '-' | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
  done
}

def unun {
  for file in *; do
    mv $file $(echo $file | tr -- '-' '_' | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
  done
}

def hyhy {
  for file in *; do
    mv $file $(echo $file | tr -- '_' '-' | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
  done
}

def \# {
  ($@)
}

def dep {
  echo "This command is deprecated. Use «$1» instead."
  return 1
}

def mvv {
  [[ $# -ge 2 ]] && mv "$@" && \
    if [[ $# -eq 2 ]]; then
      d "$(fullpath $2)/$(basename $1)"
    else
      d "$(fullpath $2)"
    fi
}

def gensym {
  cat /dev/urandom | base64 | tr -dc '0-9a-zA-Z' | head -c5
}

def λ {
  # local name=`gensym`
  # . <(echo "function ${name} () { \"$@\"; }") && ${name} $@ && unset -f ${name}

  # . <(echo "function \"${@}\" () { $@ \$@; }")
  . <(echo "function \"${@}\" () { $@ \$@; }")
  # eval "function \"${@}\" () { $@ \$@; }"

  # echo "$@"
}

#———————————————————————————————————————————————————————————————————————————————
# malgrandaĵoj 2-a

funs=(
  # exit
  q "exit"
  q! "SAVEHIST=0; exit"

  # ziŝo
  z "exec zsh"
  zf "zed -f"
  zc "zcalc"
  zl "wc -l $HISTFILE"
  vh "v ${HOME}/.zhistory"
  zh "v ${HOME}/.zhistory"

  # rm
  rm "trash"

  # cd
  cd "cdx"
  cd! "cdx!"

  d  "cdx"
  d! "cdx!"
  d/ "cd/"
  .. "d .."

  rm~ "rm *~"
  rm~! "rm! *~"

  \- "popd;"

  # ls
  l1 "l -1"
  lh "l -H"
  l! "l -R"
  lv 'l ${1:-*} | less; 0'

  ln! "ln -sf"
  md "mkdir -p"

  vN "v -N"
  tf "tail -F"
  rh "rehash"
  rr  "reset;"
  date! "date '+%Y-%m-%dT%H:%M'"

  zcp "zmv -C"
  zln "zmv -L"

  mount! "s mount"
  umount! "s umount"
  mount "s =mount"
  umount "s =umount"
  reboot! "s =reboot"
  poweroff! "s =poweroff"
  halt! "s =halt -p"
  disks "s lsblk --fs"

  # 0s
  d. 'cd "$(fullpath .)"; 0'
  mv. 'mv ${@} .; 0'
  fullpath 'echo "${1:A}"; 0'
  mute '"${@}" >& /dev/null; 0'
  mutex '"${@}" >& /dev/null &|; 0'
  mu1 '"${@}" > /dev/null; return $?; 0'
  mu2 '"${@}" 2> /dev/null; return $?; 0'
  mu12 '"${@}" >& /dev/null; return $?; 0'
  when 'if eval "$1" ; then shift; ${@}; fi; 0'
  _casedown 'print "$1:l"; 0'
  _caseup 'print "$1:l"; 0'
  lt 'ls -tA | sed -n "${1}"p; 0'
  lssum  'dosum ls "${@}"; 0'
  mvsum  'dosum mv "${@}"; 0'
  mvsum! 'dosum mv! "${@}"; 0'
  cpsum  'dosum cp "${@}"; 0'

  lsd  'do_date ls "${@}"; 0'
  mvd  'do_date mv "${@}"; 0'
  mvd! 'do_date mv! "${@}"; 0'
  cpd  'do_date cp "${@}"; 0'
  cpd! 'do_date cp! "${@}"; 0'
  mvsk  'do_back m "${@}"; 0'
  mvsk! 'do_back m! "${@}"; 0'
  cpsk  'do_back c "${@}"; 0'
  cpsk! 'do_back c! "${@}"; 0'
  reprint 'repeat $1; do printf "$2"; done; print; 0'
  join 'print ${1}${2}; 0'
  se 'e /sudo::$(fullpath $1); 0'
  loop 'while :; do "${@}"; done; 0'
  printb 'for i ("${@}") { printf "$i"; sleep 1; printf "\b" }; 0'
  twirl 'loop printb "|" "/" "—" "\\"; 0'
  sstart 'for i ("${@}") service_command start $i; 0'
  sstop 'for i ("${@}") service_command stop $i; 0'
  srestart 'for i ("${@}") service_command restart $i; 0'
  ghost 'for i ("${@}") g "$i" /etc/hosts; 0'
  f1 'f ${@} | head -1; 0'
  fcd 'cd $(find . -type d -iname "${@}") $argv[2,-1]; 0'
  uf 'unset -f ${@}; 0'
  mrf 'ls -tr | tail -n 1; 0'
  unix2dos 'for i (${@}) perl -p -e "s/\n/\r\n/" -i $i; 0'
  dos2unix 'for i (${@}) perl -p -e "s/\r\n/\n/" -i $i; 0'
  cpr 'for item (${@}) { cp! ${item} ${item:r} }; 0'
  cpe 'for item (${@}) { cp! ${item} ${item:e} }; 0'
  mvr 'for item (${@}) { mv! ${item} ${item:r} }; 0'
  mve 'for item (${@}) { mv! ${item} ${item:e} }; 0'
  echo. 'echo $PWD >>! $1; 0'
  psx 'ps aux | grep -i ${@}; 0'
  pkr 'psk ${@} && ${@}; 0'
  pkxr 'psk ${@} && mute ${@}; 0'
  file_exists 'if [[ -f $1 ]]; then return 0; else return 1; fi; 0'
  not_file_exists '! file_exists $1; 0'
  dir_exists 'if [[ -d $1 ]]; then return 0; else return 1; fi; 0'
  not_dir_exists '! dir_exists $1; 0'
  all_false '! all_true ${@}; 0'
  all_files 'all_true file_exists ${@}; 0'
  some_files 'some_true file_exists ${@}; 0'
  not_files_exist 'all_true not_file_exists ${@}; 0'
  page 'which $1 | less; 0'
  glob 'find $PWD -name "$1" -exec ${argv[2,-1]} {} \;; 0'
  touch! 'mkdir -p $(dirname $1); touch $1; 0'
  cp@ 'cp "$1" "${2:r}.${1:e}"; 0'
  mv@ 'mv "$1" "${2:r}.${1:e}"; 0'
  ssh@ 'ssh "${1}.local"; 0'
  cpz 'cp -a "$1" "${1:r}.z"; 0'
  mvz 'mv "$1" "${1:r}.z"; 0'
  sid 'sed -i'

  # aliaj
  dcase "zmv '(*)' '\${(L)1}'"
  ucase "zmv '(*)' '\${(U)1}'"
  ccase "zmv '(*)' '\${(C)1}'"
  h1 "head -n 1"
  t1 "tail -n 1"

  # network manager
  up "nm c up"
  down "nm c down"
); def_funs
