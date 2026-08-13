{ ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # keybinds._props.clear-defaults = true;
      keybinds = {
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
        ];
      };
      theme = "catppuccin-macchiato";
    };
  };
}
