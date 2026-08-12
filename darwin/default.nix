{ ... }:

{
  environment.systemPackages = [
  ];

  # Lets `chsh` accept nushell. The per-user profile path (not the store path)
  # is what to chsh to — a store path becomes a dead login shell the next time
  # `nh clean all` runs:
  #   chsh -s /etc/profiles/per-user/chrisaddy/bin/nu
  # Only the per-user profile path: listing pkgs.nushell here would add
  # /run/current-system/sw/bin/nu to /etc/shells without installing nushell
  # system-wide, i.e. a dead entry.
  environment.shells = [
    "/etc/profiles/per-user/chrisaddy/bin/nu"
  ];

  # Auto-upgrade nix package and the daemon service
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Declare the primary user
  users.users.chrisaddy = {
    name = "chrisaddy";
    home = "/Users/chrisaddy";
  };

  # Set system state version
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
