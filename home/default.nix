{ config, pkgs, lib, username, headless ? false, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./programs/bat.nix
    ./programs/lazygit.nix
    ./programs/nixvim
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/yazi.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ] ++ lib.optionals (!headless) [
    ./programs/zellij.nix
    ./programs/ghostty.nix
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
      cloc
      curl
      dust
      fd
      jq
      ripgrep
      tree
      wget

      # Development
      git
      claude-code
      lazygit
      delta
      gh
      gcc
      nodejs
      sqlite

      # Python
      python3
      uv
      ruff
      basedpyright

      # Shell tools
      starship
      zoxide
      carapace
      bat
      eza
      gum
      just
      direnv
      sesh

      # Nix
      nh
      devenv

      # Terminal
      tmux
      yazi
    ] ++ lib.optionals (!headless) [
      # Full dev environment extras
      codex
      fzf
      pre-commit
      cmake
      ninja
      go
      rust-analyzer
      elan
      stow
      awscli2
      duckdb
      ffmpeg
      zellij
    ] ++ lib.optionals (isLinux && !headless) [
      # Linux desktop only
      nyxt
    ];
  };

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  programs.git = {
    enable = true;
    signing.format = null;
    settings.user = {
      name = "chrisaddy";
      email = "chris.william.addy@gmail.com";
    };
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
}
