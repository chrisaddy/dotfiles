{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nh
    alejandra

    (writeShellScriptBin "clean-system" ''
      #!/usr/bin/env nu
      nh clean all
    '')

    (writeShellScriptBin "search" ''
      #!/usr/bin/env nu
      ${pkgs.nh}/bin/nh search $query -j --limit 10000
      | from json
      | get results
      | get package_attr_name
      | str join (char nl)
      | fzf
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
