{
  lib
}: 
let
  username = 
    if builtins.getEnv "USER" != "" 
      then builtins.getEnv "USER"
      else "chrisaddy";

  homeDirectory = "/Users/${username}";
  email = "chris.william.addy@gmail.com";
in
{
  inherit username homeDirectory email;
}
