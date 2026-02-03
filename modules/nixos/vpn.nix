_: {
  flake.modules.nixos.vpn =
    { pkgs, ... }:
    {
      services = {
        # VPN
        mullvad-vpn.enable = true;
        mullvad-vpn.package = pkgs.mullvad-vpn;

        # Tailscale
        tailscale.enable = true;
        resolved.enable = true;

      };

      environment.systemPackages = with pkgs; [
        tailscale
      ];
    };

}
