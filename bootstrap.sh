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

# --- Enable flakes (user config) ---
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  echo "==> Enabled flakes (user)"
else
  echo "==> Flakes already enabled (user)"
fi

# --- Enable flakes (system config, needed for nix-collect-garbage etc.) ---
if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null
  echo "==> Enabled flakes (system)"
else
  echo "==> Flakes already enabled (system)"
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

# --- Set zsh as default shell ---
NIX_ZSH="$(which zsh 2>/dev/null || echo "")"
if [ -n "${NIX_ZSH}" ] && [ "$(basename "${SHELL}")" != "zsh" ]; then
  echo "==> Setting zsh as default shell (${NIX_ZSH})"
  if ! grep -qF "${NIX_ZSH}" /etc/shells 2>/dev/null; then
    echo "${NIX_ZSH}" | sudo tee -a /etc/shells >/dev/null
  fi
  sudo chsh -s "${NIX_ZSH}" "${USERNAME}"
  echo "==> Default shell changed to zsh"
else
  echo "==> Shell already set to zsh"
fi

echo "==> Done! Open a new shell to pick up all changes."
