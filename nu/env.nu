source-env $"($env.HOME)/.nix-profile/etc/profile.d/hm-session-vars.sh"
source-env $"/etc/profiles/per-user/($env.USER)/etc/profile.d/hm-session-vars.sh"

$env.PATH = $env.PATH ++ [ $"/etc/profiles/per-user/($env.USER)/bin" ]
