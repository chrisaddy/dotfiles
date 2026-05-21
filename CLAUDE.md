# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for Arch Linux and macOS, managed with Nix Home Manager and nix-darwin via flakes.

## Commands

### nix-darwin (macOS system config)
```bash
# Build and activate (requires sudo)
sudo darwin-rebuild switch --flake ~/dotfiles#olympus-3

# Or via nh
sudo nh darwin switch ~/dotfiles
```

### Home Manager
```bash
# Build and activate (macOS Apple Silicon)
nix run home-manager -- switch --flake '.#chrisaddy@darwin'

# Build and activate (Linux x86_64)
nix run home-manager -- switch --flake '.#chrisaddy@linux'

# Dry-run build (no activation)
nix build '.#homeConfigurations.chrisaddy@darwin.activationPackage' --dry-run
```

## Architecture

### Flake Structure
```
flake.nix              # Flake with home-manager + nix-darwin inputs
bootstrap.sh           # Zero-to-configured setup script
darwin/
  default.nix          # nix-darwin system config (system packages, platform)
home/
  default.nix          # Main home config (packages, imports, custom derivations)
  packages/            # Vendored lockfiles for npm packages
  programs/
    bat.nix            # bat config
    ghostty.nix        # Ghostty terminal (non-headless only)
    helix.nix          # Helix editor
    lazygit.nix        # Lazygit TUI
    niri.nix           # Niri compositor (Linux only)
    starship.nix       # Starship prompt
    tmux.nix           # Tmux
    waybar.nix         # Waybar (Linux only)
    yazi.nix           # Yazi file manager
    zoxide.nix         # Zoxide
    zsh.nix            # Zsh shell
```

Headless mode (used for `exedev@linux`) strips graphical programs (Ghostty, Niri, Waybar) and heavy dev tools.

All program configurations are fully inlined in their .nix files using `xdg.configFile.*.text`.

### Environment
- Editor: hx (helix)
- Shell: zsh with starship prompt
- Tmux prefix: `C-Space`
