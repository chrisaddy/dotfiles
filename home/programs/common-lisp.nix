{
  pkgs,
  lib,
  ...
}:
let
  # Quicklisp's installer. Nothing in nixpkgs installs Quicklisp itself, and
  # upstream's only distribution is this one file, so it is pinned by hash and
  # run once per machine (see the activation step below). The hash is the one
  # upstream has published for years; the file has not changed since 2015.
  quicklispInstaller = pkgs.fetchurl {
    url = "https://beta.quicklisp.org/quicklisp.lisp";
    hash = "sha256-SnpcKuvgcWQXBHhUJnOX4kpE0MzglhJ0EenOnM/rLBc=";
  };
in
{
  home.packages = [
    # The Lisp that Sly starts from Doom's :lang common-lisp
    # (inferior-lisp-program defaults to "sbcl").
    pkgs.sbcl
  ];

  # Loads Quicklisp into every SBCL, including the one Sly starts, so `ql:` is
  # there without thinking about it. This is the block `(ql:add-to-init-file)`
  # would write; it is declared here because ~/.sbclrc is Home Manager's file
  # and that function could not edit it. The probe keeps SBCL starting cleanly
  # on a machine where the install below has not run yet.
  home.file.".sbclrc".text = ''
    #-quicklisp
    (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                           (user-homedir-pathname))))
      (when (probe-file quicklisp-init)
        (load quicklisp-init)))
  '';

  # Quicklisp is a mutable tree in ~/quicklisp (the client, the dist index and
  # every library you quickload), so like ~/.opam and Doom's packages it lives
  # outside the Nix store. Install it once if it is missing. This downloads
  # from quicklisp.org, so a failure (offline) only warns and the next switch
  # tries again. --no-userinit: ~/.sbclrc above must not run mid-install.
  home.activation.installQuicklisp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/quicklisp/setup.lisp" ]; then
      noteEcho "Installing Quicklisp into ~/quicklisp"
      if ! run --quiet ${pkgs.sbcl}/bin/sbcl --non-interactive --no-sysinit --no-userinit \
        --load ${quicklispInstaller} \
        --eval '(quicklisp-quickstart:install)'; then
        warnEcho "Quicklisp install failed; it will be retried on the next switch."
      fi
    fi
  '';
}
