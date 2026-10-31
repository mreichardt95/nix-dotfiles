_:

{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs = {
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
        libsForQt5.qt5ct
        qt6Packages.qt6ct
      ];
    };
}
