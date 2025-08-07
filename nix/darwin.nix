{
  nix-darwin,
  system,
  hostName,
  user,
}:
nix-darwin.lib.darwinSystem {
  modules = [ ./darwin-configuration.nix ];
  specialArgs = { inherit system hostName user; };
}
