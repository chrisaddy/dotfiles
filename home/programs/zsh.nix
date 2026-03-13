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
