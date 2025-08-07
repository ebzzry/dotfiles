#!/usr/bin/env -S zsh -f

#———————————————————————————————————————————————————————————————————————————————
# emaksaj klavoj

# bindkey -A emacs main

#———————————————————————————————————————————————————————————————————————————————
# vi-klavoj

if darwin_test || linux_test; then
  bindkey -v

  function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
      [[ $1 = 'block' ]]; then
      echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
      [[ ${KEYMAP} == viins ]] ||
      [[ ${KEYMAP} = '' ]] ||
      [[ $1 = 'beam' ]]; then
      echo -ne '\e[6 q'
    fi
  }
  zle -N zle-keymap-select

  zle-line-init() {
    zle -K viins
    echo -ne "\e[6 q"
  }
  zle -N zle-line-init

  # 202212172302 [ebzzry] kio estas ĉi tio?
  # echo -ne '\e[6 q'
  # preexec() { echo -ne '\e[6 q'; }
else
  bindkey -e
  bindkey -A emacs main
fi

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

#bindkey -M viins 'jk' vi-cmd-mode

bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

bindkey -M isearch '^r' history-incremental-search-backward
bindkey -M isearch '^s' history-incremental-search-forward

#———————————————————————————————————————————————————————————————————————————————
# difinoj

keys=(
  "\e." insert-last-word
  '\e,' insert-last-last-word
  "\e=" copy-prev-shell-word
  "\eq" push-line-or-edit
  '^X8' insert-unicode-char
  $'\eOM' accept-line
  "^[[1~"   beginning-of-line
  "^[[4~"   end-of-line
)
def_keys

out_keys=(
  '\e`' '$()\C-b'
  "\e'" "''\C-b"
  '\e"' '""\C-b'
  '\e"' '""\C-b'
)
