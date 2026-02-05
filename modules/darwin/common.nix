{ inputs, ... }:

{
  flake.modules.darwin.common =
    { pkgs, ... }:
    {
      # Nix settings
      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
        gc = {
          automatic = true;
          interval = {
            Weekday = 0;
            Hour = 0;
            Minute = 0;
          };
          options = "--delete-older-than 7d";
        };
      };

      # Darwin state version
      system.stateVersion = 4;

      # Nixpkgs
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.self.overlays.additions
          inputs.self.overlays.modifications
          inputs.self.overlays.stable-packages
        ];
      };

      # Enable zsh at system level
      programs.zsh.enable = true;

      # Base system packages
      environment.systemPackages = with pkgs; [
        vim
        wget
        htop
        git
      ];
    };
}
