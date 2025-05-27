{pkgs, ...}: {
  home.packages = with pkgs; [
    yabai
    skhd
  ];
  home.file.yabai = {
    executable = true;
    target = ".config/yabai/yabairc";
    text = ''
      #!/usr/bin/env sh

      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

      yabai -m config layout bsp
      yabai -m config auto_balance off
      yabai -m config window_topmost on

      yabai -m config top_padding    0
      yabai -m config bottom_padding 0
      yabai -m config left_padding   0
      yabai -m config right_padding  0
      yabai -m config window_gap     0

      yabai -m rule --add app="^System Preferences$" manage=off

      echo "yabai configuration loaded.."
    '';
  };
}
