{
  nixos,
  system,
  hostName,
  user,
}:
nixos.lib.nixosSystem {
  modules = [ ./nixos-configuration.nix ];
  specialArgs = { inherit system hostName user; };
}
