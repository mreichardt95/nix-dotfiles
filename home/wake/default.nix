{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
  sharedConfig = "${dotfiles}/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  imports = [
    ./shell.nix
    ./programs.nix
    ./tmux.nix
  ];

  home.username = "wake";
  home.homeDirectory = "/home/wake";
  home.stateVersion = "25.11";

  # Shared dotfile symlinks (all machines)
  xdg.configFile."nvim" = {
    source = create_symlink "${sharedConfig}/nvim/";
    recursive = true;
  };

  xdg.configFile."ghostty" = {
    source = create_symlink "${sharedConfig}/ghostty/";
    recursive = true;
  };

  xdg.configFile."foot" = {
    source = create_symlink "${sharedConfig}/foot/";
    recursive = true;
  };

  xdg.configFile."rofi" = {
    source = create_symlink "${sharedConfig}/rofi/";
    recursive = true;
  };

  home.file.".p10k.zsh".source = ../../config/p10k/p10k.zsh;

  # Shared packages (host-agnostic)
  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixfmt
    nixpkgs-fmt
    gcc
    nodejs
    lazygit
    yamllint
    claude-code
    python3
    unzip
    go
    cargo
    discord
    zoxide
    fzf
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      excludeShellChecks = [ "SC2016" ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
    oh-my-zsh
    vlc
    kdePackages.dolphin
    rofi
    freelens-bin
    kubectl
    xorg.xrandr
    davinci-resolve
    neofetch
    ghostty
    foot
    kitty
    dbeaver-bin
    unrar
    rusty-path-of-building
  ];
}
