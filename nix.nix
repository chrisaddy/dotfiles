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

    (writeShellScriptBin "search" ''
      nh search $1 -j | jq .results.'[]'.package_attr_name | fzf
    '')

    (writeShellScriptBin "up" ''
      pushd $HOME/dotfiles
      git add .
      git commit -m 'updates'
      git pull --rebase

      ${pkgs.alejandra}/bin/alejandra -q .

      ${pkgs.nh}/bin/nh os switch --update .
      nix flake update
      nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#$(scutil --get LocalHostName)"
      git push
    '')
  ];
}
