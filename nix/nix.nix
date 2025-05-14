{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nh
    alejandra

    (writeShellScriptBin "clean-system" ''
      sudo nix-collect-garbage --delete-older-than 15d --verbose
      nix store optimise --verbose
      nix store gc --verbose
    '')

    (writeShellScriptBin "up" ''
      # go to config directory
      pushd $HOME/dotfiles
      git add .
      git commit -m 'updates'
      pushd nix

      ${pkgs.alejandra}/bin/alejandra -q .

      # ${pkgs.nh}/bin/nh os switch --update .
      nix flake update
      nix run nix-darwin/master#darwin-rebuild -- switch --flake .#Mac
      popd
      git push
      popd
    '')
  ];
}
