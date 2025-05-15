{pkgs, ...}: {
  home.packages = with pkgs; [
    # ghc
    # haskellPackages.stack
    # cabal-install
    # mise
    # ormolu
    # hlint
    # haskell-language-server
    # haskellPackages.hoogle
    # ghcid
    # haskellPackages.implicit-hie
    # haskellPackages.hspec-discover
    # haskellPackages.cabal-fmt
    # haskellPackages.fast-tags
    # haskellPackages.haskell-debug-adapter
  ];

  home.shellAliases = {
    "sb" = "stack build";
    "st" = "stack test";
    "sr" = "stack run";
    "si" = "stack init";
    "sg" = "stack ghci";
  };
}
