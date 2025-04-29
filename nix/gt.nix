{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
  ];
  programs = {
    git = {
      enable = true;
      ignores = [
        "*~"
        "*.swp"
      ];
      includes = [
        {
          path = "~/.gitconfig";
          contents = {
            user = {
              name = "chrisaddy";
              email = "chris.william.addy@gmail.com";
            };
          };
        }
      ];
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
