#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERNAME="$(whoami)"

echo "==> Bootstrapping dotfiles for ${USERNAME} on $(uname -s) ($(uname -m))"

# --- Install Nix if not present ---
if command -v nix &>/dev/null; then
  echo "==> Nix already installed: $(nix --version)"
else
  echo "==> Installing Nix..."
  curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  echo "==> Nix installed: $(nix --version)"
fi

# --- Enable flakes ---
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  echo "==> Enabled flakes"
else
  echo "==> Flakes already enabled"
fi

# --- Determine platform ---
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64)   PLATFORM="linux"     SYSTEM="x86_64-linux"    ;;
  Linux-aarch64)  PLATFORM="linux"     SYSTEM="aarch64-linux"   ;;
  Darwin-arm64)   PLATFORM="darwin"    SYSTEM="aarch64-darwin"  ;;
  Darwin-x86_64)  PLATFORM="darwin"    SYSTEM="x86_64-darwin"   ;;
  *) echo "Unsupported platform: $(uname -s)-$(uname -m)" && exit 1 ;;
esac

FLAKE_TARGET="${USERNAME}@${PLATFORM}"

# --- Ensure homeConfiguration exists in flake.nix ---
if ! grep -q "\"${FLAKE_TARGET}\"" "${DOTFILES_DIR}/flake.nix"; then
  echo "==> Adding homeConfiguration for '${FLAKE_TARGET}' to flake.nix"
  sed -i "/^      };$/i\\        \"${FLAKE_TARGET}\" = mkHome \"${SYSTEM}\" \"${USERNAME}\";" \
    "${DOTFILES_DIR}/flake.nix"
fi

# --- Activate home-manager ---
echo "==> Activating home-manager for '${FLAKE_TARGET}' (${SYSTEM})"
cd "${DOTFILES_DIR}"
nix run home-manager -- switch --flake ".#${FLAKE_TARGET}"

echo "==> Done! Open a new shell to pick up all changes."
