# -*- mode: sh; coding: utf-8 -*-


#---------------------------------------------------------------------------------------------------
# GHC
#---------------------------------------------------------------------------------------------------

if [[ -e $HOME/.nix-profile/bin/ghc ]]; then
  export NIX_GHC="$HOME/.nix-profile/bin/ghc"
  export NIX_GHCPKG="$HOME/.nix-profile/bin/ghc-pkg"
  export NIX_GHC_DOCDIR="$HOME/.nix-profile/share/doc/ghc/html"
  export NIX_GHC_LIBDIR="$HOME/.nix-profile/lib/ghc-$($NIX_GHC --numeric-version)"
fi


#---------------------------------------------------------------------------------------------------
# Stack
#---------------------------------------------------------------------------------------------------

# autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
# hh stack && eval "$(stack --bash-completion-script stack)"


#---------------------------------------------------------------------------------------------------
# Kubernetes
#---------------------------------------------------------------------------------------------------
#hh minikube && eval $(minikube docker-env)
#hh kubectl && source <(kubectl completion zsh)


#---------------------------------------------------------------------------------------------------
# minishift
#---------------------------------------------------------------------------------------------------
#hh minishift && [[ "$(minishift status)" != "Stopped" ]] && eval $(minishift docker-env)
