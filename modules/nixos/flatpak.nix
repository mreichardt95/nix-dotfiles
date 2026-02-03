_: {
  flake.modules.nixos.flatpak = _: {
    # Flatpak
    services.flatpak.enable = true;
  };
}
