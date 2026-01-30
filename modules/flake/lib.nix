{ inputs, ... }:

{
  flake.lib = {
    mkNixos =
      {
        hostname,
        system,
        modules ? [ ],
      }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          outputs = inputs.self;
        };
        modules = [
          inputs.self.modules.nixos.common
          inputs.home-manager.nixosModules.home-manager
          {
            networking.hostName = hostname;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs;
                outputs = inputs.self;
              };
            };
          }
        ] ++ modules;
      };
  };
}
