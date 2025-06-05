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
    # cacert
    espanso
  ];
  programs.git = {
    userName = gitUsername;
    userEmail = gitEmail;
  };

  programs.jujutsu.settings.user = {
    email = gitEmail;
    name = gitUsername;
  };

  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };
}
