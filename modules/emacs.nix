{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs:
      with epkgs; [
        all-the-icons
        dashboard
        doom-modeline
        doom-themes
        evil-leader
        rainbow-delimiters
        hl-todo
        diff-hl
        dirvish
        lsp-mode
        lsp-ui
        lsp-treemacs
        elpy
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
        helm-org-rifle
        keycast
        ess
        nix-mode
        yasnippet
        yasnippet-snippets
        org
        org-jira
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
