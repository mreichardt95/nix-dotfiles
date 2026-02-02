{ ... }:
{
  flake.modules.nixos.secureboot =
    { lib, pkgs, ... }:

    {
      # Secure Boot setup with lanzaboote
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      # Secure Boot cli
      environment.systemPackages = with pkgs; [
        sbctl
      ];
    };
}
