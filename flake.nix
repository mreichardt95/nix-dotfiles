{
  description = "Dotfiles with dendritic structure";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ComfyUI is not in nixpkgs (pulls Python deps nixpkgs lacks; see
    # NixOS/nixpkgs#227006). This flake ships pinned, tested torch/CUDA builds,
    # so intentionally does NOT follow our nixpkgs to keep those pins working.
    # Pinned to a known-good rev; bump deliberately. CUDA 13.x pulls in
    # libnvshmem, which nixpkgs builds from source with no binary cache
    # anywhere (unfree, Hydra skips it) - expect a multi-hour rebuild whenever
    # the CUDA version changes.
    comfyui.url = "github:utensils/comfyui-nix/b4d4ed4c047e739db42b9a486a87fb1511f5d476";

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
