{
  config,
  pkgs,
  ...
}: {
  home.username = "chris";
  home.homeDirectory = "/Users/chrisaddy";

  home.packages = with pkgs; [htop starship];

  programs.git = {
    enable = true;
    userName = "Chris Addy";
    userEmail = "chris@example.com";
  };

  programs.zsh.enable = true;
}
