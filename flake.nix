{
  description = "hyperprior flake with fenix";

  nixConfig = {
    extra-trusted-substituters = ["https://cache.flox.dev"];
    extra-trusted-public-keys = ["flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flox = {
      url = "github:flox/flox/v1.6.0";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    fenix,
    flake-parts,
    home-manager,
    nix-darwin,
    nixvim,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];

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
              nixpkgs.overlays = [fenix.overlays.default];
              environment.systemPackages = with pkgs; [
                (fenix.packages.${pkgs.system}.complete.withComponents [
                  "cargo"
                  "clippy"
                  "rust-src"
                  "rustc"
                  "rustfmt"
                  "rust-analyzer"
                ])
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
              nixpkgs.overlays = [
                fenix.overlays.default
                (self: super: {
                  nix = super.nix.overrideAttrs (old: {
                    mesonFlags = (old.mesonFlags or []) ++ ["-Ddoc-gen=false"];
                  });
                  nix-dev-shell = super.nix-dev-shell.overrideAttrs (old: {
                    mesonFlags = (old.mesonFlags or []) ++ ["-Ddoc-gen=false"];
                  });
                })
              ];
              environment.systemPackages = with pkgs; [
                (fenix.packages.${pkgs.system}.complete.withComponents [
                  "cargo"
                  "clippy"
                  "rust-src"
                  "rustc"
                  "rustfmt"
                ])
                rust-analyzer-nightly
              ];
            })
          ];
        };

        darwinConfigurations.olympus = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ({...}: {
              environment.systemPackages = [
                inputs.flox.packages.aarch64-darwin.default
              ];
              nix.settings = {
                experimental-features = "nix-command flakes";
                substituters = ["https://cache.flox.dev"];
                trusted-public-keys = [
                  "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
                ];
              };
            })

            ./hosts/olympus/darwin-configuration.nix
            ./hosts/olympus
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.chrisaddy = import ./home/olympus.nix;
              home-manager.extraSpecialArgs = {inherit inputs nixvim;}; # ← Add this
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
