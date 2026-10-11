_:

{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        gamescopeSession = {
          enable = true;
        };
      };

      programs.gamemode.enable = true;
      # gamemode's pkexec helpers (governor, split_lock_mitigate) require group membership
      users.users.wake.extraGroups = [ "gamemode" ];

      services.sunshine = {
        enable = true;
        autoStart = false;
        capSysAdmin = true;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        heroic
        bottles
        protonup-ng
      ];
    };
}
