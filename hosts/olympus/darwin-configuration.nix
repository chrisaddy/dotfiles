{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # cacert
    # nodejs
  ];

  networking.hostName = "olympus";
  system.stateVersion = 6;

  users.users.chrisaddy = {
    name = "chrisaddy";
    home = "/Users/chrisaddy";
  };

  # environment.variables = {
  #   SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #   NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #   CURL_CA_BUNDLE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #   REQUESTS_CA_BUNDLE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  # };

  nix.enable = false;
}
