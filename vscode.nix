{pkgs, ...}: let
  pythonBin = "${pkgs.python313}/bin/python3";
in {
  home.packages = with pkgs; [
    dockerfile-language-server-nodejs
    pylyzer
    ruff
  ];
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # ui
        zhuangtongfa.material-theme
        # docker
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        # git
        visualjj.visualjj
        # go
        golang.go
        # html
        ecmel.vscode-html-css
        # markdown
        yzhang.markdown-all-in-one
        # nix
        jnoortheen.nix-ide
        # python
        ms-python.python
        ms-python.debugpy
        ms-pyright.pyright
        pylyzer.pylyzer
        charliermarsh.ruff
        cameron.vscode-pytest
        # toml
        tamasfe.even-better-toml
        # misc
        mkhl.direnv # directory-specific environments
        vspacecode.whichkey # handy menu
      ];

      userSettings = {
        "workbench.colorTheme" = "Solarized Dark";
        "editor.formatOnSave" = true;
        "python.defaultInterpreterPath" = pythonBin;
        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "editor.formatOnSave" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll" = "explicit";
          };
          "linting.enabled" = true;
          "linting.pylintEnabled" = false;
        };
        "python.linting.enabled" = true;
        "python.linting.pylintEnabled" = false;
        "python.linting.pyrightEnabled" = true;
        "python.analysis.diagnosticSeverityOverrides" = {
          "reportMissingImports" = "none";
        };
      };
    };
  };
}
