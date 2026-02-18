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
        discord
        kdePackages.dolphin
        xrandr
        fastfetch
        unrar
        rofi
      ];

      xdg.configFile."rofi" = {
        source = create_symlink "${dotfiles}/config/rofi/";
        recursive = true;
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
      };
    };
}
