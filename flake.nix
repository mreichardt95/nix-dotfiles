{
  description = "Dotfiles with dendritic structure";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";

    # Pinned to last nixpkgs rev that shipped tailscale 1.96.5.
    # 1.98.0 (current unstable) breaks tailnet DNS after suspend/resume and
    # mullvad up/down cycles; 1.98.1 has an upstream fix (src_valid_mark) but
    # hasn't reached nixpkgs yet. Drop this input once unstable is >= 1.98.1.
    nixpkgs-tailscale-pin.url = "github:NixOS/nixpkgs/b12141ef619e0a9c1c84dc8c684040326f27cdcc";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?rev=fb08eced449e87e47321e95beeb890a63d2c67bd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
