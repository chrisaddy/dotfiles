}: {
  imports = [
    ./docker.nix
    # ./emacs.nix
    ./git.nix
    ./helix.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./shells.nix
    ./terminal.nix
    ./tmux.nix
    # ./vim.nix
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

}
