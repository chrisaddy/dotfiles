{
  config,
  pkgs,
  ...
}: let
  gitUsername = "chrisaddy";
  gitEmail = "chris.william.addy@gmail.com";
in {
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nh
    alejandra
  ];

  programs.git = {
    userName = gitUsername;
    userEmail = gitEmail;
  };

  programs.jujutsu.user = {
    email = gitEmail;
    name = gitUsername;
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };
}
