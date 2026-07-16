{...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
  };
}
