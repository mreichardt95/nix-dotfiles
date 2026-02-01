{ ... }:

{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rusty-path-of-building
      ];
    };
}
