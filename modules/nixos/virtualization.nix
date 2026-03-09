_:

{
  flake.modules.nixos.virtualization =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;

      programs.virt-manager.enable = true;
      # Mask broken libvirt unit that hardcodes /usr/bin/sh (doesn't exist on NixOS)
      systemd.services.virt-secret-init-encryption.enable = false;

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
    };
}
