{
  pkgs,
  lib,
  username,
  headless ? false,
  # Whether a desktop belongs on this machine. Defaults to the headless
  # answer, but is independent: WSL wants the full toolchain and no
  # compositor. See mkHome in flake.nix.
  gui ? !headless,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  imports = [
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/lazygit.nix
    ./programs/mise.nix
    ./programs/helix.nix
    ./programs/neovim.nix
    ./programs/notes.nix
    ./programs/scripts.nix
    ./programs/starship.nix
    ./programs/yazi.nix
    ./programs/zellij.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ]
  ++ lib.optionals (!headless) [
    # Nushell is the login shell everywhere except the headless VMs, which
    # keep zsh: bootstrap.sh and exevm drive them with `ssh host "a && b"`,
    # which nushell cannot parse.
    ./programs/nushell.nix
  ]
  ++ lib.optionals gui [
    ./programs/ghostty.nix
    ./programs/niri.nix
    ./programs/waybar.nix
  ];

  home = {
    username = username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "24.11";

    packages =
      with pkgs;
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
        lazygit
        delta
        gh
        nodejs
        pnpm
        sqlite

        # python
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
        # devenv 2.2.1+ vendors its own bin/secretspec, which collides with the
        # standalone package in buildEnv. hiPrio keeps this explicit 0.17.0 as
        # the one on PATH.
        (lib.hiPrio secretspec)

        # Terminal
        yazi
      ]
      ++ lib.optionals isDarwin [
        libiconv
        clang
        coreutils # GNU coreutils; BSD versions lack flags some tooling expects
      ]
      ++ lib.optionals isLinux [
        gcc
      ]
      ++ lib.optionals (!headless) [
        # Full dev environment extras
        fzf
        ninja
        shfmt # :lang sh — format
        shellcheck # :lang sh — lint
        nixfmt # :lang nix — format (nixfmt-rfc-style is now an alias for this)
        rust-analyzer
        rustfmt # :lang rust — format-on-save
        lldb
        marksman
        markdown-oxide
        lua-language-server # :lang lua
        yaml-language-server # :lang yaml
        tree-sitter # grammar CLI for neovim/helix
        zig

        # OCaml — opam manages the compiler and libraries in ~/.opam, so only
        # opam itself plus its build prerequisites live in the Nix closure.
        opam
        gmp
        m4
        pkg-config
        unzip

        awscli2
        azure-cli
        google-cloud-sdk
        duckdb
        ffmpeg
      ]
      ++ lib.optionals (isLinux && !headless) [
        bubblewrap # opam's build sandbox (Linux-only; opam skips it on darwin)
      ]
      ++ lib.optionals (isLinux && gui) [
        nyxt
      ];
  };

  home.sessionVariables = {
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

  # One definition for every shell: Home Manager merges home.shellAliases into
  # bash, zsh and nushell alike. They used to be declared per-shell, which
  # drifted — zsh aliased `ls` to `exa`, a package that is not installed, while
  # nushell correctly used `eza`.
  home.shellAliases = {
    ls = "eza -la";
    lss = "yazi";
    ccc = "claude --dangerously-skip-permissions";
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
