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
  default.nix          # Main home config (packages, imports, flag wiring)
  programs/
    bat.nix            # bat config
    ghostty.nix        # Ghostty terminal (gui only)
    helix.nix          # Helix editor
    lazygit.nix        # Lazygit TUI
    neovim.nix         # Neovim via nixvim
    niri.nix           # Niri compositor (Linux, gui only)
    nushell.nix        # Nushell (login shell; non-headless only)
    scripts.nix        # `update`, `exevm` binaries
    starship.nix       # Starship prompt
    waybar.nix         # Waybar (Linux, gui only)
    yazi.nix           # Yazi file manager
    zellij.nix         # Zellij multiplexer
    zoxide.nix         # Zoxide
    zsh.nix            # Zsh shell
```

### `headless` and `gui`

`mkHome` in `flake.nix` takes two independent booleans, both threaded into
`home/default.nix` via `extraSpecialArgs`:

- `headless` — this is a lightweight VM. It drops nushell (so the machine keeps
  zsh, because `bootstrap.sh` and `exevm` drive VMs with `ssh host "a && b"`,
  which nu cannot parse) and the heavy dev toolchain (fzf, opam, rust-analyzer,
  the language servers, awscli2, google-cloud-sdk, duckdb, ffmpeg, …).
- `gui` — a desktop belongs here. Gates Ghostty, Niri, Waybar, and Nyxt. It
  defaults to `!headless`, so the workstations and VMs behave as before, but it
  is set independently for WSL.

Keep them separate. `chris@linux` (WSL2) is exactly the case that needs
`headless = false` with `gui = false`: the full toolchain and no compositor.

All program configurations are fully inlined in their .nix files using `xdg.configFile.*.text`.

### OCaml / opam

Nix installs only `opam` and its build prerequisites (`gmp`, `m4`, `pkg-config`,
`unzip`, plus `bubblewrap` on Linux for opam's sandbox). The compiler and all
libraries live in a mutable `~/.opam` outside the Nix store, so first-run setup
is manual:

```bash
# Only on a machine with no ~/.opam yet:
opam init --bare -n
opam switch create default ocaml-base-compiler

# Always — the editor tooling (LSP + formatter):
opam install -y dune ocaml-lsp-server ocamlformat utop
exec zsh   # pick up the opam env
```

`opam switch list` shows whether a switch already exists; `opam switch create`
errors out if the name is taken.

`home/programs/zsh.nix` runs `eval "$(opam env --safe)"` at shell init, guarded on
`~/.opam` existing, so shells work before that bootstrap. The direnv hook runs at
precmd and therefore still overrides this for per-project switches.

`ocaml-lsp-server` and `ocamlformat` must live in the default switch for the
editors to pick them up. Because the toolchain comes from the shell env, start
the editor from a shell; launched from a GUI launcher it will not see the opam
binaries.

OCaml is excluded from headless mode (`exedev@linux`).

### Environment
- Editor: hx (helix)
- Shell: nushell (login shell) with starship prompt; zsh still installed
- Multiplexer: zellij

### Nushell as login shell

`home/programs/nushell.nix` configures nushell; it is imported whenever
`headless` is false. `exedev@linux` (headless) stays on zsh, because both
`bootstrap.sh` and `exevm` drive VMs with `ssh host "a && b"` and nushell has
no `&&`.

Two details that are easy to get wrong:

- `configDir` is pinned to nu's own per-platform default (`Library/Application
  Support/nushell` on darwin, `.config/nushell` on Linux) and is **home
  relative**. It must not follow `xdg.enable`: nu only reads `~/.config/nushell`
  when `XDG_CONFIG_HOME` is set, and that variable only reaches shells via the
  POSIX `hm-session-vars.sh`, which nushell never sources — so a nu shell
  started from Ghostty or Finder would find no config. An *absolute* path here
  silently generates no config files at all.
- Env vars are generated from `home.sessionVariables` / `home.sessionPath`, so
  adding one there reaches nu too. Values containing POSIX expansion (`$VAR`,
  `${VAR:+...}`) are skipped, since nu does not interpret them, and must be
  written natively in `extraEnv` — `TERMINFO_DIRS` is the current example.

Changing the login shell is manual and one-time (nix-darwin only writes
`/etc/shells`). `chsh` records a literal path, so use the profile path, never a
store path — a store path becomes a dead login shell after `nh clean all`:

```bash
# macOS, after `darwin-rebuild switch`
chsh -s /etc/profiles/per-user/chrisaddy/bin/nu

# Linux: bootstrap.sh does this (also appends to /etc/shells)
chsh -s ~/.nix-profile/bin/nu
```

Verify with `dscl . -read /Users/chrisaddy UserShell` (macOS) or
`getent passwd "$USER"` (Linux), then open a **new** terminal while keeping the
current one alive. Rollback is `chsh -s /bin/zsh`.

`update` and `exevm` are real binaries from `home/programs/scripts.nix` rather
than zsh aliases/functions, so both shells get them. A nu wrapper calling
`zsh -lc update` would not work: `-lc` is non-interactive, so `.zshrc` — where
Home Manager puts aliases and functions — is never read.

### The `update` script

`home/programs/scripts.nix` builds `update` with `writeShellApplication`, which
means shellcheck runs at build time — a shell mistake fails `nix build`, not the
next run.

On a pacman machine it also upgrades the system layer, which Nix does not own:

```sh
paru -Syu --needed <archSystemPackages>      # falls back to sudo pacman -Syu
```

`paru` covers the AUR and invokes sudo itself; plain `pacman` needs `sudo` in
front. Passing the package list to `-Syu` makes the upgrade and the
ensure-installed one transaction. Detection is `command -v pacman`, which works
because `writeShellApplication` appends `:$PATH` after the Nix runtime inputs,
so `/usr/bin` is still on PATH.

`archSystemPackages` is the declarative list of things that genuinely cannot
come from Nix — pacman's own dependency graph (`base-devel` for paru's AUR
builds, `git`, `bubblewrap` for `glycin`) and the base system (`sudo`,
`openssh`, `less`, `vim` as a rescue editor). **An ordinary CLI tool does not
belong there**; put it in `home/default.nix`. Nix wins on PATH, so a pacman copy
of a tool Nix already provides is dead weight.
