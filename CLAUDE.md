# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a Nix-based dotfiles repository using flake-parts for modular configuration management across multiple hosts and users. The architecture follows a hierarchical structure:

### Core Structure
- **flake.nix**: Main flake configuration defining inputs (nixpkgs, home-manager, nix-darwin, nixvim, fenix, flox) and outputs for different systems
- **hosts/**: Host-specific configurations for different machines (aion, m4, olympus) with both NixOS and nix-darwin support  
- **home/**: Home-manager configurations per user/host (common.nix contains shared settings)
- **modules/**: Reusable modules for specific applications and tools

### Configuration Pattern
Each host configuration imports:
1. Host-specific darwin/NixOS configuration
2. Home-manager with user-specific imports from home/
3. Shared modules from modules/ directory
4. Special args for accessing flake inputs

### Key Components
- **nixvim**: Comprehensive Neovim configuration with LSPs, formatters, and plugins
- **fenix**: Rust toolchain management
- **flox**: Development environment management
- **home-manager**: User environment and dotfiles management

## Common Commands

### System Management
```bash
# Rebuild system configuration (macOS)
darwin-rebuild switch --flake .#m4
darwin-rebuild switch --flake .#olympus

# Rebuild home-manager only
home-manager switch --flake .#chrisaddy@m4

# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

### Development Workflow
```bash
# Format Nix files
alejandra .

# Check flake
nix flake check

# Show system info
nix-shell -p nix-info --run "nix-info -m"

# Enter development shell with flox
flox activate
```

### Testing Changes
```bash
# Test configuration without switching
darwin-rebuild check --flake .#m4

# Build without switching
nix build .#darwinConfigurations.m4.system
```

## Module System

The configuration uses a modular approach where each application/tool has its own module in `modules/`:
- **ai.nix**: AI development tools
- **vim.nix**: Complete nixvim configuration with LSPs, formatters, debugging
- **git.nix**: Git configuration and tools  
- **helix.nix**: Helix editor configuration
- **tmux.nix**: Terminal multiplexer setup
- **python.nix**: Python development environment
- **ocaml.nix**: OCaml development setup

Each host's home configuration imports only the modules it needs.

## Special Considerations

### Vim Configuration
The vim module uses nixvim for declarative Neovim configuration with:
- LSPs for multiple languages (Python, Nix, Bash, OCaml, etc.)
- Formatters: conform-nvim with language-specific formatters
- Testing: neotest with Python and Plenary adapters
- Debugging: nvim-dap with Python support
- AI integration: avante, codecompanion, supermaven

### Host-Specific Features
- **m4**: Primary macOS development machine
- **olympus**: Secondary macOS machine with minimal Nix (nix.enable = false)
- **aion**: Linux configuration (currently commented out)

### Flake Inputs Management
The flake follows nixpkgs inputs for consistency and uses flake-parts for modular output generation. All major inputs (home-manager, nix-darwin, nixvim) follow the main nixpkgs input.