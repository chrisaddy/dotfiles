{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.org-roam
      epkgs.catppuccin-theme
      epkgs.which-key
    ];
    extraConfig = ''
      ;; Base settings
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (setq inhibit-startup-screen t)
      (setq display-line-numbers-type 'relative)
      (global-display-line-numbers-mode 1)
      (savehist-mode 1)
      (recentf-mode 1)
      (setq make-backup-files nil)
      (setq auto-save-default nil)

      ;; Theme
      (setq catppuccin-flavor 'macchiato)
      (load-theme 'catppuccin :no-confirm)

      ;; Which-key
      (require 'which-key)
      (which-key-mode 1)

      ;; Org-roam
      (setq org-roam-directory (expand-file-name "~/notes"))
      (setq org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))
      (setq org-roam-completion-everywhere t)

      (require 'org-roam)
      (org-roam-db-autosync-mode 1)

      ;; Keybindings (C-c n prefix)
      (global-set-key (kbd "C-c n f") #'org-roam-node-find)
      (global-set-key (kbd "C-c n i") #'org-roam-node-insert)
      (global-set-key (kbd "C-c n l") #'org-roam-buffer-toggle)
      (global-set-key (kbd "C-c n c") #'org-roam-capture)
      (global-set-key (kbd "C-c n d") #'org-roam-dailies-goto-today)
    '';
  };
}
