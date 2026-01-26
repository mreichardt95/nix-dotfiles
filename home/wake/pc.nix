{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
  pcConfig = "${dotfiles}/hosts/pc/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  imports = [
    ../common
    ./default.nix
  ];

  # PC-specific dotfile symlinks
  xdg.configFile."hypr" = {
    source = create_symlink "${pcConfig}/hypr/";
    recursive = true;
  };

  # PC-specific packages (if any)
  # home.packages = with pkgs; [ ];
}
