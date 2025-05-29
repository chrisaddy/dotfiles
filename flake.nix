{
  description = "hyperprior config";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    experimental-features = [
      "cgroups"
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

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
  }:
  let 
  inherit (builtins) readDir;
  inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs nameValuePair;
  lib' = nixpkgs.lib.extend (_: _: nix-darwin.lib);
  lib = lib'.extend <| import ./lib inputs;

  hostsByType = readDir ./hosts
    |> mapAttrs (name: const <| import ./hosts/${name} lib)
    |> attrsToList
    |> groupBy ({ name, value }:
      if value ? class && value.class == "nixos" then
        "nixosConfigurations"
      else
        "darwinConfigurations")
    |> mapAttrs (const listToAttrs);

  hostConfigs = hostsByType.darwinConfigurations // hostsByType.nixosConfigurations
    |> attrsToList
    |> map ({ name, value }: nameValuePair name value.config)
    |> listToAttrs;

  in hostsByType // hostConfigs // {
    inherit lib;

    herculesCI = { ... }: {
      ciSystems = [ "aarch64-linux" "x86_64-linux"];
    };
  };
}
