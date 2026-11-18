{
  pkgs,
  lib,
  config,
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
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "export ${name}=${lib.escapeShellArg value}") doomEnv
      )}
      exec "$EMACSDIR/bin/doom" "$@"
    '';
  };
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

  # Emacs itself reads these at startup, so it must be started from a shell
  # (nushell gets them too, generated from home.sessionVariables).
  home.sessionVariables = doomEnv;

  # The Doom framework, pinned as the `doomemacs` flake input. Must match
  # EMACSDIR.
  xdg.configFile."emacs".source = doomemacs;

  # The Doom config. Must match DOOMDIR.
  xdg.configFile."doom".source = ../doom;

  home.packages = [
    doom
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
