let carapace_completer = {|spans|
  ^carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
  show_banner: false
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: $carapace_completer
    }
  }
  hooks: {
    pre_prompt: [
      { ||
        if (which direnv | is-empty) { return }

        direnv export json
        | from json
        | default {}
        | load-env

        if ('ENV_CONVERSIONS' in $env) and ('PATH' in $env.ENV_CONVERSIONS) {
          $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        }
      }
    ]
  }
}

# source $"($nu.home-path)/.cargo/env.nu"

# --- Aliases ---
alias vi = vim
alias vim = nvim
alias nano = nvim
alias emacs = emacs -nw
alias lj = lazyjj
alias sioyek = sioyek --shared-database-path `/Volumes/X10 Pro/sioyek/shared.db`
alias "flox activate" = ^flox activate -- nu
# alias jh = 'jj --help'
# alias je = 'jj edit'
# alias js = 'jj st'
# alias jsq = 'jj squash'

source ~/.config/carapace/init.nu



def clean [] {
  ^docker system prune --force --all --volumes
  cd projects
  ^cargo sweep --time 1 --recursive
}


export-env {

}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

source ~/.config/zoxide/config.nu
