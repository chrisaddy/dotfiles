$env.EDITOR = "nvim"

$env.PATH = ($env.PATH
  | append "/nix/var/nix/profiles/default/bin"
  | append $"/etc/profiles/per-user/($env.USER)/bin"
  | append "/run/current-system/sw/bin"
  | append "/opt/homebrew/bin"
)

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu




if ("~/.secrets.nu" | path exists) {
  source ~/.secrets.nu
}

zoxide init nushell --cmd cd | save -f ~/.zoxide.nu
source ~/.zoxide.nu
