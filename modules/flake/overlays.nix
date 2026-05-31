{ inputs, ... }:

{
  flake.overlays = {
    additions = final: _prev: import ./pkgs { pkgs = final; };

    modifications =
      final: prev:
      # openldap 2.6.13's test017-syncreplication-refresh is flaky on i686,
      # pulled in via bottles -> wine 32-bit. Skip checks for i686 only so
      # the x86_64 derivation hash stays unchanged and KDE/SASL stay cached.
      (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "i686-linux") {
        openldap = prev.openldap.overrideAttrs (_: {
          doCheck = false;
        });
      })
      // {
        # Pin tailscale to 1.96.5. 1.98.0 in current nixpkgs breaks tailnet
        # DNS after suspend/resume and mullvad up/down (DNS queries leak out
        # the wrong interface and MagicDNS stops resolving). 1.98.1 ships an
        # upstream fix; drop this pin once nixpkgs picks it up.
        inherit
          (import inputs.nixpkgs-tailscale-pin {
            system = final.stdenv.hostPlatform.system;
          })
          tailscale
          ;
      };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
