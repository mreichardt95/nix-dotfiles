{ inputs, ... }:

{
  flake.overlays = {
    additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications = _final: _prev: { };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
