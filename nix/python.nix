{pkgs, ...}: {
  home.packages = with pkgs; [
    mise
    uv
    ruff
    pre-commit
    python313Packages.python-lsp-server
    python313Packages.jedi-language-server
    pyright
  ];
}
