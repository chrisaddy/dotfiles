# Doom Emacs via Nix Home Manager — Design

**Date:** 2026-06-17
**Reference:** https://github.com/sebnyberg/doomemacs-nix-example

## Goal

Add Doom Emacs to the dotfiles, managed through Nix Home Manager. Follow the
reference repo's pragmatic approach: Nix installs Emacs and symlinks both the
Doom framework and the user's Doom config into XDG paths, while Doom's package
state remains mutable outside the Nix store (synced manually via `doom sync`).

## Decisions

- **Config storage:** Real `.el` files in `home/doom/`, symlinked via
  `xdg.configFile."doom".source = ../doom`. Doom expects real files and elisp is
  awkward to inline.
- **Config content:** Minimal sane starter (vertico, magit, evil, a few langs).
- **Platforms:** Available everywhere, including the headless `exedev@linux`
  config. The module branches internally on `headless` for package/font choices.
- **Framework pinning:** Doom Emacs added as a `flake = false` flake input
  (pinned in `flake.lock`, updated via `nix flake update`) rather than a
  hardcoded `builtins.fetchGit` rev.

## Components

### 1. `flake.nix`

- Add input: `doomemacs = { url = "github:doomemacs/doomemacs"; flake = false; };`
- Thread `doomemacs` into both code paths:
  - `mkHome`: add to `extraSpecialArgs`.
  - darwin block: add to `home-manager.extraSpecialArgs`.
- Add `doomemacs` to the `outputs = { ... }:` argument set.

### 2. `home/programs/emacs.nix` (new)

Module signature: `{ pkgs, lib, config, headless ? false, doomemacs, ... }`.

- `programs.emacs.enable = true` with package:
  - headless → `pkgs.emacs30-nox`
  - Linux non-headless → `pkgs.emacs30-pgtk`
  - macOS → `pkgs.emacs30`
- `home.sessionVariables`:
  - `DOOMDIR = "${config.xdg.configHome}/doom"`
  - `EMACSDIR = "${config.xdg.configHome}/emacs"`
  - `DOOMLOCALDIR = "${config.xdg.dataHome}/doom"`
  - `DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el"`
- `home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ]`
- `xdg.configFile."emacs".source = doomemacs;`
- `xdg.configFile."doom".source = ../doom;`
- `home.packages`: `fd`, `(ripgrep.override { withPCRE2 = true; })`; non-headless
  also gets `emacs-all-the-icons-fonts`, `nerd-fonts.symbols-only`,
  `nerd-fonts.jetbrains-mono`.
- `fonts.fontconfig.enable = true` on Linux non-headless.

### 3. `home/default.nix`

- Add `./programs/emacs.nix` to the unconditional `imports` list (the module
  itself handles headless branching).

### 4. `home/doom/` (new)

- `init.el` — `doom!` module block: completion (vertico, corfu), ui (doom theme,
  modeline, nerd icons, ligatures), editor (evil +everywhere, file-templates,
  fold), emacs (dired, undo, vc), checkers (syntax, spell), tools (lookup, magit,
  tree-sitter), lang (emacs-lisp, `(nix)`, `(python +lsp +tree-sitter)`,
  markdown, sh, org), config (default +bindings).
- `config.el` — user identity, JetBrainsMono Nerd Font, `doom-one` theme,
  relative line numbers, sane defaults.
- `packages.el` — commented placeholder for extra packages.

### 5. `CLAUDE.md`

Add a "Doom Emacs" subsection documenting first-run bootstrap and the
sync-after-change rule.

## Bootstrap (manual, one-time)

Nix cannot run these because Doom's state is mutable:

```bash
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"   # or re-login
~/.config/emacs/bin/doom install
~/.config/emacs/bin/doom sync
```

Run `doom sync` after any change to `home/doom/` or the Doom env vars.

## Trade-offs

Doom's package state lives outside the Nix store (mutable), so this is not a
fully pure/reproducible setup. This is the reference's deliberate choice and the
only approach that works reliably with Doom today.

## Verification

`nix build '.#homeConfigurations.chrisaddy@darwin.activationPackage' --dry-run`
must evaluate cleanly. Full reproducibility of Doom packages is out of scope.
