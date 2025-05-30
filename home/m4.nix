{...}: {
  imports = [
    ./common.nix
    ../modules/gcloud.nix
    ../modules/ghostty.nix
    ../modules/git.nix
    ../modules/helix.nix
    ../modules/media.nix
    ../modules/nushell.nix
    ../modules/tmux.nix
  ];
  home.username = "chrisaddy";
  home.homeDirectory = "/Users/chrisaddy";
}
