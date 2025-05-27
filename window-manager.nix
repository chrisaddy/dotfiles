{pkgs, ...}: {
  home.packages = with pkgs; [
    yabai
  ];
  # programs.yabai = {
  #   enable = true;
  #   package = pkgs.yabai;
  #   enableScriptingAddition = true;
  #   config = {
  #     layout = "bsp";
  #     auto_balance = "on";
  #     focus_follows_mouse = "autoraise";
  #     mouse_follows_focus = "off";
  #     window_gap = 10;
  #     top_padding = 10;
  #     bottom_padding = 10;
  #     left_padding = 10;
  #     right_padding = 10;
  #   };
  # };
}
