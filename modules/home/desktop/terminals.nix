_:

{
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dotfiles = config.myconf.dotfilesPath;
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      home.packages =
        with pkgs;
        lib.optionals (!pkgs.stdenv.isDarwin) [
          ghostty
          foot
          kitty
        ];

      xdg.configFile."ghostty" = {
        source = create_symlink "${dotfiles}/config/ghostty/";
        recursive = true;
      };

      xdg.configFile."foot" = lib.mkIf (!pkgs.stdenv.isDarwin) {
        source = create_symlink "${dotfiles}/config/foot/";
        recursive = true;
      };
    };
}
