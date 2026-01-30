{ inputs, ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = import ../../pkgs { inherit pkgs; };
    };
}
