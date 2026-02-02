{ ... }:
{
  flake.modules.nixos.wake =
    { pkgs, ... }:

    {
      users.users.wake = {
        isNormalUser = true;
        description = "wake";
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "render"
          "docker"
          "libvirtd"
        ];
        packages = with pkgs; [
          kdePackages.kate
        ];
      };
    };
}
