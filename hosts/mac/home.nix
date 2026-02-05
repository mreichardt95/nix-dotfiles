{ inputs, ... }:

{
  imports = with inputs.self.modules.homeManager; [
    common
    shell
    development
  ];

  home = {
    username = "mreichardt";
    homeDirectory = "/Users/mreichardt";
  };

  # Override nr alias for darwin-rebuild
  programs.zsh.shellAliases = {
    nr = "darwin-rebuild switch --flake ~/Projects/dotfiles";
  };
}
