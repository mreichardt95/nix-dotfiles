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

      services.sunshine = {
        enable = true;
        autoStart = false;
        capSysAdmin = true;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        heroic
        mangohud
        bottles
        protonup-ng
      ];
    };
}
