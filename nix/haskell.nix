{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core Haskell tools
    ghc                  # Glasgow Haskell Compiler
    stack                # Project development tool
    cabal-install        # Package manager and build tool
    mise                 # Runtime version manager (formerly rtx)
    ormolu               # Code formatter
    hlint                # Linter for suggesting code improvements
    haskell-language-server # LSP server for Haskell
    hoogle               # Haskell API search engine
    ghcid                # Fast GHC compiler checker
    implicit-hie         # Auto-generate hie.yaml files
    hspec-discover       # Test framework
    cabal-fmt            # Formatter for cabal files
  ];

  home.file.".config/mise/config.toml".text = ''
    [tools]
    haskell = "latest"
  '';

  home.shellAliases = {
    "sb" = "stack build";
    "st" = "stack test";
    "sr" = "stack run";
    "si" = "stack init";
    "sg" = "stack ghci";

    "fmt" = "ormolu --mode inplace $(find . -name '*.hs')";

    "lint" = "hlint .";
  };
}
