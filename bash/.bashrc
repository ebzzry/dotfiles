# -*- mode: sh; coding: utf-8 -*-


#--------------------------------------------------------------------------------
# Mediaj variabloj
#--------------------------------------------------------------------------------

OS=$(uname)
PATH=$PATH:$HOME/bin:$HOME/.node/bin:/usr/local/bin
PS1="\e[1;36m\u\e[1;0m \e[1;37m\h\e[1;31m \e[1;32m\w\e[1;0m\n\e[1;32m\e[1m> \e[1;0m"
PYTHONIOENCODING=UTF-8
PROMPT_COMMAND="history -a"


#--------------------------------------------------------------------------------
# Opcioj
#--------------------------------------------------------------------------------

shopt -s nocasematch


#--------------------------------------------------------------------------------
# Alinomoj
#--------------------------------------------------------------------------------

case "${OS}" in
  (Darwin)
    alias l="ls -GFAtr"
    alias la="ls -GFAtrl"
    ;;
  (*)
    alias l="ls --color=auto -Atr"
    alias la="ls --color=auto -A"
    ;;
esac

alias ll="l -l"
alias lk="la -l"
alias v=less
alias d="cd"
alias tm="tmux"
alias sc="screen"
alias rm!="rm -rf"
alias s="sudo"
alias dkr="docker"
alias dkrc="docker-compose"

alias status="sudo systemctl status"
alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias reload="sudo systemctl reload"


#-------------------------------------------------------------------------------
# Gito
#-------------------------------------------------------------------------------

function git () {
  local git= self= op=

  if [[ -n "${BASH}" ]]; then
    git=$(which git)
    self=${FUNCNAME}
  elif [[ -n "${ZSH_NAME}" ]]; then
    git=$(whence -p git)
    self=$0
  else
    echo "Meh"
    return 1
  fi

  if [[ $# -eq 0 ]]; then
    if [[ -n "${BASH}" ]]; then
      type "${self}" | less
    elif [[ -n "${ZSH_NAME}" ]]; then
      which "${self}" | less
    else
      echo "Meh"
      return 1
    fi
  else
    op="$1"
    shift

    case "${op}" in
      (i) touch .gitignore; "${git}" init; "${self}" a.; "${self}" cim "$@" ;;
      (i!) "${self}" i "Pravaloriziĝu" ;;

      (s) "${git}" status ;;
      (c) "${git}" clone "$@" ;;
      (h) "${git}" show "$@" ;;
      (mv) "${git}" mv "$@" ;;
      (mv!) "${git}" mv -f "$@" ;;
      (me) "${git}" merge "$@" ;;
      (ta) "${git}" tag "$@" ;;
      (bl) "${git}" blame "$@" ;;

      (cl) "${git}" clean "$@" ;;
      (cl!) "${self}" cl -f ;;

      (ci) "${git}" commit "$@" ;;
      (cia) "${self}" ci --amend "$@" ;;
      (cim) "${self}" ci --message "$@" ;;

      (co) "${git}" checkout "$@" ;;
      (com) "${self}" co master ;;
      (cot) "${self}" co trunk ;;
      (co!) "${self}" co --force "$@" ;;
      (cob) "${self}" co -b "$@" ;;

      (ls) "${git}" ls-files "$@" ;;
      (lsm) "${self}" ls -m ;;
      (lsd) "${self}" ls -d ;;
      (lsdrm) "${self}" lsd | xargs "${git}" rm ;;

      (rt) "${git}" reset "$@" ;;
      (rt!) "${self}" rt --hard "$@" ;;
      (rv) "${git}" revert "$@" ;;

      (g) "${git}" grep "$@" ;;
      (gi) "${self}" g -i "$@" ;;

      (f) "${git}" fetch "$@" ;;
      (fa) "${self}" f --all "$@" ;;

      (rm) "${git}" rm "$@" ;;
      (rmr) "${self}" rm -r "$@" ;;
      (rm!) "${self}" rm -rf "$@" ;;

      (rb) "${git}" rebase "$@" ;;
      (rbi) "${self}" rb --interactive "$@" ;;
      (rbc) "${self}" rb --continue "$@" ;;
      (rbs) "${self}" rb --skip "$@" ;;
      (rba) "${self}" rb --abort "$@" ;;
      (rbs) "${self}" rb --skip "$@" ;;
      (rbi!) "${self}" rbi --root "$@" ;;

      (ri) "${self}" rbi HEAD~"$1" ;;
      (rs) "${self}" rt --soft HEAD~"$1" && "${self}" cim "$(git log --format=%B --reverse HEAD..HEAD@{1} | head -1)" ;;

      (ph) "${git}" push "$@" ;;
      (phu) "${self}" ph -u "$@" ;;
      (ph!) "${self}" ph --force "$@" ;;
      (pho) "${self}" phu origin "$@" ;;
      (phom) "${self}" pho main "$@" ;;
      (phoM) "${self}" pho master "$@" ;;
      (phd) "${self}" ph --delete "$@" ;;
      (phdo) "${self}" phd origin "$@" ;;
      (oo) "${self}" ph origin "$(git brh)" ;;
      (oo!) "${self}" ph! origin "$(git brh)" ;;

      (pl) "${git}" pull "$@" ;;
      (pl!) "${self}" pl --force "$@" ;;
      (plr) "${self}" pl --rebase "$@" ;;
      (plro) "${self}" plr origin "$@" ;;
      (plru) "${self}" plr upstream "$@" ;;
      (plrom) "${self}" plro main ;;
      (plroM) "${self}" plro master ;;
      (plrum) "${self}" plru main ;;
      (plruM) "${self}" plru master ;;
      (plrot) "${self}" plro trunk ;;
      (plrut) "${self}" plru trunk ;;

      (a) "${git}" add "$@" ;;
      (au) "${self}" a -u ;;
      (a.) "${self}" a . ;;

      (aum) "${self}" au; "${self}" cim "$@" ;;
      (aux) "${self}" aum "x" ;;
      (a.m) "${self}" a.; "${self}" cim "$@" ;;
      (a.x) "${self}" a.m "x" ;;

      (git) "{self}" aum "git" ;;

      (auxx) "${self}" aux; "${self}" rs 2 ;;
      (au.x) "${self}" a.x; "${self}" rs 2 ;;
      (auxx!) "${self}" auxx; "${self}" oo! ;;

      (l) "${git}" log "$@" ;;
      (l1) "${self}" l -1 --pretty=%B ;;
      (lo) "${self}" l --oneline ;;
      (lp) "${self}" l --patch ;;
      (lp1) "${self}" lp -1 ;;
      (lpw) "${self}" lp --word-diff=color ;;

      (br) "${git}" branch "$@" ;;
      (bra) "${self}" br -a ;;
      (brm) "${self}" br -m "$@" ;;
      (brmh) "${self}" brm "$(git brh)" ;;
      (brd) "${self}" br -d "$@" ;;
      (brD) "${self}" br -D "$@" ;;
      (brh) "${git}" rev-parse --abbrev-ref HEAD ;;

      (d) "${git}" diff "$@" ;;
      (dc) "${git}" diff --cached "$@" ;;
      (dh) "${self}" d HEAD ;;
      (dhw) "${self}" d --word-diff=color ;;

      (re) "${git}" remote "$@" ;;
      (rea) "${self}" re add "$@" ;;
      (reao) "${self}" rea origin "$@" ;;
      (reau) "${self}" rea upstream "$@" ;;
      (rer) "${self}" re remove "$@" ;;
      (ren) "${self}" re rename "$@" ;;
      (rero) "${self}" rer origin "$@" ;;
      (reru) "${self}" rer upstream "$@" ;;
      (res) "${self}" re show "$@" ;;
      (reso) "${self}" res origin ;;
      (resu) "${self}" res upstream ;;

      (rl) "${git}" rev-list "$@" ;;
      (rla) "${self}" rl --all "$@" ;;
      (rl0) "${self}" rl --max-parents=0 HEAD ;;

      (cp) "${git}" cherry-pick "$@" ;;
      (cpc) "${self}" cp --continue "$@" ;;
      (cpa) "${self}" cp --abort "$@" ;;

      (fb) FILTER_BRANCH_SQUELCH_WARNING=1 "${git}" filter-branch "$@" ;;
      (fb!) "${self}" fb -f "$@" ;;
      (fbm) "${self}" fb! --msg-filter "$@" ;;
      (fbi) "${self}" fb! --index-filter "$@" ;;
      (fbe) "${self}" fb! --env-filter "$@" ;;

      (rp) "${git}" rev-parse "$@" ;;
      (rph) "${self}" rp HEAD ;;

      (st) "${git}" stash "$@" ;;
      (stp) "${self}" st pop "$@" ;;

      (subt) "${git}" subtree "$@" ;;
      (subta) "${self}" subt add "$@" ;;
      (subtph) "${self}" subt push "$@" ;;
      (subtpl) "${self}" subt pull "$@" ;;

      (subm) "${git}" submodule "$@" ;;
      (subms) "${self}" subm status "$@" ;;
      (submy) "${self}" subm summary "$@" ;;
      (submu) "${self}" subm update "$@" ;;
      (subma) "${self}" subm add "$@" ;;
      (submi) "${self}" subm init "$@" ;;

      (ref) "${git}" reflog "$@" ;;

      (de) "${git}" describe "$@" ;;
      (det) "${self}" de --tags "$@" ;;

      (*) "${git}" "${op}" "$@" ;;
    esac
  fi
}


#-------------------------------------------------------------------------------
# Funkcioj
#-------------------------------------------------------------------------------

function sagent () {
  ssh-agent $SHELL "$@"
}

function sadd () {
  ssh-add "$@"
}


#-------------------------------------------------------------------------------
# Klavoj
#-------------------------------------------------------------------------------

set -o vi
