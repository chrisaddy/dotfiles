{ ... }:
# Rex reads one file, init.lua (see `rex config --help`). It is written inline
# like the other programs here. Edit the text below, switch, then
# `rex config reload` (or `rex config check` first to catch Lua errors).
#
# Home-relative .config/rex rather than xdg.configFile: Rex's own default on
# macOS and Linux is ~/.config/rex, and it must not depend on xdg.enable.
{
  home.file.".config/rex/init.lua".text = ''
    rex.action{
      name  = "then_normal",
      title = "Run an action and return to normal mode",
      args  = { action = "string", args = "object?" },
      run   = function(ctx, args)
        rex.client.queue(args.action, args.args or {})
        rex.client.queue("client.mode.exit_all")
      end,
    }

    -- ctrl+h/j/k/l move between panes directly, no mode needed.
    rex.bind("cmd+h", "pane.focus", { direction = "left" })
    rex.bind("cmd+j", "pane.focus", { direction = "down" })
    rex.bind("cmd+k", "pane.focus", { direction = "up" })
    rex.bind("cmd+l", "pane.focus", { direction = "right" })

    -- cmd+shift+j/k walk down/up the session list.
    rex.bind("cmd+shift+l", "client.tab.next")
    rex.bind("cmd+shift+h", "client.tab.previous")
  '';
}
