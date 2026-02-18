_:

{
  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        p7zip
      ];
    };
}
