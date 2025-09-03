{
  pkgs,
  system,
  hostName,
  user,
  lib,
  ...
}:
{
  environment.systemPackages =
    import ./common-packages.nix { inherit pkgs; }
    ++ import ./darwin-packages.nix { inherit pkgs; };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = false;
      autoUpdate = false;
    };
    taps = [ "d12frosted/emacs-plus" ];
    brews = import ./brews.nix { };
    casks = import ./casks.nix { };
  };
  nix = {
    enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "${user}"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
      ];
    };
  };
  programs.zsh.enable = false;
  system = {
    configurationRevision = null;
    stateVersion = 4;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    hostPlatform = "${system}";
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "tarsnap"
    ];
  users.users.${user} = {
    name = "$USER";
    home = "/Users/$USER";
  };
  networking = {
    hostName = "${hostName}";
  };
}
