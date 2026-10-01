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
        # latest (615.x): stable 595.x had a periodic ~2s vkd3d-proton throughput
        # collapse in UE5 DX12 games (Gothic 1 Remake: 40↔100 fps sawtooth).
        # 615.71.09 DP regression: after a monitor input switch (HPD low) the
        # detach is rejected and the next DSC link training fails -> no signal
        # until reboot. Upstream fix pending: NVIDIA/open-gpu-kernel-modules#1359
        # (issue #1357). Drop the override once a release contains it.
        package =
          let
            inherit (config.boot.kernelPackages) nvidiaPackages;
          in
          assert nvidiaPackages.latest.version == "615.71.09";
          nvidiaPackages.mkDriver {
            version = "615.71.09";
            sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
            sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
            openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
            settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
            persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
            patchesOpen = [
              (pkgs.fetchpatch {
                name = "nvidia-open-dp-unplugged-detach.patch";
                url = "https://github.com/NVIDIA/open-gpu-kernel-modules/compare/615.71.09...a2e8b26b20dfb6f2fa3cb8985e3f1126cba38aae.diff";
                hash = "sha256-g7n7YySwi638Iq8LgCriM6qUYH57q6EMm3cB+zxFRm8=";
              })
            ];
          };
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
