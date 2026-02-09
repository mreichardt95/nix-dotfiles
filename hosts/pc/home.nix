{
  inputs,
  config,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  imports = with inputs.self.modules.homeManager; [
    common
    shell
    development
    desktop
    media
    gaming
    messengers
    browser
  ];
  home = {
    username = "wake";
    homeDirectory = "/home/wake";

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "~/.steam/root/compatibilitytools.d";
    };
  };

  # PC-specific: Hyprland autostart on TTY1
  programs.zsh.profileExtra = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      exec hyprland
    fi
  '';

  # PC-specific dotfile symlinks
  xdg.configFile."hypr" = {
    source = create_symlink "${dotfiles}/config/hypr/";
    recursive = true;
  };
}
