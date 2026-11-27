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
          luks.devices."luks-55964a8d-3971-4f9c-8d10-97df28e39c6f" = {
            device = "/dev/disk/by-uuid/55964a8d-3971-4f9c-8d10-97df28e39c6f";
            # Pass TRIM through dm-crypt so the weekly fstrim.timer reaches the SSD.
            allowDiscards = true;
            # Skip dm-crypt's kernel workqueues; lower latency on NVMe.
            bypassWorkqueues = true;
          };
        };
        # DIMM temperature sensors: firmware claims the FCH SMBus via ACPI, so
        # i2c_piix4 refuses to bind ("ACPI: OSL: Resource conflict"). lax lets it
        # bind; piix4 then instantiates the DDR5 SPD hubs for spd5118.
        kernelParams = [ "acpi_enforce_resources=lax" ];
        kernelModules = [
          "kvm-amd"
          "spd5118"
        ];
        extraModulePackages = [ ];
      };

      # Data drive is unlocked in stage 2 (after / is up) with a keyfile that
      # lives on the encrypted root, so there is no second passphrase prompt.
      # Keyslot 0 holds a backup passphrase. The keyfile is NOT in this repo.
      # TRIM / no-workqueue flags are stored persistently in the LUKS2 header.
      environment.etc.crypttab.text = ''
        games UUID=87e22774-22d3-4760-a3eb-b3139c5236c3 /etc/secrets/games.key nofail
      '';

      fileSystems = {
        "/" = {
          device = "/dev/mapper/luks-55964a8d-3971-4f9c-8d10-97df28e39c6f";
          fsType = "ext4";
        };
        # 2TB Crucial P3 data drive (LUKS2 + ext4), unlocked via /etc/crypttab below.
        "/mnt/games" = {
          device = "/dev/mapper/games";
          fsType = "ext4";
          options = [ "nofail" ];
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

      # OOM cushion for large ML workloads (e.g. ComfyUI holding ~44GB of
      # LTX-Video weights in RAM). Overflow only — swappiness kept low so the
      # kernel prefers RAM and only spills under real pressure.
      swapDevices = [
        {
          device = "/swapfile";
          size = 32 * 1024; # MiB → 32 GB
        }
      ];
      boot.kernel.sysctl."vm.swappiness" = 10;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
