{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/users/wake/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  imports = [ ./zsh.nix ];
  home.username = "wake";
  home.homeDirectory = "/home/wake";
  programs.git.enable = true;
  home.stateVersion = "25.11";

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."nvim" = {
    source = create_symlink "${dotfiles}/nvim/";
    recursive = true;
  };
  xdg.configFile."hypr" = {
    source = create_symlink "${dotfiles}/hypr/";
    recursive = true;
  };

  home.file.".p10k.zsh".source = ./config/p10k/p10k.zsh;
  xdg.configFile."ghostty" = {
    source = create_symlink "${dotfiles}/ghostty/";
    recursive = true;
  };


  # home.file.".config/hypr".source = ./config/hypr;
  xdg.configFile."foot" = {
    source = create_symlink "${dotfiles}/foot/";
    recursive = true;
  };
  xdg.configFile."rofi" = {
    source = create_symlink "${dotfiles}/rofi/";
    recursive = true;
  };

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
    tmux
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
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

}
