{
  lib,
  pkgs,
  themes,
  ...
}: let
  inherit (lib) mkValue;
in {
  options.theme =
    mkValue
    <| themes.custom
    <| themes.raw.gruvbox-dark-hard
    // {
      cornerRadius = 4;
      borderWidth = 2;
      margin = 0;
      padding = 8;

      font = {
        size = {
          normal = 20;
          big = 24;
        };
        sans = {
          name = "Lexend";
          package = pkgs.lexend;
        };
        mono = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        icons = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.gruvbox-plus-icons;
        };
      };
    };
}
