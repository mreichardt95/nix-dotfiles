_:

{
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    lib.mkIf (!pkgs.stdenv.isDarwin) (
      let
        dotfiles = config.myconf.dotfilesPath;
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
      }
    );
}
