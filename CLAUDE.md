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
  doom/                # Doom Emacs config (init.el, config.el, packages.el)
  packages/            # Vendored lockfiles for npm packages
  programs/
    bat.nix            # bat config
    emacs.nix          # Emacs + Doom (symlinks framework & config, sets DOOM* env)
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

### Doom Emacs

`home/programs/emacs.nix` installs Emacs (via `programs.emacs`) and symlinks both
the Doom framework (pinned as the `doomemacs` flake input) and the `home/doom/`
config dir into XDG paths, then sets the `DOOM*` env vars. Doom's package state
stays mutable outside the Nix store, so first-run setup is manual:

```bash
# After the first `darwin-rebuild`/`home-manager switch`,
# from a SHELL THAT HAS THE DOOM* env vars (re-login or `exec zsh`;
# re-sourcing hm-session-vars.sh in an existing shell is a no-op because of
# its once-per-session guard). Verify with: echo $DOOMLOCALDIR
~/.config/emacs/bin/doom sync
```

Do **not** run `doom install` here. Under Nix the framework lives at a
read-only store path with no `.git`, so `doom install`'s submodule-update and
git-hook-deploy steps always fail. `doom sync` is the only command needed; it
installs/builds packages into `$DOOMLOCALDIR` (`~/.local/share/doom`).

The `doomemacs` input MUST be fetched with submodules — the framework keeps its
modules in a `sources/doom+` submodule, and the `github:` fetcher drops
submodules. The flake uses `git+https://github.com/doomemacs/doomemacs?submodules=1`
for this reason; don't revert it to the `github:` shorthand.

Run `~/.config/emacs/bin/doom sync` after any change to `home/doom/init.el`,
`home/doom/packages.el`, or the Doom env vars. Update the framework with
`nix flake update doomemacs`.

### OCaml / opam

Nix installs only `opam` and its build prerequisites (`gmp`, `m4`, `pkg-config`,
`unzip`, plus `bubblewrap` on Linux for opam's sandbox). The compiler and all
libraries live in a mutable `~/.opam` outside the Nix store, so — like Doom —
first-run setup is manual:

```bash
# Only on a machine with no ~/.opam yet:
opam init --bare -n
opam switch create default ocaml-base-compiler

# Always — the tooling Doom's :lang ocaml expects:
opam install -y dune ocaml-lsp-server ocamlformat utop
exec zsh   # pick up the opam env
```

`opam switch list` shows whether a switch already exists; `opam switch create`
errors out if the name is taken.

`home/programs/zsh.nix` runs `eval "$(opam env --safe)"` at shell init, guarded on
`~/.opam` existing, so shells work before that bootstrap. The direnv hook runs at
precmd and therefore still overrides this for per-project switches.

Doom's `:lang (ocaml +lsp)` uses opam's `ocaml-lsp-server` and `ocamlformat` —
both must be in the default switch, and `doom sync` must run after enabling it.
Because the toolchain comes from the shell env, Emacs must be started from a
shell (terminal or `emacsclient`). Launched from a macOS GUI launcher it won't
see the opam binaries; the fix if that ever matters is `exec-path-from-shell` in
`home/doom/packages.el`.

OCaml is excluded from headless mode (`exedev@linux`).

### Environment
- Editor: hx (helix)
- Shell: zsh with starship prompt
- Tmux prefix: `C-Space`
