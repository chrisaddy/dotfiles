# modules/common/git.nix
{
  lib,
  config,
  ...
}: {
  options = {
    programs.git.enable = lib.mkEnableOption "Git integration";
    programs.jujutsu.enable = lib.mkEnableOption "Jujutsu integration";
    programs.gh.enable = lib.mkEnableOption "GitHub CLI integration";
  };

  config = lib.mkMerge [
    (lib.mkIf config.programs.git.enable {
      programs.git = {
        enable = true;
        difftastic.enable = true;
        ignores = ["*~" "*.swp"];
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
    })

    (lib.mkIf config.programs.jujutsu.enable {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "chrisaddy";
            email = "chris.william.addy@gmail.com";
          };
          ui = {
            diff-editor = ["nvim" "-c" "DiffEditor $left $right $output"];
          };
        };
      };
    })

    (lib.mkIf config.programs.gh.enable {
      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
    })
  ];
}
