

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

        # Load environment from direnv as JSON
        direnv export json
        | from json
        | default {}
        | load-env

        # Ensure PATH stays a list if ENV_CONVERSIONS exists
        if ('ENV_CONVERSIONS' in $env) and ('PATH' in $env.ENV_CONVERSIONS) {
          $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
        }
      }
    ]
  }
}

source $"($nu.home-path)/.cargo/env.nu"

# --- Aliases ---
alias vi = vim
alias vim = nvim
alias nano = nvim
alias lj = lazyjj
# alias jh = 'jj --help'
# alias je = 'jj edit'
# alias js = 'jj st'
# alias jsq = 'jj squash'



source ~/.cache/carapace/init.nu
