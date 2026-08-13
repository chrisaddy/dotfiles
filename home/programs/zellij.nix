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
              _args = [ "p" ];
              _children = [
                { TogglePaneEmbedOrFloating = { }; }
                { SwitchToMode._args = [ "locked" ]; }
              ];
            };
          }
        ];
      };
      theme = "catppuccin-macchiato";
    };
  };
}
