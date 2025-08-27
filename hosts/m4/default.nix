
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.chrisaddy = import ../../home/olympus.nix {
      inherit pkgs;
      inherit (inputs) nixvim;
    };
  };

  users.users.chrisaddy = {
    home = "/Users/chrisaddy";
    shell = pkgs.nushell;
  };

  programs.zsh.enable = true;
}
