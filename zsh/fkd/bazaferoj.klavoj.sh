# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# bindkey
#---------------------------------------------------------------------------------------------------

bindkey -A emacs main
bindkey -M menuselect '^o' accept-and-infer-next-history


#---------------------------------------------------------------------------------------------------
# Difinoj
#---------------------------------------------------------------------------------------------------

keys=(
  "^I" expand-or-complete-prefix
  "^W" kill-region
  "\e/" redo
  "\e=" copy-prev-shell-word
  "\eq" push-line-or-edit
  '^X8' insert-unicode-char
  '\ew' copy-region
  "\e." insert-last-word
  '\e,' insert-last-last-word
  "^[[A" undefined-key
  "^[[B" undefined-key
  "^[[C" undefined-key
  "^[[D" undefined-key
  $'\eOM' accept-line
); def_keys

out_keys=(
  '\e`' '$()\C-b'
  "\e'" "''\C-b"
  '\e"' '""\C-b'
); def_out_keys
