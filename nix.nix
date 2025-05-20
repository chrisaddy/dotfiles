{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nh
    alejandra

    (writeShellScriptBin "search" ''
      #!/usr/bin/env nu
      ${pkgs.nh}/bin/nh search $query -j --limit 10000
      \| from json
      \| get results
      \| get package_attr_name
      \| str join (char nl)
      \| fzf
    '')

    (writeShellScriptBin "up" ''
      #!/usr/bin/env nu
      cd $"($nu.env.HOME)/dotfiles"
      git add .
      do { git commit -m "updates" } | ignore
      git pull --rebase
      ${pkgs.alejandra}/bin/alejandra -q .
      let system = (uname)
      if $system == "Darwin" {
        ${pkgs.nh}/bin/nh darwin switch .
      } else {
        ${pkgs.nh}/bin/nh os switch --update .
      }
      git push
    '')
  ];
}
