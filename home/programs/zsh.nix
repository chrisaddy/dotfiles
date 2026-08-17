{ config, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "exa -la";
      lss = "yazi";
      ccc = "claude --dangerously-skip-permissions";
      zl = "zellij attach $(zellij list-sessions --short | fzf)";
      zk = "zellij delete-session $(zellij list-sessions --short | fzf) --force";
      # `update` and `exevm` live in programs/scripts.nix as real binaries, so
      # nushell gets them too.
    };

    initContent = ''
      export PATH=$HOME/.local/bin:$PATH:$HOME/.cargo

      # Carapace completions
      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)

      # opam env for the default switch (compiler, dune, ocaml-lsp-server,
      # ocamlformat). Guarded on ~/.opam so a machine that hasn't run
      # `opam init` yet starts a clean shell. --safe keeps opam from rewriting
      # any state just to print the env. Per-project switches still override
      # this via the direnv hook below, which runs at precmd.
      # Skipped inside devenv: an auto-activated devenv shell re-runs this file,
      # and opam would prepend its switch ahead of the project's nix toolchain.
      if [ -z "$DEVENV_ROOT" ] && command -v opam >/dev/null 2>&1 && [ -d "$HOME/.opam" ]; then
        eval "$(opam env --safe)"
      fi

      # devenv native auto-activation (devenv 2.0+). Resolved via $PATH rather
      # than a pinned store path, for the same GC-safety reason as direnv below.
      # Projects opt in with `devenv allow`.
      if command -v devenv >/dev/null 2>&1; then
        eval "$(devenv hook zsh)"
      fi

      # direnv hook resolved via $PATH rather than a pinned store path, so it
      # keeps working after a rebuild + garbage collection deletes the old
      # direnv derivation out from under an already-running shell.
      if command -v direnv >/dev/null 2>&1; then
        _direnv_hook() {
          trap -- ''' SIGINT
          eval "$(direnv export zsh)"
          trap - SIGINT
        }
        typeset -ag precmd_functions
        if (( ! ''${precmd_functions[(I)_direnv_hook]} )); then
          precmd_functions=(_direnv_hook $precmd_functions)
        fi
        typeset -ag chpwd_functions
        if (( ! ''${chpwd_functions[(I)_direnv_hook]} )); then
          chpwd_functions=(_direnv_hook $chpwd_functions)
        fi
      fi

      source $HOME/.secrets
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # We install our own $PATH-based hook above; disable HM's, which bakes in an
    # absolute store path that breaks when that store path is GC'd.
    enableZshIntegration = false;
  };
}
