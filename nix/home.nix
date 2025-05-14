{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./ai.nix
    # ./emacs.nix
    ./git.nix
    ./hx
    ./haskell.nix
    ./helix.nix
    ./media.nix
    ./nix.nix
    ./notes.nix
    ./python.nix
    ./shells.nix
    ./terminal.nix
    ./tmux.nix
    # ./vim.nix
  ];
  #home.username = lib.mkForce "chrisaddy";
  #home.homeDirectory = lib.mkForce "/Users/chrisaddy";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    fd
    ripgrep
    # Removed pyenv to avoid collision with python311
    direnv
    zoxide
  ];

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };
}
