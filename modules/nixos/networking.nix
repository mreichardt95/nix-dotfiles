{ ... }:
{
  flake.modules.nixos.networking =
    { pkgs, ... }:
    {
      # Networking
      networking.networkmanager.enable = true;
    };

}
