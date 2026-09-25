{ inputs, ... }:

{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      # Nix settings
      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        # Defaults (max-jobs = auto = 16, cores = 0 = all) let 16 derivations
        # each spawn 16 compiler threads on 16 hardware threads. The 16x
        # oversubscription adds no throughput, thrashes the X3D L3, and starves
        # timeout-based test suites (jupyter-server's websocket tests fail this
        # way under a comfy-ui rebuild). 4x4 saturates the CPU exactly.
        settings = {
          max-jobs = 4;
          cores = 4;
        };
      };
      system.stateVersion = "25.11";

      # Nixpkgs
      nixpkgs = {
        config.allowUnfree = true;
        # electron_40 is EOL in nixpkgs but is the last Electron that runs the
        # Awakened PoE Trade overlay without eating clicks (41+ regressed the
        # X11 input passthrough). See modules/home/gaming/awakened-poe-trade.nix.
        config.permittedInsecurePackages = [ "electron-40.10.5" ];
        overlays = [
          inputs.self.overlays.additions
          inputs.self.overlays.modifications
          inputs.self.overlays.stable-packages
          # Exposes comfyui / comfy-ui-cuda (and rocm/xpu variants).
          inputs.comfyui.overlays.default
        ];
      };
      # Globally Enable zsh
      programs.zsh.enable = true;

      # Base system packages
      environment.systemPackages = with pkgs; [
        vim
        wget
        htop
        git
        git-lfs
        nh
        dig
      ];
    };
}
