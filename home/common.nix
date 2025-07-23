{
  pkgs,
  config,
  ...
}: let
  gitUsername = "chrisaddy";
  gitEmail = "chris.william.addy@gmail.com";
in {
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    nh
    alejandra
    espanso
    tree
  ];
  programs.git = {
    userName = gitUsername;
    userEmail = gitEmail;
  };

  programs.jujutsu.settings.user = {
    email = gitEmail;
    name = gitUsername;
  };

  programs.lazydocker.enable = true;

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };
}
