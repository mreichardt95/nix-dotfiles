_:

{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      # comfy-ui (NVIDIA/CUDA build) with our default flags baked in:
      #   --enable-manager                ComfyUI-Manager for installing nodes
      #   --use-pytorch-cross-attention   avoid fp8 FA3-hopper crash on Blackwell (sm_120)
      #   --listen                        bind all interfaces (LAN-reachable UI)
      comfy-ui = pkgs.symlinkJoin {
        name = "comfy-ui-wrapped";
        paths = [ pkgs.comfy-ui-cuda ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/comfy-ui \
            --add-flags "--enable-manager --use-pytorch-cross-attention --listen --base-directory /mnt/games/ComfyUI"
        '';
      };
    in
    {
      home.packages = with pkgs; [
        claude-code
        opencode
        lmstudio
        comfy-ui
      ];
    };

  # ComfyUI (launched with --listen) reachable from LAN devices (laptop, iPad).
  flake.modules.nixos.ai.networking.firewall.allowedTCPPorts = [ 8188 ];
}
