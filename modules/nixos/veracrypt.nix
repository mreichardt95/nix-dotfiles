_: {
  flake.modules.nixos.veracrypt =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        veracrypt
      ];
    };

}
