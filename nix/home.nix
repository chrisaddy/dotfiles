{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./ai.nix
    # ./emacs.nix
    ./git.nix
    ./haskell.nix
    ./media.nix
    ./nix.nix
    ./python.nix
    ./shells.nix
    ./terminal.nix
    ./tmux.nix
    ./vim.nix
  ];
  home.username = lib.mkForce "chrisaddy";
  home.homeDirectory = lib.mkForce "/Users/chrisaddy";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    git
    fd
    ripgrep
    pyenv
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
