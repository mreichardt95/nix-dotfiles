{ inputs, ... }:

{
  imports = [
    ./pc/module.nix
  ];

  flake.nixosConfigurations.pc = inputs.self.lib.mkNixos {
    hostname = "pc";
    system = "x86_64-linux";
    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.self.modules.nixos.desktop
      inputs.self.modules.nixos.gaming
      inputs.self.modules.nixos.virtualization
      inputs.self.modules.nixos.nvidia
      inputs.self.modules.nixos.pc
      { home-manager.users.wake = ./pc/home.nix; }
    ];
  };
}
