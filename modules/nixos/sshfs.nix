{ ... }:
{
  flake.modules.nixos.sshfs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        pciutils
        sshfs
      ];

      # Fuse
      programs.fuse.userAllowOther = true;
    };

}
