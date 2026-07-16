;;; config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run
;; 'doom sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "chrisaddy"
      user-mail-address "chris.william.addy@gmail.com")

;; Fonts. JetBrainsMono Nerd Font ships via the nerd-fonts.jetbrains-mono
;; package in emacs.nix; nerd icons come from nerd-fonts.symbols-only.
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 14))

;; Theme.
(setq doom-theme 'doom-one)

;; Relative line numbers play nicely with evil motions.
(setq display-line-numbers-type 'relative)

;; Org directory. Must be set before org loads.
(setq org-directory "~/org/")

;; vterm: build the native module against the Nix-provided libvterm
;; (libvterm-neovim, in home/default.nix) instead of emacs-libvterm's vendored
;; copy. The vendored build uses autotools/`glibtool`, which we don't ship;
;; pointing CMAKE_PREFIX_PATH at the Nix profile lets cmake find the system lib
;; (USE_SYSTEM_LIBVTERM defaults ON) and skip that path entirely.
(setq vterm-module-cmake-args
      (concat "-DCMAKE_PREFIX_PATH=" (expand-file-name "~/.nix-profile")))

;; pr-review: review GitHub PRs in Emacs. Auth uses ghub, which reads a token
;; from auth-source (e.g. ~/.authinfo.gpg) for machine api.github.com. Bound
;; under the git leader: SPC g p (open by URL) and SPC g P (search).
(use-package! pr-review
  :commands (pr-review pr-review-open-url pr-review-search-open)
  :init
  (map! :leader
        (:prefix ("g" . "git")
         :desc "PR review (URL)" "p" #'pr-review-open-url
         :desc "PR review (search)" "P" #'pr-review-search-open)))
