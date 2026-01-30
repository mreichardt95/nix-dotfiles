{ pkgs, ... }:

{
  # VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Tailscale
  services.tailscale.enable = true;
  services.resolved.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Printing
  services.printing.enable = false;
}
