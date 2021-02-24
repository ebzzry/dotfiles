# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Antaŭŝarĝi
#---------------------------------------------------------------------------------------------------

autoload zed
autoload zcalc
autoload zmv
autoload zargs

autoload colors
colors

autoload compinit
compinit

zmodload zsh/deltochar 2> /dev/null
zmodload zsh/clone 2> /dev/null
zmodload zsh/complist 2> /dev/null
zmodload zsh/mathfunc 2> /dev/null
zmodload zsh/pcre 2> /dev/null

autoload insert-unicode-char
zle -N insert-unicode-char

autoload insert-last-word
zle -N insert-last-word

autoload insert-last-last-word
zle -N insert-last-last-word

autoload insert-last-command
zle -N insert-last-command
