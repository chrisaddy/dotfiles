{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core Haskell tools
    ghc # Glasgow Haskell Compiler
    stack # Project development tool
    cabal-install # Package manager and build tool
    mise # Runtime version manager (formerly rtx)
    ormolu # Code formatter
    hlint # Linter for suggesting code improvements
    haskell-language-server # LSP server for Haskell
    haskellPackages.hoogle # Haskell API search engine
    ghcid # Fast GHC compiler checker
    haskellPackages.implicit-hie # Auto-generate hie.yaml files
    haskellPackages.hspec-discover # Test framework
    haskellPackages.cabal-fmt # Formatter for cabal files
  ];

  home.shellAliases = {
    "sb" = "stack build";
    "st" = "stack test";
    "sr" = "stack run";
    "si" = "stack init";
    "sg" = "stack ghci";
  };
}
