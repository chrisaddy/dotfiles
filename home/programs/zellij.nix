{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.zellijPlugins; [
      zjstatus
    ];
    settings = {
      # keybinds._props.clear-defaults = true;
      keybinds = {
        normal._children = [
          {
            unbind = {
              _args = [
                "Ctrl h"
                "Ctrl t"
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

        ];
        tab._children = [
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
