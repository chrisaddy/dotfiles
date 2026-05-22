{pkgs, ...}: let
  catppuccin-yazi = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "41f24ed142e34109a9a65a5dfe58c1b4eb6d2fd9";
    hash = "sha256-Og33IGS9pTim6LEH33CO102wpGnPomiperFbqfgrJjw=";
  };
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        ratio = [0 4 3];
      };
      opener = {
        edit = [
          {run = ''hx "$@"''; block = true;}
        ];
      };
    };
  };

  xdg.configFile = {
    "yazi/theme.toml".source = "${catppuccin-yazi}/themes/macchiato/catppuccin-macchiato-mauve.toml";
    "yazi/Catppuccin-macchiato.tmTheme".source = "${catppuccin-bat}/themes/Catppuccin Macchiato.tmTheme";
  };
}
