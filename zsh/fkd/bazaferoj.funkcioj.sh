# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Ĝeneralaj
#---------------------------------------------------------------------------------------------------

function load () {
  if [[ -e "$1" ]]; then source "$1"; fi
}

function bye () {
  if (( ! $#BUFFER )); then
    exit
  else
    zle delete-char-or-list
  fi
}; zle -N bye

function defalias () {
  eval "function $1 () { $2 \$@ }"
}

function reset-terminal () {
  =reset
}; zle -N reset-terminal

function warning () {
  echo -e "\e[0;33m\e[1mWarning: \e[0;0m$@" >&2
  return 1
}

function error () {
  echo -e "\e[0;31m\e[1mError: \e[0;0m$@" >&2
  return 1
}

function copy-region () {
  zle kill-region
  zle yank
}; zle -N copy-region

function casedown () {
  if [[ $# -eq 0 ]]; then
    while read i; do _casedown "${i}"; done
  else
    for i ("$@") _casedown "${i}"
  fi
}

function caseup () {
  if [[ $# -eq 0 ]]; then
    while read i; do _caseup "${i}"; done
  else
    for i ("$@") _caseup "${i}"
  fi
}

function export_exists () {
  for i (${argv[2,-1]}) {
    if hh $i; then
      export ${argv[1]}=$i
      break
    fi
  }
}

function extn () {
  if [[ -z "${1:e}" ]]; then
    print "data"
  else
    print "${1:e}"
  fi
}

function op () {
  case $1 in
    l|ls)   print "command ls" ;;
    m|mv)   print "command mv" ;;
    m!|mv!) print "command mv -f";;
    c|cp)   print "command cp -rpi" ;;
    c!|cp!) print "command cp -rpf" ;;
    *) return 1 ;;
  esac
}

autoload print_sum

function dosum () {
  local op="$(op $argv[1])"
  for i ($argv[2,-1]) {
    case $argv[1] in
      l|ls)
        [[ -f $i ]] && print $(print_sum $i) $i
        ;;
      *)
        ${(s. .)op} -- "$i" "$(print_sum $i).$(extn $i)"
        ;;
    esac
  }
}

function print_date () {
  print $(stat --format='%y' -- "$1" | sed 's/\(....-..-..\)\ \(..:..:..\..........\)\ \(\+..\)\(..\)/\1T\2\3:\4/')
}

function do_date () {
  local op="$(op $argv[1])"
  for i ($argv[2,-1]) {
    case $argv[1] in
      l|ls)
        [[ -f $i ]] && print $(print_date $i) $i
        ;;
      *)
        ${(s. .)op} -- "$i" "$(print_date $i).$(extn $i)"
        ;;
    esac
  }
}

function do_back () {
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

function unsav () {
  if [[ ${1:e} == "sav" ]]; then
      mv $1 ${1:r}
  fi
}

function unfn () {
  if (( $#1 )); then
    which $1 | sed -e '1d;$d;s/	//g;s/\$\@/\"$@\"/;s/\"\"\$\@\"\"/\"$@\"/'
  fi
}

function exfun () {
  if (( $#1 )); then
    which $1 | sed -e '1d;$d;s/	//g;s/\$\@//'
  fi
}

function shebang () {
  case "$1" in
    sh) sed -i -e '1i#!/usr/bin/env sh' "$2" ;;
    zsh) sed -i -e '1i#!/usr/bin/env zsh' "$2" ;;
  esac
}

function mkbin () {
  local dir=$1
  local type=$2

  for i (${argv[3,-1]}) {
    autoload $i

    if [[ ! -f $dir/$i ]]; then
      unfn $i >! $dir/$i
      chmod +x $dir/$i

      case $type in
        sh) shebang sh $dir/$i ;;
        zsh) shebang zsh $dir/$i ;;
      esac
    fi
  }
}

function zb () {
  local dir=$HOME/bin
  local bin=(fx frm! len leo @)

  (
    cd $dir
    for i ($bin) {
          [[ -f "$i" ]] && rm -f "$i"
    }
  )

  mkbin $dir zsh $bin
}

function functionp () {
  local arg="$(which $1 | sed -n '1s/^\(.\).*/\1/p')"

  if [[ ! $arg[1] == "/" ]]; then
    return 0
  else
    return 1
  fi
}

function s2 () {
  if functionp $1; then
    sudo zsh -c $@
    # s2 $(exfun $1) ${argv[2,-1]}
  else
    sudo $@
  fi
}

autoload service_command

function sdisable () {
  for i ("$@") {
    update-rc.d -f "$i" remove _
    update-rc.d "$i" stop 99 0 1 2 3 4 5 6 . _
  }
}

function senable () {
  for i ("$@") {
    update-rc.d "$1" defaults _
  }
}

function cf () {
  if [[ $# -gt 1 ]]; then
    x="$1"; shift 1
    print "$@" >| "$x"
  fi
}

function f_bins () {
  local type="$argv[1]"
  for i ($argv[2,-1]) {
    if [[ -e "$i" ]]; then
      find "$i" -maxdepth 1 -type ${type} -iname '*bin*' | sort
    fi
  }
}

function f_dirs () {
  if [[ -d $1 ]]; then
    find $1 -maxdepth 1 -type d
  fi
}

function cd! () {
  [[ ! -d "$@" ]] && mkdir -p "$@"
  builtin cd $@
}

function cd/ () {
  builtin cd "$(dirname $(fullpath $1))"
}

function cdx/ () {
  if (( ! $#@ )); then
    builtin cd
  elif [[ -d $argv[1] ]]; then
    cd/ "$(fullpath $argv[1])"
    $argv[2,-1]
  else
    echo "$0: no such file or directory: $1"
  fi
}

function cdx () {
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

function cdx@ () { (cdx "$@") }

function cdx! () {
  mkdir -p $argv[1]
  cdx "$@"
}

function cdx@! () { (cdx! "$@") }

function xd () { (cd $@) }

function mk_dir () {
  [[ $# -eq 2 ]] && {
    eval "function d${1} () { cdx $2 \$@ }"
  }
}

function mk_dirs () {
  while [[ $# -ge 2 ]]; do
    mk_dir "$1" "$2"; shift 2
  done
}

function def_dirs () {
  mk_dirs $dirs
  unset dirs
}

function def_cd () {
  local x=

  ## dosierujoj
  for i ($1 $(find $1 -maxdepth 1 -type d)) {
    if [[ ${1:t} == ${i:t} ]]; then
      x=${1:t}
    else
      x=${1:t}${i:t}
    fi

    for j (${x}) {
      mk_dir ${j:l} $i
    }
  }
}

function def_cdx () {
  for i ($CDX) {
    if [[ -d $i ]]; then
      def_cd $i
    fi
    unset CDX
  }
}


#---------------------------------------------------------------------------------------------------
# Invitaj konstruiloj
#---------------------------------------------------------------------------------------------------

function prompt_color () { export PS1="$PS1_COLOR" RPS1= }
function prompt_plain () { export PS1="$PS1_PLAIN" RPS1= }
function prompt_color_e () { export PS1="$PS1_COLOR_E" RPS1= }


#---------------------------------------------------------------------------------------------------
# Alinomoj kaj difinoj
#---------------------------------------------------------------------------------------------------

function def_real_alias () {
  while [[ $# -ge 2 ]]; do
    alias "$1=$2"
    shift 2
  done
}

function def_real_aliases () {
  def_real_alias $real_aliases
  unset real_aliases
}

function def_global_alias () {
  while [[ $# -ge 1 ]]; do
    alias -g "$1"
    shift 1
  done
}

function def_global_aliases () {
  def_global_alias $global_aliases
  unset global_aliases
}

function def_comp () {
  while [[ $# -ge 2 ]]; do
    hh "${2}" && compdef "${1}"="${2}"
    # hh $2 && compdef "$1=$2"
    shift 2
  done
}

function def_comps () {
  def_comp $comps
  unset $comps
}

function def_program_alias () {
  while [[ $# -ge 1 ]]; do
    alias -s "$1"
    shift 1
  done
}

function def_program_aliases () {
  def_program_alias $program_aliases
  unset program_aliases
}

function def_fun () {
  while [[ $# -ge 2 ]]; do
    eval "function $1 () { $2 \$@ }"
    shift 2
  done
}

function def_fun () {
  while [[ $# -ge 2 ]]; do
    if [[ ${2[1]} == "+" ]]; then
        eval "function $1 () { ( ${2[3,-1]} \$@) }"
        shift 2
    else
        eval "function $1 () { $2 \$@ }"
      shift 2
    fi
  done
}

function def_funs () {
  def_fun $funs
  unset funs
}

function def_option () { for i ("$@") setopt $i }

function def_options () { def_option $options; unset options }

function def_cat () {
  while [[ $# -ge 2 ]]; do
    eval "function cat${1} () { s cat $2 }"
    eval "function vi${1} () { s vi $2 }"
    eval "function v${1} () { s v $2 }"
    eval "function e${1} () { e $2 }"
    shift 2
  done
}

function def_cats () { def_cat $cats; unset cats }

function def_key () {
  while [[ $# -ge 2 ]]; do
    bindkey "$1" "$2"
    shift 2
  done
}

function def_keys () {
  def_key $keys
  unset keys
}

function def_out_key () {
  while [[ $# -ge 2 ]]; do
    bindkey -s "$1" "$2"
    shift 2
  done
}

function def_out_keys () {
  def_out_key $out_keys
  unset out_keys
}

function def_mk () {
  eval "function ${argv[1]} () {
            if [[ \$# -ge 2 ]]; then
                if [[ ! -e \${@: -1} ]]; then
                     mkdir -p \${@: -1}
                fi

                command ${argv[2,-1]} \$@
            fi
        }"
}

function def_home_funs () {
  if [[ -d $HOME/hejmo && "`find $HOME -maxdepth 1 -type d -empty -name hejmo`" != "$HOME/hejmo" ]] then
    for i ($HOME/hejmo/*(/)) {
      local base=`basename $i`
      if [[ -d $i ]]; then
        eval "function $base () { cdx \$HOME/hejmo/$base \"\$@\" }"
      fi
    }
  fi
}


#---------------------------------------------------------------------------------------------------
# Retkonektado
#---------------------------------------------------------------------------------------------------

function hostmatch () {
  [[ $# -eq 1 ]] &&
  cat /etc/hosts |
  sed -n "/^${1}./p" |
  awk '{print $1}'
}

function ip_addr_cidr () {
  [[ $# -eq 1 ]] &&
  ip addr show $1 |
  grep 'inet ' |
  awk '{print $2}'
}

function subnet_24 () {
  autoload ip_addr
  [[ $# -eq 1 ]] &&
  ip_addr $1 |
  awk -F "." '{$4=""; print $0}' |
  sed -e 's/\ /./g;s/\.$//'
}

function hosts_all () {
  printf "%s.1-254\n" $1
}

function subnet () {
  print $2 | cut -d . -f 1-$(($1/8))
}


#---------------------------------------------------------------------------------------------------
# Miksaĵo
#---------------------------------------------------------------------------------------------------

function cpdate () {
  for i ($2/*) {
    if [[ "`stat $i G Modify A '{print $1}'`" == "$1" ]]; then
      rz $i $3
    fi
  }
}

function fx () {
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

function frm! () {
  fx $@ rm -rvf %
}

function fdate () {
  # fe 2014-02-14 2014-02-15 ...
  # find . -type f -newermt $1 ! -newermt $2 -exec ${argv[3,-1]} \;
  find . -type f -newermt $1 ! -newermt $2 -print0 | xargs -I % -0 -exec ${argv[3,-1]}
}

function ftoday () {
  fdate yesterday today echo %
}

#function zm () { z $1 && tex2png $1 && b ${i:r}.png }

# map command arg1 arg2
function map () {
  for i in ${argv[2,-1]}; do "$1" "${i}"; done
}

# rmap arg command1 command2
function rmap () {
  for i in ${argv[2,-1]}; do $i ${1}; done
}

function rmap () {
  for cmd (${argv[2,-1]}) { ${(ps: :)${cmd}} ${1} }
}

function mapl () {
  setopt local_traps

  trap 'return 1' HUP INT TERM ABRT

  while read i; do
    if [[ -n "$i" ]]; then
      ${argv[1,-2]} "$i"
    fi
  done < ${argv[-1]}
}

function rmapl () {
  setopt local_traps

  local file=$1
  shift

  trap 'return 1' HUP INT TERM ABRT

  while read -r line; do
    if [[ -n "$line" ]]; then
      $@ "$line"
    fi
  done < "$file"
}

function mapd () {
  for i in ${argv[2,-1]}; do
    cdx@ $i $(echo ${argv[1]} | sed "s/\"//;s/\'//")
  done
}

function print_non_empty_lines () {
  while read i; do
    if [[ -n "$i" ]]; then
      print $i
    fi
  done < "$@"
}

function purge_files () {
  for i ($(find $1 | sed 1d)) {
    rm -rf $i
  }
}

function sumcol () {
  if [[ $# -eq 2 ]]; then
    cat "$2" | awk "{sum += \$$1} END {print sum}"
  fi
}

function lsfonts () {
  identify -list font | grep Font | awk '{print $2}'
}

function printcat () {
  for i ("$@") {
    printf "$i: "
    cat $i }
}

function printcatdir () {
  for i (`find "$@" -type f`) {
    printcat $i
  }
}

function def_lib () {
  if [[ -d $ZLIB ]]; then
    for i ($(find $ZLIB -type f \( ! -name '*__' \))) . $i
  fi
}

function def_opt () {
  if [[ -d $ZOPT ]]; then
      for i ($(find $ZOPT -type f \( ! -name '*.ex' \))) source $i
  fi
}

function call_if_null () {
  if [[ $# -eq 2 ]]; then
    print $2
  else
    print `$1`
  fi
}

function durh () {
  echo $#
  if [[ $# -ge 2 ]]; then
    du "${argv[2,-1]}" | sort -rh | head -n "$1"
  fi
}

function subnet () {
  echo $(default_network | sed -e 's|.0/.*||')$1
}

function def_bracket () {
  eval "\
    function ${1}b () {
        if (( \$#@ == 2 )); then
            $1 \$1 \$2\ \[\$1:r\].\$(extn \$1)
        else
            return 1
        fi
    }"
}; #map def_bracket cp mv

function time2seconds () {
  local time=$1
  local hours=`echo $time | cut -d : -f 1`
  local minutes=`echo $time | cut -d : -f 2`
  local seconds=`echo $time | cut -d : -f 3`

  echo "($hours * 3600) + ($minutes * 60) + $seconds" | bc
}


function mkf () {
  eval "function foo () { $@ }"
  echo foo
}

function mkshorts () {
  for i ($@) {
    for j (. @ /) {
      eval "function ${i}${j} () { ${i} *(${j}) \"\$@\" }"
    }
  }
}; mkshorts la ll lf lk l1 lr la ls

function mvpwd () {
  local dot_name="`pwd`"
  local new_name="$(dirname $dot_name)/$1"

  mv "$dot_name" "$new_name" && cd "$new_name"
}

function rme! () {
  for i (*.${1}) {
    rm! $i
  }
}

function rex () {
  for var ($@) {
    read -s ${var}\?"$var: "
    echo ''
    export $var
  }
}

function chrootp () {
  if [[ ! "`ls -id / | cut -d \  -f 1`" == 2 ]]; then
    return 0
  else
    return 1
  fi
}

function all_true () {
  for i (${argv[2,-1]}) {
    if ! $1 $i; then
      return 1
    fi
  }
  return 0
}

function some_true () {
  for i (${argv[2,-1]}) {
    if $1 $i; then
      return 0
    fi
  }
  return 1
}

function rm () {
  for i in $@; do
    if [[ "$i" == "$HOME" ]]; then
        return 1
    fi
  done

  command rm -i $@
}

function rm! () {
  if [[ "$1" == "$HOME" || "$1" == "$HOME/" || "$1" == "~" || "$1" == "~/" ]]; then
      return 1
  else
    =rm -rf $@
  fi
}

function rm@ () {
  if [[ -d $1 ]]; then
      find $1 -type f -exec shred -vfzun 10 {} \;
      command rm -rf $1
  else
    shred -vfzun 10 $1
  fi
}

function wrap () {
  local cmd=$1
  shift
  eval $cmd
  $@
  eval $cmd
}

function free! () {
  wrap 'free -h' suc 'sync; echo 3 > /proc/sys/vm/drop_caches; s swapoff -a; s swapon -a'
}

function defown () {
  eval "function $1 () {
          s $2 \${argv[2,-1]}
          s chown -R \$1 \${argv[-1]}
        }"
}

defown raown 'rsync -avz'
defown cpown 'cp -af'
defown mvown 'mv -f'

function dls () {
  if [[ $# == 0 ]]; then
      dirs -v
  else
    builtin cd -${1}
  fi
}

function touchx () {
  if (( $#1 )); then
      touch $1
      chmod +x $1
  fi
}

function z! () {
  dirs -lv | awk -F '\t' '{print $2}' | tac >! $HOME/.z
  exec zsh
}

function z+ () {
  if [[ -f $HOME/.z ]]; then
      local pwd=$PWD

      while read -r line; do
        pushd "$line"
      done < $HOME/.z

      pushd $pwd
  fi
}

function mv+ () {
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

function 0 () {
  echo $@ > /dev/null 2>&1
}


#---------------------------------------------------------------------------------------------------
# malgrandaĵoj 1-a
#---------------------------------------------------------------------------------------------------

function h () { which $@ }
function hh () { h "$@" > /dev/null 2>&1 }
function hr () { fullpath "$(h $@)" }
function hs () { for i ($@) { if hh $i; then print $i; break; fi } }


#---------------------------------------------------------------------------------------------------
# malgrandaĵoj 2-a
#---------------------------------------------------------------------------------------------------

funs=(
  # ziŝo
  z "exec zsh"
  zf "zed -f"
  zc "zcalc"
  zl "wc -l $HISTFILE"
  zm "man zshall"
  vh "v $HOME/.zhistory"
  zh "v $HOME/.zhistory"
  zh! "xzless $HOME/hejmo/dat/zisxo/historio/latest"

  # cd
  cd "cdx"
  cd! "cdx!"

  cx "cdx"
  cx! "cdx!"
  cx/ "cdx/"

  d "cdx"
  d! "cdx!"
  d/ "cd/"

  cp "command cp -i"
  mv "command mv -i"
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
  rr "fc -RI"
  hi "fc -liD"
  date! "date '+%Y-%m-%dT%H:%M'"

  zcp "zmv -C"
  zln "zmv -L"

  mount! "s mount"
  umount! "s umount"
  reboot! "s =reboot"
  poweroff! "s =poweroff"
  halt! "s =halt -p"
  disks "s lsblk --fs"

  # 0s
  cd. 'cd "$(fullpath .)"; 0'
  d. 'cd.; 0'
  mv. 'mv $@ .; 0'
  fullpath 'echo "${1:A}"; 0'
  mute '"$@" >& /dev/null; 0'
  mutex '"$@" >& /dev/null &|; 0'
  mu1 '"$@" > /dev/null; return $?; 0'
  mu2 '"$@" 2> /dev/null; return $?; 0'
  mu12 '"$@" >& /dev/null; return $?; 0'
  when 'if eval "$1" ; then shift; $@; fi; 0'
  _casedown 'print "$1:l"; 0'
  _caseup 'print "$1:l"; 0'
  lt 'ls -tA | sed -n "${1}"p; 0'
  lssum  'dosum ls "$@"; 0'
  mvsum  'dosum mv "$@"; 0'
  mvsum! 'dosum mv! "$@"; 0'
  cpsum  'dosum cp "$@"; 0'
  cpsum! 'dosum cp! "$@"; 0'
  lsd  'do_date ls "$@"; 0'
  mvd  'do_date mv "$@"; 0'
  mvd! 'do_date mv! "$@"; 0'
  cpd  'do_date cp "$@"; 0'
  cpd! 'do_date cp! "$@"; 0'
  mvsk  'do_back m "$@"; 0'
  mvsk! 'do_back m! "$@"; 0'
  cpsk  'do_back c "$@"; 0'
  cpsk! 'do_back c! "$@"; 0'
  reprint 'repeat $1; do printf "$2"; done; print; 0'
  join 'print ${1}${2}; 0'
  se 'e /sudo::$(fullpath $1); 0'
  ze 'if [[ -f $ZSRC/$1 ]]; then e $ZSRC/$1; fi; 0'
  loop 'while :; do "$@"; done; 0'
  printb 'for i ("$@") { printf "$i"; sleep 1; printf "\b" }; 0'
  twirl 'loop printb "|" "/" "—" "\\"; 0'
  sstart 'for i ("$@") service_command start $i; 0'
  sstop 'for i ("$@") service_command stop $i; 0'
  srestart 'for i ("$@") service_command restart $i; 0'
  ghost 'for i ("$@") g "$i" /etc/hosts; 0'
  f1 'f $@ | head -1; 0'
  fcd 'cd $(find . -type d -iname "$@") $argv[2,-1]; 0'
  uf 'unset -f $@; 0'
  mrf 'ls -tr | tail -n 1; 0'
  unix2dos 'for i ($@) perl -p -e "s/\n/\r\n/" -i $i; 0'
  dos2unix 'for i ($@) perl -p -e "s/\r\n/\n/" -i $i; 0'
  cpr 'for item ($@) { cp! ${item} ${item:r} }; 0'
  cpe 'for item ($@) { cp! ${item} ${item:e} }; 0'
  mvr 'for item ($@) { mv! ${item} ${item:r} }; 0'
  mve 'for item ($@) { mv! ${item} ${item:e} }; 0'
  echo. 'echo $PWD >>! $1; 0'
  psx 'ps aux | grep -i $@; 0'
  pkr 'psk $@ && $@; 0'
  pkxr 'psk $@ && mute $@; 0'
  file_exists 'if [[ -f $1 ]]; then return 0; else return 1; fi; 0'
  not_file_exists '! file_exists $1; 0'
  dir_exists 'if [[ -d $1 ]]; then return 0; else return 1; fi; 0'
  not_dir_exists '! dir_exists $1; 0'
  all_false '! all_true $@; 0'
  all_files 'all_true file_exists $@; 0'
  some_files 'some_true file_exists $@; 0'
  not_files_exist 'all_true not_file_exists $@; 0'
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
