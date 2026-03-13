{ config, pkgs, lib, ... }:

{
  xdg.configFile."niri/config.kdl" = lib.mkIf pkgs.stdenv.isLinux {
    source = ../../config/niri/config.kdl;
  };
}
