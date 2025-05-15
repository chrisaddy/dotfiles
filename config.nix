{lib}: let
  username =
    if builtins.getEnv "USER" != ""
    then builtins.getEnv "USER"
    else "caddy";

  homeDirectory = "/Users/${username}";
  email = "chris.william.addy@gmail.com";

  hostnameMap = {
    "Christophers-MacBook-Pro" = "Mac";
  };
in {
  inherit username homeDirectory email;
}
