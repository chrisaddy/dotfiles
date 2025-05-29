{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nh
  ];

  programs.git = {
    enable = true;
    userName = "chrisaddy";
    userEmail = "chris.william.addy@gmail.com";
  };
}
