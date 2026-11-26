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

      # Ark's built-in "Extract here" hard-codes autoSubfolder, which renames an
      # existing top-level folder to "x (1)" instead of merging. This entry runs
      # ark without --autosubfolder so archives merge into the existing folder.
      xdg.dataFile."kio/servicemenus/ark-extract-merge.desktop" = {
        executable = true;
        text = ''
          [Desktop Entry]
          Type=Service
          MimeType=application/zip;application/x-7z-compressed;application/vnd.rar;application/x-rar;application/x-tar;application/x-compressed-tar;application/x-bzip2-compressed-tar;application/x-xz-compressed-tar;application/x-zstd-compressed-tar;
          Actions=extractMerge;
          X-KDE-Submenu=Extract
          X-KDE-Priority=TopLevel

          [Desktop Action extractMerge]
          Name=Extract here (merge)
          Icon=ark
          Exec=${pkgs.kdePackages.ark}/bin/ark --batch --autodestination %F
        '';
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
      };
    };
}
