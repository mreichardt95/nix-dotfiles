_:

{
  flake.modules.homeManager.gaming =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        rusty-path-of-building
        (awakened-poe-trade.overrideAttrs (_: {
          postFixup = ''
            makeWrapper ${lib.getExe electron} $out/bin/awakened-poe-trade \
              --add-flags $out/share/awakened-poe-trade/resources/app.asar \
              --add-flags "--ozone-platform=x11" \
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
