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

  home.file.hammerspoon = {
    target = ".hammerspoon/init.lua";
    text =
      # lua
      ''
        hs.hotkey.bind({"cmd", "shift"}, "B", function()
          hs.application.launchOrFocus("qutebrowser")
        end)

        hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
          hs.reload()
        end)

        hs.alert.show("Config loaded")
        hs.loadSpoon("AClock")
        hs.hotkey.bind({"cmd", "shift"}, "C", function()
          spoon.AClock:toggleShow()
        end)

        hs.hotkey.bind({"cmd"}, "h", function()
          hs.execute("yabai -m window --focus west")
        end)
        hs.hotkey.bind({"cmd"}, "j", function()
          hs.execute("yabai -m window --focus south")
        end)
        hs.hotkey.bind({"cmd"}, "k", function()
          hs.execute("yabai -m window --focus north")
        end)
        hs.hotkey.bind({"cmd"}, "l", function()
          hs.execute("yabai -m window --focus east")
        end)
      '';
  };

  # focus window
  #     alt - h : yabai -m window --focus west
  #     alt - j : yabai -m window --focus south
  #     alt - k : yabai -m window --focus north
  #     alt - l : yabai -m window --focus east

  home.file.skhd = {
    target = ".config/skhd/skhdrc";
    text = ''
      #!/usr/bin/env sh
      alt - return : /usr/bin/open -na "Ghostty"
      alt - b : /usr/bin/open /Applications/qutebrowser.app/


      # swap managed window
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east

      # fast focus desktop
      # cmd + alt - x : yabai -m space --focus recent
      # cmd + alt - 1 : yabai -m space --focus 1

      # send window to desktop and follow focus
      # shift + cmd - z : yabai -m window --space next; yabai -m space --focus next
      # shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2

      # increase window size
      shift + alt - a : yabai -m window --resize left:-20:0
      shift + alt - s : yabai -m window --resize right:-20:0
      # shift + alt - w : yabai -m window --resize top:0:-20

      # decrease window size
      shift + cmd - s : yabai -m window --resize bottom:0:-20
      shift + cmd - w : yabai -m window --resize top:0:20

      # float / unfloat window and center on screen
      alt - t : yabai -m window --toggle float; \
                yabai -m window --grid 4:4:1:1:2:2

      # toggle sticky(+float), topmost, picture-in-picture
      alt - p : yabai -m window --toggle sticky; \
                yabai -m window --toggle topmost; \
                yabai -m window --toggle pip
    '';
  };
}
