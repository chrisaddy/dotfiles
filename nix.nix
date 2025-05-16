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
      ${pkgs.nh}/bin/nh search $1 -j --limit 10000 | jq .results.'[]'.package_attr_name | fzf
    '')

    (writeShellScriptBin "up" ''
      pushd $HOME/dotfiles
      git add .
      git commit -m 'updates'
      git pull --rebase

      ${pkgs.alejandra}/bin/alejandra -q .

      if [[ "$(uname)" == "Darwin" ]]; then
        ${pkgs.nh}/bin/nh darwin switch .
      else
        ${pkgs.nh}/bin/nh os switch --update .
      fi
      git push
    '')
  ];
}
