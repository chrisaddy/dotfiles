{
  # Import user config from the centralized configuration
  config ? import ./config.nix { lib = null; }
}: {
  name = config.username;
  email = config.email;
  homeDirectory = config.homeDirectory;
}