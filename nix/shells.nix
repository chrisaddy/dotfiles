{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
    pyenv
    direnv
    zoxide
    tmux
  ];

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    envFile.source = ../nu/env.nu;
    configFile.source = ../nu/config.nu;

    # settings = {
    #   show_banner = false;
    #   completions = {
    #     case_sensitive = false;
    #     quick = true;
    #     partial = true;
    #     algorithm = "fuzzy";
    #     external = {
    #       enable = true;
    #       max_results = 100;
    #       completer = lib.hm.nushell.mkNushellInline ''
    #         carapace $spans.0 nushell ...$spans | from json
    #       '';
    #     };
    #   };
    # };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
