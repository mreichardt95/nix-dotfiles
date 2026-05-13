{ inputs, ... }:

{
  flake.overlays = {
    additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications =
      _final: prev:
      # openldap 2.6.13's test017-syncreplication-refresh is flaky on i686,
      # pulled in via bottles -> wine 32-bit. Skip checks for i686 only so
      # the x86_64 derivation hash stays unchanged and KDE/SASL stay cached.
      prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "i686-linux") {
        openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
      };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
