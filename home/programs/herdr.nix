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
in
{
  home.packages = [ herdr-sync ];

  home.activation.herdrSync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe herdr-sync}
  '';
}
