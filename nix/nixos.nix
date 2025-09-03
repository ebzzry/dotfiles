{
  nixos,
  system,
  hostName,
  user,
  determinate,
}:
nixos.lib.nixosSystem {
  modules = [
    ./nixos-configuration.nix
    determinate.nixosModules.default
  ];
  specialArgs = {
    inherit
      system
      hostName
      user
      determinate
      ;
  };
}
