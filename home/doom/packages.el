;; -*- no-byte-compile: t; -*-
;;; packages.el

;; Declare extra packages here, then run 'doom sync' to install them. See the
;; Doom docs for the full syntax:
;;   https://docs.doomemacs.org/latest/#/getting-started/packages
;;
;; Examples:
;;   (package! some-package)
;;   (package! another-package :recipe (:host github :repo "username/repo"))
;;   (unpin! pinned-package)
;;   (disable-packages! a-package)

;; Review GitHub pull requests inside Emacs. Deps (magit-section, ghub,
;; markdown-mode) come from the :tools magit and :lang markdown modules.
(package! pr-review :recipe (:host github :repo "blahgeek/emacs-pr-review"))

;; pdf-tools ships a C server (epdfinfo) that it otherwise compiles on first
;; use with autotools and poppler. Nix already provides the package with the
;; server built (programs.emacs.extraPackages in home/programs/emacs.nix);
;; 'prefer makes Doom use that copy and skip installing its own.
(package! pdf-tools :built-in 'prefer)
