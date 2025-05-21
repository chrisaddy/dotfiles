{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo
    rustup
  ];
}
