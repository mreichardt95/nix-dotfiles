_:

{
  flake.modules.homeManager.development =
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
        [
          neovim
          ripgrep
          nil
          nixfmt
          nixpkgs-fmt
          gcc
          nodejs
          lazygit
          yamllint
          python3
          unzip
          go
          cargo
        ]
        ++ lib.optionals (!pkgs.stdenv.isDarwin) [
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
      programs.git = {
        enable = true;
        lfs.enable = true;
      };

      # Direnv
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
