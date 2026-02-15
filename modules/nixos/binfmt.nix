_: {
  flake.modules.nixos.binfmt =
    _:

    {
      boot = {
        binfmt = {
          emulatedSystems = [ "aarch64-linux" ];
          registrations.aarch64-linux.fixBinary = true;
        };
      };
    };
}
