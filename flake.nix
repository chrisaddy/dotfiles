{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      mkHome = system: username: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          nixvim.homeManagerModules.nixvim
          ./home
        ];
        extraSpecialArgs = {
          inherit username;
        };
      };
    in
    {
      homeConfigurations = let
        darwinHome = mkHome "aarch64-darwin" "chrisaddy";
        linuxHome = mkHome "x86_64-linux" "chrisaddy";
      in {
        # nh auto-detection (user@hostname)
        "chrisaddy@olympus-2" = darwinHome;
        "chrisaddy" = darwinHome;
        # Explicit platform targets
        "chrisaddy@darwin" = darwinHome;
        "chrisaddy@darwin-x86" = mkHome "x86_64-darwin" "chrisaddy";
        "chrisaddy@linux" = linuxHome;
        "chrisaddy@linux-arm" = mkHome "aarch64-linux" "chrisaddy";
      };
    };
}
