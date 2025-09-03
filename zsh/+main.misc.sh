# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# alinomoj

global_aliases=(
  # T='.. tar! ${PWD:t}; -;'
  C="|& c"
  V="|& v"
  G="|& rg --color auto"
  D='$(basename $PWD)'
  S="|& sort"
  R="S -rn"
  X="| xargs -0 -J %"
  L="|& wc -l | sed 's/^\ *//'"
  A="|& awk"

  0.='*(.L0)' # nulo-longecaj regulaj dosieroj
  0/='*(/L0)' # nulo-longecaj dosierujoj

  O,='{,.}*'   # ĉiuj dosieroj, inkluzive punkto-dosieroj
  O.='**/*(.)' # all regular files
  O/='**/*(/)' # all directories
  O@='**/*(@)' # all symlinks

  A.='*(.om[-1])' # oldest regular files
  A/='*(/om[-1])' # oldest directories
  A@='*(@om[-1])' # oldest symlinks

  Z.='*(.om[1])' # newest regular files
  Z/='*(/om[1])' # newest directories
  Z@='*(@om[1])' # newest symlinks

  P="${PWD}"
)
def_global_aliases

# program_aliases=(
#   md="e"
#   txt="e"
#   rkt="e"
#   lisp="e"
#   scm="e"
#   ss="e"
#   nix="e"
#   tex="e"

#   pdf="za"
#   dvi="ok"
#   epub="eb"
#   html="o"

#   mp4="p"
#   mkv="p"

#   kra="kr"

#   jpg="b"
#   png="b"
#   gif="b"

#   ods="lo"
#   odt="lo"
#   odg="lo"
#   odf="lo"

#   exe="wine"

#   docx="catdocx"
#   xlsx="xlsx2csv"

#   asm="asm!"
# )
# def_program_aliases

#———————————————————————————————————————————————————————————————————————————————
# diversaĵoj

#ulimit -c 0
#umask 027
