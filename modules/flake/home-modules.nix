{ inputs, ... }:

{
  flake.homeModules = {
    inherit (inputs.self.modules.homeManager)
      common
      options
      shell
      development
      desktop
      ;
  };
}
