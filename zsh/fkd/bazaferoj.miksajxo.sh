# -*- mode: sh; coding: utf-8 -*-

#———————————————————————————————————————————————————————————————————————————————
# alinomoj

global_aliases=(
  D='$(basename $PWD)'
  C="|& c"
  V="|& v"
  G="|& rg --color auto"
  S="|& sort"
  R="S -rn"
  Y="|& tee"
  H="|& head"
  T="|& tail"
  H1="H -n 1"
  T1="T -n 1"
  L="|& wc -l | sed 's/^\ *//'"
  N.='*(.L0)'     # nulo-longecaj regulaj dosieroj
  N/='*(/L0)'     # nulo-longecaj dosierujoj
  Z,='{,.}*'      # ĉiuj dosieroj, inkluzive punkto-dosieroj
  Z.='**/*(.)'    # ĉiuj regulaj dosieroj
  Z/='**/*(/)'    # ĉiuj dosierujoj
  Z@='**/*(@)'    # ĉiuj simbolligiloj
  M.='*(.om[-1])' # plej malnova regula dosiero
  M/='*(/om[-1])' # plej malnova dosierujo
  M@='*(@om[-1])' # plej malnova simbolligilo
  P.='*(.om[1])'  # plej nova regula dosiero
  P/='*(/om[1])'  # plej nova dosierujo
  P@='*(@om[1])'  # plej nova simblolligilo
); def_global_aliases

program_aliases=(
  md="e"
  txt="e"
  rkt="e"
  lisp="e"
  scm="e"
  ss="e"
  nix="e"
  tex="e"

  pdf="za"
  dvi="ok"
  epub="eb"
  html="o"

  mp4="p"
  mkv="p"

  kra="kr"

  jpg="b"
  png="b"
  gif="b"

  ods="lo"
  odt="lo"
  odg="lo"
  odf="lo"

  exe="wine"

  docx="catdocx"
  xlsx="xlsx2csv"

  asm="asm!"
); def_program_aliases

#———————————————————————————————————————————————————————————————————————————————
# diversaĵoj

ulimit -c 0
#umask 027
