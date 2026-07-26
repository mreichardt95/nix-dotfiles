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
        # Render the overlay on X11 (XWayland): the overlay-window native module
        # needs an X11 window, and --ozone-platform placed *before* the app path
        # (unlike stock, which puts it after and is ignored) forces it there.
        # https://github.com/SnosMe/awakened-poe-trade/issues/1659
        #
        # Do NOT also `--set XDG_SESSION_TYPE x11`. Price-check copies the hovered
        # item by injecting Ctrl+C into PoE; XDG_SESSION_TYPE=x11 forces that down
        # the XTEST path, which KWin-Wayland silently drops for XWayland clients
        # (verified: XTestFakeKeyEvent not delivered even to the focused window,
        # while XSendEvent is). Leaving it at the real `wayland` keeps the
        # injection path that worked pre-July. Ozone (rendering) and
        # XDG_SESSION_TYPE (input backend) are independent knobs.
        (awakened-poe-trade.overrideAttrs (_: {
          postFixup = ''
            makeWrapper ${lib.getExe electron_40} $out/bin/awakened-poe-trade \
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
