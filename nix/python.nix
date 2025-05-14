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

  home.shellAliases = {
    "py" = "ipython";

    "uvs" = "uv pip sync";
    "uvr" = "uv run";

    "rf" = "ruff format";
    "rl" = "ruff check";
    "rfix" = "ruff check --fix";

    "venv" = "python -m venv .venv";
    "va" = "source .venv/bin/activate";
  };
}
