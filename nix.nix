{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nh
    alejandra

    (writeShellScriptBin "up" ''
      pushd $HOME/dotfiles
      git add .
      git commit -m "updates"
      git pull --rebase
      ${pkgs.alejandra}/bin/alejandra -q .
      ${pkgs.nh}/bin/nh darwin switch .
      git push
    '')
  ];
}
