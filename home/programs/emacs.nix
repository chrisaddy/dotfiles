{
  pkgs,
  lib,
  config,
  headless ? false,
  gui ? true,
  doomemacs,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  # One Emacs per kind of machine:
  #   no desktop (VMs, WSL) -> emacs-nox   no GUI toolkit in the closure
  #   Linux desktop         -> emacs-pgtk  Wayland-native, for niri
  #   macOS                 -> emacs       Cocoa
  emacsPackage =
    if !gui then
      pkgs.emacs-nox
    else if isLinux then
      pkgs.emacs-pgtk
    else
      pkgs.emacs;

  # Where Doom lives. The framework and the config are read-only links into
  # the Nix store (see xdg.configFile below); everything Doom installs or
  # builds goes to DOOMLOCALDIR, which is mutable and outside the store.
  # Without DOOMLOCALDIR Doom falls back to $EMACSDIR/.local, i.e. it tries to
  # write into the store.
  doomEnv = {
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMDIR = "${config.xdg.configHome}/doom";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
  };

  doomExports = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "export ${name}=${lib.escapeShellArg value}") doomEnv
  );

  # `doom` on PATH. A wrapper rather than adding ~/.config/emacs/bin to
  # home.sessionPath, so the CLI carries its own environment: it works from a
  # shell that predates the session variables, and from `upd`. It also pins
  # the CLI to the same Emacs the editor runs, so packages are byte-compiled
  # by the version that will load them.
  doom = pkgs.writeShellApplication {
    name = "doom";
    runtimeInputs = [
      config.programs.emacs.finalPackage
      pkgs.git
    ];
    text = ''
      ${doomExports}
      exec "$EMACSDIR/bin/doom" "$@"
    '';
  };

  # `emacs` on PATH, for the same reason. Without DOOMLOCALDIR in its
  # environment Emacs still finds Doom in ~/.config/emacs but looks for the
  # synced profile in the store, finds none and stops with "void-variable
  # doom-modules". That is every shell opened before the first switch, and
  # anything else that does not source hm-session-vars.sh. hiPrio because
  # programs.emacs installs the real bin/emacs into the same profile.
  emacsWithDoomEnv = lib.hiPrio (
    pkgs.writeShellScriptBin "emacs" ''
      ${doomExports}
      exec ${config.programs.emacs.finalPackage}/bin/emacs "$@"
    ''
  );
in
{
  programs.emacs = {
    enable = true;
    package = emacsPackage;
    # Packages with native code come from Nix, prebuilt. Doom would otherwise
    # compile them on first use, which needs cmake and libtool for vterm and
    # autotools plus poppler for pdf-tools. Doom declares vterm as
    # `:built-in 'prefer`, so it picks this copy up by itself; pdf-tools gets
    # the same declaration in home/doom/packages.el.
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
    ];
  };

  # Emacs reads these at startup. The `emacs` wrapper above sets them
  # itself; this covers whatever starts Emacs by another path (the daemon's
  # login shell, a script calling a store path). nushell gets them too,
  # generated from home.sessionVariables.
  home.sessionVariables = doomEnv;

  # One long-lived Emacs per login, reached with `emacsclient`: launchd on
  # macOS, a systemd user unit on Linux. Not on the headless VMs, where a
  # resident Doom is most of the machine. `client.enable` only adds an
  # "Emacs Client" launcher entry on Linux desktops.
  services.emacs = {
    enable = !headless;
    client.enable = gui;
  };

  # Home Manager's systemd unit already starts Emacs through a login shell,
  # but its launchd agent execs the binary directly, and launchd hands it
  # only /usr/bin:/bin:/usr/sbin:/sbin and none of the session variables.
  # Doom would then have no DOOMLOCALDIR (it would try to write into the
  # store) and find neither git, rg, fd nor any language server. A login
  # shell reads ~/.profile, which sources hm-session-vars.sh and the Nix
  # profile, so the daemon sees what a terminal sees. `exec` keeps Emacs as
  # the process launchd supervises.
  launchd.agents.emacs.config.ProgramArguments = lib.mkIf config.services.emacs.enable (
    lib.mkForce [
      pkgs.runtimeShell
      "-l"
      "-c"
      "exec ${config.services.emacs.package}/bin/emacs --fg-daemon"
    ]
  );

  # The Doom framework, pinned as the `doomemacs` flake input. Must match
  # EMACSDIR.
  xdg.configFile."emacs".source = doomemacs;

  # The Doom config. Must match DOOMDIR.
  xdg.configFile."doom".source = ../doom;

  home.packages = [
    doom
    emacsWithDoomEnv
  ]
  ++ lib.optionals gui [
    pkgs.nerd-fonts.jetbrains-mono # doom-font in home/doom/config.el
    pkgs.nerd-fonts.symbols-only # nerd-icons glyphs: modeline, dired, completion
  ];

  # Emacs uses ~/.emacs.d whenever it exists and only then looks at
  # ~/.config/emacs, and a plain Emacs creates ~/.emacs.d on its first start.
  # An empty one left behind that way would hide Doom completely, so remove
  # it. rmdir only succeeds on an empty directory; one with content is left
  # alone and reported.
  home.activation.removeEmptyEmacsD = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "$HOME/.emacs.d" ] && [ ! -L "$HOME/.emacs.d" ]; then
      if ! run rmdir "$HOME/.emacs.d" 2>/dev/null; then
        warnEcho "~/.emacs.d exists and is not empty, so Emacs will load it instead of Doom in ~/.config/emacs. Move it away to use Doom."
      fi
    fi
  '';
}
