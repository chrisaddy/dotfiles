{...}: {
  imports = [
    ./common.nix
    ../modules/git.nix
    ../modules/helix.nix
    ../modules/ghostty.nix
    ../modules/nushell.nix
    ../modules/tmux.nix
  ];
  home.username = "chrisaddy";
  home.homeDirectory = "/Users/chrisaddy";
}
