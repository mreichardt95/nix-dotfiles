_:

{
  flake.modules.homeManager.common = _: {
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
