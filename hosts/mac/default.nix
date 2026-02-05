{ inputs, ... }:

{
  flake.darwinConfigurations.macbook = inputs.self.lib.mkDarwin {
    hostname = "macbook";
    system = "aarch64-darwin";
    modules = [
      inputs.self.modules.darwin.mreichardt
      { home-manager.users.mreichardt = ./home.nix; }
    ];
  };
}
