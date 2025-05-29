{
  config,
  pkgs,
  ...
}: let
in {
  environment.variables = {
    MANPAGER = "bat --plain";
    PAGER = "bat --plain";
  };

  environment.shellAliases = {
    cat = "bat";
    less = "bat --plain";
  };

  home-manager.sharedModules = [
    {
      programs.bat = {
        enabled = true;

        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
        ];
        config = {
          pager = "less -FR";
          theme = "TwoDark";
        };
      };
    }
  ];
}
