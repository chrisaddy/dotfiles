{
  config,
  pkgs,
  lib,
  headless ? false,
  gui ? !headless,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  # Obsidian Sync has no daemon. The sync engine lives inside the Electron
  # renderer, and `obsidian-cli` is only a client that attaches to an app that
  # is already up ("The CLI is unable to find Obsidian. Please make sure
  # Obsidian is running and try again."). Nothing in the package parses a
  # `--headless` flag. So keeping a vault in sync means keeping the desktop app
  # running, and the only question left is whether it gets a window.
  #
  # WSL is the machine where it must not: the full toolchain with no compositor
  # (`gui = false`), but still a real workstation rather than one of the
  # lightweight VMs (`headless = false`). See mkHome in flake.nix. On the
  # workstations Obsidian is an ordinary windowed app and needs none of this.
  syncDaemon = isLinux && !gui && !headless;

  displayNum = "99";
  display = ":${displayNum}";
in
{
  programs.obsidian.enable = true;

  # `programs.obsidian.vaults` and `.cli` are deliberately left at their
  # defaults. Obsidian owns ~/.config/obsidian/obsidian.json: it holds the
  # generated vault id that ties this checkout to the Sync account, and the app
  # rewrites the file as vaults are opened. Setting either option here hands
  # that file to Home Manager and drops the registration, which would leave the
  # headless instance parked on the vault picker, syncing nothing.

  systemd.user.services = lib.mkIf syncDaemon {
    # Xvfb is a plain unit rather than an `xvfb-run` wrapper around Obsidian:
    # xvfb-run traps signals on behalf of a child it supervises, which fights
    # systemd over process lifetime and restarts.
    obsidian-xvfb = {
      Unit.Description = "Virtual X display for headless Obsidian";
      Service = {
        ExecStart = "${pkgs.xvfb}/bin/Xvfb ${display} -screen 0 1280x1024x24 -nolisten tcp";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    obsidian-sync = {
      Unit = {
        Description = "Obsidian, windowless, so Obsidian Sync keeps running";
        Requires = [ "obsidian-xvfb.service" ];
        After = [
          "obsidian-xvfb.service"
          "network-online.target"
        ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Environment = [
          "DISPLAY=${display}"
          # The Nix wrapper adds `--ozone-platform=wayland` whenever both
          # NIXOS_OZONE_WL and WAYLAND_DISPLAY are set. WSLg sets the latter for
          # the whole user session, so without clearing them Electron would
          # ignore Xvfb and put a real window on the desktop — the one outcome
          # this unit exists to avoid.
          "NIXOS_OZONE_WL="
          "WAYLAND_DISPLAY="
        ];

        # Ordering only guarantees Xvfb was *exec'd*, not that it has created
        # its socket, so without this the app loses the race and dies on
        # "cannot open display". The wait deliberately contains no `$`:
        # systemd runs its own variable expansion over Exec* lines, so a
        # `$i` or `$(seq ...)` here is read by systemd before bash ever sees
        # it. TimeoutStartSec is what bounds the loop, rather than a counter.
        ExecStartPre = "${pkgs.bash}/bin/bash -c 'until [ -e /tmp/.X11-unix/X${displayNum} ]; do sleep 0.2; done'";
        TimeoutStartSec = 30;

        # Chromium suspends timers and throttles renderers it believes are
        # hidden, and on an unviewed Xvfb screen every window looks hidden.
        # Left alone, sync goes quiet minutes after start rather than failing
        # outright, which is the harder problem to notice.
        ExecStart = lib.concatStringsSep " " [
          "${config.programs.obsidian.package}/bin/obsidian"
          "--disable-gpu"
          "--disable-background-timer-throttling"
          "--disable-renderer-backgrounding"
          "--disable-backgrounding-occluded-windows"
        ];

        Restart = "on-failure";
        RestartSec = 15;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
