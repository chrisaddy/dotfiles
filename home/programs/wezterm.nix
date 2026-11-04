{ ... }: {
  xdg.configFile."wezterm/backgrounds".source = ../../bg;
  programs.wezterm = {
    enable = true;
    settings = {
      enable_scrollbar = false;
      audible_bell = "Disabled";
      font = {
        size = 16;
      };
      color_scheme = "tokyonight_moon";
      hide_tab_bar_if_only_one_tab = true;
      background = [
        {
          source.File = "${../../bg/a_motorcycle_parked_outside_a_restaurant.jpg}";
          hsb = {
            brightness = 0.08;
            saturation = 0.9;
          };
          opacity = 1.0;
          width = "Cover";
          height = "Cover";
        }
      ];
    };
  };
}
