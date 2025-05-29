{
  description = "hyperprior config";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    experimental-features = ["cgroups" "flakes" "nix-command" "pipe-operators"];
    trusted-users = ["root" "@build" "@wheel" "@admin"];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "nix-darwin";
        home-manager.follows = "home-manager";
      };
    };

    themes.url = "github:RGBCube/ThemeNix";
  };

  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    ...
  }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList groupBy listToAttrs mapAttrs nameValuePair isFunction;

    lib' = nixpkgs.lib.extend (_: _: nix-darwin.lib);
    lib = lib'.extend <| import ./lib inputs;

    rawHosts =
      readDir ./hosts
      |> mapAttrs (name: _: let
        imported = import ./hosts/${name};
        host =
          if isFunction imported
          then imported lib
          else imported;
      in {
        class = host.class;
        config = host.config lib;
      });

    hostsByType =
      rawHosts
      |> attrsToList
      |> groupBy ({value, ...}:
        if value ? class && value.class == "nixos"
        then "nixosConfigurations"
        else "darwinConfigurations")
      |> mapAttrs (_: listToAttrs);
  in {
    darwinConfigurations = hostsByType.darwinConfigurations or {};
    nixosConfigurations = hostsByType.nixosConfigurations or {};
    lib = lib;
  };
}
### hosts/m4/default.nix
{
  class = "darwin";
  config = lib:
    lib.darwinSystem' (
      {lib, ...}: {
        imports = [];

        networking.hostName = "m4";

        users.users.chrisaddy = {
          name = "chrisaddy";
          home = "/Users/chrisaddy";
        };

        home-manager.users.chrisaddy.home = {
          stateVersion = "25.05";
          homeDirectory = "/Users/chrisaddy";
        };

        system.stateVersion = "25.05";
      }
    );
}
