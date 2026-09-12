$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.NPM_CONFIG_PREFIX = ($env.HOME | path join ".npm-global")

$env.PATH = (
    $env.PATH
    | if ($in | describe) == "string" { split row (char esep) } else { $in }
    | prepend [
        ($env.HOME | path join ".npm-global" "bin")
        ($env.HOME | path join ".local" "bin")
        "/nix/var/nix/profiles/default/bin"
        ($env.HOME | path join ".nix-profile/bin")
    ]
    | uniq
)

$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
