_:

{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      home.packages = with pkgs; [
        ghostty
        foot
        kitty
      ];

      xdg.configFile."ghostty" = {
        source = create_symlink "${dotfiles}/config/ghostty/";
        recursive = true;
      };

      xdg.configFile."foot" = {
        source = create_symlink "${dotfiles}/config/foot/";
        recursive = true;
      };
    };
}
