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

      xdg.configFile."ghostty/config".text = ''
        command = ${pkgs.tmux}/bin/tmux new-session -A -s main
        theme = Catppuccin Macchiato
        background-opacity=1.0
        window-theme=dark
        font-thicken = true
        macos-titlebar-style = native
        keybind = cmd+grave_accent=toggle_quick_terminal
      '';

      xdg.configFile."ghostty/themes" = {
        source = create_symlink "${dotfiles}/config/ghostty/themes/";
        recursive = true;
      };

      xdg.configFile."foot" = lib.mkIf (!pkgs.stdenv.isDarwin) {
        source = create_symlink "${dotfiles}/config/foot/";
        recursive = true;
      };
    };
}
