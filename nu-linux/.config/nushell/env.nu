$env.EDITOR = "nvim"

$env.PATH = ($env.PATH
  | append "/usr/local/bin"
  | append $"($env.HOME)/.local/bin"
  | append "/opt/zerobrew/prefix/bin"
  | append "/opt/homebrew/bin"
  | append $"($env.HOME)/.cargo/bin"
)

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

if ("~/.secrets.nu" | path exists) {
  source ~/.secrets.nu
}
