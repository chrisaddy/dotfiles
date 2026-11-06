{ lib, pkgs, ... }:
# Herdr's own files (shipped mods and layouts, the .d.ts files, state) are
# rewritten on every start, so only the pieces we wrote live in ~/dotfiles/herdr.
#
# They are copied into ~/.config/herdr-app, not linked. Herdr resolves links
# and refuses anything that lands outside its folder: a linked mod folder
# loads no svg or font, and a linked file in a real folder fails to import.
#
# ~/dotfiles/herdr is the source of truth: a switch copies it over whatever is
# in ~/.config. After editing a mod there, `herdr-sync` copies it across and
# Herdr hot-reloads it.
#
# keys.json and settings.json stay unmanaged: Herdr's settings screen writes
# them.
let
  herdr-sync = pkgs.writeShellApplication {
    name = "herdr-sync";
    runtimeInputs = [ pkgs.rsync ];
    text = ''
      src="$HOME/dotfiles/herdr"
      dst="''${XDG_CONFIG_HOME:-$HOME/.config}/herdr-app"
      [ -d "$src" ] || exit 0
      mkdir -p "$dst/mods" "$dst/layouts"
      # --delete drops files removed from the repo; the files Herdr writes
      # into every mod folder are excluded, so they are kept.
      for mod in "$src"/mods/*/; do
        rsync -a --delete --exclude '*.d.ts' --exclude jsconfig.json \
          "$mod" "$dst/mods/$(basename "$mod")/"
      done
      # No --delete here: Herdr's shipped layouts live beside ours.
      rsync -a "$src/layouts/" "$dst/layouts/"
    '';
  };
  # A Claude Code PostToolUse hook on the Artifact tool: records each published
  # artifact so the office hangs a whiteboard for it. Republishing the same URL
  # keeps its one board.
  office-artifact = pkgs.writeShellApplication {
    name = "office-artifact";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      file="''${XDG_CONFIG_HOME:-$HOME/.config}/herdr-app/office-artifacts.json"
      entry=$(jq -c '
        select((.tool_input.action // "publish") == "publish" and (.tool_input.asset // false) == false)
        | { url: ([.tool_response | .. | strings | scan("https://claude\\.ai/(?:code/)?artifact/[A-Za-z0-9-]+")] | first),
            file: (.tool_input.file_path // ""), title: (.tool_input.title // ""), at: (now | floor) }
        | select(.url != null)') || exit 0
      [ -n "$entry" ] || exit 0
      # Prefer the page's own <title>, then the file's name.
      path=$(jq -r .file <<<"$entry")
      title=$(jq -r .title <<<"$entry")
      if [ -f "$path" ]; then
        page=$(sed -n 's:.*<title>\(.*\)</title>.*:\1:p' "$path" | head -n 1)
        title=''${page:-$title}
      fi
      [ -n "$title" ] || { title=$(basename "$path"); title=''${title%.*}; }
      [ -f "$file" ] || echo '[]' >"$file"
      tmp=$(mktemp "$file.XXXXXX")
      jq --argjson e "$entry" --arg title "$title" '
        ($e | del(.file) | .title = $title) as $e
        | if any(.[]; .url == $e.url) then map(if .url == $e.url then .title = $e.title else . end) else . + [$e] end
      ' "$file" >"$tmp" && mv "$tmp" "$file"
    '';
  };
  # A Claude Code hook for every event that changes what Claude is doing. Herdr
  # counts a terminal as an agent only once its program sends an OSC 7501
  # status, and Claude Code sends none, so this writes one to Claude's
  # terminal. Hooks have no terminal of their own: walk up to the first
  # ancestor that has one. Outside a herdr-core terminal it does nothing.
  herdr-claude-status = pkgs.writeShellApplication {
    name = "herdr-claude-status";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      [ -n "''${HC_TERMINAL_ID:-}" ] || exit 0
      status=$(jq -r '
        if .hook_event_name == "SessionStart" or .hook_event_name == "SessionEnd" then "state=idle"
        elif .hook_event_name == "Stop" then "state=done"
        elif .hook_event_name == "PermissionRequest" then "state=blocked:kind=permission"
        elif .hook_event_name == "Notification" then
          if .notification_type == "permission_prompt" then "state=blocked:kind=permission"
          elif .notification_type == "elicitation_dialog" then "state=blocked:kind=question"
          else empty end
        else "state=working" end') || exit 0
      [ -n "$status" ] || exit 0
      pid=$PPID
      while [ "$pid" -gt 1 ]; do
        tty=$(ps -o tty= -p "$pid" | tr -d ' ')
        case $tty in
          "" | "?" | "??") pid=$(ps -o ppid= -p "$pid" | tr -d ' ') ;;
          *) printf '\033]7501;%s\033\134' "$status" >"/dev/$tty" 2>/dev/null; exit 0 ;;
        esac
      done
    '';
  };
in
{
  home.packages = [
    herdr-sync
    office-artifact
    herdr-claude-status
  ];

  home.activation.herdrSync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe herdr-sync}
  '';
}
