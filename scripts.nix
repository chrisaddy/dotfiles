{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "book" ''
      #!/usr/bin/env nu
      def main [url: string] {
        http get $url
      }
    '')
  ];
}
