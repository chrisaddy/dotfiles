{...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    prefix = "C-Space";
    mouse = true;
    newSession = true;
  };
  sensibleOnTop = true;
  shell = "${pkgs.nushell}/bin/nu";
  plugins = with pkgs; [
    tmuxPlugins.battery
    tmuxPlugins.better-mouse-mode
    tmuxPlugins.continuum
    tmuxPlugins.cpu
    tmuxPlugins.net-speed
    tmuxPlugins.weather
    tmuxPlugins.tmux-fzf
    tmuxPlugins.tokyo-night-tmux
  ];
  extraConfig = ''
       TMUX_FZF_OPTIONS="-p -w 80% -h 70% -m"
       bind s choose-session
       set -g status-left " "
       set -g status-right " "


       bind Space run-shell -b ${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/window.sh move"

    bind ^Space run-shell -b ${pkgs.tmuxPlugins.tmux-fzf}/share/plugins/tmux-fzf/scripts/session.sh switch"

  '';
}
# set -g status-style bg=#1A1B26,fg=#C0CAF5
# set -g window-status-style bg=#292E42,fg=#7DCFFF
# set -g window-status-current-style bg=#414868,fg=#BB9AF7
# bind ^X lock-server
# bind ^D detach
# bind * list-clients
# bind m display-popup -E "tmux switch-client -t \$(tmux list-sessions -F '#S' | fzf)"
# bind l refresh-client
#
# # windows
# bind ^C new-window -c "$HOME"
# bind c new-window -c "#{pane_current_path}"
# bind ^h last-window
# bind ^l next-window
# bind ^W list-windows
# bind - split-window -v -c "#{pane_current_path}"
# bind v split-window -h -c "#{pane_current_path}"
# bind w choose-window
# bind r command-prompt "rename-window %%"
#
# # panes
# bind h select-pane -L
# bind j select-pane -D
# bind d select-pane -U
# bind l select-pane -R
# bind z resize-pane -Z
# bind -r -T prefix , resize-pane -L 20
# bind -r -T prefix . resize-pane -R 20
# bind -r -T prefix - resize-pane -D 7
# bind -r -T prefix = resize-pane -U 7
# set -g pane-active-border-style 'fg=magenta,bg=default'
# set -g pane-border-style 'fg=brightblack,bg=default'
# bind * setw synchronize-panes
# bind P set pane-border-status
# bind ^K kill-pane
# bind x swap-pane -D
# bind-key -T copy-mode-vi v send-keys -X begin-selection
# set-option -g default-terminal 'screen-256color'
# set-option -g terminal-overrides ',xterm-256color:RGB'
#
# set -g base-index 1
# set -g detach-on-destroy off
# set -g escape-time 0
# set -g history-limit 1000000
# set -g renumber-windows on
# set -g set-clipboard on
# set -g status-position bottom
# set -g default-terminal "${TERM}"
# setw -g mode-keys vi
#
#
# # Available actions:
# #
# # scripts/session.sh: attach, detach, rename, kill
# # scripts/window.sh: switch, link, move, swap, rename, kill
# # scripts/pane.sh: switch, break, join, swap, layout, kill, resize
# # scripts/clipboard.sh: system, buffer
# # scripts/process.sh: display, tree, terminate, kill, interrupt, continue, stop, quit, hangup
#
# # set -g @plugin 'erikw/tmux-powerline'
# set -g @plugin 'tmux-plugins/tmux-yank'
# set -g @plugin 'tmux-plugins/tmux-resurrect'
# set -g @continuum-restore 'on'
# set -g @resurrect-strategy-nvim 'session'

