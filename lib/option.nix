_: _: super: let
  inherit (super) mkOption;
in {
  mkConst = value: mkOption {
    default = value;
    readOnly = true;
  };

  mkvalue = default: mkOption {
    inherit default;
  };
}
