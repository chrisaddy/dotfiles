# dotfiles (arch branch)

Same personal configs as `main`, minus Nix. This branch targets a plain Arch
Linux machine: packages come from pacman/AUR, configs are plain files
symlinked into place with GNU stow, and `just` replaces `nh`/`home-manager`
as the task runner. `main` (Nix + Home Manager + nix-darwin, covers macOS too)
is the source of truth for what these configs are supposed to do — this
branch is a from-scratch re-implementation of the same setup for a non-Nix
box, not a fork that stays in sync automatically.

## Quick start

```bash
git clone https://github.com/chrisaddy/dotfiles ~/dotfiles
cd ~/dotfiles
git checkout arch
./bootstrap.sh
```

`bootstrap.sh` installs `just` if missing and then runs `just bootstrap`,
which:

1. installs every package in `packages/pacman.txt` via `pacman`, and every
   package in `packages/aur.txt` via `paru` (bootstrapping `paru` itself from
   the AUR if it isn't already on the machine)
2. symlinks every `config/<package>/` tree into `$HOME` with `stow`
3. fetches the `zjstatus` zellij plugin (not packaged for Arch)
4. rebuilds bat's theme cache
5. sets `nu` (nushell) as the login shell

Run `just --list` for the individual recipes (`install`, `stow`, `restow`,
`unstow`, ...).

## Structure

```
Justfile                  # install / stow / bootstrap recipes
bootstrap.sh              # thin wrapper: install just, then `just bootstrap`
packages/
  pacman.txt               # official-repo packages
  aur.txt                   # AUR packages (via paru)
config/                    # one stow package per subdirectory
  git/.config/git/config
  zsh/.zshrc
  nushell/.config/nushell/
  starship/.config/starship.toml
  bat/.config/bat/            # config + vendored Catppuccin Macchiato theme
  lazygit/.config/lazygit/config.yml
  yazi/.config/yazi/          # config + vendored Catppuccin theme
  zellij/.config/zellij/config.kdl
  ghostty/.config/ghostty/config
  niri/.config/niri/config.kdl
  waybar/.config/waybar/      # config.jsonc + style.css
  nvim/.config/nvim/          # lazy.nvim, converted from the nixvim config
  scripts/.local/bin/         # update, exevm
```

## Notable deviations from `main`

- **Neovim** was NixVim there; here it's plain Lua bootstrapping
  [lazy.nvim](https://github.com/folke/lazy.nvim). Two plugins could not be
  confirmed against an upstream repo while converting (nixvim's `bacon` and
  `codediff` modules) — see the comments in
  `config/nvim/.config/nvim/lua/plugins/git.lua` and `editor.lua` before
  relying on those two.
- **LSP servers** are expected on `$PATH` (installed via the package lists
  above) rather than auto-installed by `mason.nvim` — there's no second,
  editor-managed package manager on this branch.
- **darwin/**, **emacs/doom**, and anything nix-specific (nh, devenv,
  secretspec, nixfmt) don't apply here and were dropped rather than ported.
- `home/programs/zsh.nix`'s `ls` alias literally says `alias ls="exa -la"`
  (the unmaintained predecessor to `eza`) while nushell's says `eza -la` —
  that mismatch already existed in the Nix config and was carried over as-is
  in `config/zsh/.zshrc` rather than silently "fixed".
- `cargo-clean-recursive` and `ty` (Astral's type checker) aren't packaged
  for Arch; install with `cargo install cargo-clean-recursive` and
  `uv tool install ty`.
- The Claude Code CLI itself isn't a system package here either — it's the
  self-updating installer in `~/.local/bin` that `config/nvim`'s claudecode.nvim
  and the `ccc` alias both point at.

## Updating

```bash
update   # from packages/... in config/scripts: git pull, pacman -Syu, paru -Sua, just stow, commit, push
```
