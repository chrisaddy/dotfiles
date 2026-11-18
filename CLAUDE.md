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
flake.nix              # Flake with home-manager + nix-darwin inputs (+ nixvim, doomemacs)
bootstrap.sh           # Zero-to-configured setup script
darwin/
  default.nix          # nix-darwin system config (system packages, platform)
home/
  default.nix          # Main home config (packages, imports, flag wiring)
  doom/                # Doom Emacs config (init.el, config.el, packages.el)
  programs/
    bat.nix            # bat config
    emacs.nix          # Emacs + Doom (links framework and config, `doom` wrapper)
    ghostty.nix        # Ghostty terminal (gui only)
    helix.nix          # Helix editor
    lazygit.nix        # Lazygit TUI
    neovim.nix         # Neovim via nixvim
    niri.nix           # Niri compositor (Linux, gui only)
    nushell.nix        # Nushell (login shell; non-headless only)
    scripts.nix        # `upd`, `exevm`, `swagger` binaries
    starship.nix       # Starship prompt
    tmux.nix           # Tmux (prefix C-a; fzf sessions on prefix+Space, tmux-fzf menu on prefix+F)
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

### Doom Emacs

`home/programs/emacs.nix` installs Emacs and links two read-only store paths:
the Doom framework (the `doomemacs` flake input) at `~/.config/emacs` and the
config in `home/doom/` at `~/.config/doom`. Everything Doom installs or builds
is mutable and lives in `~/.local/share/doom` (`DOOMLOCALDIR`), outside the Nix
store. `upd` runs `doom sync` after the switch, so a new machine and a moved
framework pin are both handled there; by hand it is:

```bash
doom sync      # after changing home/doom/init.el or packages.el, then switching
doom doctor    # when something looks off
```

`home/doom/config.el` needs a switch but no sync. Things that are easy to get
wrong:

- **Never `doom install` or `doom upgrade`.** Both drive git in `$EMACSDIR`,
  which here is a store path with no `.git`. `doom sync` is the only install
  step, and the framework is updated with `nix flake update doomemacs`.
- The `doomemacs` input is `git+https://...?submodules=1`, not `github:`. Doom
  keeps its modules in the `sources/doom+` submodule and the `github:` tarball
  has no submodules.
- Doom needs `EMACSDIR`, `DOOMDIR` and `DOOMLOCALDIR` in Emacs's environment.
  Without `DOOMLOCALDIR` it looks for its synced profile inside the store and
  stops with `void-variable doom-modules`. So `emacs` and `doom` on PATH are
  both wrappers that export the three (`doom` also pins the CLI to the
  editor's Emacs), and `home.sessionVariables` carries them for the daemon.
  Only `Emacs.app` opened from Finder or Spotlight bypasses all of that; use
  `emacsclient -c` there.
- Emacs prefers `~/.emacs.d` over `~/.config/emacs` whenever the former exists,
  and a plain Emacs creates it on first start. Activation removes an empty one
  and warns about a non-empty one, because either hides Doom completely.
- vterm and pdf-tools have native parts, so they come prebuilt from Nix
  (`programs.emacs.extraPackages`) and Doom is told to prefer those copies:
  vterm upstream, pdf-tools in `home/doom/packages.el`.

The Emacs build follows `gui`: `emacs-nox` without a desktop, `emacs-pgtk` on a
Linux desktop, Cocoa `emacs` on macOS.

#### Daemon and `emacsclient`

`services.emacs` starts one Emacs at login everywhere except the headless VMs:
a launchd agent (`org.nix-community.home.emacs`) on macOS, `emacs.service` in
the systemd user session on Linux.

```bash
emacsclient -c            # new GUI frame
emacsclient -t            # frame in this terminal
emacsclient -n FILE       # open FILE in an existing frame and return

# restart the daemon
launchctl kickstart -k gui/$(id -u)/org.nix-community.home.emacs   # macOS
systemctl --user restart emacs                                     # Linux
```

- Both platforms start Emacs through a login shell (`bash -l -c`). On Linux
  that is Home Manager's own unit; on macOS `emacs.nix` overrides the agent's
  `ProgramArguments`, because launchd would otherwise exec Emacs with a bare
  PATH and no `DOOM*` variables. The daemon's environment is therefore what
  `~/.profile` produces, not what nushell or `.zshrc` add on top (the opam
  env, for one).
- **A running daemon does not see a `doom sync`.** Restart it after syncing,
  or after a switch that changed `home/doom/`. Restarting closes every frame;
  unsaved buffers are only auto-saved.
- On macOS a switch that changes the Emacs store path makes Home Manager
  reload the agent, which restarts the daemon in the middle of `upd`, before
  its `doom sync`. After an Emacs version bump that daemon comes up without a
  Doom profile (`void-variable doom-modules`); restart it once `upd` is done.

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
- Editor: nvim (neovim)
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

`upd` and `exevm` are real binaries from `home/programs/scripts.nix` rather
than zsh aliases/functions, so both shells get them. A nu wrapper calling
`zsh -lc upd` would not work: `-lc` is non-interactive, so `.zshrc` — where
Home Manager puts aliases and functions — is never read.

### The `upd` script

`home/programs/scripts.nix` builds `upd` with `writeShellApplication`, which
means shellcheck runs at build time — a shell mistake fails `nix build`, not the
next run.

It is named `upd` rather than `update` because nushell ships an `update`
builtin (it edits table cells) and builtins shadow externals, so from the
login shell a binary called `update` can never be invoked.

On a pacman machine it also upgrades the system layer, which Nix does not own:

```sh
sudo pacman -Syu --needed <archSystemPackages>
```

Passing the package list to `-Syu` makes the upgrade and the ensure-installed
one transaction. Detection is `command -v pacman`, which works because
`writeShellApplication` appends `:$PATH` after the Nix runtime inputs, so
`/usr/bin` is still on PATH.

There is **no AUR helper** in the loop. Every entry in `archSystemPackages`
must therefore resolve in the official repos — an AUR-only name makes
`pacman -S` exit with "target not found", and `set -o errexit` takes the whole
update down with it before any Nix work runs.

`archSystemPackages` is the declarative list of things that genuinely cannot
come from Nix: the Arch base (`base`, `base-devel`, `sudo`, `openssh`, `less`),
`bubblewrap` because `glycin` links against it, and `vim`/`git` as the rescue
floor — a broken Nix profile takes `nvim` and Nix's `git` with it, and repairing
the flake needs an editor and a way to reach the repo. **An ordinary CLI tool
does not belong there**; put it in `home/default.nix`. Nix wins on PATH, so a
pacman copy of a tool Nix already provides is dead weight.
