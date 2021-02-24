# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Serĉdosierindikoj
#---------------------------------------------------------------------------------------------------

path=(
  # NixOS
  /var/setuid-wrappers
  /run/wrappers/bin
  $HOME/.nix-profile/bin
  $HOME/.nix-profile/sbin
  /run/current-system/sw/bin
  /run/current-system/sw/sbin
  /nix/var/nix/profiles/default/bin
  /nix/var/nix/profiles/default/sbin

  # FHS
  /bin
  /sbin
  /opt/bin
  /usr/local/bin
  /usr/bin
  /usr/sbin
  /usr/games
  /usr/X11R6/bin
)


#---------------------------------------------------------------------------------------------------
# Uzantvariabloj
#---------------------------------------------------------------------------------------------------

UNAME=($(uname -srm))
UNAME=($UNAME:l)
OS=$UNAME[1]
OS_RELEASE=$UNAME[2]
ARCH=$UNAME[3]


#---------------------------------------------------------------------------------------------------
# Sistemvariabloj
#---------------------------------------------------------------------------------------------------


LANG="eo.utf8"
LANGUAGE="eo.utf8"
LC_ALL="eo.utf8"
#LANG="en_US.UTF-8"
TZ='Asia/Manila'


#---------------------------------------------------------------------------------------------------
# la aferojn pri invitoj frue antaŭsarĝi
#---------------------------------------------------------------------------------------------------

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats " [%b%m%u%c%a]"
zstyle ':vcs_info:git*' formats " %F{cyan}%B[%f%F{green}%B%b%f%F{magenta}%B%m%u%c%a%f%F{cyan}%B]"
