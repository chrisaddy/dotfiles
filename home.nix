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
    ./tmux.nix
    # ./vim.nix
    # ./vscode.nix
    # ./web.nix
    # ./windsurf.nix
  ];
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    fd
    ripgrep
    # Removed pyenv to avoid collision with python311
    direnv
    zoxide
    tree
  ];

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };
}
