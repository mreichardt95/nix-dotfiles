{ inputs, ... }:

{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      # Hyprland
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      programs.dms-shell = {
        enable = true;
        systemd.enable = false;
        quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
      };

      # Programs
      programs.firefox.enable = true;

      # Plasma + SDDM
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.autoNumlock = true;
      services.desktopManager.plasma6.enable = true;

      # Audio (PipeWire)
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

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
