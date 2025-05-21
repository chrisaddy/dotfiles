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
    nyxt-src = {
      url = "github:atlas-engineer/nyxt/v3.12.0";
      flake = false;
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
    nyxt-src,
    /*
    nyxt
    */
    ...
  }: let
    lib = nixpkgs.lib;
    system = "aarch64-darwin";

    userConfig = import ./config.nix {inherit lib;};

    overlays = [
      (final: prev: {
        # emacsNoNativeComp = prev.emacs.override {
        #   withNativeCompilation = false;
        # };

        nyxt = prev.stdenv.mkDerivation {
          pname = "nyxt";
          version = "3.12.0";
          src = nyxt-src;
          buildInputs = [
            prev.make
          ];
          installPhase = ''
            make
            mkdir -p $out/bin
            cp my-binary $out/bin/
          '';
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
