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
    # TMUX_FZF_OPTIONS="-p -w 80% -h 70% -m"
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
    bind v split-window -h -c "#{pane_current_path}"
    bind w choose-window
    bind r command-prompt "rename-window %%"
    bind ^R command-prompt "rename-session %%"

    bind Space run-shell -b ${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/window.sh move"

    bind ^Space run-shell -b ${pkgs.tmuxPlugins.tmux-fzf}/share/plugins/tmux-fzf/scripts/session.sh switch"

    bind m display-popup -E "tmux switch-client -t \$(tmux list-sessions -F '#S' | ${pkgs.fzf}/bin/fzf)"

    set -g renumber-windows on
    set -g set-clipboard on

    setw -g mode-keys vi

  '';
}
# scripts/session.sh: attach, detach, rename, kill
# scripts/window.sh: switch, link, move, swap, rename, kill
# scripts/pane.sh: switch, break, join, swap, layout, kill, resize
# scripts/clipboard.sh: system, buffer
# scripts/process.sh: display, tree, terminate, kill, interrupt, continue, stop, quit, hangup

