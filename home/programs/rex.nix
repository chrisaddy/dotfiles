{ ... }:
# Rex reads one file, init.lua (see `rex config --help`). It is written inline
# like the other programs here. Edit the text below, switch, then
# `rex config reload` (or `rex config check` first to catch Lua errors).
#
# Home-relative .config/rex rather than xdg.configFile: Rex's own default on
# macOS and Linux is ~/.config/rex, and it must not depend on xdg.enable.
{
  home.file.".config/rex/init.lua".text = ''
    -- Migrated from ~/.config/zellij/config.kdl

    rex.action{
      name  = "then_normal",
      title = "Run an action and return to normal mode",
      args  = { action = "string", args = "object?" },
      run   = function(ctx, args)
        rex.client.queue(args.action, args.args or {})
        rex.client.queue("client.mode.exit_all")
      end,
    }

    -- zellij pane mode (config.kdl:18-35)
    rex.mode("pane", { exclusive = true })
    rex.bind("ctrl+k", "client.mode.enter", { name = "pane" })
    rex.bind("pane/h", "then_normal", { action = "pane.focus", args = { direction = "left" } })
    rex.bind("pane/j", "then_normal", { action = "pane.focus", args = { direction = "down" } })
    rex.bind("pane/k", "then_normal", { action = "pane.focus", args = { direction = "up" } })
    rex.bind("pane/l", "then_normal", { action = "pane.focus", args = { direction = "right" } })

    -- zellij tab mode (config.kdl:36-60)
    rex.mode("tab", { exclusive = true })
    rex.bind("ctrl+space", "client.mode.enter", { name = "tab" })
    rex.bind("tab/h", "then_normal", { action = "pane.focus", args = { direction = "left" } })
    rex.bind("tab/j", "then_normal", { action = "pane.focus", args = { direction = "down" } })
    rex.bind("tab/k", "then_normal", { action = "pane.focus", args = { direction = "up" } })
    rex.bind("tab/l", "then_normal", { action = "pane.focus", args = { direction = "right" } })
  '';
}
