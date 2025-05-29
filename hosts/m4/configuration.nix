{lib, ...}: {
  networking.hostName = "m4";
  system.stateVersion = 6;

  users.users.chrisaddy = {
    name = "chrisaddy";
    home = "/Users/chrisaddy";
  };

  nix.enable = false;
}
