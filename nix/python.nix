{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core Python tools
    python311
    mise
    uv
    ruff 

    python311Packages.ipython # Enhanced interactive Python shell
    
    nodePackages.pyright # Fast Python type checker (LSP)
    python311Packages.python-lsp-server # Python LSP server
  ];

  # Configure mise for Python version management
  home.shellAliases = {
    # Python environment shortcuts
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
