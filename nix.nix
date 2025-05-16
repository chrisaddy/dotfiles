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
      #!/usr/bin/env nu
      cd $"($nu.env.HOME)/dotfiles"
      git add .
      do { git commit -m "updates" } | ignore
      git pull --rebase
      alejandra -q .
      let system = (uname)
      if $system == "Darwin" {
        nh darwin switch .
      } else {
        nh os switch --update .
      }
      git push
    '')
  ];
}
