{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      vim = "nvim";
      update = "pushd $HOME/dotfiles && nh home switch . -c $(whoami)@$(if [ $(uname) = Darwin ]; then echo darwin; else echo linux; fi) && nh clean all; popd";
    };

    initContent = ''
      export PATH=$HOME/.local/bin:$PATH

      # Carapace completions
      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
