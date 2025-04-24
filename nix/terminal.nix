{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains-mono
  ];
  programs.alacritty = {
    enable = true;
    theme = "challenger_deep";
    settings = {
      font.normal.family = "JetBrains Mono";
      font.size = 24.0;
      window.decorations = "none";
    };
  };
}
