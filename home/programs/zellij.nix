{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.zellijPlugins; [
      zjstatus
    ];
    layouts = {
      dev = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      borderless = true;
                      plugin = {
                        location = "zellij:tab-bar";
                      };
                      size = 1;
                    };
                  }
                  {
                    children = { };
                  }
                  {
                    pane = {
                      borderless = true;
                      plugin = {
                        location = "zellij:status-bar";
                      };
                      size = 2;
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _children = [
                  {
                    pane = {
                      command = "claude --dangerously-skip-permissions";
                    };
                  }
                ];
                _props = {
                  focus = true;
                  name = "claude";
                };
              };
            }
            {
              tab = {
                _children = [
                  {
                    pane = {
                      command = "nvim";
                    };
                  }
                ];
                _props = {
                  name = "nvim";
                };
              };
            }
            {
              tab = {
                _children = [
                  {
                    pane = {
                      command = "zsh";
                    };
                  }
                ];
                _props = {
                  name = "shell";
                };
              };
            }
            {
              tab = {
                _children = [
                  {
                    pane = {
                      command = "lazgit";
                    };
                  }
                ];
                _props = {
                  name = "git";
                };
              };
            }
          ];
        };
      };
    };
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
