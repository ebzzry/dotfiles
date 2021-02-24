# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Ŝarĝinte
#---------------------------------------------------------------------------------------------------

def_mk cp! cp -rf
def_mk mv! mv -f


#---------------------------------------------------------------------------------------------------
# Bibliotekoj
#---------------------------------------------------------------------------------------------------

if ! chrootp; then
  source $HOME/hejmo/fkd/zisxo/zsh-git-prompt/zshrc.sh
  GIT_PROMPT_EXECUTABLE="haskell"
fi

if chrootp; then
  path=(
    $path
    $HOME/.local/share/tresorit
  )
fi


#---------------------------------------------------------------------------------------------------
# Invito
#---------------------------------------------------------------------------------------------------

if [[ "$TERM" == "dumb" ]]; then
  unsetopt zle prompt_cr prompt_subst
  for i (precmd preexec) { hh $i && unfn $i }
  PS1="$ "
else
  precmd ()  { linux_pc_test && vcs_info; print -Pn "\e]0;%n %m:%1~\a" }
  preexec () { print -Pn "\e]0;%n %m:($1)\a" }
fi


#---------------------------------------------------------------------------------------------------
# Ŝanĝradikigmedioj
#---------------------------------------------------------------------------------------------------

chrootp && CHROOT_PROMPT='%F{yellow}(C)%f'

if linux_pc_test || darwin_test; then
    local host_color=
    if chrootp; then hostcolor="yellow"; else hostcolor="red"; fi

    if [[ "$TERM" == "dumb" ]]; then
        PS1='%n %m %~ %D{%n}> '
    else
      if ! chrootp; then
        PS1='%F{cyan}%B%n%b%f%B%F{magenta} %f%b%B%F{$hostcolor}%m%f%b %F{green}%B%~%b%f $(git_super_status) %D{%n}%F{green}%B>%b%f%F{white} '
      else
        PS1='%F{cyan}%B%n%b%f%B%F{magenta} %f%b%B%F{$hostcolor}%m%f%b %F{green}%B%~%b%f %D{%n}%F{green}%B>%b%f%F{white} '
      fi
    fi
else
  PS1='%n %m %0d${vcs_info_msg_0_} %D{%n} [★] '
fi


#---------------------------------------------------------------------------------------------------
# Klavaro
#---------------------------------------------------------------------------------------------------

{
  local file=$HOME/hejmo/dat/klavaro/linukso/dvorak.map.gz
  [[ "$TERM" == linux && -f $file ]] && s loadkeys $file
  unset file
}


#---------------------------------------------------------------------------------------------------
# Nix
#---------------------------------------------------------------------------------------------------

#load $HOME/.nix-profile/etc/profile.d/nix.sh

autoload -U +X compinit && compinit
# autoload -U +X bashcompinit && bashcompinit
hh stack && eval "$(stack --bash-completion-script stack)"


#---------------------------------------------------------------------------------------------------
# AWS
#---------------------------------------------------------------------------------------------------

[[ -f $HOME/.nix-profile/share/zsh/site-functions/aws_zsh_completer.sh ]] && load $HOME/.nix-profile/share/zsh/site-functions/aws_zsh_completer.sh


#---------------------------------------------------------------------------------------------------
# Kompletigoj
#---------------------------------------------------------------------------------------------------

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:cd:*' ignore-parents parent pwd

compinit

comps=(
  d "cd"
  s "sudo"
); def_comps


#---------------------------------------------------------------------------------------------------
# Dosierujoj
#---------------------------------------------------------------------------------------------------

CDX=(
  $HOME/hejmo/*(/)
); def_cdx
