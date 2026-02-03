{ inputs, ... }:

{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs = {
        # Hyprland
        hyprland = {
          enable = true;
          xwayland.enable = true;
        };
        dms-shell = {
          enable = true;
          systemd.enable = false;
          quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
        };
        firefox.enable = true;
      };

      services = {
        # Plasma + SDDM
        displayManager.sddm = {
          enable = true;
          autoNumlock = true;
        };
        desktopManager.plasma6.enable = true;
        # Audio (PipeWire)
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
      };

      security.rtkit.enable = true;

      # Fonts
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      # PC-specific packages
      environment.systemPackages = with pkgs; [
        plasma5Packages.qt5ct
        qt6Packages.qt6ct
      ];
    };
}
