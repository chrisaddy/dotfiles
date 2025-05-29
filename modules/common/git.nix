{
  self,
  config,
  pkgs,
  lib,
  ...
}: let 
email = "chris.william.addy@gmail.com";
username = "chrisaddy";
in {
  # home.packages = with pkgs; [
  #   lazygit
  #   lazyjj
  #   jujutsu
  #   radicle-node
  # ];
  home-manager.sharedModules = [
    {
      programs = {
        jujutsu = {
          enable = true;
          settings = {
            user = {
              email = email;
              name = username;
            };
            ui = {
              diff-editor = ["nvim" "-c" "DiffEditor $left $right $output"];
            };
          };
        };
        git = {
          enable = true;
          difftastic.enable = true;
          ignores = [
            "*~"
            "*.swp"
          ];
          lfs.enable = true;
          maintenance = {
            enable = true;
            repositories = [
              "$HOME/projects/pocketsizefund/pocketsizefund"
            ];
          };
          userName = username;
          userEmail = email;
        };
        gh = {
          enable = true;
          settings = {
            git_protocol = "ssh";

            prompt = "enabled";
          };
        };
      };
    }
  ];
}
