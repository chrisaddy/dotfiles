{
  workmux,
  pkgs,
  lib,
  ...
}:
let
  tmuxFzf = pkgs.tmuxPlugins.tmux-fzf;
in
{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    historyLimit = 50000;
    escapeTime = 0;
    keyMode = "vi";
    # Not C-Space: zellij binds Ctrl Space to tab mode, and tmux often runs
    # inside zellij. C-a is unbound there.
    prefix = "C-Space";

    extraConfig = ''
            # Terminal overrides
            set -ga terminal-overrides ",*256col*:Tc"
            set -g allow-passthrough on
            set -ga terminal-overrides ",*:Ss=\\E[%p1%d q:Se=\\E[2 q"

            # keyMode sets vi for the command prompt too, where Esc only enters
            # vi normal mode and a second Esc is ignored. Emacs prompt keys make
            # Esc cancel the prompt; copy mode stays vi.
            set -g status-keys emacs

            # Pane base index
            setw -g pane-base-index 1

            # Renumber windows when one is closed
            set -g renumber-windows on

            # Enable focus events for vim/neovim
            set -g focus-events on
            set -g extended-keys on

            set -g clock-mode-style 24
            set -g set-clipboard on

            # Reload config
            bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

            # Split panes
            bind / split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            unbind '"'
            unbind %

            # navigate windows
            bind l next-window
            bind h last-window

            bind-key w command-prompt -I "#S" "rename-window '%%'"

            # Navigate panes with vim-style keys
            bind -n C-h select-pane -L
            bind -n C-j select-pane -D
            bind -n C-k select-pane -U
            bind -n C-l select-pane -R

            # Alt-hjkl: move between panes; at the left/right edge, step to the
            # previous/next window and land on its nearest pane. Up/down stop
            # at the edge instead of wrapping.
            bind -n M-h if -F "#{pane_at_left}" "previous-window ; select-pane -t '{right}'" "select-pane -L"
            bind -n M-l if -F "#{pane_at_right}" "next-window ; select-pane -t '{left}'" "select-pane -R"
            bind -n M-j if -F "#{pane_at_bottom}" "" "select-pane -D"
            bind -n M-k if -F "#{pane_at_top}" "" "select-pane -U"

            # Resize panes
            bind -r H resize-pane -L 5
            bind -r J resize-pane -D 5
            bind -r K resize-pane -U 5
            bind -r L resize-pane -R 5

            # Create new window in current directory
            bind c new-window -c "#{pane_current_path}"

            # Sessions
            # Like zellij's Ctrl Space, Space: a fuzzy session switcher in a popup.
            # tmux-fzf's full menu (windows, panes, kill, rename...) is prefix F.
            bind Space run-shell -b "${tmuxFzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
            bind-key R command-prompt -I "#S" "rename-session '%%'"
            bind n command-prompt "new-session -s '%%'"
            bind-key o display-popup -E -w 40% "sesh connect \"$(
       sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡'
      )\""

            # Status bar
            set -g status-position top
            set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
            set -g status-left-length 30
            set -g status-left "#[fg=#89b4fa,bold] #S #[default]"
            set -g status-right-length 50
            set -g status-right "#[fg=#6c7086]%Y-%m-%d %H:%M #[default]"
            setw -g window-status-format " #I:#W "
            setw -g window-status-current-format "#[fg=#f5c2e7,bold] #I:#W #[default]"

            # Copy mode
            bind -T copy-mode-vi v send-keys -X begin-selection
            bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
            bind -T copy-mode-vi r send-keys -X rectangle-toggle

            # Pane borders
            set -g pane-border-style "fg=#313244"
            set -g pane-active-border-style "fg=#89b4fa"

            # Don't detach when session is destroyed
            set -g detach-on-destroy off

            # Activity monitoring
            setw -g monitor-activity on
            set -g visual-activity off

            # Source local overrides
            if-shell "test -f ~/.tmux.conf.local" "source-file ~/.tmux.conf.local"
    '';

    # nixpkgs patches the plugin's scripts to call fzf from the store, so this
    # works on the headless VMs too, which do not install fzf.
    # resurrect: prefix C-s saves the sessions, prefix C-r restores them.
    plugins = [
      tmuxFzf
      pkgs.tmuxPlugins.resurrect
    ];
  };

  home.packages = [
    workmux.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.tuicr
  ];

  xdg.configFile."workmux/config.yaml" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    text = ''
      merge_strategy: rebase
      agent: claude
      panes:
        - command: <agent>
          focus: true
        - split: horizontal

    '';
  };

}
