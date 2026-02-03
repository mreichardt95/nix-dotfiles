{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks = {
        # Lint with statix
        statix = pkgs.runCommand "statix-check" { } ''
          ${pkgs.statix}/bin/statix check ${inputs.self} --config ${inputs.self}/statix.toml
          touch $out
        '';

        # Check for dead code with deadnix
        deadnix = pkgs.runCommand "deadnix-check" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${inputs.self}
          touch $out
        '';
      };
    };
}
