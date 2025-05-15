{
  pkgs,
  config,
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
    _1password-cli
    _1password-gui
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
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
          completer = "$carapace_completer";
        };
      };
    };

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
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
