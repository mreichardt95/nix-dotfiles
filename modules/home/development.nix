_:

{
  flake.modules.homeManager.development =
    { config, pkgs, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      # Neovim
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
        (pkgs.writeShellApplication {
          name = "ns";
          runtimeInputs = with pkgs; [
            fzf
            nix-search-tv
          ];
          excludeShellChecks = [ "SC2016" ];
          text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        })
        freelens-bin
        kubectl
        dbeaver-bin
      ];

      xdg.configFile."nvim" = {
        source = create_symlink "${dotfiles}/config/nvim/";
        recursive = true;
      };

      # Git
      programs.git.enable = true;

      # Direnv
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
