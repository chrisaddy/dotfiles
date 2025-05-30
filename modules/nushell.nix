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
    direnv
    tmux
    fselect
    nufmt
    entr
  ];

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
    ];
    config = {
      pager = "less -FR";
      theme = "TwoDark";
    };
  };

  programs.eza = {
    enable = false;
    enableNushellIntegration = true;
    colors = "always";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

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
    package = pkgs.writeShellScriptBin "nu" ''
      exec ${pkgs.coreutils}/bin/env ~/.local/bin/nu "$@"
    '';

    environmentVariables = {
      EDITOR = "hx";
    };

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
          completer = lib.hm.nushell.mkNushellInline ''
            {|spans|
              carapace $spans.0 nushell ...$spans | from json
            }
          '';
        };
      };
    };
    extraConfig = ''
      $env.PATH = ($env.PATH
        | split row (char esep)
        | append /nix/var/nix/profiles/default/bin
        | append /etc/profiles/per-user/${config.home.username}/bin
        | append /run/current-system/sw/bin
        | append /usr/local/bin
        | append ~/.local/bin
      )

      source ~/.secrets.nu
    '';
    shellAliases = {
      vi = "hx";
      vim = "hx";
      nano = "hx";
      lj = "lazyjj";
      jh = "jj --help";
      je = "jj edit";
      js = "jj st";
      jsq = "jj squash";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
