set shell := ["bash", "-euo", "pipefail", "-c"]

os := `uname -s`

mac: brew stow-mac rust setup-hooks

arch: pacman stow-arch rust setup-hooks

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
    local_bin="$$HOME/.local/bin"
    mkdir -p "$local_bin"

    existing=""
    for f in bin/*; do
      [ -e "$local_bin/$(basename "$f")" ] || continue
      name="$(basename "$f")"

      escaped="$(printf '%s' "$name" | sed -e 's/[.\\^$*+?(){}|\[\]\\\\]/\\&/g')"
      if [ -n "$existing" ]; then
        existing+="|$escaped"
      else
        existing="$escaped"
      fi
    done

    if [ -n "$existing" ]; then
      stow -t "$local_bin" --ignore="^($existing)$" bin
    else
      stow -t "$local_bin" bin
    fi

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

setup-hooks:
    git config core.hooksPath git/hooks

check-stow-arch:
    mkdir -p "$$HOME/.config/nushell"
    stow -n -v yazi
    stow -n -v -t "$$HOME/.config/nushell" nushell
    stow -n -v -t ~ tmux
