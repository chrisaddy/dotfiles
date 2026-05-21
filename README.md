# dotfiles

Nix-managed development environment for macOS and Linux, built with Home Manager and nix-darwin via flakes.

Keyboard-centric, Colemak-native, consistently themed with Rose Pine Moon.

## Quick Start

```bash
# Clone
git clone https://github.com/chrisaddy/dotfiles ~/dotfiles
cd ~/dotfiles

# Bootstrap (installs Nix, enables flakes, activates config)
./bootstrap.sh

# Or manually — macOS (Apple Silicon)
nix run home-manager -- switch --flake '.#chrisaddy@darwin'

# Or manually — Linux (x86_64)
nix run home-manager -- switch --flake '.#chrisaddy@linux'

# macOS system config (nix-darwin)
sudo darwin-rebuild switch --flake ~/dotfiles#olympus-3
```

## Structure

```
flake.nix                 # Inputs, system targets, home-manager configs
bootstrap.sh              # Zero-to-configured setup script
darwin/
  default.nix             # nix-darwin system config (macOS)
home/
  default.nix             # Packages, env vars, custom derivations
  packages/               # Vendored lockfiles for npm packages
  programs/
    bat.nix               # Syntax-highlighted cat
    ghostty.nix           # GPU terminal (Linux)
    helix.nix             # Helix editor
    lazygit.nix           # Git TUI
    niri.nix              # Scrollable tiling Wayland compositor (Linux)
    starship.nix          # Shell prompt
    tmux.nix              # Terminal multiplexer
    waybar.nix            # Status bar (Linux)
    yazi.nix              # Terminal file manager
    zoxide.nix            # Smart cd
    zsh.nix               # Shell, aliases, functions
```

## Targets

| Config | Platform | Use |
|---|---|---|
| `chrisaddy@darwin` | macOS aarch64 | Primary workstation |
| `chrisaddy@darwin-x86` | macOS x86_64 | Intel Mac |
| `chrisaddy@linux` | Linux x86_64 | Desktop/laptop |
| `chrisaddy@linux-arm` | Linux aarch64 | ARM boards |
| `exedev@linux` | Linux x86_64 | Headless VMs (minimal) |

Headless mode strips graphical programs (Ghostty, Niri, Waybar) and heavy dev tools (codex, cmake, go, rust-analyzer, etc.).

## Design Decisions

### Colemak Navigation

Movement keys are remapped throughout to match Colemak home row:

```
m n e i  (Colemak)
h j k l  (QWERTY equivalent)
```

### Theme

Rose Pine Moon everywhere:

- **Neovim** --- rose-pine moon colorscheme
- **Tmux** --- Catppuccin-style status bar (`#1e1e2e` bg)
- **Ghostty** --- Rose Pine Moon
- **Lazygit** --- Tokyonight variant
- **Starship** --- Coordinated hex colors
- **Bat** --- TwoDark

### Multiplexer

Tmux is the primary multiplexer. Prefix is `C-Space`.

- `/` split right, `-` split below
- `C-h/j/k/l` navigate panes (no prefix)
- `o` opens sesh session picker via gum
- `Space` choose session

### Neovim

Configured entirely through NixVim. Leader is `Space`.

**Language servers:** basedpyright, ruff, bashls, dockerls, lua_ls, html, markdown_oxide, yamlls

**Formatting on save:** ruff + isort (Python), alejandra (Nix), gofmt, jq, stylua, shfmt, and more via conform.nvim.

**Key workflows:**
- `<leader>ff` find files, `<leader>fg` live grep, `<leader><leader>` buffers
- `<leader>gg` Neogit
- `<leader>o` Oil file browser
- `<leader>u` Undotree
- `gd` go to definition, `K` hover

### Shell

Zsh with starship prompt, carapace completions, direnv, and zoxide.

Notable aliases:
- `vim` -> `nvim`
- `ls` -> `exa -la`
- `lss` -> `yazi`
- `ccc` -> `claude --dangerously-skip-permissions`
- `update` -> pull, `nh home switch`, clean, commit, push (one command)
- `exevm()` -> provision exe.dev VMs with dotfiles

## Packages

<details>
<summary>Full package list</summary>

**Core:** cloc, curl, dust, fd, jq, ripgrep, tree, wget

**Dev:** git, claude-code, pi-coding-agent, lazygit, delta, gh, nodejs, sqlite

**Python:** python3, uv, ruff, basedpyright

**Rust:** cargo, rustc, cargo-clean-recursive

**Nix:** nh, devenv, secretspec

**Shell:** starship, zoxide, carapace, bat, eza, gum, just, direnv, sesh

**Terminal:** tmux, yazi

**Darwin-only:** libiconv, clang
**Linux-only:** gcc

**Desktop (non-headless):** codex, fzf, cmake, ninja, go, rust-analyzer, elan, awscli2, google-cloud-sdk, duckdb, ffmpeg
**Linux desktop:** nyxt

</details>

## Updating

```bash
# From anywhere
update

# Or manually
cd ~/dotfiles
nix run home-manager -- switch --flake '.#chrisaddy@darwin'
```

## License

Do whatever you want with it.
