{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      enable = true;
      userName = "chrisaddy";
      userEmail = "chris.william.addy@gmail.com";
    };
  };
}
