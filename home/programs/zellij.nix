{ config, pkgs, ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.zellijPlugins; [
      zjstatus
    ];
    settings = {
      # Without this, zellij spawns $SHELL, which every process inherits from
      # whenever its session started — so a terminal opened before a `chsh`
      # keeps handing zellij the old shell indefinitely. Naming the shell here
      # makes new panes independent of that stale inheritance.
      #
      # Resolved through PATH rather than a store path, for the same reason the
      # direnv and devenv hooks are: a pinned store path dies at the next
      # `nh clean all`. Keyed off nushell actually being installed, since the
      # headless VMs do not have it and stay on zsh.
      default_shell = if config.programs.nushell.enable then "nu" else "zsh";

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
                "Ctrl n"
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
              _args = [ "Ctrl u" ];
              _children = [
                { SwitchToMode._args = [ "resize" ]; }
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
