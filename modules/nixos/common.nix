{ inputs, ... }:

{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      # Nix settings
      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };

      # Nixpkgs
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.self.overlays.additions
          inputs.self.overlays.modifications
          inputs.self.overlays.stable-packages
        ];
      };

      # Base system packages
      environment.systemPackages = with pkgs; [
        vim
        wget
        htop
        git
      ];
    };
}
