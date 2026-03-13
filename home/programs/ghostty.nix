{ config, ... }:

{
  xdg.configFile."ghostty/config".text = ''
    font-size = 20
    theme = Rose Pine Moon
    cursor-style = block
    shell-integration = zsh
    shell-integration-features = cursor,no-title
    background-opacity = 0.9
    macos-titlebar-style = transparent
    window-decoration = true

    window-position-x = 5
    window-position-y = 5
    window-width = 100
    window-height = 100

    confirm-close-surface = false

    keybind = alt+backspace=text:\x1b\x7f
    keybind = shift+enter=text:\n
    keybind = super+1=goto_tab:1
    keybind = super+2=goto_tab:2
    keybind = super+3=goto_tab:3
    keybind = super+4=goto_tab:4
    keybind = super+5=goto_tab:5
    keybind = super+6=goto_tab:6
    keybind = super+7=goto_tab:7
    keybind = super+8=goto_tab:8
    keybind = super+9=goto_tab:9
  '';
}
