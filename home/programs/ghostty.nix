{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      font-size = 20;
      theme = "Rose Pine Moon";
      cursor-style = "block";
      shell-integration = "zsh";
      shell-integration-features = "cursor,no-title";
      background-opacity = 0.9;
      macos-titlebar-style = "transparent";
      window-decoration = true;

      window-position-x = 5;
      window-position-y = 5;
      window-width = 100;
      window-height = 100;

      confirm-close-surface = false;

      keybind = [
        "alt+backspace=text:\\x1b\\x7f"
        "shift+enter=text:\\n"
        "super+1=goto_tab:1"
        "super+2=goto_tab:2"
        "super+3=goto_tab:3"
        "super+4=goto_tab:4"
        "super+5=goto_tab:5"
        "super+6=goto_tab:6"
        "super+7=goto_tab:7"
        "super+8=goto_tab:8"
        "super+9=goto_tab:9"
      ];
    };
  };
}
