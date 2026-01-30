{ ... }:

{
  flake.modules.nixos.nvidia =
    { config, pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libvdpau-va-gl
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        VDPAU_DRIVER = "nvidia";
        NVD_BACKEND = "direct";
        NIXOS_OZONE_WL = "1";
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      environment.systemPackages = with pkgs; [
        libva-utils
      ];
    };
}
