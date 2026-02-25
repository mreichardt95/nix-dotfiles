# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS + Home Manager dotfiles using Nix Flakes with a dendritic (tree-like) module structure via `flake-parts`.

## Common Commands

```bash
# Rebuild and switch to new NixOS configuration
nh os switch ~/Projects/dotfiles

# Format all Nix files
nix fmt

# Run linting checks (statix + deadnix)
nix flake check

# Update flake inputs
nix flake update
```

## Architecture

### Module Structure

```
modules/
├── flake/      # Flake outputs (lib, overlays, checks, formatter, packages)
├── nixos/      # NixOS system modules
├── home/       # Home Manager user modules
├── hardware/   # Hardware-specific configs
└── users/      # User definitions
```

### Key Files

- `flake.nix` - Main entry point, defines inputs and uses flake-parts
- `modules/flake/lib.nix` - `mkNixos` helper for creating host configurations
- `hosts/pc/default.nix` - PC NixOS configuration (imports nixos modules)
- `hosts/pc/home.nix` - PC Home Manager configuration (imports home modules)
- `config/` - Application configs (nvim, hypr, rofi, etc.) symlinked via home-manager

### Configuration Flow

1. `flake.nix` → uses `mkNixos` from `modules/flake/lib.nix`
2. Host config (`hosts/pc/`) imports relevant modules from `modules/nixos/` and `modules/home/`
3. Home Manager modules reference files in `config/` directory

### Overlays

Three overlays in `modules/flake/overlays.nix`:
- `additions` - Custom packages from `modules/flake/pkgs/`
- `modifications` - Package overrides
- `stable-packages` - Packages pinned to stable nixpkgs

## Code Quality

- Formatter: `nixfmt-tree`
- Linter: `statix` (configured in `statix.toml`)
- Dead code detection: `deadnix`
