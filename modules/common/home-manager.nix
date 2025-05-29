{
  lib,
  config,
  ...
}: {
  options = {
    home-manager.enable = lib.mkEnableOption "Enable Home Manager shared settings";
  };

  config = lib.mkIf config.home-manager.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
