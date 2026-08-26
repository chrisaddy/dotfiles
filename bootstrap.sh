#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "==> Bootstrapping dotfiles (Arch Linux, no Nix) for $(whoami)"

if ! command -v just >/dev/null 2>&1; then
  echo "==> Installing just"
  sudo pacman -S --needed --noconfirm just
fi

just bootstrap

echo "==> Done! Open a new shell to pick up all changes."
