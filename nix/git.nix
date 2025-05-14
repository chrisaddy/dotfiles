{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
  ];
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "chris.william.addy@gmail.com";
          name = "chrisaddy";
        };
        ui = {
          diff-editor = ["nvim" "-c" "DiffEditor $left $right $output"];
        };
      };
    };
    git = {
      enable = true;
      difftastic.enable = true;
      # hooks = {
      #   pre-commit = ./pre-commit-script;
      # };
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
      userName = "chrisaddy";
      userEmail = "chris.william.addy@gmail.com";
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
