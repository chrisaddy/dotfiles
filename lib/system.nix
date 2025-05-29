inputs: self: super: collectNix: let
  inherit (super.lib) attrValues filter getAttrFromPath hasAttrByPath;

  common = collectNix ../modules/common;
  linux = collectNix ../modules/linux;
  darwin = collectNix ../modules/darwin;

  collectInputs = let
    inputs' = attrValues inputs;
  in
    path:
      inputs'
      |> filter (hasAttrByPath path)
      |> map (getAttrFromPath path);

  inputLinux = collectInputs ["nixosModules" "default"];
  inputDarwin = collectInputs ["darwinModules" "default"];
  inputOverlays = collectInputs ["overlays" "defaults"];

  overlayModule = {nixpkgs.overlays = inputOverlays;};

  specialArgs =
    inputs
    // {
      inherit inputs;
      keys = import ../keys.nix;
      lib = self;
    };
in {
  nixosSystem' = module:
    super.nixosSystem {
      inherit specialArgs;
      modules = [module overlayModule] ++ common ++ linux ++ inputLinux;
    };

  darwinSystem' = module:
    super.darwinSystem {
      inherit specialArgs;
      modules = [module overlayModule] ++ common ++ darwin ++ inputDarwin;
    };
}
