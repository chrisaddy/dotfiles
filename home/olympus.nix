{...}: {
  imports = [
    ./common.nix
    ../modules/ai.nix
    ../modules/docker.nix
    ../modules/gcloud.nix
    ../modules/ghostty.nix
    ../modules/git.nix
    # ../modules/helix.nix
    ../modules/media.nix
    ../modules/nushell.nix
    ../modules/python.nix
    ../modules/tmux.nix
    ../modules/vim.nix
  ];
  home.username = "chrisaddy";
  home.homeDirectory = "/Users/chrisaddy";
}
