{inputs}: self: super: let
  lib = super.lib;
  filesystem = import ./filesystem.nix {inherit lib;};
  collectNix = filesystem.collectNix;

  colors = import ./colors.nix inputs self super;
  option = import ./option.nix inputs self super;
  values = import ./values.nix inputs self super;
  system = import ./system.nix inputs self (super // {inherit lib;}) collectNix;
in
  filesystem // colors // option // values // system
