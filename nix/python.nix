{pkgs, ...}: let
  pythonEnv = pkgs.python311.withPackages (ps:
    with ps; [
      pytest
      ipython
      python-lsp-server
    ]);
in {
  home.packages = with pkgs; [
    pythonEnv
    mise
    uv
    ruff
    pre-commit
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
