inputs: self: super: let
  fullLib = super.lib;
  filesystem = import ./filesystem.nix {lib = fullLib;};
  collectNix = filesystem.collectNix;

  colors = import ./colors.nix inputs self super;
  option = import ./option.nix inputs self super;
  values = import ./values.nix inputs self super;
  system = import ./system.nix inputs self (super // {lib = fullLib;}) collectNix;
in
  filesystem // colors // option // values // system
