{
  pkgs,
  lib,
  username,
  headless ? false,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  imports =
    [
      ./programs/bat.nix
      ./programs/lazygit.nix
      ./programs/helix.nix
      ./programs/starship.nix
      ./programs/tmux.nix
      ./programs/yazi.nix
      ./programs/zoxide.nix
      ./programs/zsh.nix
    ]
    ++ lib.optionals (!headless) [
      ./programs/ghostty.nix
      ./programs/niri.nix
      ./programs/waybar.nix
    ];

  home = {
    username = username;
    homeDirectory =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs;
      [
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

        # Networking
        tailscale

        # Rust
        cargo
        rustc
        cargo-clean-recursive

        # Type checking
        ty

        # Nix
        nh
        devenv
        secretspec

        # Terminal
        tmux
        yazi
      ]
      ++ lib.optionals isDarwin [
        libiconv
        clang
      ]
      ++ lib.optionals isLinux [
        gcc
      ]
      ++ lib.optionals (!headless) [
        # Full dev environment extras
        codex
        fzf
        cmake
        ninja
        go
        rust-analyzer
        lldb
        marksman
        markdown-oxide
        elan
        awscli2
        google-cloud-sdk
        duckdb
        ffmpeg
      ]
      ++ lib.optionals (isLinux && !headless) [
        # Linux desktop only
        nyxt
      ];
  };

  home.sessionVariables =
    {
      EDITOR = "hx";
      VISUAL = "hx";
      NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    }
    // lib.optionalAttrs isDarwin {
      LIBRARY_PATH = lib.makeLibraryPath [
        pkgs.libiconv
      ];
    };

  home.sessionPath = ["$HOME/.npm-global/bin"];

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
