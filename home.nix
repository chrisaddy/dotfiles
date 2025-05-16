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
    ./helix.nix
    ./media.nix
    ./nix.nix
    ./notes.nix
    ./python.nix
    ./shells.nix
    ./terminal.nix
    ./tmux.nix
    ./vim.nix
    ./vscode.nix
    ./windsurf.nix
  ];
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
