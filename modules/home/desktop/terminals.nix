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
      tmuxCmd =
        if pkgs.stdenv.isDarwin
        then "/bin/bash -l -c '${pkgs.tmux}/bin/tmux new-session -A -s main'"
        else "${pkgs.tmux}/bin/tmux new-session -A -s main";
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
        command = ${tmuxCmd}
        theme = Catppuccin Macchiato
        background-opacity=1.0
        window-theme=dark
        font-thicken = true
        ${lib.optionalString pkgs.stdenv.isDarwin "font-size = 14"}
        macos-titlebar-style = native
        keybind = cmd+grave_accent=toggle_quick_terminal
        key-repeat-delay = 100
        key-repeat-interval = 30
      '';

      xdg.configFile."foot" = lib.mkIf (!pkgs.stdenv.isDarwin) {
        source = create_symlink "${dotfiles}/config/foot/";
        recursive = true;
      };
    };
}
