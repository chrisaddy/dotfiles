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
    stow emacs
    stow -t ~ tmux

stow-nushell-mac:
    stow -t "$HOME/Library/Application Support/nushell" nushell

stow-nushell-arch:
    stow -t "$HOME/.config/nushell" nushell

stow-doom:
    stow -t ~ doom

stow-mac: stow-common stow-doom stow-nushell-mac

stow-arch: stow-common stow-nushell-arch
    stow hypr
    stow uwsm

unstow-mac:
    stow -D ghostty || true
    stow -D nvim || true
    stow -D emacs || true
    stow -D -t ~ tmux || true
    stow -D -t ~ doom || true
    stow -D -t "$$HOME/Library/Application Support/nushell" nushell || true

unstow-arch:
    stow -D ghostty || true
    stow -D nvim || true
    stow -D emacs || true
    stow -D hypr || true
    stow -D -t ~ tmux || true
    stow -D -t "$$HOME/.config/nushell" nushell || true

check-stow-mac:
    mkdir -p "$$HOME/Library/Application Support/nushell"
    stow -n -v -t "$$HOME/Library/Application Support/nushell" nushell
    stow -n -v ghostty nvim emacs
    stow -n -v -t ~ doom tmux

check-stow-arch:
    mkdir -p "$$HOME/.config/nushell"
    stow -n -v -t "$$HOME/.config/nushell" nushell
    stow -n -v ghostty nvim emacs hypr
    stow -n -v -t ~ tmux
