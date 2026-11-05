{ pkgs, ... }: {
  home.packages = with pkgs; [ maestral ];
  systemd.user.services.maestral = {
    Unit.Description = "Maestral Dropbox client";
    Service = {
      ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
      ExecStop = "${pkgs.maestral}/bin/maestral stop";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
