# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for Arch Linux and macOS, managed with Nix Home Manager via flakes.

## Commands

### Home Manager
```bash
# Build and activate (macOS Apple Silicon)
nix run home-manager -- switch --flake '.#chrisaddy@darwin'

# Build and activate (Linux x86_64)
nix run home-manager -- switch --flake '.#chrisaddy@linux'

# Dry-run build (no activation)
nix build '.#homeConfigurations.chrisaddy@darwin.activationPackage' --dry-run
```

### Legacy Stow (still available)
```bash
just mac    # macOS full setup with stow
just arch   # Arch Linux full setup with stow
```

## Architecture

### Home Manager Structure
```
flake.nix              # Flake with home-manager input
home/
  default.nix          # Main home config (packages, imports)
  programs/
    bat.nix            # bat config (HM native module)
    ghostty.nix        # Ghostty terminal (xdg.configFile)
    kitty.nix          # Kitty terminal (xdg.configFile)
    lazygit.nix        # Lazygit TUI (HM native module)
    neovim.nix         # Neovim config (xdg.configFile, recursive)
    niri.nix           # Niri compositor (xdg.configFile, Linux only)
    starship.nix       # Starship prompt (HM native module)
    tmux.nix           # Tmux (HM native module)
    waybar.nix         # Waybar (xdg.configFile, Linux only)
    yazi.nix           # Yazi file manager (HM native module)
    zellij.nix         # Zellij multiplexer (xdg.configFile)
    zoxide.nix         # Zoxide (HM native module)
    zsh.nix            # Zsh shell (HM native module)
```

### Raw Config Sources
Original config files are still in stow-style directories and referenced by Home Manager:
- `ghostty/.config/ghostty/` - Ghostty config (inlined in nix)
- `kitty/.config/kitty/` - Kitty configs (sourced by HM)
- `nvim/.config/nvim/` - Full Neovim config with lazy.nvim
- `zellij/.config/zellij/` - Zellij config and layouts
- `niri/.config/niri/` - Niri compositor config
- `waybar/.config/waybar/` - Waybar config and styles

### Neovim Plugin Structure
Plugins are in `nvim/.config/nvim/lua/plugins/`:
- `languages.lua` - LSP and language support
- `fzf.lua` - Fuzzy finding
- `navigation.lua` - File/buffer navigation
- `git.lua` - Git integration
- `which-key.lua` - Keymaps and Zellij integration

### Environment
- Editor: nvim
- Shell: zsh with starship prompt
- Tmux prefix: `C-Space`
