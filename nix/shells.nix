{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
    pyenv
    direnv
    zoxide
    tmux
    _1password-cli
    _1password-gui
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    loginShell = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    dirHashes = {
      projects = "$HOME/projects";
      psf = "$HOME/projects/psf";
    };
    history = {
      append = true;
      expireDuplicatesFirst = true;
      findNoDups = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      vim = "nvim";
      cp = "cp -rfiv";
    };
    sessionVariables = {
      EDITOR = "hx";
      ZK_NOTEBOOK_DIR = "$HOME/vaults/zettelkasten";
    };
    initContent = ''
      cmt() {
        local branch diff message temp_file ticket_number final_message
        branch=$(git rev-parse --abbrev-ref HEAD)
        diff=$(git --no-pager diff --cached)
        [ -z "$diff" ] && echo "No changes to commit." && return 1
        ticket_number=$(echo "$branch" | grep -oE '[A-Z]+-[0-9]+' || echo "TRIVIAL")
        message=$(echo "$diff" | mods -f "... prompt ...")  # trim prompt for brevity
        [ -z "$message" ] && echo "Failed to generate commit message." && return 1
        temp_file=$(mktemp)
        echo "$ticket_number $message" > "$temp_file"
        nvim "$temp_file"
        final_message=$(cat "$temp_file")
        rm "$temp_file"
        [ -z "$final_message" ] && echo "Empty commit message. Aborting." && return 1
        git commit -m "$final_message"
      }
      eval "$(/opt/homebrew/bin/brew shellenv)"

      export PATH="$HOME/.local/bin:$PATH"
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init --path)"
      eval "$(pyenv init -)"
      source "$HOME/.secrets"
    '';
  };
}
