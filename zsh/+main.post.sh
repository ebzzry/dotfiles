# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# ŝarĝinte

def_mk cp! cp -rf
def_mk mv! mv -f

#———————————————————————————————————————————————————————————————————————————————
# bibliotekoj

if chrootp; then
  path=(
    $path
    ${HOME}/.local/share/tresorit
  )
fi

#———————————————————————————————————————————————————————————————————————————————
# invito

if [[ "$TERM" == "dumb" ]]; then
  unsetopt zle prompt_cr prompt_subst
  for i in precmd preexec; do wh $i && unfn $i; done
  PS1="$ "
else
  precmd ()  { linux_pc_test && vcs_info; print -Pn "\e]0;%n %m:%1~\a" }
  preexec () { print -Pn "\e]0;%n %m:($1)\a" }
fi

autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info

def rgbcolor {
    echo "16 + $1 * 36 + $2 * 6 + $3" | bc
}

orange=$(rgbcolor 5 3 0)

#———————————————————————————————————————————————————————————————————————————————
# ŝanĝradikigmedioj

chrootp && CHROOT_PROMPT='%F{yellow}(C)%f'

#———————————————————————————————————————————————————————————————————————————————
# invito

if linux_pc_test || darwin_test; then
  if [[ "$TERM" == "dumb" ]]; then
    PS1='%n %m %~ %D{%n} '
  else
    PS1='%F{cyan}%B%n%b%f%B%F{yellow} %f%b%B%F{red}%m%f%b%F{yellow}%B %b%f%F{green}%B%~%b%f${vcs_info_msg_0_}%b%D{%n}%F{${orange}}%B%b%f%F{white} '
  fi
else
  PS1='%n %m %0d %D{%n} '
fi

#———————————————————————————————————————————————————————————————————————————————
# klavaro

{
  local file=${HOME}/dat/klavaro/linukso/dvorak.map.gz
  [[ "$TERM" == linux && -f $file ]] && s loadkeys $file
  unset file
}

#———————————————————————————————————————————————————————————————————————————————
# nix

autoload -U +X compinit && compinit

#———————————————————————————————————————————————————————————————————————————————
# aws

[[ -f ${HOME}/.nix-profile/share/zsh/site-functions/aws_zsh_completer.sh ]] && load ${HOME}/.nix-profile/share/zsh/site-functions/aws_zsh_completer.sh

#———————————————————————————————————————————————————————————————————————————————
# kompletigoj

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

#———————————————————————————————————————————————————————————————————————————————
# dosierujoj

# CDX=(
#   ${HOME}/Developer/*(/)
# ); def_cdx

#———————————————————————————————————————————————————————————————————————————————
# starship

# eval "$(starship init zsh)"
