{
  description = "Chris Addy's modular NixOS + macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    flake-utils,
    ...
  }: let
    systems = [
      "aarch64-darwin"
      "x86_64-linux"
    ];

    lib = import ./lib/default.nix inputs self {
      inherit (nixpkgs) lib;
      darwinSystem = nix-darwin.lib.darwinSystem;
      nixosSystem = nixpkgs.lib.nixosSystem;
    };
  in
    flake-utils.lib.eachSystem systems (system: {
    })
    // {
      darwinConfigurations = {
        m4 = lib.darwinSystem' ({lib, ...}: {
          imports = [./hosts/m4/configuration.nix];
        });
      };

      nixosConfigurations = {
        aion = lib.nixosSystem' ./hosts/aion/default.nix;
      };
    };
}
