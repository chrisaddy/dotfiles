{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "book" ''
      #!/usr/bin/env nu
      ls
    '')
  ];
}
