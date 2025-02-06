{
  description = "A flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        apps = import ./apps.nix { inherit pkgs; };
        packages = import ./packages.nix { inherit pkgs; };
        devShells = import ./shells.nix { inherit nixpkgs pkgs; };
      });
}
