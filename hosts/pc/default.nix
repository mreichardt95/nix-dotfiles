{ inputs, ... }:

{
  flake.nixosConfigurations.pc = inputs.self.lib.mkNixos {
    hostname = "pc";
    system = "x86_64-linux";
    modules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.self.modules.nixos.hardware-pc
      inputs.self.modules.nixos.secureboot
      inputs.self.modules.nixos.binfmt
      inputs.self.modules.nixos.locale
      inputs.self.modules.nixos.wake
      inputs.self.modules.nixos.desktop
      inputs.self.modules.nixos.gaming
      inputs.self.modules.nixos.virtualization
      inputs.self.modules.nixos.nvidia
      inputs.self.modules.nixos.vpn
      inputs.self.modules.nixos.veracrypt
      inputs.self.modules.nixos.flatpak
      inputs.self.modules.nixos.sshfs
      inputs.self.modules.nixos.networking
      { home-manager.users.wake = ./home.nix; }
    ];
  };
}
