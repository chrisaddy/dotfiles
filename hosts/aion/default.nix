lib: lib.nixosSystem' ({ config, pkgs, keys, lib, ...}: let
  inherit (lib) collectNix remove;
in {
  imports = collectNix ./. |> remove ./default.nix;

  users.users.chrisaddy = {
    isNormalUser = true;
    description = "chrisaddy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  home-manager.users.chrisaddy.home = {
    stateVersion = "25.05";
    homeDirectory = "/home/chrisaddy";
  };

})
