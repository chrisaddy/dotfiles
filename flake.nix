{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "aarch64-darwin";

    userConfig = import ./config.nix {inherit lib;};

    overlays = [
      (final: prev: {
        emacsNoNativeComp = prev.emacs.override {
          withNativeCompilation = false;
        };
      })
    ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    baseModules = [
      {
        nix.enable = false;

        nixpkgs = {
          hostPlatform = system;
          overlays = overlays;
          config.allowBroken = true;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "claude-code"
              "1password-cli"
              "1password"
            ];
        };

        nix.settings = {
          experimental-features = "nix-command flakes";
        };

        environment.systemPackages = with pkgs; [
          vim
        ];

        users.users.${userConfig.username} = {
          home = userConfig.homeDirectory;
          shell = pkgs.nushell;
        };

        system.stateVersion = 6;
        system.configurationRevision = self.rev or self.dirtyRev or null;
      }

      home-manager.darwinModules.home-manager

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.${userConfig.username} = {
          imports = [
            ./home.nix
            nixvim.homeManagerModules.nixvim
          ];
        };
      }
    ];

    mkHost = name: {
      darwinConfigurations.${name} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = baseModules;
      };
    };

    hosts = [
      "Mac"
      "Christophers-Macbook-Pro"
    ];
  in
    lib.foldl' (acc: name: acc // (mkHost name)) {} hosts;
}
