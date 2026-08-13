{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.zellijPlugins; [
      zjstatus
    ];
    settings = {
      # keybinds._props.clear-defaults = true;
      layout = {
        _children = [
          {
            default_tab_template = {
              _children = [
                { children = { }; } # your panes go here
                {
                  pane = {
                    size = 1;
                    borderless = true;
                    plugin = {
                      location = "file:${pkgs.zellijPlugins.zjstatus}/bin/zjstatus.wasm";
                    };
                  };
                }
              ];
            };
          }
        ];
      };
      keybinds = {
        normal._children = [
          {
            unbind = {
              _args = [
                "Ctrl h"
                "Ctrl t"
                "Ctrl p"
              ];
            };
          }
          {
            bind = {
              _args = [ "Ctrl i" ];
              _children = [
                { SwitchToMode._args = [ "pane" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "Ctrl m" ];
              _children = [
                { SwitchToMode._args = [ "move" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "Ctrl Space" ];
              _children = [
                { SwitchToMode._args = [ "tab" ]; }
              ];
            };
          }
        ];
        tab._children = [
          {
            bind = {
              _args = [ "Space" ];
              _children = [
                {
                  LaunchOrFocusPlugin = {
                    _args = [ "session-manager" ];
                    _children = [
                      { floating._args = [ true ]; }
                      { move_to_focused_tab._args = [ true ]; }
                    ];
                  };
                }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "h" ];
              _children = [
                { MoveFocusOrTab = "Left"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "j" ];
              _children = [
                { MoveFocusOrTab = "Down"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "k" ];
              _children = [
                { MoveFocusOrTab = "Up"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "l" ];
              _children = [
                { MoveFocusOrTab = "Right"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }

        ];
        pane._children = [
          {
            bind = {
              _args = [ "h" ];
              _children = [
                { MoveFocus = "Left"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "j" ];
              _children = [
                { MoveFocus = "Down"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "k" ];
              _children = [
                { MoveFocus = "Up"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
          {
            bind = {
              _args = [ "l" ];
              _children = [
                { MoveFocus = "Right"; }
                { SwitchToMode._args = [ "normal" ]; }
              ];
            };
          }
        ];
      };
      theme = "catppuccin-macchiato";
    };
  };
}
