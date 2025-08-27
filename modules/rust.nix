{pkgs, ...}: {
  home.packages = with pkgs; [
    bacon
    cargo
    cargo-watch
  ];
}
