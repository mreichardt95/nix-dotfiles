{ ... }:

{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vlc
        davinci-resolve
      ];
    };
}
