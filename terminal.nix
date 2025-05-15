{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    cmake
    jetbrains-mono
  ];
  xdg.configFile."ghostty/config".text = ''
    font-size = 24
    theme = tokyonight-storm
    cursor-style = block
    shell-integration = zsh
    shell-integration-features = cursor,no-title
    background-opacity = 0.9
    macos-titlebar-style = transparent

    window-position-x = 5
    window-position-y = 5
    window-width = 85
    window-height = 24
  '';
}
