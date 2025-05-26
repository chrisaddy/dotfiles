{
  description = "Chris's multi-host flake (macOS + NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    themes.url = "github:RGBCube/ThemeNix";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    flake-utils,
    themes,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    overlays = [
      (final: prev: {
        # Example: disable native-comp for Emacs
        # emacsNoNativeComp = prev.emacs.override { withNativeCompilation = false; };
      })
    ];

    mkPkgs = system:
      import nixpkgs {
        inherit system overlays;
      };

    userConfig = import ./config.nix {inherit lib;};

    nixCommon = {
      nixpkgs = {
        overlays = overlays;
        config = {
          allowUnfree = true;
          allowBroken = true;
          allowUnsupportedSystem = true;
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [];
        };
      };

      nix.settings.experimental-features = "nix-command flakes";
    };
  in {
    darwinConfigurations."Chriss-MacBook-Air" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        nixCommon

        {
          users.users.${userConfig.username} = {
            home = userConfig.homeDirectory;
            shell = (mkPkgs "aarch64-darwin").nushell;
          };

          system.stateVersion = 6;
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userConfig.username} = {
            imports = [./home.nix];
          };
        }
      ];
    };

    nixosConfigurations.t470s = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixCommon
        ./configuration.nix
        ./hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userConfig.username} = {
            imports = [./home.nix];
          };
        }
      ];

      specialArgs = {inherit userConfig overlays;};
    };
  };
}
