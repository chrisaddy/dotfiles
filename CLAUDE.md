# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for Arch Linux and macOS, using GNU Stow for symlink management and Flox for environment management.

## Commands

### Setup
```bash
# macOS full setup
just mac

# Arch Linux full setup
just arch

# Check stow links without applying (dry-run)
just check-stow-mac
just check-stow-arch
```

### Stow Operations
```bash
# Apply symlinks (macOS)
just stow-mac

# Apply symlinks (Arch)
just stow-arch

# Remove symlinks
just unstow-mac
just unstow-arch

# Individual stow commands for specific configs
stow ghostty          # to ~/.config/ghostty
stow nvim             # to ~/.config/nvim
stow -t ~ tmux        # .tmux.conf to home
stow -t ~ doom        # .doom.d to home
```

### Nushell Location
- macOS: `~/Library/Application Support/nushell/`
- Arch: `~/.config/nushell/`

## Architecture

### Directory Structure
Each top-level directory is a stow package:
- `bat/` - bat configuration
- `ghostty/` - Ghostty terminal config (uses Flox + Nushell as shell)
- `nvim/` - Neovim config with lazy.nvim plugin manager
- `nushell/` - Shell configuration with carapace completions, direnv hooks, zoxide
- `tmux/` - Tmux config with TPM plugins, prefix is `C-Space`
- `starship/` - Prompt configuration

### Environment
- Flox is used for environment management (`.flox/`)
- Default shell command in tmux/ghostty: `flox activate -- nu`
- Editor: nvim

### Neovim Plugin Structure
Plugins are in `nvim/.config/nvim/lua/plugins/`:
- `languages.lua` - LSP and language support
- `fzf.lua` - Fuzzy finding
- `navigation.lua` - File/buffer navigation
- `git.lua` - Git integration
- `ai.lua` - AI assistance
