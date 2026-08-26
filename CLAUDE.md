# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the **arch branch** of a personal dotfiles repo. `main` manages the
same configs on macOS + Linux with Nix (Home Manager + nix-darwin, via
flakes). This branch is a from-scratch, non-Nix re-implementation of the same
configs for a plain Arch Linux machine: pacman/AUR for packages, GNU stow for
placing dotfiles, and `just` as the task runner. It does not track `main`
automatically — when a config changes on `main`, the equivalent file here
needs to be updated by hand.

## Commands

```bash
./bootstrap.sh      # install `just` if missing, then `just bootstrap`
just --list         # see all recipes
just install        # pacman (packages/pacman.txt) + paru (packages/aur.txt)
just stow            # symlink every config/<package>/ into $HOME
just restow          # stow -R, after editing files inside a package
just unstow           # remove the symlinks
```

## Architecture

```
Justfile                  # install / stow / bootstrap recipes
bootstrap.sh              # thin wrapper: install just, then `just bootstrap`
packages/
  pacman.txt               # official-repo packages
  aur.txt                   # AUR packages (via paru)
config/                    # one stow package per top-level subdirectory;
                            # each mirrors the $HOME path it symlinks to
```

Each subdirectory of `config/` is an independent GNU stow package. `just
stow` runs `stow -t ~ -d config <every subdir>`; adding a new tool means
adding a new `config/<name>/` tree with paths relative to `$HOME`, then
adding it to `packages/pacman.txt` or `packages/aur.txt`.

### Neovim

`config/nvim/.config/nvim/` is plain Lua bootstrapping
[lazy.nvim](https://github.com/folke/lazy.nvim), converted by hand from
`main`'s NixVim config. `init.lua` sets options/leader and calls
`require("lazy").setup(...)`; `lua/keymaps.lua` holds all keymaps;
`lua/plugins/*.lua` holds one lazy.nvim spec file per logical group
(colorscheme, ui, completion, treesitter, lsp, git, editor, claudecode).

LSP servers are plain `nvim-lspconfig` + `vim.lsp.enable(...)` — there is no
`mason.nvim`. Every server name in `lua/plugins/lsp.lua` is expected to
resolve on `$PATH`, installed via `packages/pacman.txt` / `packages/aur.txt`
rather than by a second, editor-managed package manager.

Two plugins (`bacon`, `codediff`) were carried over from NixVim's module
names with the upstream GitHub repo unconfirmed — see the comments in
`lua/plugins/editor.lua` and `lua/plugins/git.lua` before relying on either.

### Shell

Nushell is the login shell (`just shell` / `chsh`), matching `main`'s
full-workstation default. Zsh (`config/zsh/.zshrc`) is kept side-by-side and
fully configured, same as on `main`. `update` and `exevm`
(`config/scripts/.local/bin/`) are plain shell scripts on `$PATH` so both
shells get them without either needing to know about the other.

### What was intentionally dropped, not ported

`darwin/`, Doom Emacs/opam bootstrapping notes, and anything Nix-specific
(`nh`, `devenv`, `secretspec`, `nixfmt`, NixOS/nix-darwin system config) don't
apply to a plain Arch box and were left out rather than translated. Nix
language tooling itself (the `nil` LSP, `alejandra` formatter) was kept in
Neovim's language configs, since editing someone else's `.nix` files
is still plausible even on a Nix-free machine.

See `README.md`'s "Notable deviations from `main`" section for the specific
list of things that could not be ported 1:1 (unconfirmed plugin sources,
packages not in pacman/AUR, a pre-existing `exa`/`eza` alias mismatch carried
over as-is).
