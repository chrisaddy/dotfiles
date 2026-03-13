{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimPlugins.lean-nvim.overrideAttrs {
        dependencies = [];
        doCheck = false;
      })
    ];

    extraConfigLua = ''
      require('lean').setup({
        mappings = true,
      })
    '';
  };
}
