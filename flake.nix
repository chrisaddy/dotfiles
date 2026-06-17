{
  description = "Home Manager and nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doomemacs = {
      # git+https (not github:) with submodules=1 so the modules live in
      # `sources/doom+` (github: fetches a tarball without submodules).
      url = "git+https://github.com/doomemacs/doomemacs?submodules=1";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-darwin,
    doomemacs,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
    mkHome = system: username: {headless ? false}:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./home
        ];
        extraSpecialArgs = {
          inherit username headless doomemacs;
        };
      };
  in {
    darwinConfigurations."olympus-3" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.chrisaddy = import ./home;
          home-manager.extraSpecialArgs = {
            username = "chrisaddy";
            headless = false;
            inherit doomemacs;
          };
        }
      ];
    };

    homeConfigurations = let
      darwinHome = mkHome "aarch64-darwin" "chrisaddy" {};
      linuxHome = mkHome "x86_64-linux" "chrisaddy" {};
    in {
      # nh auto-detection (user@hostname)
      "chrisaddy@olympus-3" = darwinHome;
      "chrisaddy" = darwinHome;
      # Explicit platform targets
      "chrisaddy@darwin" = darwinHome;
      "chrisaddy@darwin-x86" = mkHome "x86_64-darwin" "chrisaddy" {};
      "chrisaddy@linux" = linuxHome;
      "chrisaddy@linux-arm" = mkHome "aarch64-linux" "chrisaddy" {};
      # exe.dev VM (lightweight, headless)
      "exedev@linux" = mkHome "x86_64-linux" "exedev" {headless = true;};
    };
  };
}
