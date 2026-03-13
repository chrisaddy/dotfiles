{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    historyLimit = 50000;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "C-Space";

    extraConfig = ''
      # Terminal overrides
      set -ga terminal-overrides ",*256col*:Tc"
      set -g allow-passthrough on
      set -ga terminal-overrides ",*:Ss=\\E[%p1%d q:Se=\\E[2 q"

      # Pane base index
      setw -g pane-base-index 1

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Enable focus events for vim/neovim
      set -g focus-events on

      set -g clock-mode-style 24
      set -g set-clipboard on

      # Key bindings
      bind C-a send-prefix

      # Reload config
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

      # Split panes
      bind / split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Navigate panes with vim-style keys
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Create new window in current directory
      bind c new-window -c "#{pane_current_path}"

      # Sessions
      bind Space choose-session
      bind-key R command-prompt -I "#S" "rename-session '%%'"
      bind n command-prompt "new-session -s '%%'"

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
  };
}
