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
        ]
        ++ modules;
      };

    mkDarwin =
      {
        hostname,
        system,
        modules ? [ ],
      }:
      inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          outputs = inputs.self;
        };
        modules = [
          inputs.self.modules.darwin.common
          inputs.home-manager.darwinModules.home-manager
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
        ]
        ++ modules;
      };
  };
}
