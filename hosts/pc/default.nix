{ config, pkgs, ... }:

{
  imports = [
    ../common
    ../common/users/wake.nix
    ./configuration.nix
  ];
}
