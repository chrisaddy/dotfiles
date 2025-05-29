inputs: self: super: let
  # Pre-load just the pieces that don’t depend on `self` fully yet
  filesystem = import ./filesystem.nix inputs self super;
  collectNix = filesystem.collectNix;

  # Now load the rest with `collectNix` available in `self`
  baseLib = {
    inherit collectNix;
  };

  colors = import ./colors.nix inputs (self // baseLib) super;
  option = import ./option.nix inputs (self // baseLib) super;
  system = import ./system.nix inputs (self
    // baseLib
    // {
      collectNix = baseLib.collectNix;
    })
  super;
  values = import ./values.nix inputs (self // baseLib) super;
in
  baseLib // colors // filesystem // option // system // values
