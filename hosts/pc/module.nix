{ ... }:

{
  flake.modules.nixos.pc =
    { ... }:
    {
      imports = [
        ./default.nix
      ];
    };
}
