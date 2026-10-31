{
  inputs,
  config,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
in
{
  imports = with inputs.self.modules.homeManager; [
    options
    common
    shell
    development
    desktop
    media
    gaming
    messengers
    browser
    ai
  ];

  myconf = {
    isWork = false;
    isDarwin = false;
    dotfilesPath = dotfiles;
  };

  home = {
    username = "wake";
    homeDirectory = "/home/wake";

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "~/.steam/root/compatibilitytools.d";
    };
  };
}
