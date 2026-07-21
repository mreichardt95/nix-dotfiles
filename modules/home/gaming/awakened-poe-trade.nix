_:

{
  flake.modules.homeManager.gaming =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        rusty-path-of-building
        # Pin Electron instead of tracking rolling `pkgs.electron`.
        # APT 3.28.103 (Mar 2026) worked on Electron 40; Electron 41+ regressed
        # the overlay's X11 input passthrough so the override-redirect overlay
        # keeps eating clicks (must alt-tab to reset). Confirmed still broken on
        # 43, so this is not a 41-only bug. Pinned to the last-known-good 40,
        # which is EOL/insecure -> permittedInsecurePackages in nixos/common.nix.
        #
        # Also force X11 (XWayland): Electron 39+ auto-detects Wayland via
        # XDG_SESSION_TYPE and ignores --ozone-platform placed after the app path.
        # As a native Wayland client the overlay steals focus from PoE.
        # https://github.com/SnosMe/awakened-poe-trade/issues/1659
        (awakened-poe-trade.overrideAttrs (_: {
          postFixup = ''
            makeWrapper ${lib.getExe electron_40} $out/bin/awakened-poe-trade \
              --set XDG_SESSION_TYPE x11 \
              --add-flags "--ozone-platform=x11" \
              --add-flags $out/share/awakened-poe-trade/resources/app.asar \
              --prefix LD_LIBRARY_PATH : "${
                lib.makeLibraryPath [
                  libxtst
                  libxt
                ]
              }"
          '';
        }))
      ];
    };
}
