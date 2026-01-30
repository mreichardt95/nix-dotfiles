{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader - Secure Boot setup
  # https://nix-community.github.io/lanzaboote/introduction.html
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Networking
  networking.hostName = "pc";
  networking.networkmanager.enable = true;

  # VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Timezone and locale
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

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

  programs.fuse.userAllowOther = true;

  # Display manager and desktop
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.desktopManager.plasma6.enable = true;

  # Keyboard
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  console.keyMap = "de-latin1-nodeadkeys";

  # Printing
  services.printing.enable = false;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User packages (PC-specific)
  users.users.wake.packages = with pkgs; [
    kdePackages.kate
  ];

  # Programs
  programs.steam.enable = true;
  programs.firefox.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # NVIDIA environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
  };

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Flatpak
  services.flatpak.enable = true;

  # Virtualization
  virtualisation.docker.enable = true;

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Game streaming
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Tailscale
  services.tailscale.enable = true;
  services.resolved.enable = true;

  # PC-specific packages
  environment.systemPackages = with pkgs; [
    tailscale
    libva-utils
    pciutils
    heroic
    plasma5Packages.qt5ct
    qt6Packages.qt6ct
    veracrypt
    nh
    sshfs
    sbctl
  ];

  system.stateVersion = "25.11";
}
