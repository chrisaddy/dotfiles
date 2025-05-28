lib: lib.nixosSystem; ({ ocnfig, keys, lib, ...}: let
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

  system.stateVersion = "25.05";
  home-manager.sharedModules = [{
    home.stateVersion = "25.05";
  }];
};
)
