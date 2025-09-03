# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# serĉdosierindikoj

path=(
  # Nix
  /var/setuid-wrappers
  /run/wrappers/bin
  ${HOME}/.nix-profile/bin
  ${HOME}/.nix-profile/sbin
  /run/current-system/sw/bin
  /run/current-system/sw/sbin
  /nix/var/nix/profiles/default/bin
  /nix/var/nix/profiles/default/sbin

  # Homebrew
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/homebrew/opt/openjdk/bin
  /opt/homebrew/opt/grep/libexec/gnubin

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

#———————————————————————————————————————————————————————————————————————————————
# uzantvariabloj

UNAME=($(uname -srm))
UNAME=(${UNAME:l})
OS=${UNAME[1]}
OS_RELEASE=${UNAME[2]}
ARCH=${UNAME[3]}

#———————————————————————————————————————————————————————————————————————————————
# sistemvariabloj

LANG="en_US.UTF-8"
# LANG="eo.utf8"
# LANGUAGE="eo.utf8"
# LC_ALL="eo.utf8"
TZ='Asia/Manila'

#———————————————————————————————————————————————————————————————————————————————
# frue antaŭŝargi la aferojn pri invitoj

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats " [%b%m%u%c%a]"
zstyle ':vcs_info:git*' formats " %F{cyan}%B[%f%F{green}%B%b%f%F{magenta}%B%m%u%c%a%f%F{cyan}%B]"
