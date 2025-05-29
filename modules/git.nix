{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    lazyjj
    jujutsu
    radicle-node
  ];
  programs = {
    jujutsu = {
      enable = true;
      settings = {
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
