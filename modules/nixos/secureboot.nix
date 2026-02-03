_: {
  flake.modules.nixos.secureboot =
    { lib, pkgs, ... }:

    {
      boot = {
        # Secure Boot setup with lanzaboote
        loader = {
          systemd-boot.enable = lib.mkForce false;
          efi.canTouchEfiVariables = true;
        };
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };

      };

      # Secure Boot cli
      environment.systemPackages = with pkgs; [
        sbctl
      ];
    };
}
