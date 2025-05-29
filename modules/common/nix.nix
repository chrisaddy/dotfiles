{ self, config, inputs, lib, pkgs, ...}: let
  inherit (lib) attrValues attrsToList concatStringsSep disabled filter filterAttrs flip id isType mapAttrs mapAttrsToList match merge mkAfter optionalAttrs optionals;
  inherit (lib.strings) toJSON;
in {
  nix.gc = merge {
    automatic = true;
    options = "--delete-older-than 3d";
  } <| optionalAttrs config.isLinux {
    dates = "weekly";
    persistent = true;
  }

  nix.optimize.automatic = true;

  environment.systemPackages = with pkgs; [

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
