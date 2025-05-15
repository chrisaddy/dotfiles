{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    prefix = "C-Space";
    mouse = true;
    newSession = true;
    sensibleOnTop = true;
    shell = "${pkgs.nushell}/bin/nu";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.continuum
      tmuxPlugins.tmux-fzf
      tmuxPlugins.tokyo-night-tmux
    ];
    extraConfig = ''
      set-environment -g TMUX_FZF_OPTIONS "-p -w 90% -h 90% -m"
      set-environment -g TMUX_FZF_PLUGIN_DIR "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf"
      bind s choose-session
      set -g status-left " "
      set -g status-right " "

      bind ^D detach
      bind * list-clients
      bind l refresh-client

      # windows
      bind ^C new-window -c "$HOME"
      bind c new-window -c "#{pane_current_path}"
      bind ^W list-windows
      bind - split-window -v -c "#{pane_current_path}"
      bind / split-window -h -c "#{pane_current_path}"
      bind ^H previous-window
      bind ^L next-window
      bind w choose-window
      bind Space run-shell -b "#{TMUX_FZF_PLUGIN_DIR}/scripts/session.sh"
      bind ^Space run-shell -b "#{TMUX_FZF_PLUGIN_DIR}/scripts/window.sh"
      bind m run-shell -b "#{TMUX_FZF_PLUGIN_DIR}/scripts/command.sh"
      bind b run-shell -b "#{TMUX_FZF_PLUGIN_DIR}/scripts/clipboard.sh"

      set -g renumber-windows on
      set -g set-clipboard on

      setw -g mode-keys vi
    '';
  };
}
