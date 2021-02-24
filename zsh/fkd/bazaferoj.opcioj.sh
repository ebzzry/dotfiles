# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# Malŝalti
#---------------------------------------------------------------------------------------------------

unset options


#---------------------------------------------------------------------------------------------------
# Difinoj
#---------------------------------------------------------------------------------------------------

options=(
  no_beep
  no_bg_nice
  no_clobber
  no_correct
  no_correct_all
  no_flowcontrol
  no_ignore_eof
  no_mark_dirs
  no_notify
  no_share_history

  auto_pushd
  pushd_ignore_dups
  pushd_to_home
  pushd_minus
  pushd_silent

  bang_hist
  hist_find_no_dups
  hist_ignore_all_dups
  hist_no_store
  hist_reduce_blanks
  inc_append_history
  prompt_subst

  complete_in_word
  complete_aliases

  auto_remove_slash
  chase_links
  equals
  interactive_comments
  path_dirs
  global_rcs
  rcs
  local_traps

  glob_complete
  glob_dots
  ksh_glob
  extended_glob
); def_options
