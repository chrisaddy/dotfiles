{
  config,
  lib,
  windowsProfile ? null,
  ...
}:
let
  # The config dir holds the backgrounds next to wezterm.lua, so one config
  # finds the image on Linux, macOS and Windows alike.
  background = "a_motorcycle_parked_outside_a_restaurant.jpg";
in
{
  xdg.configFile."wezterm/backgrounds".source = ../../bg;
  programs.wezterm = {
    enable = true;
    settings = {
      enable_scroll_bar = false;
      audible_bell = "Disabled";
      font_size = 16;
      color_scheme = "tokyonight_moon";
      hide_tab_bar_if_only_one_tab = true;
      background = [
        {
          source.File = lib.generators.mkLuaInline ''wezterm.config_dir .. "/backgrounds/${background}"'';
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

  # On WSL the terminal is the Windows wezterm-gui.exe, which reads
  # %USERPROFILE%\.config\wezterm and cannot follow symlinks into the Nix
  # store. Copy real files there instead.
  home.activation.windowsWezterm = lib.mkIf (windowsProfile != null) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      dest=${lib.escapeShellArg "${windowsProfile}/.config/wezterm"}
      if [ -d ${lib.escapeShellArg windowsProfile} ]; then
        run mkdir -p "$dest/backgrounds"
        run cp -fL --no-preserve=mode \
          ${config.xdg.configFile."wezterm/wezterm.lua".source} "$dest/wezterm.lua"
        run cp -fL --no-preserve=mode ${../../bg}/* "$dest/backgrounds/"
      else
        warnEcho "windowsWezterm: ${windowsProfile} is missing; skipped"
      fi
    ''
  );
}
