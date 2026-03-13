{ config, pkgs, lib, ... }:

{
  xdg.configFile."waybar/config.jsonc" = lib.mkIf pkgs.stdenv.isLinux {
    source = ../../config/waybar/config.jsonc;
  };
  xdg.configFile."waybar/style.css" = lib.mkIf pkgs.stdenv.isLinux {
    source = ../../config/waybar/style.css;
  };
}
