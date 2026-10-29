{
  workmux,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    workmux.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."workmux/config.yaml" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    text = ''
      merge_strategy: rebase
      agent: claude
      panes:
        - command: <agent>
          focus: true
        - split: horizontal

    '';
  };
}
