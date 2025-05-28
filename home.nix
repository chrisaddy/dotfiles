{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./ai.nix
    ./docker.nix
    # ./emacs.nix
    ./git.nix
    ./gcloud.nix
    ./haskell.nix
    ./helix.nix
    ./media.nix
    ./nix.nix
    ./notes.nix
    # ./obs.nix
    ./python.nix
    ./rust.nix
    ./shells.nix
    ./terminal.nix
    # ./theme.nix
    ./tmux.nix
    # ./vim.nix
    # ./vscode.nix
    # ./web.nix
    ./window-manager.nix
    # ./windsurf.nix
  ];
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    direnv
    dysk
    dust
    fd
    ripgrep
    tree
    zoxide
  ];

  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = false;
      };
    };
  };

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

  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };
}
