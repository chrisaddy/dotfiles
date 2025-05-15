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

    envFile.text = ''
      source-env "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      source-env /etc/profiles/per-user/${config.home.username}/etc/profile.d/hm-session-vars.sh

      $env.PATH = $env.PATH ++ ["/etc/profiles/per-user/${config.home.username}/bin"]
    '';

    configFile.text = ''
      let carapace_completer = {|spans|
      carapace $spans.0 nushell ...$spans | from json
      }
    '';

    settings = {
      show_banner = false;
      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "fuzzy";
        external = {
          enable = true;
          max_results = 100;
          completer = lib.hm.nushell.mkNushellInline "$carapace_completer";
        };
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
