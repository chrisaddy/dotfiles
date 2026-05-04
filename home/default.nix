{ config, pkgs, lib, username, headless ? false, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  pi-coding-agent-unwrapped = pkgs.buildNpmPackage {
    pname = "pi-coding-agent";
    version = "0.72.1";
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.72.1.tgz";
      hash = "sha256-lyvT1SyvfsQe2a5m71Hf+awOo7CPVNRwvSf3TCcWeUY=";
      name = "pi-coding-agent-0.72.1.tgz";
    };
    sourceRoot = "package";
    postPatch = ''
      cp ${./packages/pi-coding-agent-package-lock.json} package-lock.json
    '';
    npmDepsHash = "sha256-4yl8bTUVZjJni9jPf/CbUNWfI+rQJBRcTvX7U4SH+EM=";
    dontNpmBuild = true;
  };
  pi-coding-agent = pkgs.symlinkJoin {
    name = "pi-coding-agent-wrapped";
    paths = [ pi-coding-agent-unwrapped ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/pi \
        --run 'export NPM_CONFIG_PREFIX="$HOME/.npm-global"' \
        --run 'mkdir -p "$HOME/.npm-global"' \
        --run 'export PATH="$HOME/.npm-global/bin:$PATH"'
    '';
  };
in
{
  imports = [
    ./programs/bat.nix
    ./programs/lazygit.nix
    ./programs/helix.nix
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
      pi-coding-agent
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

      # Rust
      cargo-clean-recursive

      # Nix
      nh
      devenv

      # Terminal
      tmux
      yazi
    ] ++ lib.optionals (!headless) [
      # Full dev environment extras
      anki
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
      google-cloud-sdk
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
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [ "$HOME/.npm-global/bin" ];

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
