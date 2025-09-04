(setq inhibit-startup-message t)
(desktop-save-mode 1)

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

(require 'doom-themes)
(load-theme 'doom-challenger-deep t)

(require 'doom-modeline)
(doom-modeline-mode 1)

(setq evil-want-keybinding  nil)
(require 'evil)
(setq evil-want-integration   t)
(setq evil-want-C-u-scroll    t)
(setq evil-want-C-i-jump    nil)
(evil-mode 1)
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

(evil-set-initial-state 'messages-buffer-mode 'normal)
(evil-set-initial-state 'dashboard-mode       'normal)

(require 'evil-collection)
(evil-collection-init)

; (global-evil-leader-mode)
; (evil-leader/set-leader "<SPC>")
; (evil-leader/set-key
;   "f" 'find-file
;   "b" 'switch-to-buffer
;   "k" 'kill-buffer
;   "w" 'save-buffer)

(require 'evil-commentary)
(evil-commentary-mode)

(require 'which-key)
(which-key-mode)
(setq which-key-idle-delay 0.1)

(require 'general)
(general-create-definer rune/leader-keys
  :keymaps '(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

(rune/leader-keys
  "SPC"   '(counsel-M-x                         :which-key "M-x")
  ":"   '(eval-expression                     :which-key "Eval:")
  ; "SPC" '(hyperprior/counsel-ibuffer-menu     :which-key "buffers")
  "a"   '(:ignore t                           :which-key "ai")
  ; "ar"  '(gptel-rewrite                       :which-key "ai rewrite")
  "f"   '(:ignore t                           :which-key "buffers")
  "ff"  '(counsel-ibuffer                     :which-key "find buffer")
  "fm"  '(buffer-menu                         :which-key "buffer menu")
  "fr"  '(rename-buffer                       :which-key "buffer rename")
  ; "dh"  '(dirvish                             :which-key "directory here")
  ; "dq"  '(dirvish-quick-access                :which-key "directory quick access")
  ; "dm"  '(dirvish-dispatch                    :which-key "dirvish menu")
  "t"   '(:ignore t                           :which-key "toggles")
  "o"   '(dirvish-dwim                        :which-key "dirvish")
  ;; "tt"  '(counsel-load-theme                  :which-key "choose theme")
  ; "f"   '(:ignore t                           :which-key "find")
  ; "ff"  '(counsel-find-file                   :which-key "find file")
  ; "fi"  '((lambda () (interactive)
  ;    (hyperprior/jump-to-file "~/dotfiles/emacs/init.el"))
  ; 			:which-key "open init.el")
  ; "fs"  '(save-buffer                         :which-key "file save")
  ; "gg"  '(magit-status                        :which-key "git status")
  ; "kc"  '(keycast-header-line-mode            :which-key "key cast")
  ; "ko"  '(hyperprior/kill-other-window-buffer :which-key "kill other window")
  ; "nh"  '((lambda () (interactive)
  ;      (hyperprior/jump-to-file "~/vaults/zettelkasten/✱ home/✱ home.md"))
  ; 			:which-key "notes home")
  ; "o"   '(:ignore t                           :which-key "org")
  ; "oc"  '(org-capture                         :which-key "org capture")
  ; "r"   '(:ignore t                           :which-key "reload")
  ; "ri"  '(hyperprior/reload-init              :which-key "reload init.el")
)

(require 'org)
(setq org-default-notes-file "~/org/inbox.org")

(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline "~/org/tasks.org" "Inbox")
         "* TODO %?\n  %i\n  %a")))
(setq org-capture-templates
      '(("j" "Journal" entry
         (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

;;; --- org-jira: Jira Cloud enhanced JQL fix + custom queries ---

;; Load org-jira (brings in jiralib) and set your Jira base URL.
(require 'org-jira)
(setq jiralib-url "https://mntn.atlassian.net")

;; Optional: easy prefix for org-jira commands (C-c i …).
;; (define-key global-map (kbd "C-c i") org-jira-map)

;; Your custom JQLs (write to ~/.org-jira/per-mine.org)
(setq org-jira-custom-jqls
      '((:jql "project = PER AND assignee = currentUser() AND resolution = Unresolved ORDER BY priority DESC, created DESC"
              :limit 100
              :filename "per-mine")))

;; Force org-jira to use Jira Cloud's enhanced JQL endpoint.
;; (with-eval-after-load 'org-jira
;;   (require 'json)
;;   ;; Silence byte-compiler and make sure helper is known at compile time.
;;   (declare-function jiralib--rest-call "jiralib")

;;   (defun jiralib-do-jql-search--enhanced (jql &optional limit callback)
;;     "Run a JQL search using Jira Cloud's enhanced endpoint.
;; JQL is a string. LIMIT is maxResults. CALLBACK (if non-nil) is passed to `jiralib--rest-call`."
;;     (jiralib--rest-call
;;      "POST" "/rest/api/3/search/jql"
;;      :headers '(("Content-Type" . "application/json"))
;;                           (maxResults . ,(or limit 50))))
;;      callback))

;;   ;; If you re-eval this block, remove any prior advice first (no duplicates).
;;   (ignore-errors (advice-remove 'jiralib-do-jql-search #'jiralib-do-jql-search--enhanced))
;;   (advice-add 'jiralib-do-jql-search :override #'jiralib-do-jql-search--enhanced))

;; ;;; --- usage ---
;; ;; M-x org-jira-get-issues-from-custom-jql  (or C-c i j)
;; ;; Then edit issues locally; to push changes use:
;; ;;   M-x org-jira-update-issue
;; ;;   M-x org-jira-progress-issue
;; ;;   M-x org-jira-add-comment
