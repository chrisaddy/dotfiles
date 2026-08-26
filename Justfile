set shell := ["bash", "-euo", "pipefail", "-c"]

pkg_list := "grep -vE '^\\s*(#|$)'"

# List available recipes.
default:
    @just --list

# Full zero-to-configured setup: packages, stow, extras, login shell.
bootstrap: install stow nvim-plugins zellij-plugins bat-cache shell

# Install official-repo packages (pacman) and AUR packages (paru).
install:
    sudo pacman -Syu
    sudo pacman -S --needed --noconfirm $({{ pkg_list }} packages/pacman.txt)
    command -v paru >/dev/null 2>&1 || just install-paru
    paru -S --needed --noconfirm $({{ pkg_list }} packages/aur.txt)

# Bootstrap paru itself from the AUR (needs base-devel + git).
install-paru:
    sudo pacman -S --needed --noconfirm base-devel git
    tmp="$(mktemp -d)"; \
    git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"; \
    cd "$tmp/paru-bin" && makepkg -si --noconfirm; \
    rm -rf "$tmp"

# Symlink every config/<package> tree into $HOME with GNU stow.
stow:
    stow -v -t ~ -d config $(ls config)

# Re-stow (use after adding/removing files in a package).
restow:
    stow -v -R -t ~ -d config $(ls config)

# Remove all symlinks stow created.
unstow:
    stow -v -D -t ~ -d config $(ls config)

# Rebuild bat's theme cache after (re)stowing the vendored catppuccin theme.
bat-cache:
    bat cache --build

# Install lazy.nvim's plugins and run their branch/version checkouts up
# front. On a from-scratch install, lazy.nvim's first-ever plugin `clone`
# races its own `checkout` task (e.g. nvim-treesitter's pinned `master`
# branch) — the very first interactive nvim launch can otherwise show a
# transient config error for whichever plugin lost that race.
nvim-plugins:
    nvim --headless "+Lazy! sync" "+qa!"

# zjstatus (zellij status bar plugin) isn't packaged for Arch; fetch the
# release wasm that config/zellij/.config/zellij/config.kdl points at.
zellij-plugins:
    mkdir -p ~/.config/zellij/plugins
    curl -L -o ~/.config/zellij/plugins/zjstatus.wasm \
      https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# nushell is the login shell on the full workstation, matching the Nix setup.
shell:
    command -v nu >/dev/null 2>&1 || { echo "nushell not installed" >&2; exit 1; }
    grep -qxF "$(command -v nu)" /etc/shells || echo "$(command -v nu)" | sudo tee -a /etc/shells
    chsh -s "$(command -v nu)"
