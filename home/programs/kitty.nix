{ config, ... }:

{
  xdg.configFile."kitty/kitty.conf".source = ../../config/kitty/kitty.conf;
  xdg.configFile."kitty/Tokyo Night Storm.conf".source = ../../config/kitty + "/Tokyo Night Storm.conf";
}
