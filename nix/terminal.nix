{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    jetbrains-mono
  ];
  programs.alacritty = {
    enable = true;
    theme = "challenger_deep";
    settings = {
      font.normal.family = "JetBrains Mono";
      font.size = 20.0;
      window = {
        decorations = "none";
        dimensions = {
          columns = 0;
          lines = 0;
        };
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Windowed";
        position = "Center";
        width = 0.95;
        height = 0.9;
      };
    };
  };
}
