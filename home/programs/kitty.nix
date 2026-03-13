{ config, ... }:

{
  xdg.configFile."kitty/kitty.conf".text = ''
    font_size 16

    # Theme - Tokyo Night Storm
    include Tokyo Night Storm.conf

    cursor_shape block

    # Shell integration (zsh, with cursor but no title)
    shell_integration no-title

    background_opacity 0.9

    # macOS transparent titlebar
    macos_titlebar_color background

    # Window size (in cells)
    initial_window_width 100c
    initial_window_height 100c

    confirm_os_window_close 0

    # Enable remote control (needed for auto-reload via fswatch)
    allow_remote_control yes

    # Tab bar
    tab_bar_min_tabs 1
    tab_bar_style powerline

    # Keybindings
    map alt+backspace send_text all \x1b\x7f
    map shift+enter send_text all \n
    map cmd+1 goto_tab 1
    map cmd+2 goto_tab 2
    map cmd+3 goto_tab 3
    map cmd+4 goto_tab 4
    map cmd+5 goto_tab 5
    map cmd+6 goto_tab 6
    map cmd+7 goto_tab 7
    map cmd+8 goto_tab 8
    map cmd+9 goto_tab 9
    map cmd+shift+[ previous_window
    map cmd+shift+] next_window

    enabled_layouts tall:bias=50;full_size=1;mirrored=false
  '';

  xdg.configFile."kitty/Tokyo Night Storm.conf".text = ''
    # vim:ft=kitty

    ## name: Tokyo Night Storm
    ## license: MIT
    ## author: Folke Lemaitre
    ## upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty/tokyonight_storm.conf


    background #24283b
    foreground #c0caf5
    selection_background #2e3c64
    selection_foreground #c0caf5
    url_color #73daca
    cursor #c0caf5
    cursor_text_color #24283b

    # Tabs
    active_tab_background #7aa2f7
    active_tab_foreground #1f2335
    inactive_tab_background #292e42
    inactive_tab_foreground #545c7e
    #tab_bar_background #1d202f

    # Windows
    active_border_color #7aa2f7
    inactive_border_color #292e42

    # normal
    color0 #1d202f
    color1 #f7768e
    color2 #9ece6a
    color3 #e0af68
    color4 #7aa2f7
    color5 #bb9af7
    color6 #7dcfff
    color7 #a9b1d6

    # bright
    color8  #414868
    color9  #ff899d
    color10 #9fe044
    color11 #faba4a
    color12 #8db0ff
    color13 #c7a9ff
    color14 #a4daff
    color15 #c0caf5

    # extended colors
    color16 #ff9e64
    color17 #db4b4b
  '';
}
