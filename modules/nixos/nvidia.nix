_:

{
  flake.modules.nixos.nvidia =
    {
      config,
      pkgs,
      ...
    }:
    {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          # nvidia-vaapi-driver # Disabled: causes SIGILL crashes in Firefox/Discord on Blackwell
          libvdpau-va-gl
        ];
      };

      environment.sessionVariables = {
        # LIBVA_DRIVER_NAME = "nvidia"; # Disabled: unstable nvidia VA-API on Blackwell
        VDPAU_DRIVER = "nvidia";
        # NVD_BACKEND = "direct"; # Disabled: only needed with nvidia-vaapi-driver
        NIXOS_OZONE_WL = "1";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # KWIN_DRM_NO_AMS = "1"; # Disabled: causes black screen on boot
      };

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        nvidiaPersistenced = true; # Keep GPU initialized, avoid repeated GSP init cycles
        modesetting.enable = true;
        powerManagement.enable = true; # Save/restore GPU state across suspend/resume to prevent Xid 13 errors
        powerManagement.finegrained = false;
        open = true; # Required for Blackwell (RTX 5080)
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "580.119.02";
        #   sha256_64bit = "sha256-gCD139PuiK7no4mQ0MPSr+VHUemhcLqerdfqZwE47Nc=";
        #   openSha256 = "sha256-l3IQDoopOt0n0+Ig+Ee3AOcFCGJXhbH1Q1nh1TEAHTE=";
        #   settingsSha256 = "sha256-sI/ly6gNaUw0QZFWWkMbrkSstzf0hvcdSaogTUoTecI=";
        #   persistencedSha256 = "sha256-j74m3tAYON/q8WLU9Xioo3CkOSXfo1CwGmDx/ot0uUo=";
        # };
      };

      # Stability tweaks for RTX 5080 (Blackwell) with 580.x driver.
      # NVreg_UsePageAttributeTable improves memory management and reduces
      # the chance of GPU driver deadlocks causing full system freezes.
      boot.extraModprobeConfig = ''
        options nvidia NVreg_UsePageAttributeTable=1
      '';

      boot.kernelParams = [
        "nvidia-drm.fbdev=1"
      ];
      systemd.services.nvidia-powerd.enable = false;

      environment.systemPackages = with pkgs; [
        libva-utils
      ];
    };
}
