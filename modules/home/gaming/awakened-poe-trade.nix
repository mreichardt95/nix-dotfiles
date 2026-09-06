_:

{
  flake.modules.homeManager.gaming =
    { pkgs, lib, ... }:
    {
      # KWin 6.7 gates Xwayland input emulation (XTEST/libei) behind a
      # per-attempt permission prompt. Price-check injects Ctrl+C into PoE to
      # copy the hovered item; the prompt silently drops that injection, so
      # Ctrl+D does nothing (the overlay and Shift+Space still work because they
      # need no injection). XwaylandEisNoPrompt=true lets Xwayland apps emulate
      # input without prompting. It's only re-read at KWin startup, so it needs
      # a re-login to take effect. Set idempotently here rather than managing the
      # whole Plasma-owned kwinrc.
      home.activation.kwinXwaylandEisNoPrompt = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
          --file kwinrc --group Xwayland --key XwaylandEisNoPrompt true
      '';

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
        # 3.29.102's changelog says --ozone-platform=x11 is applied "out of the
        # box", but that lives in APT's AppImage launcher. We run `electron
        # app.asar` directly (AppImage bypassed), so we must still pass it here or
        # Electron goes Wayland-native and the overlay never appears (verified:
        # without it the main proc holds a wayland-cursor memfd and has no X window).
        #
        # Do NOT also `--set XDG_SESSION_TYPE x11`. Price-check copies the hovered
        # item by injecting Ctrl+C into PoE; XDG_SESSION_TYPE=x11 forces that down
        # the XTEST path, which KWin-Wayland silently drops for XWayland clients
        # (verified: XTestFakeKeyEvent not delivered even to the focused window,
        # while XSendEvent is). Leaving it at the real `wayland` keeps the
        # injection path that worked pre-July. Ozone (rendering) and
        # XDG_SESSION_TYPE (input backend) are independent knobs.
        #
        # Bump to 3.29.102 ahead of the nixpkgs pin catching up:
        # https://github.com/NixOS/nixpkgs/pull/546461
        (awakened-poe-trade.overrideAttrs (_: {
          version = "3.29.102";
          src = fetchurl {
            url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v3.29.102/Awakened-PoE-Trade-3.29.102.AppImage";
            hash = "sha256-mjtdM8tEi+Gvf3B4gopEEqlNfp89+J4w1Jy+dyWtig8=";
          };
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
