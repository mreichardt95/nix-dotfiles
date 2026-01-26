{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    initContent = ''
      eval "$(zoxide init zsh)"
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec hyprland
      fi
    '';

    shellAliases = {
      l = "ls -lhrt";
      cd = "z";
      vim = "nvim";
      nr = "sudo nixos-rebuild switch --flake ~/Projects/dotfiles";
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
}
