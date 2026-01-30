{ ... }:

{
  flake.modules.homeManager.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      # Zsh
      home.file.".p10k.zsh".source = create_symlink "${dotfiles}/config/p10k/p10k.zsh";

      home.packages = with pkgs; [
        zoxide
        fzf
        oh-my-zsh
      ];

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        initContent = ''
          eval "$(zoxide init zsh)"
          [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
        '';

        shellAliases = {
          l = "ls -lhrt";
          cd = "z";
          vim = "nvim";
          nr = "nh os switch ~/Projects/dotfiles";
        };

        oh-my-zsh = {
          enable = true;
          plugins = [
            "sudo"
            "git"
            "direnv"
          ];
        };

        plugins = with pkgs; [
          {
            name = "powerlevel10k";
            src = zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-syntax-highlighting";
            src = fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-syntax-highlighting";
              rev = "0.6.0";
              sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
            };
            file = "zsh-syntax-highlighting.zsh";
          }
        ];
      };
    };
}
