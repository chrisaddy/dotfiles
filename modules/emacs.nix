{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs:
      with epkgs; [
        dashboard
        doom-themes
        all-the-icons
        rainbow-delimiters
        doom-modeline
        hl-todo
        diff-hl
        dirvish
        lsp-mode
        lsp-ui
        lsp-treemacs
        elpy
        haskell-mode
        lsp-haskell
        magit
        magit-section
        projectile
        counsel-projectile
        gptel
        which-key
        evil
        evil-collection
        evil-commentary
        evil-org
        general
        org-roam
        helm-org-rifle
        keycast
        ess
        nix-mode
        vterm
        yasnippet
        yasnippet-snippets
        org
        org-roam
        dash
        f
        s
        emacsql
        helpful
        vundo
        ivy
        ivy-rich
        counsel
        listen
        company
        company-box
        lsp-ivy
        envrc
        helm-org-rifle
      ];
    extraConfig = builtins.readFile ./init.el;
  };
}
