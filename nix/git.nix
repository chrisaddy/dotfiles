{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
  ];
  programs = {
    jujutsu.enable = true;
    git = {
      enable = true;
      ignores = [
        "*~"
        "*.swp"
      ];
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
