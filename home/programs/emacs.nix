{
  pkgs,
  lib,
  config,
  headless ? false,
  doomemacs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Pick the Emacs build per platform:
  #   headless          -> emacs30-nox  (no GUI dependencies)
  #   Linux desktop     -> emacs30-pgtk (Wayland-native, good for niri)
  #   macOS desktop     -> emacs30      (Cocoa)
  emacsPackage =
    if headless
    then pkgs.emacs30-nox
    else if isLinux
    then pkgs.emacs30-pgtk
    else pkgs.emacs30;
in {
  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };

  # Autoload fonts installed via Home Manager (Linux desktop only).
  fonts.fontconfig.enable = isLinux && !headless;

  # XDG-compliant Doom paths. These must match the symlinks below.
  home.sessionVariables = {
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };
  home.sessionPath = ["${config.xdg.configHome}/emacs/bin"];

  # The Doom framework, pinned via the `doomemacs` flake input.
  # Must match $EMACSDIR.
  xdg.configFile."emacs".source = doomemacs;

  # The user's Doom configuration. Must match $DOOMDIR.
  xdg.configFile."doom".source = ../doom;

  home.packages = with pkgs;
    [
      # Indexing / search dependencies used by many Doom modules.
      fd
      (ripgrep.override {withPCRE2 = true;})
    ]
    ++ lib.optionals (!headless) [
      emacs-all-the-icons-fonts
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
    ];
}
