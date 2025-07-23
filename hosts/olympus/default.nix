lib:
lib.darwinSystem' ({lib, ...}: {
  networking.hostName = "olympus";

  users.users.chrisaddy = {
    name = "chrisaddy";
    home = "/Users/chrisaddy";
  };

  home-manager.users.chrisaddy.home = {
    stateVersion = "25.05";
    homeDirectory = "/Users/chrisaddy";
  };

  system.stateVersion = "25.05";
})
