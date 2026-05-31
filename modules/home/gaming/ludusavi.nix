_:

{
  flake.modules.homeManager.gaming =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mountpoint = "${config.home.homeDirectory}/.cache/nas-ludusavi";
      sshfsOpts = lib.concatStringsSep "," [
        "reconnect"
        "ServerAliveInterval=15"
        "ServerAliveCountMax=3"
        "cache=no"
        "follow_symlinks"
        "idmap=user"
      ];
    in
    {
      home.activation.ludusaviMountpoint = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${lib.escapeShellArg mountpoint}
      '';

      systemd.user.services.sshfs-nas-ludusavi = {
        Unit = {
          Description = "sshfs mount: nas:/mnt/Pool/Backup/ludusavi";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          Type = "simple";
          Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin";
          ExecStart = "${pkgs.sshfs}/bin/sshfs -f -o ${sshfsOpts} nas:/mnt/Pool/Backup/ludusavi ${mountpoint}";
          ExecStop = "/run/wrappers/bin/fusermount -u ${mountpoint}";
          Restart = "on-failure";
          RestartSec = 10;
        };
        Install.WantedBy = [ "default.target" ];
      };

      services.ludusavi = {
        enable = true;
        frequency = "daily";
        backupNotification = true;
        settings = {
          manifest.url = "https://raw.githubusercontent.com/mtkennerly/ludusavi-manifest/master/data/manifest.yaml";
          roots = [
            {
              path = "~/.steam/steam";
              store = "steam";
            }
            {
              path = "/mnt/games/SteamLibrary";
              store = "steam";
            }
            {
              path = "~/.config/heroic";
              store = "heroic";
            }
            {
              path = "~";
              store = "otherHome";
            }
          ];
          backup = {
            path = mountpoint;
            format = {
              chosen = "zip";
              zip.compression = "zstd";
            };
            retention = {
              full = 3;
              differential = 5;
            };
          };
          restore.path = mountpoint;
          customGames = [
            {
              name = "Dispatch (2025)";
              files = [
                "~/Games/Heroic/Prefixes/default/Dispatch/drive_c/users/steamuser/AppData/Local/Dispatch/Saved/SaveGames"
                "~/Games/Heroic/Prefixes/default/Dispatch/drive_c/users/steamuser/AppData/Local/Dispatch/Saved/Config/WindowsNoEditor"
              ];
            }
            {
              name = "Ren'Py (uncatalogued)";
              files = [ "~/.renpy" ];
            }
          ];
        };
      };

      systemd.user.services.ludusavi.Unit = {
        Requires = [ "sshfs-nas-ludusavi.service" ];
        After = [ "sshfs-nas-ludusavi.service" ];
      };
    };
}
