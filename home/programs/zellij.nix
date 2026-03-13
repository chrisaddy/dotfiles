{ config, ... }:

{
  xdg.configFile."zellij/config.kdl".source = ../../config/zellij/config.kdl;
  xdg.configFile."zellij/layouts/tmux.kdl".source = ../../config/zellij/layouts/tmux.kdl;
}
