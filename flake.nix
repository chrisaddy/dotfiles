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

    themes.url = "github:RGBCube/ThemeNix";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    themes,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "aarch64-darwin";

    userConfig = import ./config.nix {inherit lib;};

    overlays = [
      (final: prev: {
        # Add custom package overrides here
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
          config.allowUnsupportedSystem = true;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "claude-code"
            ];
        };

        nix.settings = {
          experimental-features = "nix-command flakes pipe-operators";
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
        services.yabai = {
          enable = true;
          enableScriptingAddition = true;
          config = {
            layout = "bsp";
            auto_balance = "on";
            focus_follows_mouse = "autoraise";
            mouse_follows_focus = "off";
            window_gap = 10;
            top_padding = 10;
            bottom_padding = 10;
            left_padding = 10;
            right_padding = 10;
          };
        };

        services.skhd = {
          enable = true;
          skhdConfig = ''
            alt - h : yabai -m window --focus west
            alt - l : yabai -m window --focus east
            alt - j : yabai -m window --focus south
            alt - k : yabai -m window --focus north

            shift + alt - h : yabai -m window --swap west
            shift + alt - l : yabai -m window --swap east
            shift + alt - j : yabai -m window --swap south
            shift + alt - k : yabai -m window --swap north
          '';
        };
      }

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.${userConfig.username} = {
          imports = [
            ./home.nix
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
      "Chriss-MacBook-Air"
    ];
  in
    lib.foldl' (acc: name: acc // (mkHost name)) {} hosts;
}
