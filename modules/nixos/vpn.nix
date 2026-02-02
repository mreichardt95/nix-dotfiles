{ ... }:
{
  flake.modules.nixos.vpn =
    { pkgs, ... }:
    {
      # VPN
      services.mullvad-vpn.enable = true;
      services.mullvad-vpn.package = pkgs.mullvad-vpn;

      # Tailscale
      services.tailscale.enable = true;
      services.resolved.enable = true;

      environment.systemPackages = with pkgs; [
        tailscale
      ];
    };

}
