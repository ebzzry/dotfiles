# -*- mode: sh -*-

#———————————————————————————————————————————————————————————————————————————————
# GHC

# if [[ -e ${HOME}/.nix-profile/bin/ghc ]]; then
#   export NIX_GHC="${HOME}/.nix-profile/bin/ghc"
#   export NIX_GHCPKG="${HOME}/.nix-profile/bin/ghc-pkg"
#   export NIX_GHC_DOCDIR="${HOME}/.nix-profile/share/doc/ghc/html"
#   export NIX_GHC_LIBDIR="${HOME}/.nix-profile/lib/ghc-$($NIX_GHC --numeric-version)"
# fi

#———————————————————————————————————————————————————————————————————————————————
# Stack

autoload -U +X bashcompinit && bashcompinit

#———————————————————————————————————————————————————————————————————————————————
# Kubernetes

wh minikube && eval $(minikube docker-env)
wh kubectl && source <(kubectl completion zsh)

#———————————————————————————————————————————————————————————————————————————————
# minishift

wh minishift && [[ "$(minishift status)" != "Stopped" ]] && eval $(minishift docker-env)
