{
  description = "💻❄️️";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixos,
      nix-darwin,
      flake-utils,
    }@inputs:
    let
      user = "ebzzry";
      nixosHostName = "la-vulpo";
      nixosSystem = "x86_64-linux";
      darwinHostName = "la-orcino";
      darwinSystem = "aarch64-darwin";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        apps = import ./apps.nix { inherit pkgs; };
        packages = import ./packages.nix { inherit pkgs; };
        devShells = import ./shells.nix { inherit nixpkgs pkgs; };
      }
    )
    // {
      nixosConfigurations = {
        ${nixosHostName} = import ./nixos.nix {
          inherit nixos user;
          system = nixosSystem;
          hostName = nixosHostName;
        };
      };
      darwinConfigurations = {
        ${darwinHostName} = import ./darwin.nix {
          inherit nix-darwin user;
          system = darwinSystem;
          hostName = darwinHostName;
        };
      };
      darwinPackages = self.darwinConfigurations.${darwinHostName}.pkgs;
    };
}
