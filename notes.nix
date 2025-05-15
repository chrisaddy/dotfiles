{pkgs, ...}: {
  home.packages = with pkgs; [
    just
    just-formatter
    just-lsp
    typst
    zk
  ];
}
