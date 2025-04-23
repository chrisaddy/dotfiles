;; -*- lexical-binding: t -*-

(setq inhibit-startup-message t)
(desktop-save-mode 1)

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; PACKAGE MANAGEMENT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(straight-use-package 'use-package)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; LOCAL FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hyperprior/jump-to-file (file-path)
  (interactive)
  (find-file file-path))

(defun hyperprior/counsel-ibuffer-menu ()
  (interactive)
  (let* ((current (buffer-name (current-buffer)))
         (buffers (mapcar #'buffer-name
                          (seq-filter (lambda (buf)
                                        (and (not (equal (buffer-name buf) current))
                                             (not (minibufferp buf))))
                                      (buffer-list)))))
    (ivy-read "switch to buffer: " buffers
              :action #'switch-to-buffer)))

(defun hyperprior/reload-init ()
  (interactive)
  (load-file user-init-file))

(defun hyperprior/haskell-stack-build ()
  "run `stack build` in the project root."
  (interactive)
  (let ((default-directory (locate-dominating-file default-directory "stack.yaml")))
    (compile "stack build")))

(defun hyperprior/kill-other-window-buffer ()
  (interactive)
  (let ((target (next-window)))
    (with-selected-window target
      (kill-buffer)
      (unless (one-window-p)
        (delete-window))))
  (other-window 1))

(defun hyperprior/gt-ls ()
  (interactive)
  (let ((buf (get-buffer-create "*Graphite Stack*")))
    (with-current-buffer buf
      (read-only-mode -1)
      (erase-buffer)
      (call-process "gt" nil buf t "ls")
      (read-only-mode 1))
    (pop-to-buffer buf)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; UI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(set-fringe-mode 10)
(menu-bar-mode   -1)

(setq visible-bell nil)
(setq ring-bell-function 'ignore)
(set-face-attribute 'default nil :height 250)
(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(add-to-list 'default-frame-alist '(undecorated . t))

(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-challenger-deep t))

(use-package all-the-icons
  :if (display-graphic-p)
  :straight t)

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package hl-todo
  :straight t
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(use-package diff-hl
  :straight t
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NAVIGATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dirvish
    :straight t
    :init
    (dirvish-override-dired-mode)
    :custom
    (dirvish-quick-access-entries
     '(("h" "~/"                                         "home")
       ("ce" "~/dotfiles/emacs"                          "config")
       ("cv" "~/dotfiles/nvim"                           "neovim")
       ("m" "~/Music"                                    "neovim")
       ("pr" "~/projects/"                               "projects")
       ("psf" "~/projects/pocketsizefund/pocketsizefund" "psf")))
    :config
    (setq dirvish-extensions
	  '(git-msg file-info collapse subtree yank icons side peek))
    (setq dirvish-icon-backend 'all-the-icons)
    (setq dirvish-all-the-icons-height 0.9
	  dirvish-all-the-icons-offset 0.1)
    (dirvish-peek-mode)
    (setq dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse
          git-msg file-time file-size file-modes)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))

    (setq dirvish-side-width 35)
    (setq dirvish-peek-key 'any)
    (setq dirvish-side-follow-mode t)
    (setq dirvish-use-header-line 'global
          dirvish-header-line-height '(25 . 35)
          dirvish-mode-line-height 25
          dirvish-mode-line-bar-image-width 0
          dirvish-header-line-format '(:left (path) :right (free-space))
          dirvish-mode-line-format '(:left (sort file-time " " file-size symlink)
                                         :right (omit yank index))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CLIPBOARD ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq select-enable-clipboard t)
(setq select-enable-primary t)
(unless (display-graphic-p)
  (setq interprogram-cut-function
        (lambda (text &optional _push)
          (let ((process-connection-type nil))
            (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
              (process-send-string proc text)
              (process-send-eof proc)))))
  (setq interprogram-paste-function
        (lambda ()
          (shell-command-to-string "pbpaste"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; LSP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hyperprior/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :hook ((lsp-mode . hyperprior/lsp-mode-setup)
         (haskell-mode . lsp))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-haskell-server-path "haskell-language-server-wrapper"))

(use-package lsp-ui
  :straight t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :straight t
  :after lsp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; LISP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package parinfer-rust-mode
;;   :straight t
;;   :hook emacs-lisp-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package nix-mode
  :straight t
  :init
  ; (add-hook 'nix-mode-hook
  ;    (lambda ()
  ;      ; (nixel-mode 1)
  ;      (setq-local flycheck-check-mode 'nil)))
  :config
  (add-to-list 'auto-mode-alist '("\\.nix'" . nix-mode)))

; (use-package nixel
;   :straight t
;   :after nix-mode)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PYTHON ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: deep dive on elpy and setup for IDE
(use-package elpy
  :straight t
  :init
  (elpy-enable))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; RUST ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: setup rust mode
;; https://github.com/rust-lang/rust-mode
;; https://github.com/flycheck/flycheck-rust
;; https://github.com/racer-rust/emacs-racer?tab=readme-ov-file
;; https://github.com/kwrooijen/cargo.el
;; https://github.com/brotzeit/rustic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; HASKELL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package haskell-mode
  :straight t
  :hook ((haskell-mode . interactive-haskell-mode)))

(use-package lsp-haskell
  :straight t
  :hook (haskell-mode . lsp))

(add-hook 'haskell-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; GIT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :straight t
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PROJECTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :straight t
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects"))
    (setq projectile-switch-project-action #'projectile-dired)))

(use-package counsel-projectile
  :straight t
  :config (counsel-projectile-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; AI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package gptel
  :straight t)
  ;; :config
  ;; (gptel-make-anthropic "claude" :stream t))
;; TODO: setup copilot properly
;; (use-package copilot
;;   :vc (:url "https://github.com/copilot-emacs/copilot.el"
;;             :rev :newest
;;             :branch "main")
;;   :config
;;   (add-hook 'prog-mode-hook 'copilot-mode))

;; (use-package elysium
;;   :straight t
;;   :custom
;;   (elysium-window-size 0.33)
;;   (elysium-window-style 'vertical))

(use-package smerge-mode
  :straight t
  :hook
  (prog-mode . smerge-mode))

;; (use-package aider
;;   :straight (:host github :repo "tninja/aider.el")
;;   :config
;;   (setq aider-args '("--model" "sonnet" "--no-auto-accept-architect"))

;;   )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; KEYS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package which-key
  :straight t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package evil
  :straight t
  :init
  (setq evil-want-integration   t)
  (setq evil-want-keybinding  nil)
  (setq evil-want-C-u-scroll    t)
  (setq evil-want-C-i-jump    nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode       'normal))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :straight t
  :config
  (evil-commentary-mode))

(use-package general
  :straight t
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    ";"   '(counsel-M-x                         :which-key "M-x")
    ":"   '(eval-expression                     :which-key "Eval:")
    "SPC" '(hyperprior/counsel-ibuffer-menu     :which-key "buffers")
    "a"   '(:ignore t                           :which-key "ai")
    "ai"  '(gptel                               :which-key "chat")
    "ar"  '(gptel-rewrite                       :which-key "ai rewrite")
    "b"   '(:ignore t                           :which-key "buffers")
    "bb"  '(counsel-ibuffer                     :which-key "find buffer")
    "bm"  '(buffer-menu                         :which-key "buffer menu")
    "br"  '(rename-buffer                       :which-key "buffer rename")
    "dh"  '(dirvish                             :which-key "directory here")
    "dq"  '(dirvish-quick-access                :which-key "directory quick access")
    "dm"  '(dirvish-dispatch                    :which-key "dirvish menu")
    "hb"  '(hyperprior/haskell-stack-build      :which-key "haskell build")
    "hc"  '(haskell-check                       :which-key "haskell check (current file)")
    "t"   '(:ignore t                           :which-key "toggles")
    "tt"  '(counsel-load-theme                  :which-key "choose theme")
    "f"   '(:ignore t                           :which-key "find")
    "ff"  '(counsel-find-file                   :which-key "find file")
    "fi"  '((lambda () (interactive)
              (hyperprior/jump-to-file "~/dotfiles/emacs/init.el"))
	                                        :which-key "open init.el")
    "fs"  '(save-buffer                         :which-key "file save")
    "gg"  '(magit-status                        :which-key "git status")
    "kc"  '(keycast-header-line-mode            :which-key "key cast")
    "ko"  '(hyperprior/kill-other-window-buffer :which-key "kill other window")
    "nb"  '(obsidian-jump-back                  :which-key "notes search")
    "nh"  '((lambda () (interactive)
    	      (hyperprior/jump-to-file "~/vaults/zettelkasten/✱ home/✱ home.md"))
	      		    		        :which-key "notes home")
    "ns"  '(obsidian-jump                       :which-key "notes search")
    "o"   '(:ignore t                           :which-key "org")
    "oa"  '(org-agenda                          :which-key "org agenda")
    "oc"  '(org-capture                         :which-key "org capture")
    "or"  '(org-roam                            :which-key "org roam")
    "os"  '(helm-org-rifle-occur-org-directory  :which-key "org search")
    "r"   '(:ignore t                           :which-key "reload")
    "ri"  '(hyperprior/reload-init              :which-key "reload init.el")
    "th"  '(vterm                               :which-key "terminal here")
    ))

(use-package keycast
  :straight t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; STATISTICS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ess
  :straight t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TERMINAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package vterm
  :straight t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SNIPPETS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet
  :straight t
  :hook (prog-mode . yas-minor-mode)
  :config
  (setq yas-snippet-dirs '("~/dotfiles/emacs/snippets"))
  (yas-reload-all)
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :straight t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ORG ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :straight t  ;; (:type git :host github :repo "Organizational/Org" :branch "main")
  :config
  (setq org-directory "~/vaults/zettelkasten/")
  (setq org-default-notes-file (concat org-directory "inbox.org"))
  (setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n  %u\n")))
  (setq-default word-wrap t)
  (setq org-startup-truncated nil)
  )

(use-package evil-org
  :straight t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package helm-org-rifle
  :straight t)

(use-package org-roam
  :straight t
  :config
  (setq org-roam-directory (file-truename "~/org")
  (org-roam-db-autosync-mode)
	)

(use-package dash
  :straight t)

(use-package f
  :straight t)

(use-package s
  :straight t)

(use-package emacsql
  :straight t)

(use-package magit-section
  :straight t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package helpful
  :straight t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command]  . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key]      . helpful-key))

(use-package vundo
  :straight t)

(use-package ivy
  :straight t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :straight t
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :straight t
  :bind (("M-x"     . counsel-M-x)
         ("C-x b"   . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r"     . 'counsel-minibuffer-history)))


(use-package listen
  :straight t
  :config
  (listen-mode))

(use-package company
  :straight t
  :after lsp-mode
  :hook ((prog-mode . company-mode)
         (lsp-mode . company-mode))
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection)
              :map lsp-mode-map
              ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  :config
  ;; only add if these backends are present
  (when (require 'company-ghc nil 'noerror)
    (add-to-list 'company-backends 'company-ghc))
  (add-to-list 'company-backends 'company-yasnippet))

(use-package company-box
  :straight t
  :hook (company-mode . company-box-mode))

(use-package lsp-ivy
  :straight t)

(use-package envrc
  :straight t
  :config
  (envrc-global-mode))
