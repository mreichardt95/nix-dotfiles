{ config, pkgs, ... }:

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
  };

  programs.zsh.enable = true;
}
