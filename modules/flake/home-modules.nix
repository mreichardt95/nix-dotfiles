{ inputs, ... }:

{
  flake.homeModules = {
    common = inputs.self.modules.homeManager.common;
    options = inputs.self.modules.homeManager.options;
    shell = inputs.self.modules.homeManager.shell;
    development = inputs.self.modules.homeManager.development;
    desktop = inputs.self.modules.homeManager.desktop;
  };
}
