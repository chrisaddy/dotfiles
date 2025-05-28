{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "book" ''
      #!/${pkgs.nushell}/bin/nu
      def main [url: string] {
        http get $url
      }
    '')
  ];
}
