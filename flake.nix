{
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

    # nixvim.url = "github:nix-community/nixvim";
    # mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    # nixvim,
    # mac-app-util,
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
              "vscode-extension-visualjj-visualjj"
              "vscode"
              "vscode-extension-ms-vscode-remote-remote-containers"
              "windsurf"
            ];
        };

        nix.settings = {
          experimental-features = "nix-command flakes";
        };

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
            # nixvim.homeManagerModules.nixvim
          ];
        };

        # home-manager.sharedModules = [
        #   mac-app-util.homeManagerModules.default
        # ];
      }
    ];

    mkHost = name: {
      darwinConfigurations.${name} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = baseModules;
      };
    };

    hosts = [
      "Chriss-MacBook-Air"
    ];
  in
    lib.foldl' (acc: name: acc // (mkHost name)) {} hosts;
}
