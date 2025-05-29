{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  userConfig = import ./config.nix {inherit lib;};
in {
  # home.packages = with pkgs; [
  #   lazygit
  #   lazyjj
  #   jujutsu
  #   radicle-node
  # ];
  home-manager.sharedModules = [
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = userConfig.email;
          name = userConfig.username;
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
      userName = userConfig.username;
      userEmail = userConfig.email;
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";

        prompt = "enabled";
      };
    };
  };
  ];
}
