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
    overlay = final: prev: {
      rust-toolchain = inputs.fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ];
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {pkgs, ...}: {
        _module.args.pkgs = import nixpkgs {
          system = pkgs.system;
          overlays = [overlay];
        };
      };

      flake = {
        nixosConfigurations.aion = nixpkgs.lib.nixosSystem {
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

            ({pkgs, ...}: {
              environment.systemPackages = with pkgs; [
                rust-toolchain
                rust-analyzer-nightly
              ];
            })
          ];
        };

        darwinConfigurations.m4 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
            ./hosts/m4/darwin-configuration.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.chrisaddy = import ./home/m4.nix;
            }

            ({pkgs, ...}: {
              environment.systemPackages = with pkgs; [
                rust-toolchain
                rust-analyzer-nightly
              ];
            })
          ];
        };
      };
    };
}
