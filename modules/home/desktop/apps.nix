_:

{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      ...
    }:
    lib.mkIf (!pkgs.stdenv.isDarwin) {
      home.packages = with pkgs; [
        # discord
        kdePackages.dolphin
        kdePackages.filelight
        xrandr
        fastfetch
        unrar
        thunderbird
      ];

      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
      };
    };
}
