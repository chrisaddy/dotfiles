{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains-mono
  ];
  programs.alacritty = {
    enable = true;
    theme = "challenger_deep";
    settings = {
      font.normal.family = "JetBrains Mono";
      # colors.primary.background = "0x1e1e2e";
      # colors.primary.foreground = "0xcdd6f4";
    };
  };
}
