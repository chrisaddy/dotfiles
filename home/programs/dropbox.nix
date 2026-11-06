{
  config,
  lib,
  pkgs,
  ...
}:
# Home Manager's dropbox service and dropbox-cli are Linux-only; on macOS use
# the Dropbox app.
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  services.dropbox = {
    enable = true;
    path = "${config.home.homeDirectory}/Dropbox";
  };
  home.packages = [ pkgs.dropbox-cli ];
}
