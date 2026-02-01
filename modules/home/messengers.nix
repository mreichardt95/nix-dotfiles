{ ... }:

{
  flake.modules.homeManager.messengers =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        element-desktop
      ];
    };
}
