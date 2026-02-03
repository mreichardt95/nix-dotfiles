_: {
  flake.modules.nixos.hardware-pc =
    {
      config,
      lib,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "thunderbolt"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [ ];
          luks.devices."luks-55964a8d-3971-4f9c-8d10-97df28e39c6f".device =
            "/dev/disk/by-uuid/55964a8d-3971-4f9c-8d10-97df28e39c6f";
        };
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };

      fileSystems = {
        "/" = {
          device = "/dev/mapper/luks-55964a8d-3971-4f9c-8d10-97df28e39c6f";
          fsType = "ext4";
        };
        "/mnt/games" = {
          device = "/dev/disk/by-uuid/264625FA4625CB7F";
          fsType = "ntfs3";
          options = [
            "uid=1000"
            "nofail"
          ];
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/A87A-4C74";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
