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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # The Doom Emacs framework, pinned here and linked to ~/.config/emacs by
    # home/programs/emacs.nix. git+https with submodules=1, not the github:
    # shorthand: Doom keeps its modules in the `sources/doom+` submodule and
    # github: fetches a tarball without submodules.
    doomemacs = {
      url = "git+https://github.com/doomemacs/doomemacs?submodules=1";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nixvim,
      doomemacs,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # `headless` means a lightweight VM: no nushell login shell (bootstrap.sh
      # and exevm drive these with `ssh host "a && b"`, which nu cannot parse)
      # and none of the heavy dev toolchain. `gui` is the separate question of
      # whether a compositor/terminal/browser belong here; it defaults to the
      # headless answer but is set independently for WSL, which wants the full
      # toolchain with no desktop.
      mkHome =
        system: username:
        {
          headless ? false,
          gui ? !headless,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            ./home
          ];
          extraSpecialArgs = {
            inherit
              username
              headless
              gui
              nixvim
              doomemacs
              ;
          };
        };
    in
    {
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
              gui = true;
              inherit doomemacs nixvim;
            };
          }
        ];
      };

      homeConfigurations =
        let
          darwinHome = mkHome "aarch64-darwin" "chrisaddy" { };
          linuxHome = mkHome "x86_64-linux" "chrisaddy" { };
          # WSL2 Arch box: full dev toolchain, but no compositor or terminal
          # emulator — WSLg is not where niri/waybar/ghostty earn their keep.
          wslHome = mkHome "x86_64-linux" "chris" { gui = false; };
        in
        {
          # nh auto-detection (user@hostname)
          "chrisaddy@olympus-3" = darwinHome;
          "chrisaddy" = darwinHome;
          # Explicit platform targets
          "chrisaddy@darwin" = darwinHome;
          "chrisaddy@darwin-x86" = mkHome "x86_64-darwin" "chrisaddy" { };
          "chrisaddy@linux" = linuxHome;
          "chrisaddy@linux-arm" = mkHome "aarch64-linux" "chrisaddy" { };
          # exe.dev VM (lightweight, headless)
          "exedev@linux" = mkHome "x86_64-linux" "exedev" { headless = true; };
          # WSL2 Arch
          "chris@linux" = wslHome;
          "chris" = wslHome;
        };
    };
}
