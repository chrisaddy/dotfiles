{ ... }: {
  programs.wezterm = {
    enable = true;
    settings = {
      enable_scrollbar = false;
      font = {
        size = 16.0;
      };
      color_scheme = "tokyonight_night";
      hide_tab_bar_if_only_one_tab = true;
    };
  };
}
