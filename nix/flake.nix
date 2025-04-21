{
  description = "Nix Darwin system with Emacs, Nixvim, Nushell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    emacs-overlay,
  }: let
    system = "aarch64-darwin";
    overlays = [
      (import emacs-overlay)
      (final: prev: {
        emacs-git = prev.emacs-git.overrideAttrs (oldAttrs: {
          nativeBuildInputs =
            builtins.filter
            (input: input != prev.libgccjit)
            oldAttrs.nativeBuildInputs;
          configureFlags = (oldAttrs.configureFlags or []) ++ ["--without-native-compilation"];
        });
      })
    ];
  in {
    darwinConfigurations."Mac" = nix-darwin.lib.darwinSystem {
      system = system;

      modules = [
        {
          nix.enable = false;
          nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
            hostPlatform = system;
          };

          nix.settings.experimental-features = "nix-command flakes";

          environment.systemPackages = with nixpkgs.legacyPackages.${system}; [
            vim
            nushell
          ];

          users.users.chrisaddy = {
            shell = nixpkgs.legacyPackages.${system}.nushell;
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
            # home.packages = [
            #   nixpkgs.legacyPackages.${system}.emacs-git
            # ];
          };
        }
      ];
    };
  };
}
