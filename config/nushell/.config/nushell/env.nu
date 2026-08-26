$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.NPM_CONFIG_PREFIX = ($env.HOME | path join ".npm-global")

$env.PATH = (
    $env.PATH
    | if ($in | describe) == "string" { split row (char esep) } else { $in }
    | prepend [
        ($env.HOME | path join ".npm-global" "bin")
        ($env.HOME | path join ".local" "bin")
    ]
    | uniq
)

$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
