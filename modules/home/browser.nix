_:

{
  flake.modules.homeManager.browser =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        mullvad-browser
      ];
    };
}
