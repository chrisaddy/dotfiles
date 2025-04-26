{
  description = "Nix Darwin system with Emacs, Nixvim, Nushell";

  # nixConfig = {
  #   # extra-trusted-substituters = ["https://cache.flox.dev"];
  #   # extra-trusted-public-keys = ["flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="];
  # };
  #
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    # flox = {
    #   url = "github:flox/flox/v1.4.0";
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    # flox,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "aarch64-darwin";
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
  in {
    darwinConfigurations."Mac" = nix-darwin.lib.darwinSystem {
      system = system;
      modules = [
        {
          nix.enable = false;
          nixpkgs = {
            hostPlatform = system;
            overlays = overlays;
            config.allowUnfreePredicate = pkg:
              builtins.elem (lib.getName pkg) [
                "claude-code"
              ];
          };

          nix.settings = {
            experimental-features = "nix-command flakes";
            # substituters = ["https://cache.flox.dev"];
            # trusted-public-keys = [
            #   "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
            # ];
          };

          environment.systemPackages = with pkgs; [
            vim
            zsh
          ];

          users.users.chrisaddy = {
            home = "/Users/chrisaddy";
            shell = pkgs.zsh;
          };

          system.stateVersion = 6;
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }

        home-manager.darwinModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.chrisaddy = {
            imports = [
              ./home.nix
              nixvim.homeManagerModules.nixvim
            ];
          };
        }
      ];
    };
  };
}
