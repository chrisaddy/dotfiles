{
  config,
  pkgs,
  ...
}:
{
  services.dropbox = {
    enable = true;
    path = "${config.home.homeDirectory}/Dropbox";
  };
  home.packages = [ pkgs.dropbox-cli ];
}
