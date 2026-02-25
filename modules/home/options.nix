_:

{
  flake.modules.homeManager.options =
    { lib, ... }:
    {
      options.myconf = {
        dotfilesPath = lib.mkOption {
          type = lib.types.str;
          description = "Path to the dotfiles repository";
        };
        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this is a work machine";
        };
        isDarwin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this is a macOS machine";
        };
      };
    };
}
