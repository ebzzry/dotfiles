# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# malŝaltado

unset options

#———————————————————————————————————————————————————————————————————————————————
# difinoj

# options=(
#   no_beep
#   no_bg_nice
#   no_clobber
#   no_correct
#   no_correct_all
#   no_flowcontrol
#   no_ignore_eof
#   no_mark_dirs
#   no_notify
#   no_share_history

#   auto_pushd
#   pushd_ignore_dups
#   pushd_to_home
#   pushd_minus
#   pushd_silent

#   bang_hist
#   hist_find_no_dups
#   hist_ignore_all_dups
#   hist_no_store
#   hist_reduce_blanks
#   inc_append_history
#   prompt_subst

#   complete_in_word
#   complete_aliases

#   auto_remove_slash
#   chase_links
#   equals
#   interactive_comments
#   path_dirs
#   global_rcs
#   rcs
#   local_traps

#   glob_complete
#   glob_dots
#   ksh_glob
#   extended_glob
# ); def_options

setopt no_beep
setopt no_bg_nice
setopt no_clobber
setopt no_correct
setopt no_correct_all
setopt no_flowcontrol
setopt no_ignore_eof
setopt no_mark_dirs
setopt no_notify
setopt no_share_history

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_to_home
setopt pushd_minus
setopt pushd_silent

setopt bang_hist
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_no_store
setopt hist_reduce_blanks
setopt inc_append_history
setopt prompt_subst

setopt complete_in_word
setopt complete_aliases

setopt auto_remove_slash
setopt chase_links
setopt equals
setopt interactive_comments
setopt path_dirs
setopt global_rcs
setopt rcs
setopt local_traps

setopt glob_complete
setopt glob_dots
setopt ksh_glob
setopt extended_glob
