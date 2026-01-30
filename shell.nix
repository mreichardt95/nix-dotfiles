{ ... }:
#
# {
#   flake.modules.homeManager.shell =
#     { config, lib, pkgs, ... }:
#     let
#       dotfiles = "${config.home.homeDirectory}/Projects/dotfiles";
#       mkSymlink = path:
#         pkgs.runCommand "symlink-${builtins.baseNameOf path}" { } ''
#           ln -s ${lib.escapeShellArg path} $out
#         '';
#     in
#     {
#       # Zsh
#       home.file.".p10k.zsh".source = mkSymlink "${dotfiles}/config/p10k/p10k.zsh";
#
#       home.packages = with pkgs; [
#         zoxide
#         fzf
#         oh-my-zsh
#       ];
#
#       programs.fzf = {
#         enable = true;
#         enableZshIntegration = true;
#       };
#
#       programs.zsh = {
#         enable = true;
#         autocd = true;
#         autosuggestion.enable = true;
#         enableCompletion = true;
#         initContent = ''
#           eval "$(zoxide init zsh)"
#           [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#         '';
#
#         shellAliases = {
#           l = "ls -lhrt";
#           cd = "z";
#           vim = "nvim";
#           nr = "nh os switch ~/Projects/dotfiles";
#         };
#
#         oh-my-zsh = {
#           enable = true;
#           plugins = [
#             "sudo"
#             "git"
#             "direnv"
#           ];
#         };
#
#         plugins = with pkgs; [
#           {
#             name = "powerlevel10k";
#             src = zsh-powerlevel10k;
#             file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
#           }
#           {
#             name = "zsh-syntax-highlighting";
#             src = fetchFromGitHub {
#               owner = "zsh-users";
#               repo = "zsh-syntax-highlighting";
#               rev = "0.6.0";
#               sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
#             };
#             file = "zsh-syntax-highlighting.zsh";
#           }
#         ];
#       };

      # # Tmux
      # programs.tmux = {
      #   enable = true;
      #   prefix = "C-a";
      #   baseIndex = 1;
      #   escapeTime = 0;
      #   historyLimit = 10000;
      #   keyMode = "vi";
      #   mouse = true;
      #
      #   plugins = with pkgs.tmuxPlugins; [
      #     sensible
      #     resurrect
      #     continuum
      #     copycat
      #     yank
      #     open
      #     battery
      #     {
      #       plugin = catppuccin;
      #       extraConfig = ''
      #         set -g @catppuccin_flavor "mocha"
      #         set -g @catppuccin_window_status_style "rounded"
      #         set -g @catppuccin_status_background "#242638"
      #         set -g @catppuccin_window_current_text " #{b:pane_current_path}"
      #         set -g @catppuccin_window_text " #{b:pane_current_path}"
      #       '';
      #     }
      #   ];
      #
      #   extraConfig = ''
      #     set -g default-terminal 'screen-256color'
      #     set -as terminal-features ",xterm-256color:RGB"
      #     setw -g pane-base-index 1
      #     set-window-option -g automatic-rename on
      #     set-option -g set-titles on
      #     set -g renumber-windows on
      #     set -g status-keys vi
      #     set -g @resurrect-strategy-nvim 'session'
      #     bind-key v split-window -h -c "#{pane_current_path}"
      #     bind-key s split-window -v -c "#{pane_current_path}"
      #     bind '"' split-window -c "#{pane_current_path}"
      #     bind % split-window -h -c "#{pane_current_path}"
      #     bind-key -n C-S-Left swap-window -t -1
      #     bind-key -n C-S-Right swap-window -t +1
      #     bind-key -r J resize-pane -D 5
      #     bind-key -r K resize-pane -U 5
      #     bind-key -r H resize-pane -L 5
      #     bind-key -r L resize-pane -R 5
      #     bind-key M-j resize-pane -D
      #     bind-key M-k resize-pane -U
      #     bind-key M-h resize-pane -L
      #     bind-key M-l resize-pane -R
      #     bind h select-pane -L
      #     bind j select-pane -D
      #     bind k select-pane -U
      #     bind l select-pane -R
      #     bind -n M-h select-pane -L
      #     bind -n M-j select-pane -D
      #     bind -n M-k select-pane -U
      #     bind -n M-l select-pane -R
      #     bind -n M-Left select-pane -L
      #     bind -n M-Right select-pane -R
      #     bind -n M-Up select-pane -U
      #     bind -n M-Down select-pane -D
      #     bind -n S-Left previous-window
      #     bind -n S-Right next-window
      #     bind-key b set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
      #     set -g status-right-length 100
      #     set -g status-left-length 100
      #     set -g status-left "#{E:@catppuccin_status_session}"
      #     set -g status-right "#{E:@catppuccin_status_application}"
      #     set -agF status-right "#{E:@catppuccin_status_battery}"
      #   '';
      # };
#     };
# }
