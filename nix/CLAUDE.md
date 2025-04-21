# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose
Nix-based dotfiles repository for managing macOS system configuration, including shell environments, editor configurations, and development tools.

## Commands
- `nix flake update` - Update flake dependencies
- `darwin-rebuild switch --flake .#Mac` - Apply system configuration
- `clean-system` - Clean Nix store
- `up` - Update and rebuild system

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