{
  config,
  lib,
  pkgs,
  ...
}:
let
  # nu does not expand `$HOME` inside strings, so bake the literal path in.
  expandHome = lib.replaceStrings [ "$HOME" ] [ config.home.homeDirectory ];

  # Single source of truth for env: nushell never sources hm-session-vars.sh
  # (it is POSIX), so generate the same variables from the same attrset the
  # POSIX shells get. Adding a var to home.sessionVariables reaches nu too.
  #
  # Values still containing `$` after the $HOME substitution use POSIX
  # expansion (`$VAR`, `${VAR:+...}`) that nu does not interpret — emitting them
  # would set a literal. They are skipped here and must be handled natively in
  # extraEnv below; `terminfoDirs` is the one such case today.
  sessionVars = lib.mapAttrs (_: v: expandHome (toString v)) config.home.sessionVariables;
  translatable = lib.filterAttrs (_: v: !lib.hasInfix "$" v) sessionVars;
  skipped = lib.attrNames (lib.filterAttrs (_: v: lib.hasInfix "$" v) sessionVars);

  envLines = lib.mapAttrsToList (name: value: ''$env.${name} = "${value}"'') translatable;

  skippedComment = lib.optionalString (skipped != [ ]) ''

    # Not translated from home.sessionVariables (POSIX expansion in the value):
    # ${lib.concatStringsSep ", " skipped}
  '';

  pathEntries = lib.concatMapStringsSep "\n    " (p: ''"${expandHome p}"'') config.home.sessionPath;

  # nu equivalent of HM's `$dir:$TERMINFO_DIRS${TERMINFO_DIRS:+:}/usr/share/terminfo`.
  terminfoDirs = ''
    $env.TERMINFO_DIRS = (
      ["${config.home.profileDirectory}/share/terminfo"]
      | append (
          $env.TERMINFO_DIRS?
          | default ""
          | if ($in | describe) == "string" { split row (char esep) } else { $in }
        )
      | append "/usr/share/terminfo"
      | where { |it| $it != "" }
      | uniq
      | str join (char esep)
    )
  '';
in
{
  programs.nushell = {
    enable = true;

    # Pinned to nu's OWN per-platform default, not to xdg. The module would
    # follow `xdg.enable = true` and write ~/.config/nushell on both platforms,
    # which silently breaks on darwin: nu only looks there when
    # XDG_CONFIG_HOME is set, and that variable reaches shells through the
    # POSIX hm-session-vars.sh, which nushell never sources. A nu login shell
    # started from Ghostty or Finder would read
    # ~/Library/Application Support/nushell and find nothing.
    # Kept home-relative: these become `home.file` keys, and an absolute path
    # there silently produces no files at all.
    configDir =
      if pkgs.stdenv.isDarwin then "Library/Application Support/nushell" else ".config/nushell";

    shellAliases = {
      ls = "eza -la";
      lss = "yazi";
      ccc = "claude --dangerously-skip-permissions";
    };

    extraEnv = ''
      ${lib.concatStringsSep "\n" envLines}
      ${skippedComment}
      ${terminfoDirs}

      # PATH is a string on first launch and a list once nu's own
      # ENV_CONVERSIONS have run; handle both.
      $env.PATH = (
        $env.PATH
        | if ($in | describe) == "string" { split row (char esep) } else { $in }
        | prepend [
            ${pathEntries}
            "${config.home.homeDirectory}/.local/bin"
          ]
        | uniq
      )

      $env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
    '';

    extraConfig = ''
      # direnv, resolved through $PATH rather than a pinned store path, so a
      # running shell survives a rebuild + `nh clean all` deleting the old
      # direnv derivation. Same reasoning as the zsh hook in zsh.nix, which is
      # why programs.direnv.enableNushellIntegration stays off.
      $env.config = ($env.config? | default {})
      $env.config.hooks = ($env.config.hooks? | default {})
      $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt?
        | default []
        | append {||
            if not (which direnv | is-empty) {
              direnv export json
              | from json --strict
              | default {}
              | items {|key, value|
                  if $value == null {
                    hide-env --ignore-errors $key
                  } else {
                    load-env {($key): $value}
                  }
                }
              | ignore
            }
          }
      )
    '';
  };

  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enableNushellIntegration = true;

  # Off deliberately — extraConfig above installs an equivalent pre_prompt hook
  # that resolves direnv from $PATH. Left on, both hooks run and direnv exports
  # twice per prompt.
  programs.direnv.enableNushellIntegration = false;

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
    # zsh.nix sources carapace itself; two hooks would register the completer
    # twice.
    enableZshIntegration = false;
  };
}
