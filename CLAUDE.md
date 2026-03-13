# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for Arch Linux and macOS, managed with Nix Home Manager and nix-darwin via flakes.

## Commands

### nix-darwin (macOS system config)
```bash
# Build and activate (requires sudo)
sudo darwin-rebuild switch --flake ~/dotfiles#olympus-2

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
darwin/
  default.nix          # nix-darwin system config (system packages, platform)
home/
  default.nix          # Main home config (packages, imports)
  programs/
    bat.nix            # bat config
    ghostty.nix        # Ghostty terminal
    lazygit.nix        # Lazygit TUI
    neovim.nix         # Neovim config (all lua inlined via xdg.configFile.*.text)
    niri.nix           # Niri compositor (Linux only, inlined)
    starship.nix       # Starship prompt
    tmux.nix           # Tmux
    waybar.nix         # Waybar (Linux only, inlined)
    yazi.nix           # Yazi file manager
    zellij.nix         # Zellij multiplexer (config + layout inlined)
    zoxide.nix         # Zoxide
    zsh.nix            # Zsh shell
    nixvim/            # NixVim config (alternative nvim setup)
```

All program configurations are fully inlined in their .nix files using `xdg.configFile.*.text`.

### Environment
- Editor: nvim
- Shell: zsh with starship prompt
- Keyboard layout: Colemak (m/n/e/i for vim-like navigation)
- Tmux prefix: `C-Space`
- Zellij default mode: locked (`Ctrl+Space` to toggle)
