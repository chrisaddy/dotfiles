rust:
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    cargo install bacon cargo-cache cargo-sweep tree-sitter-cli

brew:
    brew bundle

stow:
    stow ghostty
    stow -t ~ nushell
    stow nvim
    stow -t ~ tmux

mac: brew stow rust
