{ ... }:

{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam.enable = true;

      services.sunshine = {
        enable = true;
        autoStart = false;
        capSysAdmin = true;
        openFirewall = true;
      };

      environment.systemPackages = with pkgs; [
        heroic
      ];
    };
}
