{
  description = "Dotfiles with dendritic structure";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?rev=fb08eced449e87e47321e95beeb890a63d2c67bd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ComfyUI is not in nixpkgs (pulls Python deps nixpkgs lacks; see
    # NixOS/nixpkgs#227006). This flake ships pinned, tested torch/CUDA builds,
    # so intentionally does NOT follow our nixpkgs to keep those pins working.
    comfyui.url = "github:utensils/comfyui-nix";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
        ./hosts/pc/default.nix
      ];
    };
}
