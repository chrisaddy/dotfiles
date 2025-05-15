{pkgs, ...}: let
  neotestPythonWrapper = pkgs.writeScriptBin "neotest-python" ''
    #!${pkgs.bash}/bin/bash
    export PATH="${pkgs.python311}/bin:$PATH"
    exec ${pkgs.python311}/bin/python "$@"
  '';

  neotestHaskellWrapper = pkgs.writeScriptBin "neotest-haskell" ''
    #!${pkgs.bash}/bin/bash
    export PATH="${pkgs.haskellPackages.haskell-language-server}/bin:$PATH"
    exec "$@"
  '';
in {
  home.packages = [
    neotestPythonWrapper
    neotestHaskellWrapper
  ];
}
