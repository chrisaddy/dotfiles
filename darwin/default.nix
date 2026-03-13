{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    devenv
  ];

  # Auto-upgrade nix package and the daemon service
  nix.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix-daemon
  services.nix-daemon.enable = true;

  # Set system state version
  system.stateVersion = 6;

  # Platform
  nixpkgs.hostPlatform = "aarch64-darwin";
}
