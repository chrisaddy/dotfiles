set shell := ["bash", "-euo", "pipefail", "-c"]

os := `uname -s`

mac: brew stow-mac rust

arch: pacman stow-arch rust

rust:
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

brew:
    brew bundle --file Brewfile

pacman:
    sudo pacman -Syu --noconfirm
    xargs -a pkglist.txt sudo pacman -S --needed --noconfirm

stow-common:
    stow ghostty
    stow nvim
    stow -t ~ tmux
    stow -t ~ zoxide

stow-nushell-mac:
    stow -t "$HOME/Library/Application Support/nushell" nushell

stow-nushell-arch:
    stow -t "$HOME/.config/nushell" nushell

stow-mac: stow-common stow-nushell-mac

stow-arch: stow-common stow-nushell-arch
    stow hypr
    stow uwsm

unstow-mac:
    stow -D ghostty || true
    stow -D nvim || true
    stow -D yazi || true
    stow -D -t ~ tmux || true
    stow -D -t "$$HOME/Library/Application Support/nushell" nushell || true

unstow-arch:
    stow -D ghostty || true
    stow -D nvim || true
    stow -D yazi || true
    stow -D hypr || true
    stow -D -t ~ tmux || true
    stow -D -t "$$HOME/.config/nushell" nushell || true

check-stow-mac:
    mkdir -p "$$HOME/Library/Application Support/nushell"
    stow -n -v yazi
    stow -n -v -t "$$HOME/Library/Application Support/nushell" nushell

check-stow-arch:
    mkdir -p "$$HOME/.config/nushell"
    stow -n -v yazi
    stow -n -v -t "$$HOME/.config/nushell" nushell
    stow -n -v -t ~ tmux
