lib: {
  class = "darwin";
  config = lib.darwinSystem' (
    {lib, ...}: let
      inherit (lib) collectNix remove;
    in {
      imports = collectNix ./. |> remove ./default.nix;

      type = "desktop";
      networking.hostname = "Mac";

      users.users.chrisaddy = {
        name = "chrisaddy";
        home = "/Users/chrisaddy";
      };

      home-manager.users.chrisaddy.home = {
        stateVersion = "25.05";
        homeDirectory = "/Users/chrisaddy";
      };

      system.stateVersion = "25.05";
    }
  );
}
