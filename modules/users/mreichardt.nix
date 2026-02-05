_:

{
  flake.modules.darwin.mreichardt =
    { pkgs, ... }:
    {
      users.users.mreichardt = {
        name = "mreichardt";
        home = "/Users/mreichardt";
        shell = pkgs.zsh;
      };
    };
}
