{...}: {
  imports = [
    ./common.nix
    ../modules/helix.nix
    ../modules/nushell.nix
  ];
  home.username = "chrisaddy";
  home.homeDirectory = "/Users/chrisaddy";
}
