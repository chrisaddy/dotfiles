{
  description = "hyperprior";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    themes.url = "github:RGBCube/ThemeNix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    home-manager,
    nix-darwin,
    fenix,
    ...
  }: let
    lib = import ./lib/default.nix {inherit inputs;} self nixpkgs.lib;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];

      imports = [];

      flake = {
        nixosConfigurations = {
          aion = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/aion/configuration.nix
              ./hosts/aion/hardware.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.chrisaddy = import ./home/aion.nix;
              }
            ];
          };
        };

        darwinConfigurations = {
          m4 = inputs.nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            modules = [
              ./hosts/m4/darwin-configuration.nix

              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.chrisaddy = import ./home/m4.nix;
              }
            ];
          };
        };
      };
    };
}
