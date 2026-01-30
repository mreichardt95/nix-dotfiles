{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./locale.nix
    ./services.nix
    ./users.nix
  ];

  # Networking
  networking.networkmanager.enable = true;

  # Fuse
  programs.fuse.userAllowOther = true;

  # Programs
  programs.firefox.enable = true;

  # PC-specific packages
  environment.systemPackages = with pkgs; [
    tailscale
    pciutils
    plasma5Packages.qt5ct
    qt6Packages.qt6ct
    veracrypt
    nh
    sshfs
    sbctl
  ];

  system.stateVersion = "25.11";
}
