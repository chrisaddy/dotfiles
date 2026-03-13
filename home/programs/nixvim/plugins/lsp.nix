{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        dockerls.enable = true;
        docker_compose_language_service.enable = true;
        lua_ls.enable = true;
        html.enable = true;
        markdown_oxide.enable = true;
        ruff.enable = true;
        yamlls.enable = true;
        basedpyright.enable = true;
      };
    };

    extraPlugins = [
      (pkgs.vimPlugins.nvim-FeMaco-lua.overrideAttrs {
        dependencies = [];
        doCheck = false;
      })
    ];

    extraConfigLua = ''
      require("femaco").setup({})
    '';

    keymaps = [
      { mode = "n"; key = "<leader>cb"; action = "<cmd>FeMaco<cr>"; options.desc = "Code block editor"; }
    ];
  };
}
