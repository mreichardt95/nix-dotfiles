{ ... }:

{
  flake.modules.nixos.virtualization =
    { pkgs, ... }:
    {
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
    };
}
