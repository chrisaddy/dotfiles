{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "chrisaddy";
    userEmail = "chris.william.addy@gmail.com";
  };
}
