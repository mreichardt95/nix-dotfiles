{ ... }:

{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      # Terminals
      home.packages = with pkgs; [
        ghostty
        foot
        kitty
        discord
        vlc
        kdePackages.dolphin
        xorg.xrandr
        davinci-resolve
        neofetch
        unrar
        rusty-path-of-building
        rofi
      ];

      xdg.configFile."ghostty" = {
        source = create_symlink "${dotfiles}/config/ghostty/";
        recursive = true;
      };

      xdg.configFile."foot" = {
        source = create_symlink "${dotfiles}/config/foot/";
        recursive = true;
      };

      xdg.configFile."rofi" = {
        source = create_symlink "${dotfiles}/config/rofi/";
        recursive = true;
      };

      # VSCode
      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
      };
    };
}
