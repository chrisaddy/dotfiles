{ config, pkgs, lib, username, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./programs/bat.nix
    ./programs/ghostty.nix
    ./programs/lazygit.nix
    ./programs/nixvim
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/yazi.nix
    ./programs/zellij.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
    ./programs/niri.nix
    ./programs/waybar.nix
  ];

  home = {
    username = username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
      # SSL certs (needed for nix-installed tools on macOS)
      cacert

      # Core tools
      ripgrep
      fd
      fzf
      jq
      tree
      cloc
      curl
      wget

      # Development
      git
      claude-code
      codex
      lazygit
      delta
      gh
      pre-commit
      cmake
      ninja
      gcc
      go
      nodejs
      sqlite

      # Python
      python3
      uv
      ruff
      basedpyright

      # Rust
      rust-analyzer

      # Lean
      elan

      # Shell tools
      starship
      zoxide
      carapace
      bat
      eza
      gum
      just
      stow
      direnv

      # Media
      ffmpeg

      # Cloud
      awscli2

      # Data
      duckdb

      # Nix
      nh
      devenv

      # Terminal
      tmux
      zellij
      yazi
    ] ++ lib.optionals isLinux [
      # Linux-only
      nyxt
    ];
  };

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "chrisaddy";
      email = "chris.william.addy@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
}
