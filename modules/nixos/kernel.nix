_: {
  flake.modules.nixos.kernel =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_6_18;
    };
}
