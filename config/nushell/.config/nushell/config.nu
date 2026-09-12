$env.config.show_banner = false

alias ls = eza -la
alias lss = yazi
alias ccc = claude --dangerously-skip-permissions
alias claude = caveman claude
alias vim = nvim
alias vi = nvim
alias hx = helix
alias gs = gh stack
alias zl = zellij list-sessions
alias zk = zellij delete-session --force (zellij list-sessions --short | fzf)
alias rg = rg --hidden
alias ll = yazi

# cd-on-exit yazi wrapper
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -f $tmp
}

# direnv, resolved through $PATH. Mirrors the zsh precmd hook in
# config/zsh/.zshrc: exports/unexports the diff on every prompt.
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

# starship, zoxide, carapace nu integrations. Regenerated on every launch via
# nu's vendor autoload dirs rather than a one-off setup step, so a `pacman -Syu`
# upgrade of any of the three is picked up on the next shell.
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
