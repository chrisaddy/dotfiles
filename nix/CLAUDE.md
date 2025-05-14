# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose
Nix-based dotfiles repository for managing macOS system configuration, including shell environments, editor configurations, and development tools using the nix-darwin system.

## Repository Structure
- `/nix/` - Core configuration files organized by component (shells, editors, tools)
- `/emacs/` - Emacs configuration files and custom snippets
- `/ghostty/` - Configuration for the Ghostty terminal emulator
- `/bin/` - Custom scripts and binaries

## Commands
- `nix flake update` - Update flake dependencies
- `clean-system` - Clean Nix store
- `up` - Update and rebuild system (always use this command for rebuilding after any changes to dotfiles)
- `darwin-rebuild switch --flake .` - Rebuild the system configuration (alternative to `up`)

## Nix Configuration Management
- Each component has its own configuration file in `/nix/`
- Component configurations are imported in `home.nix`
- The main system configuration is defined in `flake.nix`
- To add a new tool or service, create a new .nix file and import it in `home.nix`

## Development Tools
- Terminal: Ghostty with ZSH and Nushell
- Editors: Helix (primary), Neovim, Emacs
- AI Tools: Claude Code, Mods, Codex
- Version Control: Git, Jujutsu, LazyGit
- Shell: ZSH with Starship prompt, direnv, and zoxide

## Style Guidelines
- Nix files use 2-space indentation
- Organized in modular .nix files by component
- Attribute sets are consistently structured
- Shell functions are defined in initExtra sections
- Use descriptive attribute names

## Code Conventions
- Follow functional programming paradigm
- Avoid direct environment modifications
- Use lib.mkForce for overriding values
- Maintain consistent keymapping format
- Keep plugins organized by function