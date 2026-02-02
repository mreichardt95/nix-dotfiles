{ ... }:
{
  flake.modules.nixos.flatpak =
    { ... }:
    {
      # Flatpak
      services.flatpak.enable = true;
    };
}
